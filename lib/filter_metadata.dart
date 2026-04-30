/// Mirror of `MtgjsonSyncService._computeFilterMetadata`.
///
/// Aggregates the cards corpus into the four lists the filter UI loads at
/// startup: sorted set names + (name → code) map, rarity options, keyword
/// list, and per-set metadata (name/type/release/cardCount). Result is one
/// row in `filter_metadata` keyed by `'card_filters'`.
library;

import 'dart:convert';

class FilterMetadataPayload {
  final String setsJson;
  final String setsMapJson;
  final String raritiesJson;
  final String keywordsJson;
  final String setMetadataJson;

  FilterMetadataPayload({
    required this.setsJson,
    required this.setsMapJson,
    required this.raritiesJson,
    required this.keywordsJson,
    required this.setMetadataJson,
  });
}

FilterMetadataPayload computeFilterMetadata(
  Iterable<Map<String, dynamic>> mappedCards,
) {
  final setsMap = <String, String>{};
  final rarities = <String>{};
  final keywords = <String>{};
  final setAgg = <String, Map<String, dynamic>>{};

  for (final card in mappedCards) {
    final setName = card['setName'] as String? ?? '';
    final setCode = card['setCode'] as String? ?? '';
    final setType = card['setType'] as String? ?? '';
    final releasedAt = card['releasedAt'] as String? ?? '';
    final rarity = card['rarity'] as String? ?? '';

    if (setName.isNotEmpty) setsMap[setName] = setCode;
    if (rarity.isNotEmpty) rarities.add(rarity);

    final raw = card['keywords'];
    if (raw is List) {
      for (final k in raw) {
        if (k is String) keywords.add(k);
      }
    } else if (raw is String && raw.isNotEmpty) {
      try {
        for (final k in (jsonDecode(raw) as List)) {
          if (k is String) keywords.add(k);
        }
      } catch (_) {}
    }

    if (setCode.isNotEmpty) {
      final existing = setAgg[setCode];
      if (existing != null) {
        existing['cardCount'] = (existing['cardCount'] as int) + 1;
      } else {
        setAgg[setCode] = {
          'code': setCode,
          'name': setName,
          'type': setType,
          'releasedAt': releasedAt,
          'cardCount': 1,
        };
      }
    }
  }

  final sortedSetNames = setsMap.keys.toList()..sort();
  final sortedKeywords = keywords.toList()..sort();
  final setMetadataList = setAgg.values.toList()
    ..sort((a, b) =>
        (b['releasedAt'] as String).compareTo(a['releasedAt'] as String));

  return FilterMetadataPayload(
    setsJson: jsonEncode(sortedSetNames),
    setsMapJson: jsonEncode(setsMap),
    raritiesJson: jsonEncode(rarities.toList()),
    keywordsJson: jsonEncode(sortedKeywords),
    setMetadataJson: jsonEncode(setMetadataList),
  );
}
