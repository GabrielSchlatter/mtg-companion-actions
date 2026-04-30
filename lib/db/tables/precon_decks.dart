import 'package:drift/drift.dart';

/// Drift table for pre-constructed decks (MTGJSON AllDeckFiles).
/// Replaces the ObjectBox `PreconDeckEntity`.
///
/// The generated row class is `PreconDeckRow` (not `PreconDeck`) so it
/// doesn't collide with the existing `PreconDeck` domain model.
@DataClassName('PreconDeckRow')
@TableIndex(name: 'idx_precon_name', columns: {#name})
@TableIndex(name: 'idx_precon_set_code', columns: {#setCode})
@TableIndex(name: 'idx_precon_type', columns: {#type})
class PreconDecks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get setCode => text()();
  TextColumn get setName => text().withDefault(const Constant(''))();
  TextColumn get type => text()();
  TextColumn get releaseDate => text().withDefault(const Constant(''))();
  TextColumn get mainBoardJson => text().withDefault(const Constant('[]'))();
  TextColumn get sideBoardJson => text().withDefault(const Constant('[]'))();
  TextColumn get commandersJson => text().withDefault(const Constant('[]'))();
  TextColumn get featuredCardScryfallId => text().nullable()();
}
