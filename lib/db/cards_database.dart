import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'tables/card_prices.dart';
import 'tables/cards.dart';
import 'tables/filter_metadata.dart';
import 'tables/precon_decks.dart';

part 'cards_database.g.dart';

/// The reference-data Drift database we ship to clients.
///
/// Holds only the [Cards] catalog and per-source [CardPrices] — both
/// derived from MTGJSON. The schema must match the client-side
/// `CardsDatabase` exactly; clients open the file we produce here as
/// a regular Drift DB without running migrations on the cards.
///
/// Schema bumps are coordinated with the client; the manifest's
/// `schema_version` field lets the client refuse a mismatched bundle
/// before importing.
@DriftDatabase(tables: [Cards, CardPrices, FilterMetadata, PreconDecks])
class CardsDatabase extends _$CardsDatabase {
  CardsDatabase(super.executor);

  @override
  int get schemaVersion => 2;

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
