/// Weekly job: download MTGJSON's AllPrintings.json.gz, run the same parser
/// the mobile app uses (mirrored from `mtgjson_sync_service.dart`), write
/// the result into a SQLite file matching the app's Drift `cards` schema,
/// gzip it, and write a manifest. The R2 upload is handled by the GitHub
/// Actions workflow (via `aws s3 cp`).
///
/// Outputs (in WORK_DIR):
///   - cards.sqlite       — uncompressed bundle DB
///   - cards.sqlite.gz    — what we ship
///   - latest.json        — manifest the web client polls

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:sqlite3/sqlite3.dart';

import '../lib/cards_schema.dart';
import '../lib/mtgjson_card_mapper.dart';

const mtgjsonUrl = 'https://mtgjson.com/api/v5/AllPrintings.json.gz';

Future<void> main(List<String> args) async {
  final workDir = Directory(
    Platform.environment['WORK_DIR'] ?? '/tmp/mtg-bundle',
  )..createSync(recursive: true);

  final today = DateTime.now().toUtc().toIso8601String().substring(0, 10);
  final downloadGz = File('${workDir.path}/AllPrintings.json.gz');
  final downloadJson = File('${workDir.path}/AllPrintings.json');
  final outDb = File('${workDir.path}/cards.sqlite');
  final outGz = File('${workDir.path}/cards.sqlite.gz');
  final manifestFile = File('${workDir.path}/latest.json');

  await _download(mtgjsonUrl, downloadGz);
  await _gunzip(downloadGz, downloadJson);
  final rows = await _buildBundle(downloadJson, outDb);
  await _gzip(outDb, outGz);

  final digest = await _sha256Of(outGz);
  final size = await outGz.length();

  final publicBaseUrl =
      (Platform.environment['PUBLIC_BASE_URL'] ?? '').replaceAll(RegExp(r'/$'), '');
  final manifest = {
    'version': today,
    'schema_version': schemaVersion,
    'url': '$publicBaseUrl/cards-$today.sqlite.gz',
    'latest_url': '$publicBaseUrl/cards-latest.sqlite.gz',
    'sha256': digest,
    'size_bytes': size,
    'row_count': rows,
    'generated_at': DateTime.now().toUtc().toIso8601String(),
  };
  await manifestFile.writeAsString(const JsonEncoder.withIndent('  ').convert(manifest));

  // Emit GitHub Actions outputs so the workflow can name files / upload.
  final ghOutput = Platform.environment['GITHUB_OUTPUT'];
  if (ghOutput != null) {
    File(ghOutput).writeAsStringSync(
      [
        'version=$today',
        'workdir=${workDir.path}',
        'bundle_path=${outGz.path}',
        'manifest_path=${manifestFile.path}',
        'versioned_key=cards-$today.sqlite.gz',
      ].join('\n') + '\n',
      mode: FileMode.append,
    );
  }

  _log('✅ Build complete: ${outGz.path} '
      '(${(size / 1_000_000).toStringAsFixed(1)} MB, '
      '$rows rows, sha256=${digest.substring(0, 12)}…)');
}

void _log(String msg) {
  final ts = DateTime.now().toUtc().toIso8601String();
  stdout.writeln('[$ts] $msg');
}

Future<void> _download(String url, File dst) async {
  _log('Downloading $url → ${dst.path}');
  // MTGJSON's CDN 403s the bare default UA — set a real one.
  final req = http.Request('GET', Uri.parse(url))
    ..headers['User-Agent'] =
        'mtg-companion-bundle-builder/1.0 (+https://github.com/GabrielSchlatter/mtg-companion-actions)';
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

Future<String> _sha256Of(File f) async {
  final bytes = await f.readAsBytes();
  return sha256.convert(bytes).toString();
}

/// Read the AllPrintings.json file, run [mapMtgjsonCard] over every English
/// card, and write the results to the output SQLite. Returns the number of
/// rows inserted.
Future<int> _buildBundle(File jsonFile, File outDb) async {
  if (outDb.existsSync()) outDb.deleteSync();

  _log('Parsing JSON (this loads ~700 MB into memory — fine on a 16 GB CI runner)');
  final raw = await jsonFile.readAsString();
  final root = jsonDecode(raw) as Map<String, dynamic>;
  final data = root['data'] as Map<String, dynamic>;
  _log('  sets: ${data.length}');

  final db = sqlite3.open(outDb.path);
  // Speed up the bulk import without breaking VACUUM. journal_mode=OFF
  // makes VACUUM undefined (it produced a 1.6 KiB file in the previous
  // run); synchronous=NORMAL is plenty for a CI-disposable build.
  db.execute('PRAGMA synchronous = NORMAL');
  db.execute('PRAGMA temp_store = MEMORY');
  db.execute(createCardsSql);
  for (final stmt in createIndexesSql) {
    db.execute(stmt);
  }

  final insert = db.prepare(insertSql);
  var inserted = 0;
  var skipped = 0;
  var setIdx = 0;

  db.execute('BEGIN');
  try {
    for (final entry in data.entries) {
      final setObj = entry.value as Map<String, dynamic>;
      final setName = setObj['name'] as String? ?? entry.key;
      final setType = setObj['type'] as String? ?? 'expansion';
      final releaseDate = setObj['releaseDate'] as String? ?? '';
      final cards = setObj['cards'] as List<dynamic>? ?? const [];

      // Build the per-set uuid map once so DFC face resolution works.
      final uuidMap = <String, Map<String, dynamic>>{};
      for (final c in cards) {
        final m = c as Map<String, dynamic>;
        final u = m['uuid'] as String?;
        if (u != null) uuidMap[u] = m;
      }

      for (final cj in cards) {
        final card = cj as Map<String, dynamic>;
        final mapped = mapMtgjsonCard(
          card, setName, setType, releaseDate, 'en',
          uuidMap: uuidMap,
        );
        if (mapped == null) {
          skipped++;
          continue;
        }
        insert.execute(insertParametersFor(mapped));
        inserted++;
      }

      setIdx++;
      if (setIdx % 50 == 0) {
        _log('  processed $setIdx/${data.length} sets · '
            '$inserted inserted · $skipped skipped');
      }
    }
    db.execute('COMMIT');
  } catch (_) {
    db.execute('ROLLBACK');
    rethrow;
  } finally {
    insert.dispose();
  }

  _log('Inserted $inserted cards (skipped $skipped without scryfallId)');
  _log('VACUUMing — final compaction before shipping');
  db.execute('VACUUM');
  db.dispose();

  // Cheap defence against future foot-guns (last run produced a 1.6 KiB
  // file because PRAGMA journal_mode=OFF made VACUUM undefined).
  final dbSize = outDb.lengthSync();
  _log('  cards.sqlite: ${(dbSize / 1024 / 1024).toStringAsFixed(1)} MB');
  if (dbSize < 5 * 1024 * 1024) {
    throw 'cards.sqlite is suspiciously small ($dbSize bytes) — '
        'aborting before we ship a broken bundle';
  }
  return inserted;
}
