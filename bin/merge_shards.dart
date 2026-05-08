/// Fan-in step for the matrix workflow.
///
/// Takes the base bundle (cards + prices + precons + combos, no insights)
/// produced by `build-base`, plus N shard SQLites each carrying their
/// own slice of tagger or EDHREC data, and merges everything into one
/// final bundle. Optionally seeds from the previous published bundle so
/// any oracle the shards didn't crawl this run carries forward.
///
/// Output is the same set of artifacts `build_bundle.dart` produces:
/// `cards.sqlite`, `cards.sqlite.gz`, `latest.json`, plus the
/// GITHUB_OUTPUT keys the workflow's R2-upload step consumes.
///
/// Usage:
/// ```
/// dart run bin/merge_shards.dart \
///   --base /tmp/.../cards-base/cards.sqlite \
///   --shard /tmp/.../cards-tagger-shard-0/cards.sqlite \
///   --shard /tmp/.../cards-tagger-shard-1/cards.sqlite \
///   --shard /tmp/.../cards-tagger-shard-2/cards.sqlite \
///   --shard /tmp/.../cards-edhrec-shard-0/cards.sqlite \
///   --shard /tmp/.../cards-edhrec-shard-1/cards.sqlite \
///   --shard /tmp/.../cards-edhrec-shard-2/cards.sqlite
/// ```
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:http/http.dart' as http;

import '../lib/cards_schema.dart';
import '../lib/db/cards_database.dart';

const _bundleFormat = 'drift-sqlite';
const _userAgent =
    'mtg-companion-bundle-builder/1.0 '
    '(+https://github.com/GabrielSchlatter/mtg-companion-actions)';

Future<void> main(List<String> args) async {
  final parsed = _parseArgs(args);
  if (parsed.base == null || parsed.shards.isEmpty) {
    stderr.writeln(
      'Usage: dart run bin/merge_shards.dart '
      '--base PATH --shard PATH [--shard PATH ...]',
    );
    exit(2);
  }

  final workDir = Directory(
    Platform.environment['WORK_DIR'] ?? '/tmp/mtg-bundle-merged',
  )..createSync(recursive: true);
  final outDb = File('${workDir.path}/cards.sqlite');
  final outGz = File('${workDir.path}/cards.sqlite.gz');
  final manifestFile = File('${workDir.path}/latest.json');
  if (outDb.existsSync()) outDb.deleteSync();
  if (outGz.existsSync()) outGz.deleteSync();

  // The base SQLite already has cards/prices/precons/combos. Copy it
  // verbatim as the merge target so we don't duplicate that work.
  _log('Copying base ${parsed.base!.path} → ${outDb.path}');
  await parsed.base!.copy(outDb.path);

  final db = CardsDatabase.file(outDb);
  try {
    var attachIdx = 0;
    for (final shardPath in parsed.shards) {
      attachIdx++;
      _log(
        'Merging shard $attachIdx/${parsed.shards.length}: ${shardPath.path}',
      );
      await _mergeShard(db, shardPath.path, attachAlias: 'shard$attachIdx');
    }

    // Carry over any oracles the shards didn't touch this run from the
    // previously published bundle. PUBLIC_BASE_URL must point at the
    // R2 base for this to work; otherwise we silently skip carryover
    // (first-ever run, dev environments).
    final publicBaseUrl = (Platform.environment['PUBLIC_BASE_URL'] ?? '')
        .replaceAll(RegExp(r'/$'), '');
    Map<String, int> carryoverCounts = const {};
    String? carryoverSkipReason;
    if (publicBaseUrl.isNotEmpty) {
      final prevGz = File('${workDir.path}/prev_cards.sqlite.gz');
      final prevDb = File('${workDir.path}/prev_cards.sqlite');
      if (prevGz.existsSync()) prevGz.deleteSync();
      if (prevDb.existsSync()) prevDb.deleteSync();
      final downloaded = await _tryDownload(
        '$publicBaseUrl/cards-latest.sqlite.gz',
        prevGz,
      );
      if (!downloaded) {
        carryoverSkipReason = 'previous bundle download failed (404 / 5xx)';
        _log('  carryover: $carryoverSkipReason');
      } else {
        try {
          await _gunzip(prevGz, prevDb);
          final prevSchemaVersion = await _readPrevSchemaVersion(db, prevDb);
          if (prevSchemaVersion != schemaVersion) {
            carryoverSkipReason =
                'prev schemaVersion=$prevSchemaVersion ≠ current=$schemaVersion';
            _log('  carryover: $carryoverSkipReason');
          } else {
            carryoverCounts = await _carryOverFromPrev(db, prevDb);
            _log(
              '  carryover: ${carryoverCounts.entries.map((e) => '${e.key}=${e.value}').join(', ')}',
            );
          }
        } catch (e, st) {
          carryoverSkipReason = 'carryover error: $e';
          _log('  carryover: $carryoverSkipReason');
          _log('$st');
        }
      }
    } else {
      carryoverSkipReason = 'PUBLIC_BASE_URL unset';
      _log('  carryover: $carryoverSkipReason');
    }

    // Cap edhrec_recommendations to top N per (page, category) before
    // counting + VACUUM. EDHREC already serves max 50/category and
    // averages 27. The UI groups by category and renders the first
    // few — past the top 10 is dead weight. Cap takes the table from
    // ~12M rows to ~4M and compressed bundle from ~1 GB to ~400 MB.
    await _pruneRecsTopN(db, perCategory: 10);

    // Snapshot all manifest counts before VACUUM/close — so we don't
    // need to reopen the DB after gzip just to fill in the manifest.
    final cards = await _countTable(db, 'cards');
    final prices = await _countTable(db, 'card_prices');
    final precons = await _countTable(db, 'precon_decks');
    final combos = await _countTable(db, 'combos');
    final comboCards = await _countTable(db, 'combo_cards');
    final comboFeatures = await _countTable(db, 'combo_features');
    final tags = await _countTable(db, 'tags');
    final tagAncestors = await _countTable(db, 'tag_ancestors');
    final cardTags = await _countTable(db, 'card_tags');
    final cardRels = await _countTable(db, 'card_relationships');
    final taggerStatus = await _countTable(db, 'tagger_crawl_status');
    final edhrecPages = await _countTable(db, 'edhrec_pages');
    final edhrecRecs = await _countTable(db, 'edhrec_recommendations');
    final edhrecTagLinks = await _countTable(db, 'edhrec_tag_links');
    final pricesDate = await _readPricesDateFromDb(db);

    _log('VACUUM');
    await db.customStatement('VACUUM');
    await db.close();

    final dbSize = outDb.lengthSync();
    _log('  cards.sqlite: ${(dbSize / 1_000_000).toStringAsFixed(1)} MB');

    await _gzip(outDb, outGz);
    final gzSize = outGz.lengthSync();
    final digest = sha256.convert(await outGz.readAsBytes()).toString();

    final today =
        DateTime.now().toUtc().toIso8601String().substring(0, 10);
    final manifest = <String, dynamic>{
      'version': today,
      'schema_version': schemaVersion,
      'format': _bundleFormat,
      'url': '$publicBaseUrl/cards-$today.sqlite.gz',
      'latest_url': '$publicBaseUrl/cards-latest.sqlite.gz',
      'sha256': digest,
      'size_bytes': gzSize,
      'uncompressed_bytes': dbSize,
      'row_count': cards,
      'priced_row_count': prices,
      'precon_row_count': precons,
      'combo_row_count': combos,
      'combo_card_row_count': comboCards,
      'combo_feature_row_count': comboFeatures,
      'tag_row_count': tags,
      'tag_ancestor_row_count': tagAncestors,
      'card_tag_row_count': cardTags,
      'card_relationship_row_count': cardRels,
      'tagger_status_row_count': taggerStatus,
      'edhrec_page_row_count': edhrecPages,
      'edhrec_recommendation_row_count': edhrecRecs,
      'edhrec_tag_link_row_count': edhrecTagLinks,
      'shards_merged': parsed.shards.length,
      'carryover_rows': carryoverCounts,
      if (carryoverSkipReason != null)
        'carryover_skip_reason': carryoverSkipReason,
      'prices_date': pricesDate,
      'generated_at': DateTime.now().toUtc().toIso8601String(),
    };
    await manifestFile.writeAsString(
      const JsonEncoder.withIndent('  ').convert(manifest),
    );

    // Same GITHUB_OUTPUT keys as build_bundle.dart so the upload step is
    // unchanged.
    final ghOutput = Platform.environment['GITHUB_OUTPUT'];
    if (ghOutput != null) {
      File(ghOutput).writeAsStringSync(
        [
          'version=$today',
          'workdir=${workDir.path}',
          'bundle_path=${outGz.path}',
          'manifest_path=${manifestFile.path}',
          'versioned_key=cards-$today.sqlite.gz',
          'latest_key=cards-latest.sqlite.gz',
        ].join('\n') +
            '\n',
        mode: FileMode.append,
      );
    }

    _log(
      '✅ Merge complete: ${outGz.path} '
      '(${(gzSize / 1_000_000).toStringAsFixed(1)} MB gz, '
      '${(dbSize / 1_000_000).toStringAsFixed(1)} MB raw, '
      '$cards cards, $combos combos, $cardTags card_tags, '
      '$edhrecRecs edhrec_recs, sha256=${digest.substring(0, 12)}…)',
    );
  } catch (_) {
    // Ensure the DB is closed on the error path so the file isn't left
    // locked. The success path closes it explicitly above.
    try {
      await db.close();
    } catch (_) {}
    rethrow;
  }
}

class _Args {
  File? base;
  final List<File> shards = [];
}

_Args _parseArgs(List<String> args) {
  final out = _Args();
  for (var i = 0; i < args.length; i++) {
    final a = args[i];
    if (a == '--base' && i + 1 < args.length) {
      out.base = File(args[++i]);
    } else if (a == '--shard' && i + 1 < args.length) {
      out.shards.add(File(args[++i]));
    } else {
      stderr.writeln('Unknown argument: $a');
    }
  }
  return out;
}

/// Merge the insights tables of [shardPath] into [db]. Each shard's
/// data is disjoint by oracle hash, so simple INSERT OR IGNORE handles
/// dedup against the (oracle_id, tag_id) / (oracle_id, kind,
/// partner_oracle_id) PKs. The `edhrec_pages` autoinc id is remapped
/// via that triple-column UNIQUE index so child tables
/// (recommendations, themes, tag_links) land on the right page rows in
/// main — including partnership pages where the same primary commander
/// has multiple rows with different `partner_oracle_id`.
Future<void> _mergeShard(
  CardsDatabase db,
  String shardPath, {
  required String attachAlias,
}) async {
  await db.customStatement("ATTACH DATABASE '$shardPath' AS $attachAlias");
  try {
    // ── Tagger ────────────────────────────────────────────────────
    await db.customStatement(
      'INSERT OR IGNORE INTO main.tags '
      '(tag_id, slug, name, type, category, is_root_category, description) '
      'SELECT tag_id, slug, name, type, category, is_root_category, description '
      'FROM $attachAlias.tags',
    );
    await db.customStatement(
      'INSERT OR IGNORE INTO main.tag_ancestors '
      '(tag_id, ancestor_id, depth, is_category_ancestor) '
      'SELECT tag_id, ancestor_id, depth, is_category_ancestor '
      'FROM $attachAlias.tag_ancestors',
    );
    await db.customStatement(
      'INSERT OR IGNORE INTO main.card_tags (oracle_id, tag_id) '
      'SELECT oracle_id, tag_id FROM $attachAlias.card_tags',
    );
    await db.customStatement(
      'INSERT OR IGNORE INTO main.card_relationships '
      '(relationship_id, subject_oracle_id, related_oracle_id, '
      ' subject_name, related_name, classifier, classifier_inverse, annotation) '
      'SELECT relationship_id, subject_oracle_id, related_oracle_id, '
      ' subject_name, related_name, classifier, classifier_inverse, annotation '
      'FROM $attachAlias.card_relationships',
    );
    await db.customStatement(
      'INSERT OR REPLACE INTO main.tagger_crawl_status '
      '(oracle_id, last_crawled_at) '
      'SELECT oracle_id, last_crawled_at FROM $attachAlias.tagger_crawl_status',
    );

    // ── EDHREC ────────────────────────────────────────────────────
    // Insert pages without specifying the autoinc id so main's sequence
    // assigns fresh ones; UNIQUE (oracle_id, kind, partner_oracle_id)
    // dedupes across shards and against any seeded data. Both the
    // INSERT and the remap join MUST include `partner_oracle_id` —
    // dropping it collapses every partnership row to (oracle, kind,
    // NULL) which (a) loses the partner identity in main, and (b)
    // makes multiple shard pages remap to the same main row, which
    // then causes child INSERTs to collide on
    // `(page_id, card_name)`.
    await db.customStatement(
      'INSERT OR IGNORE INTO main.edhrec_pages '
      '(oracle_id, kind, partner_oracle_id, rank, num_decks, url, last_updated) '
      'SELECT oracle_id, kind, partner_oracle_id, rank, num_decks, url, last_updated '
      'FROM $attachAlias.edhrec_pages',
    );
    // Build the shard.id → main.id remap via the natural key. `IS` is
    // SQLite's NULL-aware equality (treats NULL as equal to NULL), so
    // solo pages and partnership pages each match correctly.
    await db.customStatement('DROP TABLE IF EXISTS temp.page_remap');
    await db.customStatement(
      'CREATE TEMP TABLE page_remap AS '
      'SELECT s.id AS shard_id, m.id AS main_id '
      'FROM $attachAlias.edhrec_pages s '
      'JOIN main.edhrec_pages m '
      '  ON m.oracle_id = s.oracle_id '
      '  AND m.kind = s.kind '
      '  AND m.partner_oracle_id IS s.partner_oracle_id',
    );
    await db.customStatement(
      'INSERT OR IGNORE INTO main.edhrec_recommendations '
      '(page_id, oracle_id, card_name, card_category, '
      ' inclusion_count, inclusion_percent, synergy_score, rank_in_category) '
      'SELECT pr.main_id, sr.oracle_id, sr.card_name, sr.card_category, '
      ' sr.inclusion_count, sr.inclusion_percent, '
      ' sr.synergy_score, sr.rank_in_category '
      'FROM $attachAlias.edhrec_recommendations sr '
      'JOIN temp.page_remap pr ON pr.shard_id = sr.page_id',
    );
    await db.customStatement(
      'INSERT INTO main.edhrec_themes '
      '(page_id, theme_slug, theme_name, total_decks, inclusion_count, '
      ' rank_in_theme, synergy_score) '
      'SELECT pr.main_id, st.theme_slug, st.theme_name, st.total_decks, '
      ' st.inclusion_count, st.rank_in_theme, st.synergy_score '
      'FROM $attachAlias.edhrec_themes st '
      'JOIN temp.page_remap pr ON pr.shard_id = st.page_id',
    );
    await db.customStatement(
      'INSERT INTO main.edhrec_tag_links '
      '(page_id, slug, name, count) '
      'SELECT pr.main_id, stl.slug, stl.name, stl.count '
      'FROM $attachAlias.edhrec_tag_links stl '
      'JOIN temp.page_remap pr ON pr.shard_id = stl.page_id',
    );
    await db.customStatement('DROP TABLE temp.page_remap');
  } finally {
    await db.customStatement('DETACH DATABASE $attachAlias');
  }
}

/// Carry-over: copy insights rows from the previous bundle for oracles
/// that this run's shards did NOT crawl (i.e., not in the freshly-
/// populated `tagger_crawl_status` / `edhrec_pages` tables). For
/// oracles the shards did crawl, the new data is the source of truth
/// and we deliberately don't bring in the older rows.
///
/// Global tables (tags dictionary, tag_ancestors, card_relationships,
/// edhrec_tag_links → on a per-page basis) get plain INSERT OR IGNORE —
/// they're append-only or safe to merge as a union.
Future<Map<String, int>> _carryOverFromPrev(
  CardsDatabase db,
  File prevDb,
) async {
  final result = <String, int>{};
  await db.customStatement("ATTACH DATABASE '${prevDb.path}' AS prev");
  try {
    // Tag dictionary: keep all old tags (cheap, harmless if some are
    // unreferenced now).
    final tagsBefore = await _countTable(db, 'tags');
    await db.customStatement(
      'INSERT OR IGNORE INTO main.tags '
      '(tag_id, slug, name, type, category, is_root_category, description) '
      'SELECT tag_id, slug, name, type, category, is_root_category, description '
      'FROM prev.tags',
    );
    result['tags'] = await _countTable(db, 'tags') - tagsBefore;

    final ancestorsBefore = await _countTable(db, 'tag_ancestors');
    await db.customStatement(
      'INSERT OR IGNORE INTO main.tag_ancestors '
      '(tag_id, ancestor_id, depth, is_category_ancestor) '
      'SELECT tag_id, ancestor_id, depth, is_category_ancestor '
      'FROM prev.tag_ancestors',
    );
    result['tag_ancestors'] =
        await _countTable(db, 'tag_ancestors') - ancestorsBefore;

    // Card-tags / status: only carry rows for oracles NOT crawled this run.
    final cardTagsBefore = await _countTable(db, 'card_tags');
    await db.customStatement(
      'INSERT OR IGNORE INTO main.card_tags (oracle_id, tag_id) '
      'SELECT oracle_id, tag_id FROM prev.card_tags '
      'WHERE oracle_id NOT IN '
      '  (SELECT oracle_id FROM main.tagger_crawl_status)',
    );
    result['card_tags'] = await _countTable(db, 'card_tags') - cardTagsBefore;

    final taggerStatusBefore = await _countTable(db, 'tagger_crawl_status');
    await db.customStatement(
      'INSERT OR IGNORE INTO main.tagger_crawl_status '
      '(oracle_id, last_crawled_at) '
      'SELECT oracle_id, last_crawled_at FROM prev.tagger_crawl_status '
      'WHERE oracle_id NOT IN '
      '  (SELECT oracle_id FROM main.tagger_crawl_status)',
    );
    result['tagger_crawl_status'] =
        await _countTable(db, 'tagger_crawl_status') - taggerStatusBefore;

    // Card relationships are global (keyed by Scryfall relationship_id),
    // append-only — keep all carried rows.
    final relsBefore = await _countTable(db, 'card_relationships');
    await db.customStatement(
      'INSERT OR IGNORE INTO main.card_relationships '
      '(relationship_id, subject_oracle_id, related_oracle_id, '
      ' subject_name, related_name, classifier, classifier_inverse, annotation) '
      'SELECT relationship_id, subject_oracle_id, related_oracle_id, '
      ' subject_name, related_name, classifier, classifier_inverse, annotation '
      'FROM prev.card_relationships',
    );
    result['card_relationships'] =
        await _countTable(db, 'card_relationships') - relsBefore;

    // EDHREC pages: only carry pages whose (oracle_id, kind,
    // partner_oracle_id) wasn't refreshed this run. Then build a remap
    // and copy children.
    //
    // The `prev` bundle may be v4 (no `partner_oracle_id` column) when
    // we're shipping the first v5 build. We detect that once and pick
    // the right SQL fragment: pass the column through for v5+ prev,
    // substitute literal NULL for v4 prev (every row in v4 was
    // implicitly a solo page anyway).
    final prevHasPartnerCol = await _columnExists(
      db,
      'prev',
      'edhrec_pages',
      'partner_oracle_id',
    );
    // SQL fragments tuned to where they're used:
    //   - `insertExpr` plugs into the SELECT list (no table qualifier
    //     because the SELECT scope already targets prev.edhrec_pages)
    //   - `prevQualified` plugs into a correlated subquery / JOIN
    //     where the reference is unambiguous against prev's row.
    final insertExpr =
        prevHasPartnerCol ? 'partner_oracle_id' : 'NULL';
    final prevQualified = prevHasPartnerCol
        ? 'prev.edhrec_pages.partner_oracle_id'
        : 'NULL';
    final joinAliasQualified =
        prevHasPartnerCol ? 'p.partner_oracle_id' : 'NULL';

    final pagesBefore = await _countTable(db, 'edhrec_pages');
    await db.customStatement(
      'INSERT OR IGNORE INTO main.edhrec_pages '
      '(oracle_id, kind, partner_oracle_id, rank, num_decks, url, last_updated) '
      'SELECT oracle_id, kind, $insertExpr, rank, num_decks, url, '
      '       last_updated '
      'FROM prev.edhrec_pages '
      'WHERE NOT EXISTS ('
      '  SELECT 1 FROM main.edhrec_pages m '
      '  WHERE m.oracle_id = prev.edhrec_pages.oracle_id '
      '    AND m.kind = prev.edhrec_pages.kind '
      '    AND m.partner_oracle_id IS $prevQualified)',
    );
    result['edhrec_pages'] = await _countTable(db, 'edhrec_pages') - pagesBefore;

    // Remap: prev.id → main.id for the pages we just copied (those are
    // the rows in main that match prev's natural key).
    await db.customStatement('DROP TABLE IF EXISTS temp.prev_page_remap');
    await db.customStatement(
      'CREATE TEMP TABLE prev_page_remap AS '
      'SELECT p.id AS prev_id, m.id AS main_id '
      'FROM prev.edhrec_pages p '
      'JOIN main.edhrec_pages m '
      '  ON m.oracle_id = p.oracle_id '
      '  AND m.kind = p.kind '
      '  AND m.partner_oracle_id IS $joinAliasQualified',
    );

    final recsBefore = await _countTable(db, 'edhrec_recommendations');
    await db.customStatement(
      'INSERT OR IGNORE INTO main.edhrec_recommendations '
      '(page_id, oracle_id, card_name, card_category, '
      ' inclusion_count, inclusion_percent, synergy_score, rank_in_category) '
      'SELECT r.main_id, sr.oracle_id, sr.card_name, sr.card_category, '
      ' sr.inclusion_count, sr.inclusion_percent, '
      ' sr.synergy_score, sr.rank_in_category '
      'FROM prev.edhrec_recommendations sr '
      'JOIN temp.prev_page_remap r ON r.prev_id = sr.page_id '
      // Only pages that are NEW in main (i.e., carried-over). For pages
      // refreshed this run, main already has the new recs.
      'WHERE NOT EXISTS ('
      '  SELECT 1 FROM main.edhrec_recommendations existing '
      '  WHERE existing.page_id = r.main_id)',
    );
    result['edhrec_recommendations'] =
        await _countTable(db, 'edhrec_recommendations') - recsBefore;

    final themesBefore = await _countTable(db, 'edhrec_themes');
    await db.customStatement(
      'INSERT INTO main.edhrec_themes '
      '(page_id, theme_slug, theme_name, total_decks, inclusion_count, '
      ' rank_in_theme, synergy_score) '
      'SELECT r.main_id, st.theme_slug, st.theme_name, st.total_decks, '
      ' st.inclusion_count, st.rank_in_theme, st.synergy_score '
      'FROM prev.edhrec_themes st '
      'JOIN temp.prev_page_remap r ON r.prev_id = st.page_id '
      'WHERE NOT EXISTS ('
      '  SELECT 1 FROM main.edhrec_themes existing '
      '  WHERE existing.page_id = r.main_id)',
    );
    result['edhrec_themes'] =
        await _countTable(db, 'edhrec_themes') - themesBefore;

    final tagLinksBefore = await _countTable(db, 'edhrec_tag_links');
    await db.customStatement(
      'INSERT INTO main.edhrec_tag_links '
      '(page_id, slug, name, count) '
      'SELECT r.main_id, stl.slug, stl.name, stl.count '
      'FROM prev.edhrec_tag_links stl '
      'JOIN temp.prev_page_remap r ON r.prev_id = stl.page_id '
      'WHERE NOT EXISTS ('
      '  SELECT 1 FROM main.edhrec_tag_links existing '
      '  WHERE existing.page_id = r.main_id)',
    );
    result['edhrec_tag_links'] =
        await _countTable(db, 'edhrec_tag_links') - tagLinksBefore;

    await db.customStatement('DROP TABLE temp.prev_page_remap');
  } finally {
    await db.customStatement('DETACH DATABASE prev');
  }
  return result;
}

Future<bool> _tryDownload(String url, File dst) async {
  for (var attempt = 0; attempt < 3; attempt++) {
    try {
      final req = http.Request('GET', Uri.parse(url))
        ..headers['User-Agent'] = _userAgent;
      final client = http.Client();
      try {
        final resp = await client.send(req).timeout(const Duration(minutes: 5));
        if (resp.statusCode == 404) return false;
        if (resp.statusCode != 200) {
          await Future<void>.delayed(Duration(seconds: (attempt + 1) * 2));
          continue;
        }
        final sink = dst.openWrite();
        await resp.stream.pipe(sink);
        await sink.close();
        return true;
      } finally {
        client.close();
      }
    } catch (_) {
      await Future<void>.delayed(Duration(seconds: (attempt + 1) * 2));
    }
  }
  return false;
}

Future<void> _gunzip(File src, File dst) async {
  final raw = await src.readAsBytes();
  final out = GZipDecoder().decodeBytes(raw);
  await dst.writeAsBytes(out);
}

Future<void> _gzip(File src, File dst) async {
  final sink = dst.openWrite();
  await src.openRead().transform(gzip.encoder).pipe(sink);
  await sink.close();
}

Future<int> _readPrevSchemaVersion(CardsDatabase db, File prevFile) async {
  await db.customStatement("ATTACH DATABASE '${prevFile.path}' AS prev_check");
  try {
    final result =
        await db.customSelect('PRAGMA prev_check.user_version').get();
    if (result.isEmpty) return -1;
    return result.first.data.values.first as int? ?? -1;
  } finally {
    await db.customStatement('DETACH DATABASE prev_check');
  }
}

Future<int> _countTable(CardsDatabase db, String table) async {
  final rows = await db.customSelect('SELECT COUNT(*) AS c FROM $table').get();
  return rows.isEmpty ? 0 : (rows.first.data['c'] as int? ?? 0);
}

/// Cap [edhrec_recommendations] to top [perCategory] rows per
/// (page, category) by simply trimming rows past `rank_in_category`.
/// EDHREC's own ranks are 1..N within each category and dense, so this
/// avoids a heavy window-function pass over a 12M-row table.
Future<void> _pruneRecsTopN(
  CardsDatabase db, {
  required int perCategory,
}) async {
  final before = await _countTable(db, 'edhrec_recommendations');
  await db.customStatement(
    'DELETE FROM edhrec_recommendations '
    'WHERE rank_in_category IS NULL OR rank_in_category > $perCategory',
  );
  final after = await _countTable(db, 'edhrec_recommendations');
  _log(
    '  prune-recs: kept top $perCategory per (page,category) — '
    '$before → $after rows (-${before - after})',
  );
}

/// Whether an attached SQLite database has a given column on a table.
/// Used by the carry-over path to detect whether the previous bundle
/// is on an older schema and pick fragment substitutions accordingly.
Future<bool> _columnExists(
  CardsDatabase db,
  String schema,
  String table,
  String column,
) async {
  // `pragma_table_info` is a table-valued function; querying via
  // `pragma_table_info('<table>', '<schema>')` lets us inspect an
  // attached DB without invasive PRAGMA statements.
  final rows = await db.customSelect(
    "SELECT name FROM pragma_table_info(?, ?) WHERE name = ?",
    variables: [
      Variable<String>(table),
      Variable<String>(schema),
      Variable<String>(column),
    ],
  ).get();
  return rows.isNotEmpty;
}

Future<String> _readPricesDateFromDb(CardsDatabase db) async {
  final rows = await db
      .customSelect('SELECT fetched_date FROM card_prices LIMIT 1')
      .get();
  if (rows.isEmpty) return 'unknown';
  return (rows.first.data['fetched_date'] as String?) ?? 'unknown';
}

void _log(String msg) {
  final ts = DateTime.now().toUtc().toIso8601String();
  stdout.writeln('[$ts] $msg');
}
