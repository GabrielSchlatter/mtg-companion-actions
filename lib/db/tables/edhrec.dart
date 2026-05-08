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
/// `WITHOUT ROWID` keyed on `(pageId, cardName)` — the natural unique
/// pair. Drops the AUTOINC `id` column we never query by, drops the
/// redundant `(pageId)`-only index (the PK leading column already
/// covers single-page lookups), and drops the `(cardCategory)` index
/// that was rarely useful in isolation.
@DataClassName('EdhrecRecommendationRow')
@TableIndex(name: 'idx_edhrec_rec_oracle', columns: {#oracleId})
class EdhrecRecommendations extends Table {
  /// FK → edhrec_pages.id.
  IntColumn get pageId => integer()();

  /// Raw card name from EDHREC.
  TextColumn get cardName => text()();

  /// FK → cards.oracleId — null when name didn't resolve.
  TextColumn get oracleId => text().nullable()();

  /// EDHREC's categorisation of the recommendation — e.g. "Top Cards",
  /// "High Synergy Cards", "Lands". Display-name form.
  TextColumn get cardCategory => text().nullable()();

  IntColumn get inclusionCount => integer().nullable()();
  RealColumn get inclusionPercent => real().nullable()();
  RealColumn get synergyScore => real().nullable()();
  IntColumn get rankInCategory => integer().nullable()();

  @override
  Set<Column> get primaryKey => {pageId, cardName};

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
