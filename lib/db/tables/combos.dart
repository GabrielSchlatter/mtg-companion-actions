import 'package:drift/drift.dart';

/// Commander Spellbook combo definitions, one row per variant.
///
/// Populated weekly by paginating the public `/variants` endpoint. The
/// dataset is small (~30k variants) and the bulk endpoint tolerates a
/// full sweep, so we refetch everything every build instead of crawling
/// incrementally. Replaces the entire table on each refresh.
@DataClassName('ComboRow')
@TableIndex(name: 'idx_combo_combo_id', columns: {#comboId}, unique: true)
@TableIndex(name: 'idx_combo_bracket', columns: {#bracketTag})
class Combos extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Spellbook variant id (string — e.g. `513-5034--46`).
  TextColumn get comboId => text()();

  TextColumn get description => text().nullable()();
  TextColumn get notes => text().nullable()();

  /// Spellbook bracket tag — single letter R/S/P/O/C/E/B. Promoted out
  /// of any blob so deck-bracket aggregations don't need joins/parsing.
  TextColumn get bracketTag => text().nullable()();

  /// Combo color identity letters (e.g. "WUB").
  TextColumn get identity => text().nullable()();

  TextColumn get status => text().nullable()();

  IntColumn get popularity => integer().nullable()();
  IntColumn get manaValueNeeded => integer().nullable()();
  TextColumn get manaNeeded => text().nullable()();

  TextColumn get easyPrerequisites => text().nullable()();
  TextColumn get notablePrerequisites => text().nullable()();

  /// Whole-table replace each build — every row shares the same value.
  DateTimeColumn get lastUpdated => dateTime()();
}

/// Card slots within a combo. One row per (combo, position). Resolved to
/// oracle_id at build time using the combo's own `card.oracleId` — when
/// resolution fails (e.g. a recently-printed card not yet in the cards
/// table), the row keeps the raw name and `oracleId` is NULL.
@DataClassName('ComboCardRow')
@TableIndex(name: 'idx_combo_card_pk', columns: {#comboId, #position}, unique: true)
@TableIndex(name: 'idx_combo_card_oracle', columns: {#oracleId})
@TableIndex(name: 'idx_combo_card_combo', columns: {#comboId})
class ComboCards extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// FK → combos.id.
  IntColumn get comboId => integer()();

  /// 1-based ordering within the combo (mirrors the API's `uses` order).
  IntColumn get position => integer()();

  /// FK → cards.oracleId — null when the card name didn't resolve.
  TextColumn get oracleId => text().nullable()();

  /// Display card name as it came from Spellbook.
  TextColumn get cardName => text()();

  /// Comma-joined zone codes — e.g. "B" or "B,H". B=Battlefield, H=Hand,
  /// G=Graveyard, L=Library, E=Exile, C=Command.
  TextColumn get zoneLocations => text().nullable()();

  IntColumn get quantity => integer().withDefault(const Constant(1))();

  BoolColumn get mustBeCommander =>
      boolean().withDefault(const Constant(false))();

  TextColumn get battlefieldCardState => text().nullable()();
  TextColumn get exileCardState => text().nullable()();
  TextColumn get graveyardCardState => text().nullable()();
  TextColumn get libraryCardState => text().nullable()();
}

/// What a combo "produces" — features in Spellbook's terminology, e.g.
/// "Infinite colorless mana", "Win the game". One row per (combo,
/// feature). `featureId` is Spellbook's numeric id, kept so the same
/// feature can be matched across combos by id rather than by name.
@DataClassName('ComboFeatureRow')
@TableIndex(name: 'idx_combo_feature_pk', columns: {#comboId, #featureName}, unique: true)
@TableIndex(name: 'idx_combo_feature_combo', columns: {#comboId})
@TableIndex(name: 'idx_combo_feature_name', columns: {#featureName})
@TableIndex(name: 'idx_combo_feature_id', columns: {#featureId})
class ComboFeatures extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// FK → combos.id.
  IntColumn get comboId => integer()();

  /// Spellbook's numeric feature id when present.
  IntColumn get featureId => integer().nullable()();

  /// Human-readable feature name.
  TextColumn get featureName => text()();

  IntColumn get quantity => integer().withDefault(const Constant(1))();
}
