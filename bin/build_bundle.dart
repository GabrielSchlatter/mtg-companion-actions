/// Daily job: build the reference-data SQLite database we ship to clients.
///
/// Pipeline:
///   1. Download MTGJSON's `AllPrintings.json.gz` (cards) and
///      `AllPricesToday.json.bz2` (prices).
///   2. Run `mapMtgjsonCard` on every English card — same parser the
///      client used to run at sync time.
///   3. Open a fresh Drift `CardsDatabase` backed by a real SQLite file.
///   4. Bulk-insert mapped rows. Look up each card's prices by
///      `mtgjsonUuid` and write to `card_prices` + `cards.priceNumeric`.
///   5. Compute canonical printings → set `is_canonical_printing` per
///      oracle group winner.
///   6. Aggregate filter metadata (sets / rarities / keywords / set info)
///      → write the `card_filters` row.
///   7. Run `VACUUM` (Drift opens the result fresh on the client; smaller
///      file = faster download), close, gzip, write manifest.
///
/// Output (in `WORK_DIR`):
///   - cards.sqlite        — the Drift-compatible reference DB
///   - cards.sqlite.gz     — what we ship
///   - latest.json         — manifest the client polls
///
/// The GitHub Actions workflow uploads the gzipped file + manifest to R2.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' show Value;
import 'package:http/http.dart' as http;

import '../lib/canonical_printings.dart';
import '../lib/cards_schema.dart';
import '../lib/db/cards_database.dart';
import '../lib/filter_metadata.dart';
import '../lib/mtgjson_card_mapper.dart';
import '../lib/precon_parser.dart';
import '../lib/prices_parser.dart';

const _allPrintingsUrl = 'https://mtgjson.com/api/v5/AllPrintings.json.gz';
const _allPricesUrl = 'https://mtgjson.com/api/v5/AllPricesToday.json.bz2';
const _allDeckFilesUrl = 'https://mtgjson.com/api/v5/AllDeckFiles.zip';
const _bundleFormat = 'drift-sqlite';
const _userAgent =
    'mtg-companion-bundle-builder/1.0 '
    '(+https://github.com/GabrielSchlatter/mtg-companion-actions)';

Future<void> main(List<String> args) async {
  final workDir = Directory(
    Platform.environment['WORK_DIR'] ?? '/tmp/mtg-bundle',
  )..createSync(recursive: true);

  final today = DateTime.now().toUtc().toIso8601String().substring(0, 10);
  final printingsGz = File('${workDir.path}/AllPrintings.json.gz');
  final printingsJson = File('${workDir.path}/AllPrintings.json');
  final pricesBz2 = File('${workDir.path}/AllPricesToday.json.bz2');
  final preconsZip = File('${workDir.path}/AllDeckFiles.zip');
  final dbFile = File('${workDir.path}/cards.sqlite');
  final dbGz = File('${workDir.path}/cards.sqlite.gz');
  final manifestFile = File('${workDir.path}/latest.json');

  // Start fresh — leftover files from a prior failed run would corrupt
  // the new DB.
  if (dbFile.existsSync()) dbFile.deleteSync();
  if (dbGz.existsSync()) dbGz.deleteSync();

  await _download(_allPrintingsUrl, printingsGz);
  await _gunzip(printingsGz, printingsJson);

  await _download(_allPricesUrl, pricesBz2);
  final pricesPayload = await _decodeBz2(pricesBz2);
  _log('Parsing prices…');
  final prices = parseAllPricesToday(pricesPayload);
  _log('  ${prices.byMtgjsonUuid.length} priced cards (date=${prices.date})');

  _log('Opening cards.sqlite');
  final db = CardsDatabase.file(dbFile);

  final stats = await _writeCardsAndPrices(
    db,
    printingsJson,
    prices,
  );

  _log('Computing canonical printings…');
  await _writeCanonicalPrintings(db, stats.mappedCards);

  _log('Aggregating filter metadata…');
  await _writeFilterMetadata(db, stats.mappedCards);

  await _download(_allDeckFilesUrl, preconsZip);
  _log('Importing precon decks…');
  final preconCount = await _writePrecons(db, preconsZip, stats.mappedCards);

  // VACUUM rewrites the DB packed; same data, smaller file. Done outside
  // any transaction.
  _log('VACUUM');
  await db.customStatement('VACUUM');

  await db.close();

  final dbSize = dbFile.lengthSync();
  _log(
    '  cards.sqlite: ${(dbSize / 1_000_000).toStringAsFixed(1)} MB',
  );

  await _gzip(dbFile, dbGz);
  final gzSize = dbGz.lengthSync();
  final digest = sha256.convert(await dbGz.readAsBytes()).toString();

  final publicBaseUrl = (Platform.environment['PUBLIC_BASE_URL'] ?? '')
      .replaceAll(RegExp(r'/$'), '');
  final manifest = {
    'version': today,
    'schema_version': schemaVersion,
    'format': _bundleFormat,
    'url': '$publicBaseUrl/cards-$today.sqlite.gz',
    'latest_url': '$publicBaseUrl/cards-latest.sqlite.gz',
    'sha256': digest,
    'size_bytes': gzSize,
    'uncompressed_bytes': dbSize,
    'row_count': stats.cardsInserted,
    'priced_row_count': stats.pricesInserted,
    'precon_row_count': preconCount,
    'prices_date': prices.date,
    'generated_at': DateTime.now().toUtc().toIso8601String(),
  };
  await manifestFile.writeAsString(
    const JsonEncoder.withIndent('  ').convert(manifest),
  );

  // Surface keys to the workflow so the upload step knows what to push.
  final ghOutput = Platform.environment['GITHUB_OUTPUT'];
  if (ghOutput != null) {
    File(ghOutput).writeAsStringSync(
      [
        'version=$today',
        'workdir=${workDir.path}',
        'bundle_path=${dbGz.path}',
        'manifest_path=${manifestFile.path}',
        'versioned_key=cards-$today.sqlite.gz',
        'latest_key=cards-latest.sqlite.gz',
      ].join('\n') +
          '\n',
      mode: FileMode.append,
    );
  }

  _log(
    '✅ Build complete: ${dbGz.path} '
    '(${(gzSize / 1_000_000).toStringAsFixed(1)} MB gz, '
    '${(dbSize / 1_000_000).toStringAsFixed(1)} MB raw, '
    '${stats.cardsInserted} cards, '
    '${stats.pricesInserted} priced, '
    '$preconCount precons, '
    'sha256=${digest.substring(0, 12)}…)',
  );
}

Future<int> _writePrecons(
  CardsDatabase db,
  File zipFile,
  List<Map<String, dynamic>> mappedCards,
) async {
  // Build a `name → colorIdentity letters` index once. The browser
  // tile colors deck boxes by union-of-commanders' color identity;
  // doing this lookup at runtime forced ~200 SQL queries per screen
  // load, which froze the UI for several seconds.
  //
  // First wins by canonical printing → newest releaseDate → first seen.
  final nameToColors = <String, Set<String>>{};
  for (final c in mappedCards) {
    final name = (c['name'] as String?) ?? '';
    if (name.isEmpty) continue;
    final identity = c['colorIdentity'];
    Set<String> colors;
    if (identity is List) {
      colors = identity.whereType<String>().toSet();
    } else {
      continue;
    }
    final existing = nameToColors[name];
    final isCanonical = c['isCanonicalPrinting'] == true;
    if (existing == null || isCanonical) {
      nameToColors[name] = colors;
    }
  }

  final bytes = await zipFile.readAsBytes();
  final archive = ZipDecoder().decodeBytes(bytes);

  final pending = <PreconDecksCompanion>[];
  var skipped = 0;
  for (final f in archive.files) {
    if (!f.isFile || !f.name.endsWith('.json')) continue;
    try {
      final json = jsonDecode(utf8.decode(f.content as List<int>))
          as Map<String, dynamic>;
      final parsed = parsePreconDeckJson(json);
      if (parsed == null) {
        skipped++;
        continue;
      }

      final colorIdentity = _preconColorIdentity(parsed, nameToColors);

      pending.add(
        PreconDecksCompanion.insert(
          name: parsed.name,
          setCode: parsed.setCode,
          setName: const Value(''),
          type: parsed.type,
          releaseDate: Value(parsed.releaseDate),
          mainBoardJson: Value(parsed.mainBoardJson),
          sideBoardJson: Value(parsed.sideBoardJson),
          commandersJson: Value(parsed.commandersJson),
          featuredCardScryfallId: Value(parsed.featuredCardScryfallId),
          colorIdentityString: Value(colorIdentity),
        ),
      );
    } catch (_) {
      skipped++;
    }
  }

  if (pending.isEmpty) {
    throw 'AllDeckFiles.zip parsed to zero precons';
  }

  await db.transaction(() async {
    await db.batch((b) => b.insertAll(db.preconDecks, pending));
  });

  _log('  ${pending.length} precons (skipped $skipped malformed)');
  return pending.length;
}

/// WUBRG order — the client filter UI assumes colors come in this order
/// when matching against a hex/swatch lookup table.
const _wubrgOrder = ['W', 'U', 'B', 'R', 'G'];

/// Compute a precon's color identity by unioning its commanders'
/// colorIdentity sets (or main-board fallback for non-commander decks).
String _preconColorIdentity(
  ParsedPrecon parsed,
  Map<String, Set<String>> nameToColors,
) {
  String namesOf(String json) {
    try {
      final list = jsonDecode(json) as List<dynamic>;
      return list.map((e) => (e as Map)['name'] as String? ?? '').join('|');
    } catch (_) {
      return '';
    }
  }

  Iterable<String> namesIn(String json) sync* {
    if (json.isEmpty || json == '[]') return;
    try {
      final list = jsonDecode(json) as List<dynamic>;
      for (final e in list) {
        final n = (e as Map)['name'] as String?;
        if (n != null && n.isNotEmpty) yield n;
      }
    } catch (_) {}
  }

  final colors = <String>{};

  // Commanders take priority — for Commander decks this is the source
  // of truth even if some main-board card has a wider identity.
  final commanderNames = namesOf(parsed.commandersJson);
  if (commanderNames.isNotEmpty) {
    for (final name in namesIn(parsed.commandersJson)) {
      final c = nameToColors[name];
      if (c != null) colors.addAll(c);
    }
  } else {
    // Non-commander decks: union the whole main board.
    for (final name in namesIn(parsed.mainBoardJson)) {
      final c = nameToColors[name];
      if (c != null) colors.addAll(c);
    }
  }

  return _wubrgOrder.where(colors.contains).join();
}

void _log(String msg) {
  final ts = DateTime.now().toUtc().toIso8601String();
  stdout.writeln('[$ts] $msg');
}

Future<void> _download(String url, File dst) async {
  _log('Downloading $url → ${dst.path}');
  final req = http.Request('GET', Uri.parse(url))
    ..headers['User-Agent'] = _userAgent;
  final client = http.Client();
  try {
    final resp = await client.send(req);
    if (resp.statusCode != 200) {
      throw 'Download failed: HTTP ${resp.statusCode}';
    }
    final sink = dst.openWrite();
    await resp.stream.pipe(sink);
    await sink.close();
    _log('  size: ${(dst.lengthSync() / 1_000_000).toStringAsFixed(1)} MB');
  } finally {
    client.close();
  }
}

Future<void> _gunzip(File src, File dst) async {
  _log('Decompressing ${src.path} → ${dst.path}');
  final sink = dst.openWrite();
  await src.openRead().transform(gzip.decoder).pipe(sink);
  await sink.close();
  _log('  size: ${(dst.lengthSync() / 1_000_000).toStringAsFixed(1)} MB');
}

Future<void> _gzip(File src, File dst) async {
  _log('Compressing ${src.path} → ${dst.path}');
  final sink = dst.openWrite();
  await src.openRead().transform(gzip.encoder).pipe(sink);
  await sink.close();
  _log('  size: ${(dst.lengthSync() / 1_000_000).toStringAsFixed(1)} MB');
}

/// AllPricesToday is bz2, not gz — `package:archive`'s pure-Dart
/// `BZip2Decoder` handles it without needing a system binary on the runner.
Future<Uint8List> _decodeBz2(File src) async {
  _log('Decompressing ${src.path}');
  final raw = await src.readAsBytes();
  final out = BZip2Decoder().decodeBytes(raw);
  _log('  size: ${(out.length / 1_000_000).toStringAsFixed(1)} MB');
  return Uint8List.fromList(out);
}

class _BuildStats {
  /// All mapped cards in insertion order — kept for the canonical /
  /// filter-metadata passes so we don't have to re-read from the DB.
  final List<Map<String, dynamic>> mappedCards;
  final int cardsInserted;
  final int pricesInserted;

  _BuildStats({
    required this.mappedCards,
    required this.cardsInserted,
    required this.pricesInserted,
  });
}

/// Walk every set/card in AllPrintings, dedupe split-card faces by
/// scryfallId (first occurrence wins — the mapper resolves the other face
/// via `uuidMap`), and bulk-insert into [Cards] + [CardPrices].
Future<_BuildStats> _writeCardsAndPrices(
  CardsDatabase db,
  File jsonFile,
  PricesParseResult prices,
) async {
  _log('Parsing AllPrintings (this loads ~700 MB into memory — fine on a 16 GB CI runner)');
  final raw = await jsonFile.readAsString();
  final root = jsonDecode(raw) as Map<String, dynamic>;
  final data = root['data'] as Map<String, dynamic>;
  _log('  sets: ${data.length}');

  final mappedCards = <Map<String, dynamic>>[];
  final pendingCards = <CardsCompanion>[];
  final pendingPrices = <CardPricesCompanion>[];
  final seen = <String>{};
  var skipped = 0;
  var dedupSkipped = 0;
  var pricesInserted = 0;
  var setIdx = 0;

  const batchSize = 2000;

  Future<void> flushBatches() async {
    if (pendingCards.isNotEmpty) {
      await db.batch((b) => b.insertAll(db.cards, List.of(pendingCards)));
      pendingCards.clear();
    }
    if (pendingPrices.isNotEmpty) {
      await db.batch((b) => b.insertAll(db.cardPrices, List.of(pendingPrices)));
      pendingPrices.clear();
    }
  }

  // Single transaction wrapping all the inserts gives ~10× speedup on
  // SQLite (no per-statement fsync).
  await db.transaction(() async {
    for (final entry in data.entries) {
      final setObj = entry.value as Map<String, dynamic>;
      final setName = setObj['name'] as String? ?? entry.key;
      final setType = setObj['type'] as String? ?? 'expansion';
      final releaseDate = setObj['releaseDate'] as String? ?? '';
      final cards = setObj['cards'] as List<dynamic>? ?? const [];

      // Per-set uuid → card map for DFC face resolution inside the mapper.
      final uuidMap = <String, Map<String, dynamic>>{};
      for (final c in cards) {
        final m = c as Map<String, dynamic>;
        final u = m['uuid'] as String?;
        if (u != null) uuidMap[u] = m;
      }

      for (final cj in cards) {
        final card = cj as Map<String, dynamic>;
        final mapped = mapMtgjsonCard(
          card,
          setName,
          setType,
          releaseDate,
          'en',
          uuidMap: uuidMap,
        );
        if (mapped == null) {
          skipped++;
          continue;
        }
        final sid = mapped['scryfallId'] as String?;
        if (sid == null) {
          skipped++;
          continue;
        }
        if (!seen.add(sid)) {
          dedupSkipped++;
          continue;
        }

        // Look up prices by mtgjsonUuid (with language-suffix strip on
        // the lookup side — non-English UUIDs get `_xx` suffixes).
        final mtgjsonUuid = mapped['mtgjsonUuid'] as String?;
        final priceRecord = mtgjsonUuid != null
            ? prices.byMtgjsonUuid[mtgjsonUuid]
            : null;
        if (priceRecord != null) {
          mapped['priceNumeric'] = priceRecord.primaryPrice;
          pendingPrices.add(_priceCompanion(sid, priceRecord, prices.date));
          pricesInserted++;
        }

        mappedCards.add(mapped);
        pendingCards.add(_cardCompanion(mapped));

        if (pendingCards.length >= batchSize) {
          await flushBatches();
        }
      }

      setIdx++;
      if (setIdx % 50 == 0) {
        _log(
          '  processed $setIdx/${data.length} sets · '
          '${mappedCards.length} rows · $skipped skipped · $dedupSkipped dups',
        );
      }
    }
    await flushBatches();
  });

  _log(
    'Wrote ${mappedCards.length} cards '
    '(skipped $skipped without scryfallId, $dedupSkipped duplicates), '
    '$pricesInserted priced',
  );

  if (mappedCards.length < 30000) {
    throw 'Suspiciously few cards (${mappedCards.length})';
  }

  return _BuildStats(
    mappedCards: mappedCards,
    cardsInserted: mappedCards.length,
    pricesInserted: pricesInserted,
  );
}

Future<void> _writeCanonicalPrintings(
  CardsDatabase db,
  List<Map<String, dynamic>> mappedCards,
) async {
  final result = computeCanonicalPrintings(mappedCards);
  _log(
    '  ${result.canonicalIds.length} canonical, '
    '${result.colorIdentityStringFixes.length} colorIdentityString fix-ups',
  );

  // Chunked IN-clause updates; per-row would compile 30k+ statements.
  const chunk = 500;
  final ids = result.canonicalIds.toList();
  for (var i = 0; i < ids.length; i += chunk) {
    final slice = ids.sublist(i, i + chunk > ids.length ? ids.length : i + chunk);
    final placeholders = List.filled(slice.length, '?').join(',');
    await db.customStatement(
      'UPDATE cards SET is_canonical_printing = 1 '
      'WHERE scryfall_id IN ($placeholders)',
      slice,
    );
  }

  if (result.colorIdentityStringFixes.isNotEmpty) {
    final byValue = <String, List<String>>{};
    for (final entry in result.colorIdentityStringFixes.entries) {
      byValue.putIfAbsent(entry.value, () => []).add(entry.key);
    }
    for (final entry in byValue.entries) {
      final scryfallIds = entry.value;
      for (var i = 0; i < scryfallIds.length; i += chunk) {
        final slice = scryfallIds.sublist(
          i,
          i + chunk > scryfallIds.length ? scryfallIds.length : i + chunk,
        );
        final placeholders = List.filled(slice.length, '?').join(',');
        await db.customStatement(
          'UPDATE cards SET color_identity_string = ? '
          'WHERE scryfall_id IN ($placeholders)',
          [entry.value, ...slice],
        );
      }
    }
  }
}

Future<void> _writeFilterMetadata(
  CardsDatabase db,
  List<Map<String, dynamic>> mappedCards,
) async {
  final p = computeFilterMetadata(mappedCards);
  await db.into(db.filterMetadata).insert(
        FilterMetadataCompanion.insert(
          key: 'card_filters',
          setsJson: Value(p.setsJson),
          setsMapJson: Value(p.setsMapJson),
          raritiesJson: Value(p.raritiesJson),
          keywordsJson: Value(p.keywordsJson),
          setMetadataJson: Value(p.setMetadataJson),
          updatedAt: DateTime.now().toUtc(),
        ),
      );
}

CardsCompanion _cardCompanion(Map<String, dynamic> m) {
  String? str(String key) => m[key] as String?;
  int? asInt(String key) {
    final v = m[key];
    return v is int ? v : (v is num ? v.toInt() : null);
  }

  double? asNum(String key) {
    final v = m[key];
    return v is num ? v.toDouble() : null;
  }

  bool boolOr(String key, {bool fallback = false}) {
    final v = m[key];
    if (v is bool) return v;
    if (v is int) return v != 0;
    return fallback;
  }

  bool? boolOrNull(String key) {
    final v = m[key];
    if (v == null) return null;
    if (v is bool) return v;
    if (v is int) return v != 0;
    return null;
  }

  String jsonList(String key, {String fallback = '[]'}) {
    final v = m[key];
    if (v == null) return fallback;
    if (v is String) return v;
    try {
      return jsonEncode(v);
    } catch (_) {
      return fallback;
    }
  }

  String? jsonOrNull(String key) {
    final v = m[key];
    if (v == null) return null;
    if (v is String) return v;
    try {
      return jsonEncode(v);
    } catch (_) {
      return null;
    }
  }

  return CardsCompanion.insert(
    scryfallId: str('scryfallId') ?? '',
    mtgjsonUuid: Value(str('mtgjsonUuid')),
    oracleId: str('oracleId') ?? '',
    name: str('name') ?? '',
    flavorName: Value(str('flavorName')),
    lang: str('lang') ?? 'en',
    releasedAt: str('releasedAt') ?? '',
    uri: str('uri') ?? '',
    scryfallUri: str('scryfallUri') ?? '',
    layout: str('layout') ?? 'normal',
    manaCost: Value(str('manaCost')),
    cmc: asNum('cmc') ?? 0.0,
    typeLine: str('typeLine') ?? '',
    oracleText: Value(str('oracleText')),
    flavorText: Value(str('flavorText')),
    power: Value(str('power')),
    toughness: Value(str('toughness')),
    colorsJson: Value(jsonList('colors')),
    colorIdentityJson: Value(jsonList('colorIdentity')),
    keywordsJson: Value(jsonOrNull('keywords')),
    colorsString: Value(str('colorsString') ?? ''),
    colorIdentityString: Value(str('colorIdentityString') ?? ''),
    legalInAnyFormat: Value(boolOr('legalInAnyFormat')),
    isCanonicalPrinting: const Value(false),
    setCode: str('setCode') ?? '',
    setName: str('setName') ?? '',
    setType: str('setType') ?? '',
    collectorNumber: str('collectorNumber') ?? '',
    digital: boolOr('digital'),
    rarity: str('rarity') ?? 'common',
    rarityOrder: Value(asInt('rarityOrder') ?? 0),
    powerNumeric: Value(asNum('powerNumeric')),
    toughnessNumeric: Value(asNum('toughnessNumeric')),
    artist: Value(str('artist')),
    borderColor: str('borderColor') ?? 'black',
    frame: str('frame') ?? '2015',
    fullArt: boolOr('fullArt'),
    textless: boolOr('textless'),
    booster: boolOr('booster'),
    storySpotlight: boolOr('storySpotlight'),
    imageStatus: str('imageStatus') ?? 'highres_scan',
    imageSmall: Value(str('imageSmall')),
    imageNormal: Value(str('imageNormal')),
    imageLarge: Value(str('imageLarge')),
    imagePng: Value(str('imagePng')),
    imageArtCrop: Value(str('imageArtCrop')),
    imageBorderCrop: Value(str('imageBorderCrop')),
    legalStandard: str('legalStandard') ?? 'not_legal',
    legalFuture: str('legalFuture') ?? 'not_legal',
    legalHistoric: str('legalHistoric') ?? 'not_legal',
    legalGladiator: str('legalGladiator') ?? 'not_legal',
    legalPioneer: str('legalPioneer') ?? 'not_legal',
    legalExplorer: Value(str('legalExplorer')),
    legalModern: str('legalModern') ?? 'not_legal',
    legalLegacy: str('legalLegacy') ?? 'not_legal',
    legalPauper: str('legalPauper') ?? 'not_legal',
    legalVintage: str('legalVintage') ?? 'not_legal',
    legalPenny: str('legalPenny') ?? 'not_legal',
    legalCommander: str('legalCommander') ?? 'not_legal',
    legalOathbreaker: str('legalOathbreaker') ?? 'not_legal',
    legalBrawl: str('legalBrawl') ?? 'not_legal',
    legalHistoricbrawl: Value(str('legalHistoricbrawl')),
    legalAlchemy: str('legalAlchemy') ?? 'not_legal',
    legalPaupercommander: str('legalPaupercommander') ?? 'not_legal',
    legalDuel: str('legalDuel') ?? 'not_legal',
    legalOldschool: str('legalOldschool') ?? 'not_legal',
    legalPremodern: str('legalPremodern') ?? 'not_legal',
    legalPredh: str('legalPredh') ?? 'not_legal',
    priceUsd: Value(str('priceUsd')),
    priceUsdFoil: Value(str('priceUsdFoil')),
    priceUsdEtched: Value(str('priceUsdEtched')),
    priceEur: Value(str('priceEur')),
    priceEurFoil: Value(str('priceEurFoil')),
    priceTix: Value(str('priceTix')),
    priceNumeric: Value(asNum('priceNumeric')),
    cardFacesJson: Value(str('cardFacesJson')),
    rulingsJson: Value(str('rulingsJson')),
    object: str('object') ?? 'card',
    oversized: boolOr('oversized'),
    promo: boolOr('promo'),
    reprint: boolOr('reprint'),
    variation: boolOr('variation'),
    gamesJson: Value(jsonList('games')),
    reserved: boolOr('reserved'),
    foil: boolOr('foil'),
    nonfoil: boolOr('nonfoil'),
    finishesJson: Value(jsonList('finishes')),
    producedManaJson: Value(jsonList('producedMana')),
    edhrecRank: Value(asInt('edhrecRank')),
    isGameChanger: Value(boolOrNull('isGameChanger')),
    relatedTokenIdsJson: Value(jsonList('relatedTokenIds')),
    mtgoId: Value(asInt('mtgoId')),
    arenaId: Value(asInt('arenaId')),
    tcgplayerId: Value(asInt('tcgplayerId')),
    cardmarketId: Value(asInt('cardmarketId')),
  );
}

CardPricesCompanion _priceCompanion(
  String scryfallId,
  CardPriceRecord r,
  String date,
) {
  return CardPricesCompanion.insert(
    scryfallId: scryfallId,
    cardmarketEur: Value(r.cardmarketEur),
    cardmarketEurFoil: Value(r.cardmarketEurFoil),
    tcgplayerUsd: Value(r.tcgplayerUsd),
    tcgplayerUsdFoil: Value(r.tcgplayerUsdFoil),
    cardKingdomUsd: Value(r.cardKingdomUsd),
    cardKingdomUsdFoil: Value(r.cardKingdomUsdFoil),
    cardKingdomBuylistUsd: Value(r.cardKingdomBuylistUsd),
    fetchedDate: date,
  );
}
