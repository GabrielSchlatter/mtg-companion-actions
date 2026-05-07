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
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async => m.createAll(),
      );

  /// Open a Drift DB backed by a real file on disk (CI writes here
  /// before gzipping).
  static CardsDatabase file(File file) =>
      CardsDatabase(NativeDatabase(file));

  /// In-memory database — useful for tests.
  static CardsDatabase memory() => CardsDatabase(NativeDatabase.memory());
}
