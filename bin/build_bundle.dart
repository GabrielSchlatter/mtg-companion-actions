/// Weekly job: download MTGJSON's AllPrintings.json.gz, run the same
/// parser the mobile app uses (mirrored from `mtgjson_sync_service.dart`),
/// emit one JSON object per English card to a single NDJSON file, gzip
/// it, and write a manifest. The R2 upload is handled by the GitHub
/// Actions workflow (via `aws s3 cp`).
///
/// NDJSON (newline-delimited JSON) is used instead of a pre-built SQLite
/// because the web client can stream-parse + bulk-insert via Drift in one
/// pass, without needing a separate sqlite3.wasm load to extract rows
/// from a binary database file.
///
/// Outputs (in WORK_DIR):
///   - cards.ndjson       — one JSON object per line, mapper output shape
///   - cards.ndjson.gz    — what we ship
///   - latest.json        — manifest the web client polls

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import '../lib/cards_schema.dart';
import '../lib/mtgjson_card_mapper.dart';

const mtgjsonUrl = 'https://mtgjson.com/api/v5/AllPrintings.json.gz';
const bundleFormat = 'ndjson';

Future<void> main(List<String> args) async {
  final workDir = Directory(
    Platform.environment['WORK_DIR'] ?? '/tmp/mtg-bundle',
  )..createSync(recursive: true);

  final today = DateTime.now().toUtc().toIso8601String().substring(0, 10);
  final downloadGz = File('${workDir.path}/AllPrintings.json.gz');
  final downloadJson = File('${workDir.path}/AllPrintings.json');
  final outNdjson = File('${workDir.path}/cards.ndjson');
  final outGz = File('${workDir.path}/cards.ndjson.gz');
  final manifestFile = File('${workDir.path}/latest.json');

  await _download(mtgjsonUrl, downloadGz);
  await _gunzip(downloadGz, downloadJson);
  final rows = await _writeNdjson(downloadJson, outNdjson);
  await _gzip(outNdjson, outGz);

  final digest = await _sha256Of(outGz);
  final size = await outGz.length();

  final publicBaseUrl =
      (Platform.environment['PUBLIC_BASE_URL'] ?? '').replaceAll(RegExp(r'/$'), '');
  final manifest = {
    'version': today,
    'schema_version': schemaVersion,
    'format': bundleFormat,
    'url': '$publicBaseUrl/cards-$today.ndjson.gz',
    'latest_url': '$publicBaseUrl/cards-latest.ndjson.gz',
    'sha256': digest,
    'size_bytes': size,
    'row_count': rows,
    'generated_at': DateTime.now().toUtc().toIso8601String(),
  };
  await manifestFile.writeAsString(
    const JsonEncoder.withIndent('  ').convert(manifest),
  );

  // GitHub Actions step outputs so the workflow knows the names to upload.
  final ghOutput = Platform.environment['GITHUB_OUTPUT'];
  if (ghOutput != null) {
    File(ghOutput).writeAsStringSync(
      [
        'version=$today',
        'workdir=${workDir.path}',
        'bundle_path=${outGz.path}',
        'manifest_path=${manifestFile.path}',
        'versioned_key=cards-$today.ndjson.gz',
        'latest_key=cards-latest.ndjson.gz',
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

/// Read AllPrintings.json, run [mapMtgjsonCard] over every English card,
/// and write one JSON object per line to [out]. Returns the row count.
Future<int> _writeNdjson(File jsonFile, File out) async {
  if (out.existsSync()) out.deleteSync();

  _log('Parsing JSON (this loads ~700 MB into memory — fine on a 16 GB CI runner)');
  final raw = await jsonFile.readAsString();
  final root = jsonDecode(raw) as Map<String, dynamic>;
  final data = root['data'] as Map<String, dynamic>;
  _log('  sets: ${data.length}');

  final sink = out.openWrite();
  var rows = 0;
  var skipped = 0;
  var setIdx = 0;

  try {
    for (final entry in data.entries) {
      final setObj = entry.value as Map<String, dynamic>;
      final setName = setObj['name'] as String? ?? entry.key;
      final setType = setObj['type'] as String? ?? 'expansion';
      final releaseDate = setObj['releaseDate'] as String? ?? '';
      final cards = setObj['cards'] as List<dynamic>? ?? const [];

      // Per-set uuid → card map, used by mapMtgjsonCard for DFC face
      // resolution.
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
        sink.writeln(jsonEncode(mapped));
        rows++;
      }

      setIdx++;
      if (setIdx % 50 == 0) {
        _log('  processed $setIdx/${data.length} sets · '
            '$rows rows · $skipped skipped');
      }
    }
  } finally {
    await sink.flush();
    await sink.close();
  }

  _log('Wrote $rows rows (skipped $skipped without scryfallId)');
  final size = out.lengthSync();
  _log('  cards.ndjson: ${(size / 1_000_000).toStringAsFixed(1)} MB');
  if (size < 50 * 1024 * 1024) {
    throw 'cards.ndjson is suspiciously small ($size bytes)';
  }
  return rows;
}
