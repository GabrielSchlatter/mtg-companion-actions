import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:http/http.dart' as http;

import '../db/cards_database.dart';

/// Commander Spellbook bulk-variant fetcher.
///
/// Downloads the public bulk dump at
/// `https://json.commanderspellbook.com/variants.json` — a single ~500
/// MB file containing every combo variant, refreshed on Spellbook's
/// own cadence. One request, no rate-limit problem. The paginated
/// `backend.commanderspellbook.com/variants` endpoint is heavily rate-
/// limited at the AWS ALB layer (sustained 429 even at 2-3 req/s with
/// long rolling windows) and is not viable for a full ~30k crawl from
/// a CI worker.
///
/// The bulk dump's per-variant shape matches the paginated endpoint —
/// `{id, uses[], produces[], description, ...}` — so the same parser
/// works against both. Writes are split across `combos`, `combo_cards`,
/// and `combo_features` with all card references resolved to
/// `oracle_id` via the variant's own `card.oracleId`.

const String _bulkDumpUrl = 'https://json.commanderspellbook.com/variants.json';
const String _userAgent =
    'mtg-companion-bundle-builder/1.0 '
    '(+https://github.com/GabrielSchlatter/mtg-companion-actions)';

class SpellbookFetchResult {
  final int combosInserted;
  final int comboCardsInserted;
  final int comboFeaturesInserted;
  final int unresolvedCardSlots;
  final int totalVariantsInDump;
  final String? dumpVersion;
  final String? dumpTimestamp;
  final int dumpSizeBytes;
  final Duration fetchElapsed;

  SpellbookFetchResult({
    required this.combosInserted,
    required this.comboCardsInserted,
    required this.comboFeaturesInserted,
    required this.unresolvedCardSlots,
    required this.totalVariantsInDump,
    required this.dumpVersion,
    required this.dumpTimestamp,
    required this.dumpSizeBytes,
    required this.fetchElapsed,
  });
}

/// Download the Spellbook bulk dump and replace the `combos`,
/// `combo_cards`, and `combo_features` tables with the result.
///
/// The download + parse + insert all happen in this function. If
/// anything throws — network failure, malformed JSON, DB error — no
/// rows in the destination tables are modified (the DELETE happens
/// inside the same transaction as the INSERTs at the end). Seeded
/// combo data from the previous bundle is therefore preserved on any
/// failure mode.
///
/// [maxVariants] caps the number of variants ingested for smoke tests.
/// [workDir] is where the downloaded file is staged; defaults to a
/// system temp dir if null.
Future<SpellbookFetchResult> writeCombos(
  CardsDatabase db, {
  int? maxVariants,
  Directory? workDir,
  void Function(String)? log,
}) async {
  void emit(String msg) => log?.call(msg);
  final stopwatch = Stopwatch()..start();
  final dir = workDir ?? Directory.systemTemp;
  final dumpFile = File('${dir.path}/spellbook_variants.json');
  if (dumpFile.existsSync()) dumpFile.deleteSync();

  emit('  spellbook: downloading bulk dump from $_bulkDumpUrl');
  await _downloadWithRetries(_bulkDumpUrl, dumpFile, log: emit);
  final size = dumpFile.lengthSync();
  emit(
    '  spellbook: downloaded ${(size / 1_000_000).toStringAsFixed(1)} MB '
    'in ${stopwatch.elapsed.inSeconds}s',
  );

  emit('  spellbook: parsing JSON…');
  final raw = await dumpFile.readAsString();
  final root = jsonDecode(raw) as Map<String, dynamic>;
  final variants = root['variants'] as List<dynamic>? ?? const [];
  final dumpVersion = root['version']?.toString();
  final dumpTimestamp = root['timestamp']?.toString();
  emit(
    '  spellbook: ${variants.length} variants in dump '
    '(version=$dumpVersion, generated=$dumpTimestamp)',
  );

  // Free the raw JSON string promptly — `variants` is the only thing
  // we need from here on, and it's about a third the memory of the
  // unparsed string.
  // (Dart's GC will collect `raw` once it goes out of scope at the end
  // of this method; explicit nulling isn't necessary.)

  final pendingCombos = <_PendingCombo>[];
  final seenComboIds = <String>{};
  var unresolvedSlots = 0;
  final iterCap = maxVariants ?? variants.length;
  for (var i = 0; i < variants.length && i < iterCap; i++) {
    final raw = variants[i];
    if (raw is! Map<String, dynamic>) continue;
    final id = raw['id']?.toString();
    if (id == null || id.isEmpty) continue;
    if (!seenComboIds.add(id)) continue;

    final parsed = _parseCombo(raw);
    if (parsed == null) continue;
    if (parsed.cards.length < 2) continue;
    pendingCombos.add(parsed);
    for (final c in parsed.cards) {
      if (c.oracleId == null) unresolvedSlots++;
    }
  }
  emit('  spellbook: ${pendingCombos.length} combos accepted');

  if (pendingCombos.isEmpty) {
    throw 'Spellbook bulk dump yielded zero usable combos';
  }

  var comboCardsTotal = 0;
  var comboFeaturesTotal = 0;
  final now = DateTime.now().toUtc();

  await db.transaction(() async {
    await db.customStatement('DELETE FROM combo_features');
    await db.customStatement('DELETE FROM combo_cards');
    await db.customStatement('DELETE FROM combos');

    for (final p in pendingCombos) {
      final comboPk = await db.into(db.combos).insert(
            CombosCompanion.insert(
              comboId: p.comboId,
              description: Value(p.description),
              notes: Value(p.notes),
              bracketTag: Value(p.bracketTag),
              identity: Value(p.identity),
              status: Value(p.status),
              popularity: Value(p.popularity),
              manaValueNeeded: Value(p.manaValueNeeded),
              manaNeeded: Value(p.manaNeeded),
              easyPrerequisites: Value(p.easyPrerequisites),
              notablePrerequisites: Value(p.notablePrerequisites),
              lastUpdated: now,
            ),
          );

      if (p.cards.isNotEmpty) {
        await db.batch(
          (b) => b.insertAll(
            db.comboCards,
            p.cards
                .map(
                  (c) => ComboCardsCompanion.insert(
                    comboId: comboPk,
                    position: c.position,
                    oracleId: Value(c.oracleId),
                    cardName: c.cardName,
                    zoneLocations: Value(c.zoneLocations),
                    quantity: Value(c.quantity),
                    mustBeCommander: Value(c.mustBeCommander),
                    battlefieldCardState: Value(c.battlefieldCardState),
                    exileCardState: Value(c.exileCardState),
                    graveyardCardState: Value(c.graveyardCardState),
                    libraryCardState: Value(c.libraryCardState),
                  ),
                )
                .toList(),
          ),
        );
        comboCardsTotal += p.cards.length;
      }

      if (p.features.isNotEmpty) {
        await db.batch(
          (b) => b.insertAll(
            db.comboFeatures,
            p.features
                .map(
                  (f) => ComboFeaturesCompanion.insert(
                    comboId: comboPk,
                    featureId: Value(f.featureId),
                    featureName: f.featureName,
                    quantity: Value(f.quantity),
                  ),
                )
                .toList(),
          ),
        );
        comboFeaturesTotal += p.features.length;
      }
    }
  });

  // Tidy up the dump after a successful write — keeps WORK_DIR small.
  if (dumpFile.existsSync()) dumpFile.deleteSync();

  return SpellbookFetchResult(
    combosInserted: pendingCombos.length,
    comboCardsInserted: comboCardsTotal,
    comboFeaturesInserted: comboFeaturesTotal,
    unresolvedCardSlots: unresolvedSlots,
    totalVariantsInDump: variants.length,
    dumpVersion: dumpVersion,
    dumpTimestamp: dumpTimestamp,
    dumpSizeBytes: size,
    fetchElapsed: stopwatch.elapsed,
  );
}

Future<void> _downloadWithRetries(
  String url,
  File dst, {
  required void Function(String) log,
}) async {
  Object? lastError;
  const backoffs = <Duration>[
    Duration(seconds: 5),
    Duration(seconds: 15),
    Duration(seconds: 30),
  ];
  for (var attempt = 0; attempt < backoffs.length; attempt++) {
    try {
      final req = http.Request('GET', Uri.parse(url))
        ..headers['User-Agent'] = _userAgent;
      final client = http.Client();
      try {
        final resp = await client.send(req).timeout(
              const Duration(minutes: 5),
            );
        if (resp.statusCode != 200) {
          lastError = 'HTTP ${resp.statusCode}';
          log(
            '  spellbook download attempt ${attempt + 1}/${backoffs.length}: '
            '$lastError',
          );
        } else {
          final sink = dst.openWrite();
          await resp.stream.pipe(sink);
          await sink.close();
          return;
        }
      } finally {
        client.close();
      }
    } catch (e) {
      lastError = e;
      log(
        '  spellbook download attempt ${attempt + 1}/${backoffs.length}: $e',
      );
    }
    await Future<void>.delayed(backoffs[attempt]);
  }
  throw 'Spellbook bulk-dump download failed after ${backoffs.length} attempts: '
      '$url ($lastError)';
}

class _PendingCombo {
  final String comboId;
  final String? description;
  final String? notes;
  final String? bracketTag;
  final String? identity;
  final String? status;
  final int? popularity;
  final int? manaValueNeeded;
  final String? manaNeeded;
  final String? easyPrerequisites;
  final String? notablePrerequisites;
  final List<_PendingCard> cards;
  final List<_PendingFeature> features;

  _PendingCombo({
    required this.comboId,
    required this.description,
    required this.notes,
    required this.bracketTag,
    required this.identity,
    required this.status,
    required this.popularity,
    required this.manaValueNeeded,
    required this.manaNeeded,
    required this.easyPrerequisites,
    required this.notablePrerequisites,
    required this.cards,
    required this.features,
  });
}

class _PendingCard {
  final int position;
  final String? oracleId;
  final String cardName;
  final String? zoneLocations;
  final int quantity;
  final bool mustBeCommander;
  final String? battlefieldCardState;
  final String? exileCardState;
  final String? graveyardCardState;
  final String? libraryCardState;

  _PendingCard({
    required this.position,
    required this.oracleId,
    required this.cardName,
    required this.zoneLocations,
    required this.quantity,
    required this.mustBeCommander,
    required this.battlefieldCardState,
    required this.exileCardState,
    required this.graveyardCardState,
    required this.libraryCardState,
  });
}

class _PendingFeature {
  final int? featureId;
  final String featureName;
  final int quantity;

  _PendingFeature({
    required this.featureId,
    required this.featureName,
    required this.quantity,
  });
}

_PendingCombo? _parseCombo(Map<String, dynamic> raw) {
  final id = raw['id']?.toString();
  if (id == null || id.isEmpty) return null;

  final apiUses = raw['uses'] as List<dynamic>? ?? const [];
  final cards = <_PendingCard>[];
  for (var i = 0; i < apiUses.length; i++) {
    final use = apiUses[i];
    if (use is! Map<String, dynamic>) continue;
    final card = use['card'] as Map<String, dynamic>?;
    if (card == null) continue;
    final name = card['name']?.toString();
    if (name == null || name.isEmpty) continue;

    final oracleId = card['oracleId']?.toString();
    final zones = use['zoneLocations'] as List<dynamic>?;
    final zonesJoined = (zones == null || zones.isEmpty)
        ? null
        : zones.map((z) => z.toString()).join(',');

    cards.add(
      _PendingCard(
        position: i + 1,
        oracleId: (oracleId != null && oracleId.isNotEmpty) ? oracleId : null,
        cardName: name,
        zoneLocations: zonesJoined,
        quantity: _asInt(use['quantity']) ?? 1,
        mustBeCommander: use['mustBeCommander'] == true,
        battlefieldCardState: _nonEmpty(use['battlefieldCardState']),
        exileCardState: _nonEmpty(use['exileCardState']),
        graveyardCardState: _nonEmpty(use['graveyardCardState']),
        libraryCardState: _nonEmpty(use['libraryCardState']),
      ),
    );
  }

  final apiProduces = raw['produces'] as List<dynamic>? ?? const [];
  final features = <_PendingFeature>[];
  final seenFeatureNames = <String>{};
  for (final p in apiProduces) {
    if (p is! Map<String, dynamic>) continue;
    final feature = p['feature'] as Map<String, dynamic>?;
    final name = feature?['name']?.toString();
    if (name == null || name.isEmpty) continue;
    if (!seenFeatureNames.add(name)) continue;
    features.add(
      _PendingFeature(
        featureId: _asInt(feature?['id']),
        featureName: name,
        quantity: _asInt(p['quantity']) ?? 1,
      ),
    );
  }

  return _PendingCombo(
    comboId: id,
    description: _nonEmpty(raw['description']),
    notes: _nonEmpty(raw['notes']),
    bracketTag: _nonEmpty(raw['bracketTag']),
    identity: _nonEmpty(raw['identity']),
    status: _nonEmpty(raw['status']),
    popularity: _asInt(raw['popularity']),
    manaValueNeeded: _asInt(raw['manaValueNeeded']),
    manaNeeded: _nonEmpty(raw['manaNeeded']),
    easyPrerequisites: _nonEmpty(raw['easyPrerequisites']),
    notablePrerequisites: _nonEmpty(raw['notablePrerequisites']),
    cards: cards,
    features: features,
  );
}

int? _asInt(Object? v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

String? _nonEmpty(Object? v) {
  if (v == null) return null;
  final s = v.toString();
  return s.isEmpty ? null : s;
}
