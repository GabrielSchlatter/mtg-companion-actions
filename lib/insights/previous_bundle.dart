import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:http/http.dart' as http;

import '../cards_schema.dart';
import '../db/cards_database.dart';

/// Download + open the previous build's `cards-latest.sqlite.gz` from R2
/// and copy its insights tables forward into the new build. Each weekly
/// run starts where the last one left off, so the Tagger / EDHREC
/// crawlers only have to fetch newly-added canonical printings or
/// stale rows.
///
/// The previous bundle is publicly readable in R2 — no credentials
/// required for the seed read. Schema-version mismatch (e.g. after a
/// schema bump) silently skips the seed and the crawl rebuilds from
/// scratch.

const String _userAgent =
    'mtg-companion-bundle-builder/1.0 '
    '(+https://github.com/GabrielSchlatter/mtg-companion-actions)';

/// Insights tables to forward-copy from the previous bundle.
///
/// Every insights table is seeded — including combos. The principle is
/// "the new bundle starts with last week's data, then phases overwrite
/// only on success". A failed combo refresh, a stalled Tagger crawl, or
/// an EDHREC outage all leave the seeded rows in place so we never ship
/// a bundle worse than the last one. Successful refreshes wipe-and-
/// rewrite their tables (combos) or update only the rows they re-fetched
/// (Tagger / EDHREC, gated by their crawl-status tables).
const List<String> _insightsTables = [
  'tags',
  'tag_ancestors',
  'card_tags',
  'card_relationships',
  'tagger_crawl_status',
  'combos',
  'combo_cards',
  'combo_features',
  'edhrec_pages',
  'edhrec_recommendations',
  'edhrec_themes',
  'edhrec_tag_links',
];

class SeedResult {
  final bool used;
  final String? skipReason;
  final Map<String, int> rowsCopied;

  SeedResult({
    required this.used,
    required this.skipReason,
    required this.rowsCopied,
  });

  int get totalRows => rowsCopied.values.fold(0, (a, b) => a + b);
}

/// Try to download + apply the previous bundle as a seed. Returns a
/// [SeedResult] describing what happened — never throws on a missing
/// or incompatible seed (those are normal first-run / post-bump
/// conditions). Genuine network errors after retries do throw.
Future<SeedResult> seedFromPreviousBundle(
  CardsDatabase db, {
  required String bundleUrl,
  required Directory workDir,
  void Function(String)? log,
}) async {
  void emit(String msg) => (log ?? (m) => stdout.writeln(m))(msg);

  final tmpGz = File('${workDir.path}/prev_cards.sqlite.gz');
  final tmpDb = File('${workDir.path}/prev_cards.sqlite');
  // Clean any leftover from a previous run.
  if (tmpGz.existsSync()) tmpGz.deleteSync();
  if (tmpDb.existsSync()) tmpDb.deleteSync();

  emit('Seed: trying $bundleUrl');
  final downloaded = await _tryDownload(bundleUrl, tmpGz, log: emit);
  if (!downloaded) {
    return SeedResult(
      used: false,
      skipReason: 'previous bundle not available (404 or repeated 5xx)',
      rowsCopied: const {},
    );
  }

  try {
    await _gunzip(tmpGz, tmpDb);
  } catch (e) {
    return SeedResult(
      used: false,
      skipReason: 'gunzip failed: $e',
      rowsCopied: const {},
    );
  }

  // Schema check — abort the seed if the previous bundle was built
  // before the current schemaVersion. Reading PRAGMA user_version from
  // the attached file is the simplest validation.
  final prevSchemaVersion = await _readSchemaVersion(db, tmpDb);
  if (prevSchemaVersion != schemaVersion) {
    return SeedResult(
      used: false,
      skipReason:
          'previous bundle schemaVersion=$prevSchemaVersion, current=$schemaVersion',
      rowsCopied: const {},
    );
  }

  final rowsCopied = <String, int>{};
  await db.transaction(() async {
    await db.customStatement(
      "ATTACH DATABASE '${tmpDb.path}' AS prev",
    );
    try {
      for (final table in _insightsTables) {
        // Existence check — `tag_ancestors` etc. only exist from
        // schemaVersion 3 onwards. If we ever extend this list to a
        // newer table, missing tables in older bundles silently skip.
        final exists = await _tableExists(db, 'prev', table);
        if (!exists) continue;
        final count = await _copyTable(db, table);
        rowsCopied[table] = count;
      }
    } finally {
      await db.customStatement('DETACH DATABASE prev');
    }
  });

  return SeedResult(
    used: true,
    skipReason: null,
    rowsCopied: rowsCopied,
  );
}

Future<bool> _tryDownload(
  String url,
  File dst, {
  required void Function(String) log,
}) async {
  for (var attempt = 0; attempt < 3; attempt++) {
    try {
      final req = http.Request('GET', Uri.parse(url))
        ..headers['User-Agent'] = _userAgent;
      final client = http.Client();
      try {
        final resp = await client.send(req).timeout(const Duration(seconds: 60));
        if (resp.statusCode == 404) {
          log('  no prior bundle (404)');
          return false;
        }
        if (resp.statusCode != 200) {
          log('  download HTTP ${resp.statusCode} (attempt ${attempt + 1}/3)');
          await Future<void>.delayed(Duration(seconds: (attempt + 1) * 2));
          continue;
        }
        final sink = dst.openWrite();
        await resp.stream.pipe(sink);
        await sink.close();
        log(
          '  downloaded: '
          '${(dst.lengthSync() / 1_000_000).toStringAsFixed(1)} MB',
        );
        return true;
      } finally {
        client.close();
      }
    } catch (e) {
      log('  download error: $e (attempt ${attempt + 1}/3)');
      await Future<void>.delayed(Duration(seconds: (attempt + 1) * 2));
    }
  }
  return false;
}

Future<void> _gunzip(File src, File dst) async {
  final raw = await src.readAsBytes();
  final out = GZipDecoder().decodeBytes(raw);
  await dst.writeAsBytes(Uint8List.fromList(out));
}

Future<int> _readSchemaVersion(CardsDatabase db, File prevFile) async {
  // Use a separate attach to keep transactions clean.
  await db.customStatement("ATTACH DATABASE '${prevFile.path}' AS prev_check");
  try {
    final result = await db.customSelect('PRAGMA prev_check.user_version').get();
    if (result.isEmpty) return -1;
    return result.first.data.values.first as int? ?? -1;
  } finally {
    await db.customStatement('DETACH DATABASE prev_check');
  }
}

Future<bool> _tableExists(
  CardsDatabase db,
  String dbName,
  String tableName,
) async {
  final rows = await db.customSelect(
    "SELECT name FROM $dbName.sqlite_master "
    "WHERE type = 'table' AND name = ?",
    variables: [Variable(tableName)],
  ).get();
  return rows.isNotEmpty;
}

Future<int> _copyTable(CardsDatabase db, String table) async {
  // Plain `INSERT INTO main.<t> SELECT * FROM prev.<t>` works because
  // both schemas are identical (schemaVersion check above) and the
  // autoincrement `id` column is part of `*`. No conflicts since the
  // destination tables start empty.
  await db.customStatement('INSERT INTO main.$table SELECT * FROM prev.$table');
  final rows = await db.customSelect('SELECT COUNT(*) AS c FROM main.$table').get();
  return rows.isEmpty ? 0 : (rows.first.data['c'] as int? ?? 0);
}
