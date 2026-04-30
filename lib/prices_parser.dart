/// Parse MTGJSON `AllPricesToday.json` (already decompressed from .bz2)
/// into a `scryfallId → CardPriceRecord` map. Mirrors the in-isolate
/// parser in `MtgjsonPriceService._parsePricesIsolate`.
library;

import 'dart:convert';
import 'dart:typed_data';

class CardPriceRecord {
  final double? cardmarketEur;
  final double? cardmarketEurFoil;
  final double? tcgplayerUsd;
  final double? tcgplayerUsdFoil;
  final double? cardKingdomUsd;
  final double? cardKingdomUsdFoil;
  final double? cardKingdomBuylistUsd;

  CardPriceRecord({
    this.cardmarketEur,
    this.cardmarketEurFoil,
    this.tcgplayerUsd,
    this.tcgplayerUsdFoil,
    this.cardKingdomUsd,
    this.cardKingdomUsdFoil,
    this.cardKingdomBuylistUsd,
  });

  /// Best EUR price = cardmarket retail.
  double? get bestEur => cardmarketEur;

  /// Best USD price = cheapest of TCGplayer / Card Kingdom retail.
  double? get bestUsd {
    final tcg = tcgplayerUsd ?? tcgplayerUsdFoil;
    final ck = cardKingdomUsd ?? cardKingdomUsdFoil;
    if (tcg == null) return ck;
    if (ck == null) return tcg;
    return tcg < ck ? tcg : ck;
  }

  /// Single representative price (EUR preferred, USD fallback). Used for
  /// `cards.price_numeric` so DB sort by price works.
  double? get primaryPrice {
    if (cardmarketEur != null) return cardmarketEur;
    if (tcgplayerUsd != null) return tcgplayerUsd;
    if (cardKingdomUsd != null) return cardKingdomUsd;
    if (cardmarketEurFoil != null) return cardmarketEurFoil;
    if (tcgplayerUsdFoil != null) return tcgplayerUsdFoil;
    if (cardKingdomUsdFoil != null) return cardKingdomUsdFoil;
    return null;
  }
}

class PricesParseResult {
  /// MTGJSON's reported price feed date (e.g. `2026-04-30`).
  final String date;

  /// Keyed by mtgjsonUuid so the bundle builder can join against its
  /// in-memory uuid → mapped-card map directly.
  final Map<String, CardPriceRecord> byMtgjsonUuid;

  PricesParseResult({required this.date, required this.byMtgjsonUuid});
}

PricesParseResult parseAllPricesToday(Uint8List jsonBytes) {
  final allData = jsonDecode(utf8.decode(jsonBytes)) as Map<String, dynamic>;
  final meta = allData['meta'] as Map<String, dynamic>? ?? const {};
  final date = meta['date'] as String? ?? 'unknown';
  final data = allData['data'] as Map<String, dynamic>;

  final out = <String, CardPriceRecord>{};
  for (final entry in data.entries) {
    final cardPrices = entry.value as Map<String, dynamic>;
    final paper = cardPrices['paper'] as Map<String, dynamic>?;
    if (paper == null) continue;

    double? cmEur, cmEurFoil, tcgUsd, tcgUsdFoil, ckUsd, ckUsdFoil, ckBuy;

    final cm = paper['cardmarket'] as Map<String, dynamic>?;
    if (cm != null) {
      final retail = cm['retail'] as Map<String, dynamic>?;
      cmEur = _latestPrice(retail?['normal']);
      cmEurFoil = _latestPrice(retail?['foil']);
    }

    final tcg = paper['tcgplayer'] as Map<String, dynamic>?;
    if (tcg != null) {
      final retail = tcg['retail'] as Map<String, dynamic>?;
      tcgUsd = _latestPrice(retail?['normal']);
      tcgUsdFoil = _latestPrice(retail?['foil']);
    }

    final ck = paper['cardkingdom'] as Map<String, dynamic>?;
    if (ck != null) {
      final retail = ck['retail'] as Map<String, dynamic>?;
      ckUsd = _latestPrice(retail?['normal']);
      ckUsdFoil = _latestPrice(retail?['foil']);
      ckBuy = _latestPrice((ck['buylist'] as Map<String, dynamic>?)?['normal']);
    }

    if (cmEur == null &&
        cmEurFoil == null &&
        tcgUsd == null &&
        tcgUsdFoil == null &&
        ckUsd == null &&
        ckUsdFoil == null &&
        ckBuy == null) {
      continue;
    }

    out[entry.key] = CardPriceRecord(
      cardmarketEur: cmEur,
      cardmarketEurFoil: cmEurFoil,
      tcgplayerUsd: tcgUsd,
      tcgplayerUsdFoil: tcgUsdFoil,
      cardKingdomUsd: ckUsd,
      cardKingdomUsdFoil: ckUsdFoil,
      cardKingdomBuylistUsd: ckBuy,
    );
  }

  return PricesParseResult(date: date, byMtgjsonUuid: out);
}

/// Extract the latest price from a `{date: price}` map.
double? _latestPrice(dynamic datePrices) {
  if (datePrices is! Map) return null;
  final map = datePrices.cast<String, dynamic>();
  if (map.isEmpty) return null;
  final latestDate = map.keys.reduce((a, b) => a.compareTo(b) > 0 ? a : b);
  final value = map[latestDate];
  if (value is num && value > 0) return value.toDouble();
  return null;
}
