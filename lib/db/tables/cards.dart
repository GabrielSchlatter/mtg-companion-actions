import 'package:drift/drift.dart';

/// Drift table mirroring the full Scryfall card catalog — replaces
/// ObjectBox `CardEntity`. This is the largest table in the app (~225 MB of
/// card data on a typical English-only sync).
///
/// Indexed fields follow the ObjectBox schema and optimize the search paths
/// in `CardRepository.searchCards`. `List<String>` fields are stored as
/// JSON-encoded TEXT for simplicity.
@DataClassName('CardRow')
@TableIndex(name: 'idx_card_scryfall_id', columns: {#scryfallId}, unique: true)
@TableIndex(name: 'idx_card_mtgjson_uuid', columns: {#mtgjsonUuid})
@TableIndex(name: 'idx_card_oracle_id', columns: {#oracleId})
@TableIndex(name: 'idx_card_name', columns: {#name})
@TableIndex(name: 'idx_card_flavor_name', columns: {#flavorName})
@TableIndex(name: 'idx_card_lang', columns: {#lang})
@TableIndex(name: 'idx_card_type_line', columns: {#typeLine})
@TableIndex(name: 'idx_card_colors_string', columns: {#colorsString})
@TableIndex(name: 'idx_card_color_identity_string', columns: {#colorIdentityString})
@TableIndex(name: 'idx_card_legal_in_any_format', columns: {#legalInAnyFormat})
@TableIndex(name: 'idx_card_is_canonical_printing', columns: {#isCanonicalPrinting})
@TableIndex(name: 'idx_card_set_code', columns: {#setCode})
@TableIndex(name: 'idx_card_rarity', columns: {#rarity})
@TableIndex(name: 'idx_card_price_numeric', columns: {#priceNumeric})
class Cards extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get scryfallId => text()();
  TextColumn get mtgjsonUuid => text().nullable()();
  TextColumn get oracleId => text()();
  TextColumn get name => text()();
  TextColumn get flavorName => text().nullable()();
  TextColumn get lang => text()();

  TextColumn get releasedAt => text()();
  TextColumn get uri => text()();
  TextColumn get scryfallUri => text()();
  TextColumn get layout => text()();

  TextColumn get manaCost => text().nullable()();
  RealColumn get cmc => real()();

  TextColumn get typeLine => text()();
  TextColumn get oracleText => text().nullable()();
  TextColumn get flavorText => text().nullable()();
  TextColumn get power => text().nullable()();
  TextColumn get toughness => text().nullable()();

  /// JSON-encoded `List<String>` — unsorted color letters, e.g. `["R","G"]`.
  TextColumn get colorsJson => text().withDefault(const Constant('[]'))();

  /// JSON-encoded `List<String>` — sorted color identity letters.
  TextColumn get colorIdentityJson =>
      text().withDefault(const Constant('[]'))();

  /// JSON-encoded `List<String>?` — Scryfall keyword list.
  TextColumn get keywordsJson => text().nullable()();

  /// Precomputed: sorted colors as a WUBRG-ordered string (e.g. "WU").
  TextColumn get colorsString => text().withDefault(const Constant(''))();

  /// Precomputed: sorted color identity as a WUBRG-ordered string.
  TextColumn get colorIdentityString =>
      text().withDefault(const Constant(''))();

  BoolColumn get legalInAnyFormat =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isCanonicalPrinting =>
      boolean().withDefault(const Constant(false))();

  TextColumn get setCode => text()();
  TextColumn get setName => text()();
  TextColumn get setType => text()();
  TextColumn get collectorNumber => text()();
  BoolColumn get digital => boolean()();
  TextColumn get rarity => text()();
  IntColumn get rarityOrder => integer().withDefault(const Constant(0))();

  RealColumn get powerNumeric => real().nullable()();
  RealColumn get toughnessNumeric => real().nullable()();

  TextColumn get artist => text().nullable()();
  TextColumn get borderColor => text()();
  TextColumn get frame => text()();
  BoolColumn get fullArt => boolean()();
  BoolColumn get textless => boolean()();
  BoolColumn get booster => boolean()();
  BoolColumn get storySpotlight => boolean()();

  TextColumn get imageStatus => text()();
  TextColumn get imageSmall => text().nullable()();
  TextColumn get imageNormal => text().nullable()();
  TextColumn get imageLarge => text().nullable()();
  TextColumn get imagePng => text().nullable()();
  TextColumn get imageArtCrop => text().nullable()();
  TextColumn get imageBorderCrop => text().nullable()();

  TextColumn get legalStandard => text()();
  TextColumn get legalFuture => text()();
  TextColumn get legalHistoric => text()();
  TextColumn get legalGladiator => text()();
  TextColumn get legalPioneer => text()();
  TextColumn get legalExplorer => text().nullable()();
  TextColumn get legalModern => text()();
  TextColumn get legalLegacy => text()();
  TextColumn get legalPauper => text()();
  TextColumn get legalVintage => text()();
  TextColumn get legalPenny => text()();
  TextColumn get legalCommander => text()();
  TextColumn get legalOathbreaker => text()();
  TextColumn get legalBrawl => text()();
  TextColumn get legalHistoricbrawl => text().nullable()();
  TextColumn get legalAlchemy => text()();
  TextColumn get legalPaupercommander => text()();
  TextColumn get legalDuel => text()();
  TextColumn get legalOldschool => text()();
  TextColumn get legalPremodern => text()();
  TextColumn get legalPredh => text()();

  /// True when this card can BE the commander of a deck — derived from
  /// MTGJSON's `leadershipSkills.commander` boolean, which already
  /// resolves type-line + rules-text patterns ("can be your commander",
  /// Background, Doctor's Companion, Spacecraft commanders, …) into a
  /// single signal. Use this (not `legalCommander`) for any "is this
  /// thing eligible to lead a deck" check; `legalCommander` only means
  /// "allowed in some Commander deck", which is true for ~99% of cards.
  BoolColumn get canBeCommander =>
      boolean().withDefault(const Constant(false))();

  TextColumn get priceUsd => text().nullable()();
  TextColumn get priceUsdFoil => text().nullable()();
  TextColumn get priceUsdEtched => text().nullable()();
  TextColumn get priceEur => text().nullable()();
  TextColumn get priceEurFoil => text().nullable()();
  TextColumn get priceTix => text().nullable()();
  RealColumn get priceNumeric => real().nullable()();

  TextColumn get cardFacesJson => text().nullable()();
  TextColumn get rulingsJson => text().nullable()();

  TextColumn get object => text()();
  BoolColumn get oversized => boolean()();
  BoolColumn get promo => boolean()();
  BoolColumn get reprint => boolean()();
  BoolColumn get variation => boolean()();

  /// JSON-encoded `List<String>`.
  TextColumn get gamesJson => text().withDefault(const Constant('[]'))();

  BoolColumn get reserved => boolean()();
  BoolColumn get foil => boolean()();
  BoolColumn get nonfoil => boolean()();

  /// JSON-encoded `List<String>`.
  TextColumn get finishesJson => text().withDefault(const Constant('[]'))();

  /// JSON-encoded `List<String>`.
  TextColumn get producedManaJson =>
      text().withDefault(const Constant('[]'))();

  IntColumn get edhrecRank => integer().nullable()();
  BoolColumn get isGameChanger => boolean().nullable()();

  /// JSON-encoded `List<String>` — MTGJSON UUIDs of related tokens.
  TextColumn get relatedTokenIdsJson =>
      text().withDefault(const Constant('[]'))();

  IntColumn get mtgoId => integer().nullable()();
  IntColumn get arenaId => integer().nullable()();
  IntColumn get tcgplayerId => integer().nullable()();
  IntColumn get cardmarketId => integer().nullable()();
}
