import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'tables/card_prices.dart';
import 'tables/cards.dart';
import 'tables/combos.dart';
import 'tables/edhrec.dart';
import 'tables/filter_metadata.dart';
import 'tables/precon_decks.dart';
import 'tables/tags.dart';

part 'cards_database.g.dart';

/// The reference-data Drift database we ship to clients.
///
/// Holds the [Cards] catalog and per-source [CardPrices] — both
/// derived from MTGJSON — plus precomputed insights crawled by the
/// bundle pipeline:
///
///   - Tagger: [Tags] dictionary + [TagAncestors] DAG + [CardTags] join
///     + [CardRelationships] for "combos with"/"better than" edges.
///   - Spellbook combos: [Combos] + [ComboCards] + [ComboFeatures].
///   - EDHREC: [EdhrecPages] (card / commander) + [EdhrecRecommendations]
///     + [EdhrecThemes] + [EdhrecTagLinks].
///
/// All cross-card relations link by `oracle_id` (concept-level) so
/// every printing of a card shares the same insights — no need to
/// duplicate Tagger crawls per art.
///
/// Schema bumps are coordinated with the client; the manifest's
/// `schema_version` field lets the client refuse a mismatched bundle
/// before importing.
@DriftDatabase(
  tables: [
    Cards,
    CardPrices,
    FilterMetadata,
    PreconDecks,
    Tags,
    TagAncestors,
    CardTags,
    CardRelationships,
    TaggerCrawlStatus,
    Combos,
    ComboCards,
    ComboFeatures,
    EdhrecPages,
    EdhrecRecommendations,
    EdhrecThemes,
    EdhrecTagLinks,
  ],
)
class CardsDatabase extends _$CardsDatabase {
  CardsDatabase(super.executor);

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
        // Bundle pipeline preserves data across CI runs to avoid
        // re-crawling EDHREC / Tagger / Spellbook from scratch every
        // build. Migrations are therefore *additive* — never drop
        // crawled rows. The client-side migration is destructive
        // (every table is reference data sourced from the bundle), but
        // here we keep state.
        onUpgrade: (m, from, to) async {
          // v2 → v3: introduced the insights tables. If anyone's still
          // on v2 (unlikely at this point but cheap to handle), create
          // each one — `createTable` no-ops nothing, so guard with the
          // `from < 3` window.
          if (from < 3) {
            await m.createTable(tags);
            await m.createTable(tagAncestors);
            await m.createTable(cardTags);
            await m.createTable(cardRelationships);
            await m.createTable(taggerCrawlStatus);
            await m.createTable(combos);
            await m.createTable(comboCards);
            await m.createTable(comboFeatures);
            await m.createTable(edhrecPages);
            await m.createTable(edhrecRecommendations);
            await m.createTable(edhrecThemes);
            await m.createTable(edhrecTagLinks);
          }
          // v3 → v4: `cards.can_be_commander` (MTGJSON
          // `leadershipSkills.commander`). Default 0 means existing
          // rows get re-flagged correctly the next time MTGJSON sync
          // runs and rewrites the row.
          if (from < 4) {
            await m.database.customStatement(
              'ALTER TABLE cards '
              'ADD COLUMN can_be_commander INTEGER NOT NULL DEFAULT 0',
            );
          }
          // v4 → v5: `edhrec_pages.partner_oracle_id` for partner /
          // friends-forever / doctor-companion / choose-a-background
          // partnership pages. Replaces the unique index keyed on
          // `(oracle_id, kind)` with `(oracle_id, kind,
          // partner_oracle_id)` so multiple partnership rows for the
          // same primary commander coexist. Existing solo rows keep
          // partner_oracle_id = NULL.
          //
          // ⚠ One-shot EDHREC data clear: v5 also broadens the category
          // whitelist (the previous build dropped Creatures / Instants
          // / Sorceries / Enchantments / Lands / Utility Lands /
          // Utility Artifacts and the new build keeps them all). Every
          // existing `edhrec_recommendations` row was written under
          // the old whitelist, and the page rows are still inside the
          // 7-day staleness window — so without this truncation the
          // crawler would skip every existing page and the broader
          // categories would never land. Truncating here forces a
          // full EDHREC re-crawl on the first v5 build while leaving
          // cards / prices / tagger / spellbook untouched.
          if (from < 5) {
            await m.database.customStatement(
              'ALTER TABLE edhrec_pages ADD COLUMN partner_oracle_id TEXT',
            );
            await m.database.customStatement(
              'DROP INDEX IF EXISTS idx_edhrec_page_pk',
            );
            await m.database.customStatement(
              'CREATE UNIQUE INDEX idx_edhrec_page_pk '
              'ON edhrec_pages (oracle_id, kind, partner_oracle_id)',
            );
            await m.database.customStatement(
              'CREATE INDEX IF NOT EXISTS idx_edhrec_page_partner '
              'ON edhrec_pages (partner_oracle_id)',
            );
            // Order matters: child rows first so foreign-key-style
            // references aren't briefly dangling, even though SQLite
            // FKs aren't enforced here. Truncating in a single
            // transaction (the migrator already wraps onUpgrade) keeps
            // the bundle queryable throughout.
            await m.database.customStatement(
              'DELETE FROM edhrec_tag_links',
            );
            await m.database.customStatement('DELETE FROM edhrec_themes');
            await m.database.customStatement(
              'DELETE FROM edhrec_recommendations',
            );
            await m.database.customStatement('DELETE FROM edhrec_pages');
          }
          // v5 → v6: bundle slimming.
          //
          // edhrec_recommendations: drop the AUTOINC `id`, drop dead
          // `recommendation_type`, drop the redundant `(page_id)` and
          // `(card_category)` indexes, and switch to a WITHOUT ROWID
          // table keyed on the natural unique pair `(page_id,
          // card_name)`. SQLite can't ALTER any of these in place, so
          // recreate the table and copy the surviving columns.
          //
          // cards: drop `uri` and `scryfall_uri` (unused at the client).
          if (from < 6) {
            await m.database.customStatement(
              'CREATE TABLE edhrec_recommendations_new ('
              'page_id INTEGER NOT NULL, '
              'card_name TEXT NOT NULL, '
              'oracle_id TEXT, '
              'card_category TEXT, '
              'inclusion_count INTEGER, '
              'inclusion_percent REAL, '
              'synergy_score REAL, '
              'rank_in_category INTEGER, '
              'PRIMARY KEY (page_id, card_name)'
              ') WITHOUT ROWID',
            );
            await m.database.customStatement(
              'INSERT OR IGNORE INTO edhrec_recommendations_new '
              '(page_id, card_name, oracle_id, card_category, '
              ' inclusion_count, inclusion_percent, synergy_score, '
              ' rank_in_category) '
              'SELECT page_id, card_name, oracle_id, card_category, '
              '       inclusion_count, inclusion_percent, synergy_score, '
              '       rank_in_category '
              'FROM edhrec_recommendations',
            );
            await m.database
                .customStatement('DROP TABLE edhrec_recommendations');
            await m.database.customStatement(
              'ALTER TABLE edhrec_recommendations_new '
              'RENAME TO edhrec_recommendations',
            );
            await m.database.customStatement(
              'CREATE INDEX IF NOT EXISTS idx_edhrec_rec_oracle '
              'ON edhrec_recommendations (oracle_id)',
            );
            await m.database
                .customStatement('ALTER TABLE cards DROP COLUMN uri');
            await m.database
                .customStatement('ALTER TABLE cards DROP COLUMN scryfall_uri');
          }
          // v6 → v7: deeper bundle slimming.
          //
          // edhrec_recommendations: drop `card_name` (joined from
          // cards via oracle_id), replace `card_category TEXT` with
          // `category INTEGER` (1-byte enum, see EdhrecCategory),
          // tighten `oracle_id` to NOT NULL, change PK to
          // `(page_id, oracle_id, category)` so a card appearing in
          // multiple categories on the same page produces multiple
          // rows. Rows with NULL oracle_id or unmapped categories
          // are dropped (verified zero in the v6 dataset).
          //
          // cards: drop 31 columns the client only ever assigned to
          // its model and never read (audit captured in tables/cards.dart).
          if (from < 7) {
            await m.database.customStatement(
              'CREATE TABLE edhrec_recommendations_new ('
              'page_id INTEGER NOT NULL, '
              'oracle_id TEXT NOT NULL, '
              'category INTEGER NOT NULL, '
              'inclusion_count INTEGER, '
              'inclusion_percent REAL, '
              'synergy_score REAL, '
              'rank_in_category INTEGER, '
              'PRIMARY KEY (page_id, oracle_id, category)'
              ') WITHOUT ROWID',
            );
            // Map display-name categories → enum int. Rows with NULL
            // oracle_id, NULL/unknown card_category, or duplicate PK
            // are dropped.
            await m.database.customStatement(
              'INSERT OR IGNORE INTO edhrec_recommendations_new '
              '(page_id, oracle_id, category, inclusion_count, '
              ' inclusion_percent, synergy_score, rank_in_category) '
              'SELECT page_id, oracle_id, '
              "  CASE card_category "
              "    WHEN 'Top Commanders' THEN 0 "
              "    WHEN 'New Commanders' THEN 1 "
              "    WHEN 'Top Cards' THEN 2 "
              "    WHEN 'High Synergy Cards' THEN 3 "
              "    WHEN 'High Lift Cards' THEN 4 "
              "    WHEN 'Game Changers' THEN 5 "
              "    WHEN 'New Cards' THEN 6 "
              "    WHEN 'Creatures' THEN 7 "
              "    WHEN 'Instants' THEN 8 "
              "    WHEN 'Sorceries' THEN 9 "
              "    WHEN 'Enchantments' THEN 10 "
              "    WHEN 'Mana Artifacts' THEN 11 "
              "    WHEN 'Utility Artifacts' THEN 12 "
              "    WHEN 'Utility Lands' THEN 13 "
              "    WHEN 'Lands' THEN 14 "
              "    WHEN 'Planeswalkers' THEN 15 "
              "    WHEN 'Battles' THEN 16 "
              '  END AS category, '
              ' inclusion_count, inclusion_percent, synergy_score, '
              ' rank_in_category '
              'FROM edhrec_recommendations '
              'WHERE oracle_id IS NOT NULL '
              '  AND card_category IS NOT NULL '
              '  AND card_category IN ('
              "    'Top Commanders', 'New Commanders', 'Top Cards', "
              "    'High Synergy Cards', 'High Lift Cards', "
              "    'Game Changers', 'New Cards', 'Creatures', "
              "    'Instants', 'Sorceries', 'Enchantments', "
              "    'Mana Artifacts', 'Utility Artifacts', "
              "    'Utility Lands', 'Lands', 'Planeswalkers', "
              "    'Battles')",
            );
            await m.database
                .customStatement('DROP TABLE edhrec_recommendations');
            await m.database.customStatement(
              'ALTER TABLE edhrec_recommendations_new '
              'RENAME TO edhrec_recommendations',
            );
            await m.database.customStatement(
              'CREATE INDEX IF NOT EXISTS idx_edhrec_rec_oracle '
              'ON edhrec_recommendations (oracle_id)',
            );

            // Cards table: drop 17 columns the client never reads.
            // Kept the ones used in raw Drift queries (digital,
            // powerNumeric, toughnessNumeric, legalInAnyFormat,
            // rarityOrder, priceNumeric, flavorName, artist, setType,
            // and all the boolean printing flags).
            const dropCardCols = [
              'mtgjson_uuid',
              'image_status',
              'image_small',
              'image_normal',
              'image_large',
              'image_png',
              'image_art_crop',
              'image_border_crop',
              'object',
              'games_json',
              'finishes_json',
              'related_token_ids_json',
              'mtgo_id',
              'arena_id',
              'tcgplayer_id',
              'cardmarket_id',
            ];
            for (final col in dropCardCols) {
              await m.database
                  .customStatement('ALTER TABLE cards DROP COLUMN $col');
            }
            // Explicit index drop for the only column we removed
            // that had a dedicated index.
            await m.database.customStatement(
                'DROP INDEX IF EXISTS idx_card_mtgjson_uuid');
          }
        },
      );

  /// Open a Drift DB backed by a real file on disk (CI writes here
  /// before gzipping).
  static CardsDatabase file(File file) =>
      CardsDatabase(NativeDatabase(file));

  /// In-memory database — useful for tests.
  static CardsDatabase memory() => CardsDatabase(NativeDatabase.memory());
}
