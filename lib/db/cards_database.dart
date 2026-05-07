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
  int get schemaVersion => 5;

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
        },
      );

  /// Open a Drift DB backed by a real file on disk (CI writes here
  /// before gzipping).
  static CardsDatabase file(File file) =>
      CardsDatabase(NativeDatabase(file));

  /// In-memory database — useful for tests.
  static CardsDatabase memory() => CardsDatabase(NativeDatabase.memory());
}
