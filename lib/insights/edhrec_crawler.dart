import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show InsertMode, Value, Variable;
import 'package:http/http.dart' as http;

import '../db/cards_database.dart';

/// EDHREC crawler.
///
/// Fetches one (card-page) and optionally one (commander-page) per
/// oracle card from `json.edhrec.com`. Commander pages are only
/// requested for cards legal in Commander; EDHREC returns 404 for
/// non-commanders, which is treated as "no commander page" rather than
/// an error.
///
/// Writes to the relational EDHREC tables:
///   - `edhrec_pages`            — one row per (oracle_id, kind)
///   - `edhrec_recommendations`  — recommended-card edges
///   - `edhrec_themes`           — themes panel
///   - `edhrec_tag_links`        — tag-links panel
///
/// Refresh-cycle gate uses `edhrec_pages.last_updated` directly — no
/// separate status table needed since the page row IS the per-oracle
/// marker. A failed re-fetch never enters its transaction so the
/// previous page's child rows stay untouched.

const String _edhrecBaseUrl = 'https://json.edhrec.com';
const String _userAgent =
    'mtg-companion-bundle-builder/1.0 '
    '(+https://github.com/GabrielSchlatter/mtg-companion-actions)';

class EdhrecCrawlConfig {
  final int shardIndex;
  final int shardCount;
  final Duration pacing;
  final Duration? maxRuntime;
  final int maxConsecutiveRateLimits;

  /// Default 7 days — EDHREC popularity / synergy moves week-by-week
  /// as new sets land and meta-shifts ripple through user decklists.
  /// Longer windows leave more rows in the bundle stale.
  final Duration staleness;

  /// Whether to fetch the commander page for cards legal in Commander.
  /// On by default; turn off to skip the second request per card.
  final bool fetchCommanderPages;

  /// Whitelist of EDHREC category names to keep in `edhrec_recommendations`.
  /// EDHREC returns ~13–14 categories per page, of which only a handful
  /// power the medal / synergy / AI features in the app. Type-bucketed
  /// categories ("Creatures", "Instants", "Lands", …) are essentially the
  /// "average decklist" view — high row count, low query value — so we
  /// drop them by default. Setting this to an empty set disables the
  /// filter (keeps everything).
  final Set<String> keepCategories;

  /// EDHREC category names dropped by default. Pre-aligned with the
  /// observed bundle distribution (Creatures + Instants + Sorceries +
  /// Enchantments + Utility Lands + Utility Artifacts + Lands account
  /// for ~80% of rows in the sample run). Updating this list later only
  /// affects future builds — existing seeded rows are dropped per
  /// page during refresh, then the new (filtered) data is written.
  static const Set<String> defaultKeepCategories = {
    'High Synergy Cards',
    'Top Cards',
    'Game Changers',
    'Mana Artifacts',
    'New Cards',
    'Planeswalkers',
    'Battles',
  };

  EdhrecCrawlConfig({
    this.shardIndex = 0,
    this.shardCount = 1,
    this.pacing = const Duration(milliseconds: 1000),
    this.maxRuntime,
    this.maxConsecutiveRateLimits = 3,
    this.staleness = const Duration(days: 7),
    this.fetchCommanderPages = true,
    Set<String>? keepCategories,
  }) : keepCategories = keepCategories ?? defaultKeepCategories;
}

class EdhrecCrawlResult {
  final int pagesAttempted;
  final int pagesSucceeded;
  final int pagesFailed;
  final int pagesNotFound;
  final int pagesFresh; // skipped: still within staleness window
  final int pagesRefreshed;
  final int rateLimitHits;
  final int newRecommendations;
  final int newThemes;
  final int newTagLinks;
  final bool stoppedByRateLimit;
  final bool stoppedByTimeBudget;
  final Duration elapsed;

  EdhrecCrawlResult({
    required this.pagesAttempted,
    required this.pagesSucceeded,
    required this.pagesFailed,
    required this.pagesNotFound,
    required this.pagesFresh,
    required this.pagesRefreshed,
    required this.rateLimitHits,
    required this.newRecommendations,
    required this.newThemes,
    required this.newTagLinks,
    required this.stoppedByRateLimit,
    required this.stoppedByTimeBudget,
    required this.elapsed,
  });
}

Future<EdhrecCrawlResult> runEdhrecCrawl(
  CardsDatabase db,
  EdhrecCrawlConfig config, {
  void Function(String)? log,
}) async {
  void emit(String msg) => (log ?? (m) => stdout.writeln(m))(msg);
  final stopwatch = Stopwatch()..start();

  final nameToOracleId = await _buildNameToOracleIdMap(db);
  emit('  name→oracle_id lookup: ${nameToOracleId.length} entries');

  final freshCutoff = DateTime.now().toUtc().subtract(config.staleness);
  final freshCardPages = await _loadFreshPageOracles(db, 'card', freshCutoff);
  final freshCommanderPages =
      await _loadFreshPageOracles(db, 'commander', freshCutoff);
  emit(
    '  refresh window: staleness=${config.staleness.inDays}d · '
    '${freshCardPages.length} card pages fresh · '
    '${freshCommanderPages.length} commander pages fresh',
  );

  final cardWork = await _buildCardWorkList(db, config, freshCardPages);
  final commanderWork = config.fetchCommanderPages
      ? await _buildCommanderWorkList(db, config, freshCommanderPages)
      : <_EdhrecWorkItem>[];

  emit(
    '  shard ${config.shardIndex}/${config.shardCount} '
    'work list: ${cardWork.length} card pages · '
    '${commanderWork.length} commander pages',
  );

  // Commander pages first: they're a small fraction of the work list
  // (~3k vs 30k+) but carry the high-value data (themes, tag_links,
  // synergy scores) the app uses for "synergize with my commander"
  // queries. A time-bounded run that drops out mid-card-list still
  // ships full commander coverage that way.
  final allWork = [...commanderWork, ...cardWork];
  if (allWork.isEmpty) {
    return EdhrecCrawlResult(
      pagesAttempted: 0,
      pagesSucceeded: 0,
      pagesFailed: 0,
      pagesNotFound: 0,
      pagesFresh: freshCardPages.length + freshCommanderPages.length,
      pagesRefreshed: 0,
      rateLimitHits: 0,
      newRecommendations: 0,
      newThemes: 0,
      newTagLinks: 0,
      stoppedByRateLimit: false,
      stoppedByTimeBudget: false,
      elapsed: stopwatch.elapsed,
    );
  }

  // Whether each (oracle_id, kind) pair already has a page row from a
  // previous bundle — used to count refreshes vs first-time crawls and
  // to decide whether to DELETE child rows before INSERT.
  final cardPagePresent = await _loadAllPageOracles(db, 'card');
  final commanderPagePresent = await _loadAllPageOracles(db, 'commander');

  final client = http.Client();

  var attempted = 0;
  var succeeded = 0;
  var failed = 0;
  var notFound = 0;
  var refreshed = 0;
  var rateLimitHits = 0;
  var consecutiveRateLimits = 0;
  var newRecommendations = 0;
  var newThemes = 0;
  var newTagLinks = 0;
  var stoppedByRateLimit = false;
  var stoppedByTimeBudget = false;

  try {
    for (final w in allWork) {
      if (config.maxRuntime != null && stopwatch.elapsed > config.maxRuntime!) {
        stoppedByTimeBudget = true;
        emit('  time budget exhausted at ${stopwatch.elapsed.inSeconds}s');
        break;
      }

      attempted++;
      final wasRefresh = w.kind == 'card'
          ? cardPagePresent.contains(w.oracleId)
          : commanderPagePresent.contains(w.oracleId);

      final fetch = await _fetchPage(client, w);
      switch (fetch.outcome) {
        case _FetchOutcome.success:
          consecutiveRateLimits = 0;
          succeeded++;
          if (wasRefresh) refreshed++;
          if (fetch.json != null) {
            final stats = await _ingestPage(
              db,
              w,
              fetch.json!,
              nameToOracleId,
              isRefresh: wasRefresh,
              keepCategories: config.keepCategories,
            );
            newRecommendations += stats.newRecommendations;
            newThemes += stats.newThemes;
            newTagLinks += stats.newTagLinks;
          }
          break;
        case _FetchOutcome.notFound:
          // EDHREC has no entry for this card/commander — totally normal
          // (e.g. brand-new card not yet indexed, or a card that's legal
          // commander but never built into a deck on EDHREC).
          consecutiveRateLimits = 0;
          notFound++;
          break;
        case _FetchOutcome.rateLimited:
          rateLimitHits++;
          consecutiveRateLimits++;
          failed++;
          emit(
            '  rate-limited on ${w.kind}/${w.sanitized} '
            '(consecutive=$consecutiveRateLimits)',
          );
          if (consecutiveRateLimits >= config.maxConsecutiveRateLimits) {
            stoppedByRateLimit = true;
            emit('  rate-limit threshold hit — bailing out');
            break;
          }
          await Future<void>.delayed(
            Duration(seconds: 5 * consecutiveRateLimits),
          );
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
    client.close();
  }

  return EdhrecCrawlResult(
    pagesAttempted: attempted,
    pagesSucceeded: succeeded,
    pagesFailed: failed,
    pagesNotFound: notFound,
    pagesFresh: freshCardPages.length + freshCommanderPages.length,
    pagesRefreshed: refreshed,
    rateLimitHits: rateLimitHits,
    newRecommendations: newRecommendations,
    newThemes: newThemes,
    newTagLinks: newTagLinks,
    stoppedByRateLimit: stoppedByRateLimit,
    stoppedByTimeBudget: stoppedByTimeBudget,
    elapsed: stopwatch.elapsed,
  );
}

class _EdhrecWorkItem {
  final String scryfallId;
  final String oracleId;
  final String name;
  final String sanitized;
  final String kind; // 'card' | 'commander'
  _EdhrecWorkItem({
    required this.scryfallId,
    required this.oracleId,
    required this.name,
    required this.sanitized,
    required this.kind,
  });
}

Future<List<_EdhrecWorkItem>> _buildCardWorkList(
  CardsDatabase db,
  EdhrecCrawlConfig cfg,
  Set<String> fresh,
) async {
  final rows = await db.customSelect(
    'SELECT scryfall_id, name, oracle_id, edhrec_rank '
    'FROM cards '
    'WHERE is_canonical_printing = 1 '
    'ORDER BY CASE WHEN edhrec_rank IS NULL THEN 1 ELSE 0 END, edhrec_rank ASC',
  ).get();
  return _filterRows(rows, cfg, fresh, 'card');
}

Future<List<_EdhrecWorkItem>> _buildCommanderWorkList(
  CardsDatabase db,
  EdhrecCrawlConfig cfg,
  Set<String> fresh,
) async {
  // Only request commander pages for cards that can plausibly *be* a
  // commander. EDHREC returns 403 (not 404) for non-commander pages,
  // which is indistinguishable from a real rate-limit at HTTP level —
  // so a tight type-line filter keeps us from triggering the
  // consecutive-403 bailout on a mostly-non-commander batch. Catches
  // legendary creatures, planeswalkers (with "can be your commander"
  // text), and Backgrounds; misses the handful of legendary-artifact /
  // -enchantment / -land "can be commander" cards, which is fine —
  // those will fall through to a 403 and get counted as notFound.
  final rows = await db.customSelect(
    "SELECT scryfall_id, name, oracle_id, edhrec_rank "
    "FROM cards "
    "WHERE is_canonical_printing = 1 "
    "  AND legal_commander = 'legal' "
    "  AND ( "
    "    type_line LIKE '%Legendary Creature%' OR "
    "    type_line LIKE '%Legendary Planeswalker%' OR "
    "    type_line LIKE '%Background%' "
    "  ) "
    "ORDER BY CASE WHEN edhrec_rank IS NULL THEN 1 ELSE 0 END, edhrec_rank ASC",
  ).get();
  return _filterRows(rows, cfg, fresh, 'commander');
}

List<_EdhrecWorkItem> _filterRows(
  List<dynamic> rows,
  EdhrecCrawlConfig cfg,
  Set<String> fresh,
  String kind,
) {
  final out = <_EdhrecWorkItem>[];
  for (final r in rows.cast<dynamic>()) {
    final data = (r as dynamic).data as Map<String, Object?>;
    final oracleId = data['oracle_id'] as String? ?? '';
    if (oracleId.isEmpty) continue;
    if (fresh.contains(oracleId)) continue;

    final scryfallId = data['scryfall_id'] as String? ?? '';
    if (scryfallId.isEmpty) continue;
    if (cfg.shardCount > 1) {
      final h = _fnv1a(scryfallId);
      if (h % cfg.shardCount != cfg.shardIndex) continue;
    }
    final name = data['name'] as String? ?? '';
    if (name.isEmpty) continue;

    out.add(
      _EdhrecWorkItem(
        scryfallId: scryfallId,
        oracleId: oracleId,
        name: name,
        sanitized: _sanitizeForEdhrec(name),
        kind: kind,
      ),
    );
  }
  return out;
}

Future<Map<String, String>> _buildNameToOracleIdMap(CardsDatabase db) async {
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

Future<Set<String>> _loadFreshPageOracles(
  CardsDatabase db,
  String kind,
  DateTime cutoff,
) async {
  final cutoffEpoch = cutoff.millisecondsSinceEpoch ~/ 1000;
  final rows = await db.customSelect(
    'SELECT oracle_id FROM edhrec_pages '
    'WHERE kind = ? AND last_updated >= ?',
    variables: [Variable<String>(kind), Variable<int>(cutoffEpoch)],
  ).get();
  return {for (final r in rows) r.data['oracle_id'] as String};
}

Future<Set<String>> _loadAllPageOracles(
  CardsDatabase db,
  String kind,
) async {
  final rows = await db.customSelect(
    'SELECT oracle_id FROM edhrec_pages WHERE kind = ?',
    variables: [Variable<String>(kind)],
  ).get();
  return {for (final r in rows) r.data['oracle_id'] as String};
}

class _PageIngestStats {
  final int newRecommendations;
  final int newThemes;
  final int newTagLinks;
  _PageIngestStats({
    required this.newRecommendations,
    required this.newThemes,
    required this.newTagLinks,
  });
}

Future<_PageIngestStats> _ingestPage(
  CardsDatabase db,
  _EdhrecWorkItem w,
  Map<String, dynamic> json,
  Map<String, String> nameToOracleId, {
  required bool isRefresh,
  required Set<String> keepCategories,
}) async {
  // Extract the page-level metadata first so we can write it as a
  // single-row UPSERT on the unique (oracle_id, kind) index.
  final container = json['container'] as Map<String, dynamic>?;
  final jsonDict = container?['json_dict'] as Map<String, dynamic>?;
  final cardInfo = jsonDict?['card'] as Map<String, dynamic>?;

  final pageRank = _asInt(cardInfo?['rank']);
  final pageNumDecks = _asInt(cardInfo?['num_decks']);
  final pageUrl = _nonEmpty(cardInfo?['url']);

  // Cardlists → recommendations. Skip categories outside the whitelist
  // (when one is configured) so the bundle isn't bloated with the
  // type-bucketed "average decklist" views — those rarely drive search
  // and account for ~80% of the row count at full scale.
  final pendingRecs = <_PendingRec>[];
  final cardlists = jsonDict?['cardlists'] as List<dynamic>? ?? const [];
  for (final cardlist in cardlists) {
    if (cardlist is! Map<String, dynamic>) continue;
    final category = cardlist['header']?.toString() ?? 'Other';
    if (keepCategories.isNotEmpty && !keepCategories.contains(category)) {
      continue;
    }
    final tag = cardlist['tag']?.toString();
    final cardviews = cardlist['cardviews'] as List<dynamic>? ?? const [];
    var rank = 0;
    for (final cv in cardviews) {
      if (cv is! Map<String, dynamic>) continue;
      rank++;
      final name = cv['name']?.toString() ?? '';
      if (name.isEmpty) continue;
      final numDecks = _asInt(cv['num_decks']);
      final potentialDecks = _asInt(cv['potential_decks']);
      double? inclusionPercent;
      if (numDecks != null && potentialDecks != null && potentialDecks > 0) {
        inclusionPercent = numDecks / potentialDecks;
      }

      pendingRecs.add(
        _PendingRec(
          oracleId: _resolveName(name, nameToOracleId),
          cardName: name,
          cardCategory: category,
          recommendationType: tag,
          inclusionCount: numDecks,
          inclusionPercent: inclusionPercent,
          synergyScore: _parseDouble(cv['synergy']),
          rankInCategory: rank,
        ),
      );
    }
  }

  // Themes — when present (some pages don't expose them).
  final pendingThemes = <_PendingTheme>[];
  final panels = json['panels'] as Map<String, dynamic>?;
  final themesRaw = panels?['themes'] as List<dynamic>? ??
      jsonDict?['themes'] as List<dynamic>? ??
      const [];
  for (final t in themesRaw) {
    if (t is! Map<String, dynamic>) continue;
    final slug = t['theme_slug']?.toString() ??
        t['slug']?.toString() ??
        '';
    if (slug.isEmpty) continue;
    final name =
        t['theme_name']?.toString() ?? t['value']?.toString() ?? slug;
    pendingThemes.add(
      _PendingTheme(
        slug: slug,
        name: name,
        totalDecks: _asInt(t['total_decks']),
        inclusionCount: _asInt(t['inclusion_count']),
        rankInTheme: _parseDouble(t['rank_in_theme']),
        synergyScore: _parseDouble(t['synergy_score']),
      ),
    );
  }

  // Tag links from `panels.taglinks`.
  final pendingTagLinks = <_PendingTagLink>[];
  final taglinks = panels?['taglinks'] as List<dynamic>? ?? const [];
  for (final tl in taglinks) {
    if (tl is! Map<String, dynamic>) continue;
    final slug = tl['slug']?.toString() ?? '';
    if (slug.isEmpty) continue;
    final name = tl['value']?.toString() ?? tl['name']?.toString() ?? slug;
    pendingTagLinks.add(
      _PendingTagLink(
        slug: slug,
        name: name,
        count: _asInt(tl['count']) ?? 0,
      ),
    );
  }

  var newRecs = 0;
  var newThemes = 0;
  var newTagLinks = 0;

  await db.transaction(() async {
    // UPSERT page row by (oracle_id, kind). We need the resulting `id`
    // for child inserts; on conflict the existing row is replaced.
    int pageId;
    if (isRefresh) {
      // Find existing id, clear child tables, then update the row.
      final existing = await db.customSelect(
        'SELECT id FROM edhrec_pages WHERE oracle_id = ? AND kind = ?',
        variables: [Variable<String>(w.oracleId), Variable<String>(w.kind)],
      ).get();
      if (existing.isEmpty) {
        // Should be impossible (we checked), but fall through to insert.
        pageId = await db.into(db.edhrecPages).insert(
              EdhrecPagesCompanion.insert(
                oracleId: w.oracleId,
                kind: w.kind,
                rank: Value(pageRank),
                numDecks: Value(pageNumDecks),
                url: Value(pageUrl),
                lastUpdated: DateTime.now().toUtc(),
              ),
            );
      } else {
        pageId = existing.first.data['id'] as int;
        await db.customUpdate(
          'UPDATE edhrec_pages SET rank = ?, num_decks = ?, url = ?, last_updated = ? '
          'WHERE id = ?',
          variables: [
            Variable<int>(pageRank),
            Variable<int>(pageNumDecks),
            Variable<String>(pageUrl),
            Variable<int>(
              DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000,
            ),
            Variable<int>(pageId),
          ],
        );
        // Clear children atomically — same transaction guarantees
        // rollback on any later throw, preserving seeded data.
        await db.customUpdate(
          'DELETE FROM edhrec_recommendations WHERE page_id = ?',
          variables: [Variable<int>(pageId)],
        );
        await db.customUpdate(
          'DELETE FROM edhrec_themes WHERE page_id = ?',
          variables: [Variable<int>(pageId)],
        );
        await db.customUpdate(
          'DELETE FROM edhrec_tag_links WHERE page_id = ?',
          variables: [Variable<int>(pageId)],
        );
      }
    } else {
      pageId = await db.into(db.edhrecPages).insert(
            EdhrecPagesCompanion.insert(
              oracleId: w.oracleId,
              kind: w.kind,
              rank: Value(pageRank),
              numDecks: Value(pageNumDecks),
              url: Value(pageUrl),
              lastUpdated: DateTime.now().toUtc(),
            ),
          );
    }

    if (pendingRecs.isNotEmpty) {
      // Inserted via batch in chunks of 1000 to keep the SQLite
      // statement limit happy on big commander pages (some have
      // hundreds of recommendations).
      const chunk = 500;
      for (var i = 0; i < pendingRecs.length; i += chunk) {
        final slice = pendingRecs.sublist(
          i,
          i + chunk > pendingRecs.length ? pendingRecs.length : i + chunk,
        );
        await db.batch(
          (b) => b.insertAll(
            db.edhrecRecommendations,
            slice
                .map(
                  (p) => EdhrecRecommendationsCompanion.insert(
                    pageId: pageId,
                    oracleId: Value(p.oracleId),
                    cardName: p.cardName,
                    cardCategory: Value(p.cardCategory),
                    recommendationType: Value(p.recommendationType),
                    inclusionCount: Value(p.inclusionCount),
                    inclusionPercent: Value(p.inclusionPercent),
                    synergyScore: Value(p.synergyScore),
                    rankInCategory: Value(p.rankInCategory),
                  ),
                )
                .toList(),
            // Same (page_id, card_name) duplicate handling — EDHREC
            // sometimes lists a card under two categories on a page;
            // INSERT OR IGNORE keeps the first one we saw.
            mode: InsertMode.insertOrIgnore,
          ),
        );
      }
      newRecs = pendingRecs.length;
    }

    if (pendingThemes.isNotEmpty) {
      await db.batch(
        (b) => b.insertAll(
          db.edhrecThemes,
          pendingThemes
              .map(
                (p) => EdhrecThemesCompanion.insert(
                  pageId: pageId,
                  themeSlug: p.slug,
                  themeName: p.name,
                  totalDecks: Value(p.totalDecks),
                  inclusionCount: Value(p.inclusionCount),
                  rankInTheme: Value(p.rankInTheme),
                  synergyScore: Value(p.synergyScore),
                ),
              )
              .toList(),
          mode: InsertMode.insertOrIgnore,
        ),
      );
      newThemes = pendingThemes.length;
    }

    if (pendingTagLinks.isNotEmpty) {
      await db.batch(
        (b) => b.insertAll(
          db.edhrecTagLinks,
          pendingTagLinks
              .map(
                (p) => EdhrecTagLinksCompanion.insert(
                  pageId: pageId,
                  slug: p.slug,
                  name: p.name,
                  count: Value(p.count),
                ),
              )
              .toList(),
          mode: InsertMode.insertOrIgnore,
        ),
      );
      newTagLinks = pendingTagLinks.length;
    }
  });

  return _PageIngestStats(
    newRecommendations: newRecs,
    newThemes: newThemes,
    newTagLinks: newTagLinks,
  );
}

class _PendingRec {
  final String? oracleId;
  final String cardName;
  final String? cardCategory;
  final String? recommendationType;
  final int? inclusionCount;
  final double? inclusionPercent;
  final double? synergyScore;
  final int? rankInCategory;
  _PendingRec({
    required this.oracleId,
    required this.cardName,
    required this.cardCategory,
    required this.recommendationType,
    required this.inclusionCount,
    required this.inclusionPercent,
    required this.synergyScore,
    required this.rankInCategory,
  });
}

class _PendingTheme {
  final String slug;
  final String name;
  final int? totalDecks;
  final int? inclusionCount;
  final double? rankInTheme;
  final double? synergyScore;
  _PendingTheme({
    required this.slug,
    required this.name,
    required this.totalDecks,
    required this.inclusionCount,
    required this.rankInTheme,
    required this.synergyScore,
  });
}

class _PendingTagLink {
  final String slug;
  final String name;
  final int count;
  _PendingTagLink({
    required this.slug,
    required this.name,
    required this.count,
  });
}

// ─── Network ──────────────────────────────────────────────────────────

enum _FetchOutcome { success, notFound, rateLimited, error }

class _FetchResult {
  final _FetchOutcome outcome;
  final Map<String, dynamic>? json;
  _FetchResult(this.outcome, [this.json]);
}

Future<_FetchResult> _fetchPage(http.Client client, _EdhrecWorkItem w) async {
  final pathSegment = w.kind == 'commander' ? 'commanders' : 'cards';
  final url = '$_edhrecBaseUrl/pages/$pathSegment/${w.sanitized}.json';
  try {
    final resp = await client
        .get(
          Uri.parse(url),
          headers: const {
            'User-Agent': _userAgent,
            'Accept': 'application/json',
          },
        )
        .timeout(const Duration(seconds: 20));
    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body) as Map<String, dynamic>;
      return _FetchResult(_FetchOutcome.success, json);
    }
    // 404 + 403 both mean "no such page" for EDHREC's CDN. They use 403
    // when the resource is missing because the CDN/protection layer
    // doesn't expose 404s — non-commander commander pages all come back
    // as 403. Real rate-limit pushback shows up as 429 / 5xx.
    if (resp.statusCode == 404 || resp.statusCode == 403) {
      return _FetchResult(_FetchOutcome.notFound);
    }
    if (resp.statusCode == 429 ||
        (resp.statusCode >= 500 && resp.statusCode < 600)) {
      return _FetchResult(_FetchOutcome.rateLimited);
    }
    return _FetchResult(_FetchOutcome.error);
  } catch (_) {
    return _FetchResult(_FetchOutcome.error);
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────

String? _resolveName(String name, Map<String, String> nameToOracleId) {
  final lower = name.toLowerCase();
  final hit = nameToOracleId[lower];
  if (hit != null) return hit;
  final split = lower.indexOf(' // ');
  if (split > 0) {
    return nameToOracleId[lower.substring(0, split)];
  }
  return null;
}

/// Sanitize a card name for EDHREC's URL slug, mirroring the app's
/// `_sanitizeCardName` (lowercase → strip non-alphanumeric → spaces to
/// dashes). Bundle keys collide with runtime-cache keys for free.
String _sanitizeForEdhrec(String name) {
  final lower = name.toLowerCase();
  final stripped = lower.replaceAll(RegExp(r'[^a-z0-9\s]'), '');
  return stripped.replaceAll(RegExp(r'\s+'), '-');
}

int? _asInt(Object? v) {
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

double? _parseDouble(Object? v) {
  if (v == null) return null;
  if (v is double) return v;
  if (v is int) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

String? _nonEmpty(Object? v) {
  if (v == null) return null;
  final s = v.toString();
  return s.isEmpty ? null : s;
}

int _fnv1a(String s) {
  var h = 0x811C9DC5;
  for (var i = 0; i < s.length; i++) {
    h = (h ^ s.codeUnitAt(i)) * 0x01000193;
    h = h & 0xFFFFFFFF;
  }
  return h;
}
