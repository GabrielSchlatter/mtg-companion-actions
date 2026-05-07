import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show InsertMode, Value, Variable;
import 'package:http/http.dart' as http;

import '../db/cards_database.dart';

/// Scryfall Tagger crawler.
///
/// Crawls one printing per oracle card (the canonical printing chosen by
/// the cards-table builder) and ingests the response into the relational
/// schema:
///   - `tags`            — global dedup'd dictionary (full info from
///                         direct tags, sparse info from ancestry-only
///                         occurrences)
///   - `tag_ancestors`   — DAG edges with depth + is_category_ancestor
///   - `card_tags`       — (oracle_id, tag_id) edges
///   - `card_relationships` — Tagger's "combos with"/"better than" edges,
///                         resolved to oracle_id on both sides where
///                         possible.
///
/// Skips ART_TAG / ILLUSTRATION_TAG / PRINTING_TAG entirely — only
/// functional tags survive into the bundle. This matches the design
/// premise that all insights live at the oracle (concept) level so
/// users see the same tags regardless of which printing they own.
///
/// Crawl orchestration:
///   - Sharded: only handles cards where `hashCode(scryfall_id) % shardCount == shardIndex`.
///   - Bounded: stops on max-runtime or shard exhaustion.
///   - Skips cards already covered in `card_tags` (seeded from the
///     previous bundle).
///   - Pacing: 1.5s per request, exponential backoff on 429 / 5xx,
///     bail-out if rate-limited 3 times consecutively.

const String _taggerHome = 'https://tagger.scryfall.com';
const String _graphqlUrl = 'https://tagger.scryfall.com/graphql';

const String _graphqlQuery = r'''
  query FetchCard($set: String!, $number: String!) {
    card: cardBySet(set: $set, number: $number, back: false) {
      name
      oracleId
      scryfallUrl
      taggings {
        tag {
          id
          name
          slug
          description
          category
          type
          ancestry {
            tag {
              id
              name
              category
            }
          }
        }
      }
      relationships {
        id
        subjectName
        relatedName
        classifier
        classifierInverse
        annotation
      }
    }
  }
''';

class TaggerCrawlConfig {
  final int shardIndex;
  final int shardCount;
  final Duration pacing;

  /// Maximum wall-clock duration. Crawler exits cleanly when reached so
  /// the GitHub Actions matrix job doesn't get hard-killed at the 6h
  /// boundary. Set to null for unbounded (typical CI use).
  final Duration? maxRuntime;

  /// Bail-out threshold for consecutive rate-limit responses. Hitting
  /// this means Scryfall is actively pushing back; partial progress is
  /// preserved and the workflow's fire-alarm step decides whether to
  /// fail the run.
  final int maxConsecutiveRateLimits;

  /// How long a successful crawl is considered fresh. Oracles whose
  /// last successful crawl is older than this are eligible for re-
  /// fetch. Tags rarely change so 30 days is a reasonable default;
  /// shorter windows just spread refresh work across more runs.
  final Duration staleness;

  TaggerCrawlConfig({
    this.shardIndex = 0,
    this.shardCount = 1,
    this.pacing = const Duration(milliseconds: 1500),
    this.maxRuntime,
    this.maxConsecutiveRateLimits = 3,
    this.staleness = const Duration(days: 30),
  });
}

class TaggerCrawlResult {
  final int cardsAttempted;
  final int cardsSucceeded;
  final int cardsFailed;
  final int cardsFresh; // skipped because already crawled within staleness window
  final int cardsRefreshed; // re-crawled because previous data was stale
  final int rateLimitHits;
  final int newTags;
  final int newAncestorEdges;
  final int newCardTagEdges;
  final int newRelationships;
  final bool stoppedByRateLimit;
  final bool stoppedByTimeBudget;
  final Duration elapsed;

  TaggerCrawlResult({
    required this.cardsAttempted,
    required this.cardsSucceeded,
    required this.cardsFailed,
    required this.cardsFresh,
    required this.cardsRefreshed,
    required this.rateLimitHits,
    required this.newTags,
    required this.newAncestorEdges,
    required this.newCardTagEdges,
    required this.newRelationships,
    required this.stoppedByRateLimit,
    required this.stoppedByTimeBudget,
    required this.elapsed,
  });
}

/// Run the Tagger crawl against [db] using [config]. Reads the work list
/// from `cards` (canonical printings only, sorted by `edhrec_rank ASC`,
/// hash-sharded) and writes incrementally to the relational tables.
Future<TaggerCrawlResult> runTaggerCrawl(
  CardsDatabase db,
  TaggerCrawlConfig config, {
  void Function(String)? log,
}) async {
  void emit(String msg) => (log ?? (m) => stdout.writeln(m))(msg);
  final stopwatch = Stopwatch()..start();

  // Build name → oracle_id lookup once. Used for resolving relationship
  // sides where the JSON only gives us names.
  final nameToOracleId = await _buildNameToOracleIdMap(db);
  emit('  name→oracle_id lookup: ${nameToOracleId.length} entries');

  // Refresh-cycle gate: oracles whose last successful crawl is newer
  // than now-staleness are skipped. Older or never-crawled oracles
  // form the work list.
  final freshCutoff = DateTime.now().toUtc().subtract(config.staleness);
  final freshOracleIds = await _loadFreshOracleIds(db, freshCutoff);
  emit(
    '  refresh window: staleness=${config.staleness.inDays}d · '
    '${freshOracleIds.length} oracles still fresh',
  );

  final workList = await _buildWorkList(db, config, freshOracleIds);
  // How many of the work-list items are refreshes (had a status row but
  // it's stale) vs first-time crawls?
  final preExisting = await _loadAllStatusOracleIds(db);
  final refreshing =
      workList.where((w) => preExisting.contains(w.oracleId)).length;
  emit(
    '  shard ${config.shardIndex}/${config.shardCount} '
    'work list: ${workList.length} cards '
    '($refreshing refreshes, ${workList.length - refreshing} first-time)',
  );

  if (workList.isEmpty) {
    return TaggerCrawlResult(
      cardsAttempted: 0,
      cardsSucceeded: 0,
      cardsFailed: 0,
      cardsFresh: freshOracleIds.length,
      cardsRefreshed: 0,
      rateLimitHits: 0,
      newTags: 0,
      newAncestorEdges: 0,
      newCardTagEdges: 0,
      newRelationships: 0,
      stoppedByRateLimit: false,
      stoppedByTimeBudget: false,
      elapsed: stopwatch.elapsed,
    );
  }

  final session = _TaggerSession(http.Client());
  await session.establish();

  var attempted = 0;
  var succeeded = 0;
  var failed = 0;
  var refreshed = 0;
  var rateLimitHits = 0;
  var consecutiveRateLimits = 0;
  var newTags = 0;
  var newAncestors = 0;
  var newCardTagEdges = 0;
  var newRelationships = 0;
  var stoppedByRateLimit = false;
  var stoppedByTimeBudget = false;

  // Heartbeat every 100 cards (~150s of pacing) so a healthy multi-hour
  // crawl shows up in the log instead of looking hung.
  const heartbeatEvery = 100;

  try {
    for (final card in workList) {
      if (config.maxRuntime != null &&
          stopwatch.elapsed > config.maxRuntime!) {
        stoppedByTimeBudget = true;
        emit('  time budget exhausted at ${stopwatch.elapsed.inSeconds}s');
        break;
      }

      attempted++;
      if (attempted % heartbeatEvery == 0) {
        final pct = ((attempted / workList.length) * 100).toStringAsFixed(1);
        emit(
          '  tagger progress: $attempted/${workList.length} ($pct%) '
          '· succeeded=$succeeded failed=$failed '
          '· elapsed=${stopwatch.elapsed.inSeconds}s '
          '· cardTagEdges=$newCardTagEdges',
        );
      }
      final wasRefresh = preExisting.contains(card.oracleId);
      final fetch = await session.fetchCard(card.setCode, card.collectorNumber);
      switch (fetch.outcome) {
        case _FetchOutcome.success:
          consecutiveRateLimits = 0;
          succeeded++;
          if (wasRefresh) refreshed++;
          if (fetch.card != null) {
            final stats = await _ingestCardTags(
              db,
              card.oracleId,
              fetch.card!,
              nameToOracleId,
              isRefresh: wasRefresh,
            );
            newTags += stats.newTags;
            newAncestors += stats.newAncestors;
            newCardTagEdges += stats.newCardTagEdges;
            newRelationships += stats.newRelationships;
          }
          break;
        case _FetchOutcome.rateLimited:
          rateLimitHits++;
          consecutiveRateLimits++;
          failed++;
          emit('  rate-limited on ${card.setCode}/${card.collectorNumber} '
              '(consecutive=$consecutiveRateLimits)');
          if (consecutiveRateLimits >= config.maxConsecutiveRateLimits) {
            stoppedByRateLimit = true;
            emit('  rate-limit threshold hit — bailing out');
            break;
          }
          // Extra backoff on rate limit before next attempt.
          await Future<void>.delayed(
            Duration(seconds: 5 * consecutiveRateLimits),
          );
          break;
        case _FetchOutcome.notFound:
          // Card not in Tagger DB (e.g. recent printing not yet indexed).
          // Don't count as failure — just skip.
          consecutiveRateLimits = 0;
          break;
        case _FetchOutcome.error:
          consecutiveRateLimits = 0;
          failed++;
          break;
      }

      if (stoppedByRateLimit) break;
      await Future<void>.delayed(config.pacing);
    }
  } finally {
    session.close();
  }

  return TaggerCrawlResult(
    cardsAttempted: attempted,
    cardsSucceeded: succeeded,
    cardsFailed: failed,
    cardsFresh: freshOracleIds.length,
    cardsRefreshed: refreshed,
    rateLimitHits: rateLimitHits,
    newTags: newTags,
    newAncestorEdges: newAncestors,
    newCardTagEdges: newCardTagEdges,
    newRelationships: newRelationships,
    stoppedByRateLimit: stoppedByRateLimit,
    stoppedByTimeBudget: stoppedByTimeBudget,
    elapsed: stopwatch.elapsed,
  );
}

class _WorkItem {
  final String scryfallId;
  final String setCode;
  final String collectorNumber;
  final String oracleId;
  _WorkItem({
    required this.scryfallId,
    required this.setCode,
    required this.collectorNumber,
    required this.oracleId,
  });
}

Future<List<_WorkItem>> _buildWorkList(
  CardsDatabase db,
  TaggerCrawlConfig cfg,
  Set<String> fresh,
) async {
  // Canonical printings only — one per oracle_id. Sorted by edhrec_rank
  // (NULLS LAST so unranked cards still get crawled, just last).
  final rows = await db.customSelect(
    'SELECT scryfall_id, set_code, collector_number, oracle_id, edhrec_rank '
    'FROM cards '
    'WHERE is_canonical_printing = 1 '
    'ORDER BY CASE WHEN edhrec_rank IS NULL THEN 1 ELSE 0 END, edhrec_rank ASC',
  ).get();
  final out = <_WorkItem>[];
  for (final r in rows) {
    final oracleId = r.data['oracle_id'] as String? ?? '';
    if (oracleId.isEmpty) continue;
    // Skip oracles whose last successful crawl is still within the
    // staleness window. Anything missing from `fresh` (never crawled,
    // or crawl row predates the window) is eligible.
    if (fresh.contains(oracleId)) continue;

    final scryfallId = r.data['scryfall_id'] as String? ?? '';
    if (scryfallId.isEmpty) continue;
    if (cfg.shardCount > 1) {
      // Stable hash — Dart's String.hashCode varies between VM runs,
      // so use a tiny FNV-1a so shard distribution is reproducible.
      final h = _fnv1a(scryfallId);
      if (h % cfg.shardCount != cfg.shardIndex) continue;
    }
    out.add(
      _WorkItem(
        scryfallId: scryfallId,
        setCode: r.data['set_code'] as String? ?? '',
        collectorNumber: r.data['collector_number'] as String? ?? '',
        oracleId: oracleId,
      ),
    );
  }
  return out;
}

/// Oracles whose last successful crawl is newer than [cutoff] — those
/// are the ones the crawler should skip on this run.
Future<Set<String>> _loadFreshOracleIds(
  CardsDatabase db,
  DateTime cutoff,
) async {
  // SQLite stores Drift DateTime as unix seconds (int).
  final cutoffEpoch = cutoff.millisecondsSinceEpoch ~/ 1000;
  final rows = await db.customSelect(
    'SELECT oracle_id FROM tagger_crawl_status '
    'WHERE last_crawled_at >= ?',
    variables: [Variable<int>(cutoffEpoch)],
  ).get();
  return {for (final r in rows) r.data['oracle_id'] as String};
}

/// Every oracle_id that has a status row, regardless of freshness.
/// Used to count refreshes vs first-time crawls in the work list.
Future<Set<String>> _loadAllStatusOracleIds(CardsDatabase db) async {
  final rows = await db
      .customSelect('SELECT oracle_id FROM tagger_crawl_status')
      .get();
  return {for (final r in rows) r.data['oracle_id'] as String};
}

Future<Map<String, String>> _buildNameToOracleIdMap(CardsDatabase db) async {
  // Canonical printings only — multiple printings of the same name
  // share an oracle_id, so any one is correct. We index lowercased
  // full name AND the front face for DFCs ("Fynn // Garth" ↔ "Fynn"),
  // matching how Tagger and EDHREC sometimes truncate names.
  final rows = await db.customSelect(
    'SELECT name, oracle_id FROM cards WHERE is_canonical_printing = 1',
  ).get();
  final map = <String, String>{};
  for (final r in rows) {
    final name = r.data['name'] as String? ?? '';
    final oracleId = r.data['oracle_id'] as String? ?? '';
    if (name.isEmpty || oracleId.isEmpty) continue;
    map[name.toLowerCase()] = oracleId;
    final dfcSplit = name.indexOf(' // ');
    if (dfcSplit > 0) {
      map[name.substring(0, dfcSplit).toLowerCase()] = oracleId;
    }
  }
  return map;
}

class _CardIngestStats {
  final int newTags;
  final int newAncestors;
  final int newCardTagEdges;
  final int newRelationships;
  _CardIngestStats({
    required this.newTags,
    required this.newAncestors,
    required this.newCardTagEdges,
    required this.newRelationships,
  });
}

Future<_CardIngestStats> _ingestCardTags(
  CardsDatabase db,
  String oracleId,
  Map<String, dynamic> cardJson,
  Map<String, String> nameToOracleId, {
  required bool isRefresh,
}) async {
  final taggings = cardJson['taggings'] as List<dynamic>? ?? const [];
  final relationships = cardJson['relationships'] as List<dynamic>? ?? const [];

  var newTags = 0;
  var newAncestors = 0;
  var newCardTagEdges = 0;
  var newRelationships = 0;

  await db.transaction(() async {
    // On refresh, clear this oracle's existing tag edges so the new
    // fetch becomes the source of truth. Same transaction as the
    // re-insert + status update — if any of it throws, the rollback
    // restores the seeded data unchanged. The tag dictionary and
    // tag_ancestors stay append-only (global, harmless to retain).
    // card_relationships also stay append-only — they're keyed by
    // Scryfall's stable relationship_id, so we don't lose anything.
    if (isRefresh) {
      await db.customUpdate(
        'DELETE FROM card_tags WHERE oracle_id = ?',
        variables: [Variable<String>(oracleId)],
      );
    }

    for (final taggingRaw in taggings) {
      final tagging = taggingRaw as Map<String, dynamic>?;
      final tag = tagging?['tag'] as Map<String, dynamic>?;
      if (tag == null) continue;

      final tagId = tag['id']?.toString();
      if (tagId == null || tagId.isEmpty) continue;

      // Skip non-functional tags entirely. Functional types are
      // ORACLE_CARD_TAG and CARD_TAG; everything else (ART_TAG,
      // ILLUSTRATION_TAG, PRINTING_TAG) is per-printing data the
      // bundle ignores.
      final type = (tag['type']?.toString() ?? '').toUpperCase();
      if (!_isFunctionalType(type)) continue;

      // Direct tag — full info, OR REPLACE wins over any sparse row
      // we may have inserted from an earlier card's ancestry.
      final categoryRaw = tag['category'];
      final didInsertTag = await _upsertTag(
        db,
        tagId: tagId,
        slug: tag['slug']?.toString() ?? '',
        name: tag['name']?.toString() ?? '',
        type: type,
        categoryRaw: categoryRaw,
        description: _nonEmpty(tag['description']),
        replace: true,
      );
      if (didInsertTag) newTags++;

      // Card → tag edge.
      final didInsertEdge = await _insertOrIgnore(
        db,
        'INSERT OR IGNORE INTO card_tags (oracle_id, tag_id) VALUES (?, ?)',
        [Variable<String>(oracleId), Variable<String>(tagId)],
      );
      if (didInsertEdge) newCardTagEdges++;

      // Ancestry — sparse rows + DAG edges.
      final ancestry = tag['ancestry'] as List<dynamic>? ?? const [];
      for (var depth = 0; depth < ancestry.length; depth++) {
        final ancRaw = ancestry[depth];
        if (ancRaw is! Map<String, dynamic>) continue;
        final ancTag = ancRaw['tag'] as Map<String, dynamic>? ?? ancRaw;
        final ancId = ancTag['id']?.toString();
        if (ancId == null || ancId.isEmpty) continue;
        if (ancId == tagId) continue;

        final ancCategoryRaw = ancTag['category'];

        final didInsertAnc = await _upsertTag(
          db,
          tagId: ancId,
          slug: ancTag['slug']?.toString() ?? '',
          name: ancTag['name']?.toString() ?? '',
          type: type, // best-effort kind; will be overwritten if seen as direct
          categoryRaw: ancCategoryRaw,
          description: null,
          replace: false, // sparse — don't overwrite a direct-tag row
        );
        if (didInsertAnc) newTags++;

        final didInsertAncEdge = await _insertOrIgnore(
          db,
          'INSERT OR IGNORE INTO tag_ancestors '
          '(tag_id, ancestor_id, depth, is_category_ancestor) '
          'VALUES (?, ?, ?, ?)',
          [
            Variable<String>(tagId),
            Variable<String>(ancId),
            Variable<int>(depth + 1),
            Variable<bool>(_parseCategoryFlag(ancCategoryRaw)),
          ],
        );
        if (didInsertAncEdge) newAncestors++;
      }
    }

    for (final relRaw in relationships) {
      final rel = relRaw as Map<String, dynamic>?;
      if (rel == null) continue;
      final relationshipId = rel['id']?.toString();
      if (relationshipId == null || relationshipId.isEmpty) continue;

      final subjectName = rel['subjectName']?.toString() ?? '';
      final relatedName = rel['relatedName']?.toString() ?? '';
      if (subjectName.isEmpty || relatedName.isEmpty) continue;

      final subjectOracleId = _resolveName(subjectName, nameToOracleId);
      final relatedOracleId = _resolveName(relatedName, nameToOracleId);

      final didInsert = await _insertOrIgnore(
        db,
        'INSERT OR IGNORE INTO card_relationships '
        '(relationship_id, subject_oracle_id, related_oracle_id, '
        ' subject_name, related_name, classifier, classifier_inverse, annotation) '
        'VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
        [
          Variable<String>(relationshipId),
          if (subjectOracleId == null)
            const Variable<String>(null)
          else
            Variable<String>(subjectOracleId),
          if (relatedOracleId == null)
            const Variable<String>(null)
          else
            Variable<String>(relatedOracleId),
          Variable<String>(subjectName),
          Variable<String>(relatedName),
          Variable<String>(_nonEmpty(rel['classifier'])),
          Variable<String>(_nonEmpty(rel['classifierInverse'])),
          Variable<String>(_nonEmpty(rel['annotation'])),
        ],
      );
      if (didInsert) newRelationships++;
    }

    // Crawl status — last write of the transaction so an earlier throw
    // rolls everything back together. Re-inserts get the latest
    // timestamp; first-time crawls add a new row.
    await db.into(db.taggerCrawlStatus).insert(
          TaggerCrawlStatusCompanion.insert(
            oracleId: oracleId,
            lastCrawledAt: DateTime.now().toUtc(),
          ),
          mode: InsertMode.insertOrReplace,
        );
  });

  return _CardIngestStats(
    newTags: newTags,
    newAncestors: newAncestors,
    newCardTagEdges: newCardTagEdges,
    newRelationships: newRelationships,
  );
}

bool _isFunctionalType(String type) {
  return type == 'ORACLE_CARD_TAG' || type == 'CARD_TAG';
}

/// Returns true when a row was inserted or replaced; false when an
/// IGNORE skipped the insert (duplicate key).
Future<bool> _upsertTag(
  CardsDatabase db, {
  required String tagId,
  required String slug,
  required String name,
  required String type,
  required Object? categoryRaw,
  required String? description,
  required bool replace,
}) async {
  final categoryStr = _nonEmpty(categoryRaw);
  final isRoot = _parseCategoryFlag(categoryRaw);

  if (replace) {
    // Direct tag — overwrite any earlier sparse row.
    await db.into(db.tags).insert(
          TagsCompanion.insert(
            tagId: tagId,
            slug: slug,
            name: name,
            type: type,
            category: Value(categoryStr),
            isRootCategory: Value(isRoot),
            description: Value(description),
          ),
          mode: InsertMode.insertOrReplace,
        );
    return true;
  } else {
    // Sparse insert — only set the row if we don't already have one.
    return _insertOrIgnore(
      db,
      'INSERT OR IGNORE INTO tags '
      '(tag_id, slug, name, type, category, is_root_category, description) '
      'VALUES (?, ?, ?, ?, ?, ?, ?)',
      [
        Variable<String>(tagId),
        Variable<String>(slug),
        Variable<String>(name),
        Variable<String>(type),
        if (categoryStr == null)
          const Variable<String>(null)
        else
          Variable<String>(categoryStr),
        Variable<bool>(isRoot),
        if (description == null)
          const Variable<String>(null)
        else
          Variable<String>(description),
      ],
    );
  }
}

Future<bool> _insertOrIgnore(
  CardsDatabase db,
  String sql,
  List<Variable> args,
) async {
  final rows = await db.customUpdate(sql, variables: args);
  return rows > 0;
}

String? _resolveName(String name, Map<String, String> nameToOracleId) {
  final lower = name.toLowerCase();
  final hit = nameToOracleId[lower];
  if (hit != null) return hit;
  // DFC fallback — try matching the front face if the input has a `//`.
  final split = lower.indexOf(' // ');
  if (split > 0) {
    final front = lower.substring(0, split);
    return nameToOracleId[front];
  }
  return null;
}

bool _parseCategoryFlag(Object? v) {
  if (v is bool) return v;
  if (v is String) return v.toLowerCase() == 'true';
  return false;
}

String? _nonEmpty(Object? v) {
  if (v == null) return null;
  final s = v.toString();
  return s.isEmpty ? null : s;
}

/// Stable 32-bit FNV-1a — Dart's String.hashCode isn't reproducible
/// across VM versions / isolates, so matrix shards must hash with
/// something deterministic.
int _fnv1a(String s) {
  var h = 0x811C9DC5;
  for (var i = 0; i < s.length; i++) {
    h = (h ^ s.codeUnitAt(i)) * 0x01000193;
    h = h & 0xFFFFFFFF;
  }
  return h;
}

// ─── Session + GraphQL ────────────────────────────────────────────────

enum _FetchOutcome { success, rateLimited, notFound, error }

class _FetchResult {
  final _FetchOutcome outcome;
  final Map<String, dynamic>? card;
  _FetchResult(this.outcome, [this.card]);
}

class _TaggerSession {
  final http.Client client;
  String? _csrfToken;
  String? _cookie;

  _TaggerSession(this.client);

  Future<void> establish() async {
    try {
      final resp = await client
          .get(
            Uri.parse(_taggerHome),
            headers: const {
              'User-Agent':
                  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 '
                      '(mtg-companion-actions; +https://github.com/GabrielSchlatter/mtg-companion-actions)',
              'Accept': 'text/html,application/xhtml+xml',
            },
          )
          .timeout(const Duration(seconds: 15));
      final csrf = RegExp(
        r'name="csrf-token"\s+content="([^"]+)"',
      ).firstMatch(resp.body);
      _csrfToken = csrf?.group(1);
      _cookie = resp.headers['set-cookie'];
    } catch (_) {
      // Establishing fails are recoverable — fetchCard will surface
      // them as outcome.error and the caller decides what to do.
    }
  }

  void close() => client.close();

  Future<_FetchResult> fetchCard(String setCode, String collectorNumber) async {
    if (_csrfToken == null || _cookie == null) {
      await establish();
      if (_csrfToken == null) return _FetchResult(_FetchOutcome.error);
    }

    final body = jsonEncode({
      'query': _graphqlQuery,
      'variables': {
        'set': setCode.toLowerCase(),
        'number': collectorNumber,
      },
    });

    try {
      final resp = await client
          .post(
            Uri.parse(_graphqlUrl),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Origin': _taggerHome,
              'Referer': '$_taggerHome/',
              'User-Agent':
                  'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 '
                      '(mtg-companion-actions; +https://github.com/GabrielSchlatter/mtg-companion-actions)',
              'X-CSRF-Token': _csrfToken!,
              'Cookie': _cookie!,
            },
            body: body,
          )
          .timeout(const Duration(seconds: 20));

      if (resp.statusCode == 429 ||
          (resp.statusCode >= 500 && resp.statusCode < 600)) {
        return _FetchResult(_FetchOutcome.rateLimited);
      }
      if (resp.statusCode == 403) {
        // Session likely expired — invalidate and let the next call re-establish.
        _csrfToken = null;
        _cookie = null;
        return _FetchResult(_FetchOutcome.rateLimited);
      }
      if (resp.statusCode != 200) {
        return _FetchResult(_FetchOutcome.error);
      }
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      if (json['errors'] != null) {
        return _FetchResult(_FetchOutcome.error);
      }
      final data = json['data'] as Map<String, dynamic>?;
      final card = data?['card'] as Map<String, dynamic>?;
      if (card == null) return _FetchResult(_FetchOutcome.notFound);
      return _FetchResult(_FetchOutcome.success, card);
    } catch (_) {
      return _FetchResult(_FetchOutcome.error);
    }
  }
}
