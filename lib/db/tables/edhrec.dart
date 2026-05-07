import 'package:drift/drift.dart';

/// EDHREC page metadata, one row per (oracle card, kind).
///
/// `kind` distinguishes the regular card page (`/pages/cards/{name}`)
/// from a commander page (`/pages/commanders/{name}`); both produce
/// recommendation lists with different shapes and live at different
/// URLs upstream. Splitting them keeps the lookup deterministic and
/// avoids overwriting one with the other.
@DataClassName('EdhrecPageRow')
@TableIndex(name: 'idx_edhrec_page_pk', columns: {#oracleId, #kind}, unique: true)
@TableIndex(name: 'idx_edhrec_page_oracle', columns: {#oracleId})
@TableIndex(name: 'idx_edhrec_page_kind', columns: {#kind})
class EdhrecPages extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// FK → cards.oracleId. The subject of the page.
  TextColumn get oracleId => text()();

  /// `card` or `commander`.
  TextColumn get kind => text()();

  IntColumn get rank => integer().nullable()();
  IntColumn get numDecks => integer().nullable()();
  TextColumn get url => text().nullable()();

  DateTimeColumn get lastUpdated => dateTime()();
}

/// Recommended-card edges from each EDHREC page. The `oracleId` column
/// is the resolved recommended card (null when name didn't resolve);
/// `cardName` always preserves the raw value.
@DataClassName('EdhrecRecommendationRow')
@TableIndex(name: 'idx_edhrec_rec_pk', columns: {#pageId, #cardName}, unique: true)
@TableIndex(name: 'idx_edhrec_rec_page', columns: {#pageId})
@TableIndex(name: 'idx_edhrec_rec_oracle', columns: {#oracleId})
@TableIndex(name: 'idx_edhrec_rec_category', columns: {#cardCategory})
class EdhrecRecommendations extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// FK → edhrec_pages.id.
  IntColumn get pageId => integer()();

  /// FK → cards.oracleId — null when name didn't resolve.
  TextColumn get oracleId => text().nullable()();

  /// Raw card name from EDHREC.
  TextColumn get cardName => text()();

  /// EDHREC's categorisation of the recommendation — e.g. "high synergy
  /// cards", "top cards", "newcards". Lowercased free text.
  TextColumn get cardCategory => text().nullable()();

  TextColumn get recommendationType => text().nullable()();

  IntColumn get inclusionCount => integer().nullable()();
  RealColumn get inclusionPercent => real().nullable()();
  RealColumn get synergyScore => real().nullable()();
  IntColumn get rankInCategory => integer().nullable()();
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
