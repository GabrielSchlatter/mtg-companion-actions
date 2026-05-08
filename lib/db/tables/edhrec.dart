import 'package:drift/drift.dart';

/// EDHREC page metadata, one row per (oracle card, kind).
///
/// `kind` distinguishes the regular card page (`/pages/cards/{name}`)
/// from a commander page (`/pages/commanders/{name}`); both produce
/// recommendation lists with different shapes and live at different
/// URLs upstream. Splitting them keeps the lookup deterministic and
/// avoids overwriting one with the other.
@DataClassName('EdhrecPageRow')
@TableIndex(
  name: 'idx_edhrec_page_pk',
  columns: {#oracleId, #kind, #partnerOracleId},
  unique: true,
)
@TableIndex(name: 'idx_edhrec_page_oracle', columns: {#oracleId})
@TableIndex(name: 'idx_edhrec_page_kind', columns: {#kind})
@TableIndex(
  name: 'idx_edhrec_page_partner',
  columns: {#partnerOracleId},
)
class EdhrecPages extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// FK → cards.oracleId. The subject of the page.
  ///
  /// For partnership pages this is the lexicographically-smaller of
  /// the two pair members; the other oracle lives in
  /// [partnerOracleId]. Canonicalising on insert means a single row
  /// covers both `(A,B)` and `(B,A)` lookups — the client just sorts
  /// the two commander oracles before querying.
  TextColumn get oracleId => text()();

  /// `card` or `commander`.
  TextColumn get kind => text()();

  /// FK → cards.oracleId for the *partner* commander when this row
  /// represents a Partner / Friends Forever / Doctor + Companion /
  /// Choose-a-Background pairing. NULL for solo card / commander pages.
  TextColumn get partnerOracleId => text().nullable()();

  IntColumn get rank => integer().nullable()();
  IntColumn get numDecks => integer().nullable()();
  TextColumn get url => text().nullable()();

  DateTimeColumn get lastUpdated => dateTime()();
}

/// Recommended-card edges from each EDHREC page.
///
/// v7: dropped `card_name` (joined from `cards` via `oracle_id`),
/// replaced `card_category` text with a 1-byte `category` int (see
/// [EdhrecCategory]), and changed the PK to `(pageId, oracleId,
/// category)` — the natural unique tuple in EDHREC's data, since
/// some cards appear in two categories on the same page.
@DataClassName('EdhrecRecommendationRow')
@TableIndex(name: 'idx_edhrec_rec_oracle', columns: {#oracleId})
class EdhrecRecommendations extends Table {
  /// FK → edhrec_pages.id.
  IntColumn get pageId => integer()();

  /// FK → cards.oracleId. Always populated in v7 (verified at
  /// build time — every recommendation EDHREC returns resolves to a
  /// card we have in our catalog).
  TextColumn get oracleId => text()();

  /// `EdhrecCategory.id` — see `lib/insights/edhrec_categories.dart`.
  IntColumn get category => integer()();

  IntColumn get inclusionCount => integer().nullable()();
  RealColumn get inclusionPercent => real().nullable()();
  RealColumn get synergyScore => real().nullable()();
  IntColumn get rankInCategory => integer().nullable()();

  @override
  Set<Column> get primaryKey => {pageId, oracleId, category};

  @override
  bool get withoutRowId => true;
}

/// Negative cache for `(oracle, kind)` pairs that EDHREC returned 404
/// for. The crawler hits ~1k–2k of these per run — joke sets, mystery
/// boosters, "Unknown Event" tokens, brand-new cards EDHREC hasn't
/// indexed yet. Each one wastes a request *and* the pacing delay
/// every CI run.
///
/// `_buildCardWorkList` / `_buildCommanderWorkList` filter against
/// this table, skipping any oracle whose `last_seen` is within the
/// retry window (currently 30 days). After the window elapses the
/// card cycles back into the work list — recent printings get a real
/// EDHREC page within a week or two and we want to catch them.
///
/// `WITHOUT ROWID` keyed on `(oracleId, kind)`: the natural unique
/// pair, lookups are point-equality, no need for a separate rowid.
@DataClassName('EdhrecNotFoundRow')
class EdhrecNotFound extends Table {
  TextColumn get oracleId => text()();

  /// `'card'` or `'commander'` — the same axis as `edhrec_pages.kind`.
  /// A given oracle can be 404 on one kind but 200 on the other (a
  /// recently-printed card may have a card page but no commander
  /// page yet, or vice versa).
  TextColumn get kind => text()();

  DateTimeColumn get lastSeen => dateTime()();

  @override
  Set<Column> get primaryKey => {oracleId, kind};

  @override
  bool get withoutRowId => true;
}

/// EDHREC themes attached to a page.
@DataClassName('EdhrecThemeRow')
@TableIndex(name: 'idx_edhrec_theme_pk', columns: {#pageId, #themeSlug}, unique: true)
@TableIndex(name: 'idx_edhrec_theme_page', columns: {#pageId})
@TableIndex(name: 'idx_edhrec_theme_slug', columns: {#themeSlug})
class EdhrecThemes extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// FK → edhrec_pages.id.
  IntColumn get pageId => integer()();

  TextColumn get themeSlug => text()();
  TextColumn get themeName => text()();

  IntColumn get totalDecks => integer().nullable()();
  IntColumn get inclusionCount => integer().nullable()();
  RealColumn get rankInTheme => real().nullable()();
  RealColumn get synergyScore => real().nullable()();
}

/// EDHREC tag links — lighter than themes, keyed by slug.
@DataClassName('EdhrecTagLinkRow')
@TableIndex(name: 'idx_edhrec_taglink_pk', columns: {#pageId, #slug}, unique: true)
@TableIndex(name: 'idx_edhrec_taglink_page', columns: {#pageId})
@TableIndex(name: 'idx_edhrec_taglink_slug', columns: {#slug})
class EdhrecTagLinks extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// FK → edhrec_pages.id.
  IntColumn get pageId => integer()();

  TextColumn get slug => text()();
  TextColumn get name => text()();
  IntColumn get count => integer().withDefault(const Constant(0))();
}
