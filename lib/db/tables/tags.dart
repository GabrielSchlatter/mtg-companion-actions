import 'package:drift/drift.dart';

/// Global Scryfall Tagger tag dictionary, deduplicated across all cards.
///
/// We only ship *functional* tags (skip artwork + printing variants) so
/// the data stays attached to oracle cards and applies regardless of the
/// printing the user has. One row per tag, ~thousands of rows total.
///
/// IDs are Scryfall's tag identifiers (relay-encoded global IDs from the
/// GraphQL endpoint, stored as TEXT).
@DataClassName('TagRow')
@TableIndex(name: 'idx_tag_id', columns: {#tagId}, unique: true)
@TableIndex(name: 'idx_tag_slug', columns: {#slug})
@TableIndex(name: 'idx_tag_name', columns: {#name})
class Tags extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Scryfall tag id (e.g. `VGFnLTEyMzQ=`).
  TextColumn get tagId => text()();
  TextColumn get slug => text()();
  TextColumn get name => text()();

  /// Scryfall classifies its own tags into kinds — we keep the value but
  /// only ingest functional tags.
  TextColumn get type => text()();

  /// Scryfall's tag-level `category` field (a free-text string like
  /// "removal", "ramp"). Distinct from the [isRootCategory] flag below.
  TextColumn get category => text().nullable()();

  /// Scryfall's `category` boolean — true when the tag itself is a
  /// top-level category (used to distinguish "removal" from "doom blade").
  BoolColumn get isRootCategory =>
      boolean().withDefault(const Constant(false))();

  TextColumn get description => text().nullable()();
}

/// Tag ancestry DAG. Each row is an edge `(tag → ancestor)` with depth.
/// Scryfall's tag tree is shallow but multi-rooted — a tag can have
/// multiple category ancestors. Storing the full transitive closure
/// makes "is X under category Y?" a single indexed lookup.
@DataClassName('TagAncestorRow')
@TableIndex(name: 'idx_tag_ancestor_pk', columns: {#tagId, #ancestorId}, unique: true)
@TableIndex(name: 'idx_tag_ancestor_id', columns: {#ancestorId})
class TagAncestors extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// FK → tags.tagId (the descendant).
  TextColumn get tagId => text()();

  /// FK → tags.tagId (the ancestor).
  TextColumn get ancestorId => text()();

  /// 1 = immediate parent, 2 = grandparent, …
  IntColumn get depth => integer()();

  /// True if the ancestor's `category` boolean is set — i.e. the ancestor
  /// is itself a top-level category. Lets queries pick the most general
  /// category candidate without re-joining `tags`.
  BoolColumn get isCategoryAncestor =>
      boolean().withDefault(const Constant(false))();
}

/// Card → tag link, keyed by oracle_id so functional tags apply to every
/// printing of a card. Skipping artwork/printing-variant tags lets us
/// crawl just one printing per oracle, dramatically cutting the Tagger
/// crawl size (~30k canonical printings vs 100k+ total).
@DataClassName('CardTagRow')
@TableIndex(name: 'idx_card_tag_pk', columns: {#oracleId, #tagId}, unique: true)
@TableIndex(name: 'idx_card_tag_oracle_id', columns: {#oracleId})
@TableIndex(name: 'idx_card_tag_tag_id', columns: {#tagId})
class CardTags extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// FK → cards.oracleId.
  TextColumn get oracleId => text()();

  /// FK → tags.tagId.
  TextColumn get tagId => text()();
}

/// Per-oracle Tagger crawl status. One row per oracle_id we've ever
/// successfully fetched from Tagger; the timestamp drives the refresh
/// cycle. The crawler picks oracles where this row is missing OR
/// `last_crawled_at` is older than the staleness window. A failed
/// re-fetch is a no-op — the row + the corresponding `card_tags` rows
/// are only touched after a successful parse.
@DataClassName('TaggerCrawlStatusRow')
@TableIndex(name: 'idx_tagger_status_oracle', columns: {#oracleId}, unique: true)
@TableIndex(name: 'idx_tagger_status_last_crawled', columns: {#lastCrawledAt})
class TaggerCrawlStatus extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// FK → cards.oracleId.
  TextColumn get oracleId => text()();

  /// When the crawler last successfully wrote tags for this oracle.
  DateTimeColumn get lastCrawledAt => dateTime()();
}

/// Card-to-card relationships surfaced by Tagger ("better than",
/// "combos with", …). Resolved to oracle_ids at build time; rows where
/// either side fails to resolve get NULL on that side and keep the raw
/// name for graceful degradation.
@DataClassName('CardRelationshipRow')
@TableIndex(name: 'idx_card_rel_relationship_id', columns: {#relationshipId}, unique: true)
@TableIndex(name: 'idx_card_rel_subject', columns: {#subjectOracleId})
@TableIndex(name: 'idx_card_rel_related', columns: {#relatedOracleId})
class CardRelationships extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Scryfall's id for the relationship edge.
  TextColumn get relationshipId => text()();

  /// Resolved oracle_id of the subject card. Null when name didn't match.
  TextColumn get subjectOracleId => text().nullable()();

  /// Resolved oracle_id of the related card. Null when name didn't match.
  TextColumn get relatedOracleId => text().nullable()();

  /// Raw subject card name from Tagger — preserved as fallback.
  TextColumn get subjectName => text()();

  /// Raw related card name from Tagger.
  TextColumn get relatedName => text()();

  /// e.g. "BetterThan", "CombosWith".
  TextColumn get classifier => text().nullable()();

  /// Inverse direction's classifier.
  TextColumn get classifierInverse => text().nullable()();

  TextColumn get annotation => text().nullable()();
}
