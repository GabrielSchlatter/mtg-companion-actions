import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show InsertMode, Value, Variable;
import 'package:http/http.dart' as http;

import '../db/cards_database.dart';
import 'edhrec_categories.dart';

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
  /// Empty set (the default) means "keep everything" — including the
  /// type-bucketed categories ("Creatures", "Instants", "Lands", …) that
  /// constitute EDHREC's average-decklist view. Bundle size grows
  /// roughly 4× when the type buckets are kept; we accept that cost so
  /// downstream features (deck advisor, AI snapshots, future analyses)
  /// have the full recommendation graph available.
  ///
  /// Pass an explicit set to gate categories — e.g.
  /// `{'Top Cards', 'High Synergy Cards', 'Game Changers'}` — when
  /// experimenting with smaller bundles.
  final Set<String> keepCategories;

  EdhrecCrawlConfig({
    this.shardIndex = 0,
    this.shardCount = 1,
    this.pacing = const Duration(milliseconds: 1000),
    this.maxRuntime,
    this.maxConsecutiveRateLimits = 3,
    this.staleness = const Duration(days: 7),
    this.fetchCommanderPages = true,
    Set<String>? keepCategories,
  }) : keepCategories = keepCategories ?? const <String>{};
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

  // Partnership commander pages — Tymna+Thrasios, Doctor + Companion,
  // Choose-a-Background pairs, etc. Discovery walks EDHREC's own
  // `/partners/*` index so we only crawl pairings that have at least
  // one observed deck (the combinatorial product of all partner cards
  // would be ~22k pairs, of which only ~2-3k are actually played).
  // Skipped entirely when commander pages are disabled.
  final discoveryClient = http.Client();
  List<_EdhrecWorkItem> partnershipWork = const [];
  try {
    if (config.fetchCommanderPages) {
      final freshPairs = await _loadFreshPartnerPairs(db, freshCutoff);
      partnershipWork = await _buildPartnershipWorkList(
        discoveryClient,
        db,
        config,
        freshPairs,
        nameToOracleId,
        emit,
      );
    }
  } finally {
    discoveryClient.close();
  }

  emit(
    '  shard ${config.shardIndex}/${config.shardCount} '
    'work list: ${cardWork.length} card pages · '
    '${commanderWork.length} commander pages · '
    '${partnershipWork.length} partnership pages',
  );

  // Commander pages (solo + partnership) first: they're a small
  // fraction of the work list but carry the high-value data (themes,
  // tag_links, synergy scores) the app uses for "synergize with my
  // commander" queries. A time-bounded run that drops out mid-card-list
  // still ships full commander coverage that way.
  final allWork = [...commanderWork, ...partnershipWork, ...cardWork];
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

  // Whether each (oracle_id, kind, partner_oracle_id) row already has
  // a page row from a previous bundle — used to count refreshes vs
  // first-time crawls and to decide whether to DELETE child rows
  // before INSERT. Keys are encoded as `oracleId|partnerOracleId`
  // (partnerOracleId is empty for solo rows).
  final cardPagePresent = await _loadAllPageKeys(db, 'card');
  final commanderPagePresent = await _loadAllPageKeys(db, 'commander');

  String workKey(_EdhrecWorkItem w) =>
      '${w.oracleId}|${w.partnerOracleId ?? ''}';

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

  // Heartbeat every 100 pages (~100s of pacing) so a multi-hour crawl
  // shows up in the log instead of looking hung.
  const heartbeatEvery = 100;

  try {
    for (final w in allWork) {
      if (config.maxRuntime != null && stopwatch.elapsed > config.maxRuntime!) {
        stoppedByTimeBudget = true;
        emit('  time budget exhausted at ${stopwatch.elapsed.inSeconds}s');
        break;
      }

      attempted++;
      if (attempted % heartbeatEvery == 0) {
        final pct = ((attempted / allWork.length) * 100).toStringAsFixed(1);
        emit(
          '  edhrec progress: $attempted/${allWork.length} ($pct%) '
          '· succeeded=$succeeded notFound=$notFound failed=$failed '
          '· elapsed=${stopwatch.elapsed.inSeconds}s '
          '· recs=$newRecommendations',
        );
      }
      final wasRefresh = w.kind == 'card'
          ? cardPagePresent.contains(workKey(w))
          : commanderPagePresent.contains(workKey(w));

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

  /// Set on partnership commander pages only. The lex-smaller oracle
  /// is stored in [oracleId] / [sanitized] and the larger here, so
  /// every pair is represented by a single work item with a stable
  /// canonical key. The fetched URL still uses the *original* slug
  /// pair EDHREC published — see [pairUrlSlug].
  final String? partnerOracleId;
  final String? partnerSanitized;

  /// For partnership rows: the URL slug EDHREC actually serves
  /// (`/commanders/<a>-<b>`), in whatever order EDHREC chose. Null for
  /// solo rows.
  final String? pairUrlSlug;

  _EdhrecWorkItem({
    required this.scryfallId,
    required this.oracleId,
    required this.name,
    required this.sanitized,
    required this.kind,
    this.partnerOracleId,
    this.partnerSanitized,
    this.pairUrlSlug,
  });

  bool get isPartnership => partnerOracleId != null;
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

/// Builds work items for partnership commander pages by walking
/// EDHREC's `/pages/partners.json` index → per-card `/pages/partners/<slug>.json`
/// → unique pairs.
///
/// Closed by EDHREC's index (only pairings with at least one observed
/// deck are listed), so this naturally bounds the crawl to "real"
/// pairings rather than the combinatorial product of all partner
/// cards. The returned list is deduplicated by canonical oracle pair
/// (`(min, max)`); each work item carries the lex-smaller oracle as
/// `oracleId` and the larger as `partnerOracleId`, plus EDHREC's
/// original URL slug so we fetch the page that actually exists.
///
/// Cards on the partnership index whose names don't resolve to oracle
/// IDs in our local catalog are skipped silently (rare — usually
/// whitespace / casing edge cases EDHREC differs on).
Future<List<_EdhrecWorkItem>> _buildPartnershipWorkList(
  http.Client client,
  CardsDatabase db,
  EdhrecCrawlConfig cfg,
  Set<({String a, String b})> freshPairs,
  Map<String, String> nameToOracleId,
  void Function(String) emit,
) async {
  // 1. Fetch the `/pages/partners.json` index. Lists every partner-
  //    eligible card across all mechanics (Partner, Friends Forever,
  //    Doctor, Doctor's Companion, Choose-a-Background, Background, …)
  //    with URLs `/partners/<slug>`.
  final indexResp = await _fetchRawJson(
    client,
    '$_edhrecBaseUrl/pages/partners.json',
  );
  if (indexResp == null) {
    emit('  partner index fetch failed — skipping partnership crawl');
    return const [];
  }

  // The index has multiple cardlists, each tagged for a different
  // partnering mechanic — `partners` (open Partner), `partnerwith`
  // (Partner with X), `friendsforever`, `doctors` (Doctor's
  // Companion), `chooseabackground` × `backgrounds`, `survivors`,
  // `father&son`, `characterselect`, plus any future EDHREC adds.
  // Each cardview is one of two shapes:
  //
  //   - **Direct pair** — `url` is `/commanders/<a>-<b>` and `cards`
  //     has both members. Used by the `partnerwith` mechanic
  //     (Cazur+Ukkima, Frodo+Sam, Alisaie+Alphinaud, …) and by any
  //     other mechanic where EDHREC pre-resolves the canonical pair.
  //     We can insert these directly without a per-card walk.
  //
  //   - **Single card** — `url` is `/partners/<slug>` and `cards` is
  //     null. We then have to walk `/pages/partners/<slug>.json` to
  //     enumerate which other cards EDHREC paired it with. EDHREC
  //     occasionally returns `AccessDenied` (HTTP 403) for those
  //     per-card pages — we tolerate it and move on.
  final container = indexResp['container'] as Map<String, dynamic>?;
  final jsonDict = container?['json_dict'] as Map<String, dynamic>?;
  final cardlists = jsonDict?['cardlists'] as List<dynamic>? ?? const [];

  final pairs = <String, _EdhrecWorkItem>{}; // canonical key → work item
  final singleCardEntries = <Map<String, dynamic>>[];
  var directPairCount = 0;
  for (final cl in cardlists) {
    if (cl is! Map<String, dynamic>) continue;
    final cardviews = cl['cardviews'] as List<dynamic>? ?? const [];
    for (final cv in cardviews.whereType<Map<String, dynamic>>()) {
      final url = cv['url'] as String?;
      if (url == null) continue;
      if (url.startsWith('/commanders/')) {
        // Direct pair — extract members and add to work list.
        final pairSlug = url.substring(12);
        final cards = cv['cards'] as List<dynamic>?;
        if (cards == null || cards.length < 2) continue;
        final lhsCard = cards[0] as Map<String, dynamic>?;
        final rhsCard = cards[1] as Map<String, dynamic>?;
        if (lhsCard == null || rhsCard == null) continue;
        final lhsName = lhsCard['name'] as String?;
        final rhsName = rhsCard['name'] as String?;
        // The per-card `url` field on members is the slug fragment
        // (e.g. `alisaie-leveilleur`), not a full path.
        final lhsSlug = lhsCard['url'] as String?;
        final rhsSlug = rhsCard['url'] as String?;
        if (lhsName == null ||
            rhsName == null ||
            lhsSlug == null ||
            rhsSlug == null) continue;
        final lhsOracle = _resolveName(lhsName, nameToOracleId);
        final rhsOracle = _resolveName(rhsName, nameToOracleId);
        if (lhsOracle == null ||
            rhsOracle == null ||
            lhsOracle == rhsOracle) continue;
        final (a, b) = lhsOracle.compareTo(rhsOracle) < 0
            ? (lhsOracle, rhsOracle)
            : (rhsOracle, lhsOracle);
        final key = '$a|$b';
        if (pairs.containsKey(key)) continue;
        if (freshPairs.contains((a: a, b: b))) continue;
        pairs[key] = _EdhrecWorkItem(
          scryfallId: '$a-$b',
          oracleId: a,
          name: '$lhsName // $rhsName',
          sanitized: a == lhsOracle ? lhsSlug : rhsSlug,
          kind: 'commander',
          partnerOracleId: b,
          partnerSanitized: a == lhsOracle ? rhsSlug : lhsSlug,
          pairUrlSlug: pairSlug,
        );
        directPairCount++;
      } else if (url.startsWith('/partners/')) {
        singleCardEntries.add(cv);
      }
    }
  }
  emit('  partner index: ${directPairCount} direct pairs (Partner with X / '
      'similar) + ${singleCardEntries.length} cards needing per-card walk');

  // Walk per-card pages for the single-card entries to discover which
  // other cards EDHREC pairs them with. 403s are expected — they mean
  // EDHREC has the card in the index but not (yet) a per-card page;
  // skip and keep going.
  var indexed = 0;
  for (final entry in singleCardEntries) {
    final lhsSlug = (entry['sanitized'] as String?) ??
        _slugFromPartnersUrl(entry['url'] as String?);
    final lhsName = entry['name'] as String?;
    if (lhsSlug == null || lhsName == null) continue;
    final lhsOracle = _resolveName(lhsName, nameToOracleId);
    if (lhsOracle == null) continue;

    final perCard = await _fetchRawJson(
      client,
      '$_edhrecBaseUrl/pages/partners/$lhsSlug.json',
    );
    await Future<void>.delayed(cfg.pacing);
    if (perCard == null) continue;

    for (final cv in _extractCardviews(perCard, tag: 'pairings')) {
      final pairUrl = cv['url'] as String?;
      final rhsName = cv['name'] as String?;
      if (pairUrl == null || rhsName == null) continue;
      final pairSlug =
          pairUrl.startsWith('/commanders/') ? pairUrl.substring(12) : null;
      if (pairSlug == null) continue;
      final rhsSlug = _splitPairSlug(pairSlug, lhsSlug);
      if (rhsSlug == null) continue;
      final rhsOracle = _resolveName(rhsName, nameToOracleId);
      if (rhsOracle == null) continue;
      if (rhsOracle == lhsOracle) continue; // self-pairings are nonsense

      final (a, b) = lhsOracle.compareTo(rhsOracle) < 0
          ? (lhsOracle, rhsOracle)
          : (rhsOracle, lhsOracle);
      final key = '$a|$b';
      if (pairs.containsKey(key)) continue;
      if (freshPairs.contains((a: a, b: b))) continue;

      pairs[key] = _EdhrecWorkItem(
        scryfallId: '$a-$b',
        oracleId: a,
        name: '$lhsName // $rhsName',
        sanitized: a == lhsOracle ? lhsSlug : rhsSlug,
        kind: 'commander',
        partnerOracleId: b,
        partnerSanitized: a == lhsOracle ? rhsSlug : lhsSlug,
        pairUrlSlug: pairSlug,
      );
    }
    indexed++;
    if (indexed % 25 == 0) {
      emit('  partner discovery: $indexed/${singleCardEntries.length} '
          'per-card pages walked · unique pairs so far: ${pairs.length}');
    }
  }
  emit('  partner discovery done: ${pairs.length} unique pairs '
      '(after dedup against fresh)');

  // Apply the same shard hashing as solo work items so multiple bundle
  // builders divide the partnership crawl evenly.
  final out = <_EdhrecWorkItem>[];
  for (final w in pairs.values) {
    if (cfg.shardCount > 1 &&
        _fnv1a(w.scryfallId) % cfg.shardCount != cfg.shardIndex) {
      continue;
    }
    out.add(w);
  }
  return out;
}

/// Pulls `(canonicalSmaller, canonicalLarger)` pairs from
/// `edhrec_pages` whose `last_updated` is within the staleness window.
/// Used to skip partnership pages we already have on a re-run.
Future<Set<({String a, String b})>> _loadFreshPartnerPairs(
  CardsDatabase db,
  DateTime cutoff,
) async {
  final cutoffEpoch = cutoff.millisecondsSinceEpoch ~/ 1000;
  final rows = await db.customSelect(
    "SELECT oracle_id, partner_oracle_id FROM edhrec_pages "
    "WHERE kind = 'commander' "
    "  AND partner_oracle_id IS NOT NULL "
    "  AND last_updated >= ?",
    variables: [Variable<int>(cutoffEpoch)],
  ).get();
  return {
    for (final r in rows)
      (
        a: r.data['oracle_id'] as String,
        b: r.data['partner_oracle_id'] as String,
      ),
  };
}

/// Strips a `/partners/<slug>` href back to the slug.
String? _slugFromPartnersUrl(String? url) {
  if (url == null) return null;
  const prefix = '/partners/';
  if (!url.startsWith(prefix)) return null;
  return url.substring(prefix.length);
}

/// Given a combined pair slug (`a-slug-b-slug`) and the slug of one
/// known half, returns the other half. Robust against either-order
/// concatenation.
String? _splitPairSlug(String pairSlug, String knownSlug) {
  final prefix = '$knownSlug-';
  if (pairSlug.startsWith(prefix)) {
    final tail = pairSlug.substring(prefix.length);
    return tail.isEmpty ? null : tail;
  }
  final suffix = '-$knownSlug';
  if (pairSlug.endsWith(suffix)) {
    final head = pairSlug.substring(0, pairSlug.length - suffix.length);
    return head.isEmpty ? null : head;
  }
  return null;
}

List<Map<String, dynamic>> _extractCardviews(
  Map<String, dynamic> page, {
  required String tag,
}) {
  final container = page['container'] as Map<String, dynamic>?;
  final jsonDict = container?['json_dict'] as Map<String, dynamic>?;
  final cardlists = jsonDict?['cardlists'] as List<dynamic>? ?? const [];
  for (final cl in cardlists) {
    if (cl is! Map<String, dynamic>) continue;
    if (cl['tag'] != tag) continue;
    final cardviews = cl['cardviews'] as List<dynamic>? ?? const [];
    return [
      for (final cv in cardviews)
        if (cv is Map<String, dynamic>) cv,
    ];
  }
  return const [];
}

Future<Map<String, dynamic>?> _fetchRawJson(
  http.Client client,
  String url,
) async {
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
    if (resp.statusCode != 200) return null;
    return jsonDecode(resp.body) as Map<String, dynamic>;
  } catch (_) {
    return null;
  }
}

Future<List<_EdhrecWorkItem>> _buildCommanderWorkList(
  CardsDatabase db,
  EdhrecCrawlConfig cfg,
  Set<String> fresh,
) async {
  // Filter mirrors the paths to commander eligibility in the
  // Magic comprehensive rules:
  //
  //   903.3  — "Each deck has a legendary creature card designated
  //            as its commander." (default rule, the bulk of cases)
  //   903.3a — "Some cards have an ability that states the card can
  //            be your commander." (covers planeswalker commanders
  //            like Daretti / Estrid / Aminatou, artifact-walkers
  //            like The Aetherspark, and any future commander-
  //            archetype card uniformly.)
  //   Spacecraft / Vehicle update (Edge of Eternities, 2025) —
  //            "A card designated as commander must be either a
  //            creature card, a planeswalker card, a Vehicle card,
  //            or a Spacecraft card with one or more power/
  //            toughness boxes." For deck-construction this means
  //            Legendary Vehicles and Legendary Spacecraft with a
  //            P/T are also eligible (Hearthhull the Worldseed,
  //            The Seriema, Inspirit, Flagship Vessel, …).
  //
  // `legal_commander = 'legal'` excludes banned cards. We don't use
  // MTGJSON's `leadershipSkills.commander` (`can_be_commander`)
  // here because it's only TRUE for the 903.3a exception cases —
  // it leaves the default-eligible Legendary Creatures FALSE,
  // which would silently skip every "normal" commander.
  //
  // Backgrounds are deliberately excluded — they're co-commanders
  // only, never standalone, and the partnership flow
  // (`_buildPartnershipWorkList`) handles their EDHREC pages.
  // Note on the type_line patterns: the supertype `Legendary` and the
  // card type `Creature` can be separated by other types in type_line
  // (e.g. "Legendary Artifact Creature — Robot", "Legendary Enchantment
  // Creature — Background", "Legendary Snow Creature — Zombie"). So we
  // match `%Legendary%` AND `%Creature%` separately rather than the
  // contiguous `%Legendary Creature%` substring.
  final rows = await db.customSelect(
    "SELECT scryfall_id, name, oracle_id, edhrec_rank "
    "FROM cards "
    "WHERE is_canonical_printing = 1 "
    "  AND legal_commander = 'legal' "
    "  AND ("
    "    (type_line LIKE '%Legendary%' AND type_line LIKE '%Creature%') "
    "    OR ((type_line LIKE '%Legendary%' "
    "         AND (type_line LIKE '%Vehicle%' OR type_line LIKE '%Spacecraft%')) "
    "        AND power IS NOT NULL AND power != '') "
    "    OR oracle_text LIKE '%can be your commander%' "
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

/// Solo-page freshness check. Skips partnership rows so a fresh
/// solo Tymna page doesn't suppress a stale Tymna+Thrasios crawl.
Future<Set<String>> _loadFreshPageOracles(
  CardsDatabase db,
  String kind,
  DateTime cutoff,
) async {
  final cutoffEpoch = cutoff.millisecondsSinceEpoch ~/ 1000;
  final rows = await db.customSelect(
    'SELECT oracle_id FROM edhrec_pages '
    'WHERE kind = ? AND partner_oracle_id IS NULL AND last_updated >= ?',
    variables: [Variable<String>(kind), Variable<int>(cutoffEpoch)],
  ).get();
  return {for (final r in rows) r.data['oracle_id'] as String};
}

/// Returns `oracleId|partnerOracleId` keys for every page row of the
/// given kind. Partnerships use the canonical (lex-smaller, larger)
/// pair the crawler stored. Solo pages key as `oracleId|`.
Future<Set<String>> _loadAllPageKeys(
  CardsDatabase db,
  String kind,
) async {
  final rows = await db.customSelect(
    'SELECT oracle_id, partner_oracle_id '
    'FROM edhrec_pages WHERE kind = ?',
    variables: [Variable<String>(kind)],
  ).get();
  return {
    for (final r in rows)
      '${r.data['oracle_id']}|${r.data['partner_oracle_id'] ?? ''}',
  };
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
    final categoryDisplay = cardlist['header']?.toString() ?? 'Other';
    if (keepCategories.isNotEmpty &&
        !keepCategories.contains(categoryDisplay)) {
      continue;
    }
    // v7: drop recs whose category isn't in our enum — those are
    // headers we don't ship anyway. The 17-value enum covers every
    // category we kept in `_kEdhrecCategoryWhitelist`.
    final categoryEnum = EdhrecCategory.fromDisplayName(categoryDisplay);
    if (categoryEnum == null) continue;
    final cardviews = cardlist['cardviews'] as List<dynamic>? ?? const [];
    var rank = 0;
    for (final cv in cardviews) {
      if (cv is! Map<String, dynamic>) continue;
      rank++;
      final name = cv['name']?.toString() ?? '';
      if (name.isEmpty) continue;
      // v7: must resolve to a card we have — recs without an oracle
      // would be unjoinable (we no longer ship `card_name`).
      final oracleId = _resolveName(name, nameToOracleId);
      if (oracleId == null) continue;
      final numDecks = _asInt(cv['num_decks']);
      final potentialDecks = _asInt(cv['potential_decks']);
      double? inclusionPercent;
      if (numDecks != null && potentialDecks != null && potentialDecks > 0) {
        inclusionPercent = numDecks / potentialDecks;
      }

      pendingRecs.add(
        _PendingRec(
          oracleId: oracleId,
          category: categoryEnum.id,
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
    // UPSERT page row by (oracle_id, kind, partner_oracle_id). Partner
    // is NULL for solo rows; SQLite's IS-vs-= semantics mean we need
    // separate WHERE clauses for the lookup.
    int pageId;
    if (isRefresh) {
      // Find existing id, clear child tables, then update the row.
      final List<dynamic> existing;
      if (w.partnerOracleId == null) {
        existing = await db.customSelect(
          'SELECT id FROM edhrec_pages '
          'WHERE oracle_id = ? AND kind = ? AND partner_oracle_id IS NULL',
          variables: [
            Variable<String>(w.oracleId),
            Variable<String>(w.kind),
          ],
        ).get();
      } else {
        existing = await db.customSelect(
          'SELECT id FROM edhrec_pages '
          'WHERE oracle_id = ? AND kind = ? AND partner_oracle_id = ?',
          variables: [
            Variable<String>(w.oracleId),
            Variable<String>(w.kind),
            Variable<String>(w.partnerOracleId!),
          ],
        ).get();
      }
      if (existing.isEmpty) {
        // Should be impossible (we checked), but fall through to insert.
        pageId = await db.into(db.edhrecPages).insert(
              EdhrecPagesCompanion.insert(
                oracleId: w.oracleId,
                kind: w.kind,
                partnerOracleId: Value(w.partnerOracleId),
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
              partnerOracleId: Value(w.partnerOracleId),
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
                    oracleId: p.oracleId,
                    category: p.category,
                    inclusionCount: Value(p.inclusionCount),
                    inclusionPercent: Value(p.inclusionPercent),
                    synergyScore: Value(p.synergyScore),
                    rankInCategory: Value(p.rankInCategory),
                  ),
                )
                .toList(),
            // PK is (page_id, oracle_id, category) — duplicates within
            // a single category collapse, but the same card showing up
            // in two distinct categories on the same page produces two
            // rows (different PK).
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
  final String oracleId;
  final int category;
  final int? inclusionCount;
  final double? inclusionPercent;
  final double? synergyScore;
  final int? rankInCategory;
  _PendingRec({
    required this.oracleId,
    required this.category,
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
  // Partnerships use EDHREC's published combined slug (the side that
  // actually returns 200); solo pages use the card's own slug.
  final slug = w.pairUrlSlug ?? w.sanitized;
  final url = '$_edhrecBaseUrl/pages/$pathSegment/$slug.json';
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
