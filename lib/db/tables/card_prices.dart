import 'package:drift/drift.dart';

/// Per-source price breakdown, one row per `scryfallId`.
///
/// Mirrors the in-memory map `MtgjsonPriceService` used to build at
/// runtime by joining `AllPricesToday.json.bz2` against the local
/// `cards` table on `mtgjsonUuid`. By baking the result into the
/// bundle we get prices on web (which can't decompress bz2 in-browser)
/// and skip ~minutes of work on every mobile cold start.
///
/// Sources mirror what MTGJSON's AllPricesToday provides:
///   - Cardmarket (EUR retail)
///   - TCGplayer  (USD retail)
///   - Card Kingdom (USD retail + buylist)
///
/// Foil columns are split out from non-foil because some printings are
/// foil-only — the UI falls back to foil prices when retail is missing.
@DataClassName('CardPriceRow')
@TableIndex(name: 'idx_card_price_scryfall_id', columns: {#scryfallId}, unique: true)
class CardPrices extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Bare Scryfall UUID (no language suffix). The bundle builder strips
  /// `_de` / `_fr` etc. before writing so lookups always hit.
  TextColumn get scryfallId => text()();

  RealColumn get cardmarketEur => real().nullable()();
  RealColumn get cardmarketEurFoil => real().nullable()();

  RealColumn get tcgplayerUsd => real().nullable()();
  RealColumn get tcgplayerUsdFoil => real().nullable()();

  RealColumn get cardKingdomUsd => real().nullable()();
  RealColumn get cardKingdomUsdFoil => real().nullable()();
  RealColumn get cardKingdomBuylistUsd => real().nullable()();

  /// MTGJSON price feed date (e.g. `2026-04-30`). Useful for the UI to
  /// show "Prices as of …" without needing a separate manifest read.
  TextColumn get fetchedDate => text()();
}
