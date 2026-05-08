/// Maps MTGJSON card JSON objects into the flat field shape the app's Drift
/// `cards` table expects.
///
/// **MIRRORED** from
///   flutter_mtg_app/lib/services/mtgjson_sync_service.dart
/// — `_mapMtgjsonCard` and friends. Anything fixed here must be ported back
/// to the app (and vice versa) so mobile and web stay byte-identical.
///
/// Flutter dependencies (path_provider, drift, etc.) are not imported. The
/// only stdlib dependencies are dart:convert.

import 'dart:convert';

/// Single-side multi-face layouts (split, room, adventure, etc.) — both
/// halves render on one physical front, so `side: "b"` should still pull
/// the front image. Mirrored from `Card.singleSideLayouts`.
const Set<String> singleSideLayouts = {
  'split', 'flip', 'adventure', 'aftermath', 'room', 'case', 'prototype',
};

/// Map a MTGJSON card object to our flat CardEntity map.
/// Returns null if the card has no scryfallId (uninstantiable).
Map<String, dynamic>? mapMtgjsonCard(
  Map<String, dynamic> c,
  String setName,
  String setType,
  String releaseDate,
  String lang, {
  Map<String, Map<String, dynamic>>? uuidMap,
}) {
  try {
    final ids = c['identifiers'] as Map<String, dynamic>? ?? {};
    final scryfallId = ids['scryfallId'] as String?;
    if (scryfallId == null || scryfallId.isEmpty) return null;

    final legalities = c['legalities'] as Map<String, dynamic>? ?? {};
    final colors = toStringList(c['colors']);
    final colorIdentity = toStringList(c['colorIdentity']);
    final finishes = toStringList(c['finishes']);

    return {
      'scryfallId': scryfallId,
      // Transient build-time only — used by build_bundle.dart to look
      // up prices by MTGJSON UUID, not stored in the bundle.
      'mtgjsonUuid': c['uuid'] as String?,
      'oracleId': ids['scryfallOracleId'] as String? ?? '',
      'name': c['name'] as String? ?? '',
      'flavorName': c['flavorName'] as String?,
      'lang': lang,
      'releasedAt': releaseDate,
      'layout': c['layout'] as String? ?? 'normal',
      'manaCost': c['manaCost'] as String?,
      'cmc': (c['manaValue'] as num?)?.toDouble() ?? 0.0,
      'typeLine': c['type'] as String? ?? '',
      'oracleText': c['text'] as String?,
      'flavorText': c['flavorText'] as String?,
      'power': c['power'] as String?,
      'toughness': c['toughness'] as String?,
      'colors': colors,
      'colorIdentity': colorIdentity,
      'keywords': toStringList(c['keywords']),
      'colorsString': computeColorString(colors),
      'colorIdentityString': computeColorString(colorIdentity),
      'legalInAnyFormat': computeLegalInAnyFormat(legalities),
      'setCode': (c['setCode'] as String? ?? '').toLowerCase(),
      'setName': setName,
      'setType': setType,
      'collectorNumber': c['number'] as String? ?? '',
      'digital': c['isOnlineOnly'] as bool? ?? false,
      'rarity': c['rarity'] as String? ?? 'common',
      'rarityOrder': computeRarityOrder(c['rarity'] as String? ?? 'common'),
      'powerNumeric': parseNumericStat(c['power'] as String?),
      'toughnessNumeric': parseNumericStat(c['toughness'] as String?),
      'artist': c['artist'] as String?,
      'borderColor': c['borderColor'] as String? ?? 'black',
      'frame': c['frameVersion'] as String? ?? '2015',
      'fullArt': c['isFullArt'] as bool? ?? false,
      'textless': c['isTextless'] as bool? ?? false,
      'booster': (c['boosterTypes'] as List?)?.isNotEmpty == true,
      'storySpotlight': c['isStorySpotlight'] as bool? ?? false,
      'legalStandard': normLegal(legalities['standard']),
      'legalFuture': normLegal(legalities['future']),
      'legalHistoric': normLegal(legalities['historic']),
      'legalGladiator': normLegal(legalities['gladiator']),
      'legalPioneer': normLegal(legalities['pioneer']),
      'legalExplorer':
          legalities['explorer'] != null ? normLegal(legalities['explorer']) : null,
      'legalModern': normLegal(legalities['modern']),
      'legalLegacy': normLegal(legalities['legacy']),
      'legalPauper': normLegal(legalities['pauper']),
      'legalVintage': normLegal(legalities['vintage']),
      'legalPenny': normLegal(legalities['penny']),
      'legalCommander': normLegal(legalities['commander']),
      'legalOathbreaker': normLegal(legalities['oathbreaker']),
      'legalBrawl': normLegal(legalities['brawl']),
      'legalHistoricbrawl': legalities['historicbrawl'] != null
          ? normLegal(legalities['historicbrawl'])
          : null,
      'legalAlchemy': normLegal(legalities['alchemy']),
      'legalPaupercommander': normLegal(legalities['paupercommander']),
      'legalDuel': normLegal(legalities['duel']),
      'legalOldschool': normLegal(legalities['oldschool']),
      'legalPremodern': normLegal(legalities['premodern']),
      'legalPredh': normLegal(legalities['predh']),
      'canBeCommander': () {
        final ls = c['leadershipSkills'];
        if (ls is Map<String, dynamic>) {
          return ls['commander'] as bool? ?? false;
        }
        return false;
      }(),
      'priceUsd': null,
      'priceUsdFoil': null,
      'priceUsdEtched': null,
      'priceEur': null,
      'priceEurFoil': null,
      'priceTix': null,
      'priceNumeric': null,
      'cardFacesJson': buildCardFacesJson(c, uuidMap: uuidMap),
      'rulingsJson': buildRulingsJson(c['rulings']),
      'oversized': c['isOversized'] as bool? ?? false,
      'promo': c['isPromo'] as bool? ?? false,
      'reprint': c['isReprint'] as bool? ?? false,
      'variation': c['isAlternative'] as bool? ?? false,
      'reserved': c['isReserved'] as bool? ?? false,
      'foil': finishes.contains('foil') || finishes.contains('etched'),
      'nonfoil': finishes.contains('nonfoil'),
      'producedMana': toStringList(c['producedMana']),
      'edhrecRank': c['edhrecRank'] as int?,
      'isGameChanger': c['isGameChanger'] as bool?,
    };
  } catch (_) {
    return null;
  }
}

String scryfallImageUrl(String scryfallId, String size, {String face = 'front'}) {
  if (scryfallId.length < 2) return '';
  final a = scryfallId[0];
  final b = scryfallId[1];
  return 'https://cards.scryfall.io/$size/$face/$a/$b/$scryfallId.jpg';
}

String? buildRulingsJson(dynamic rulings) {
  if (rulings == null || rulings is! List || rulings.isEmpty) return null;
  try {
    final list = rulings.map<Map<String, String>>((r) {
      final m = r as Map<String, dynamic>;
      return {
        'date': m['date']?.toString() ?? '',
        'text': m['text']?.toString() ?? '',
      };
    }).toList();
    return jsonEncode(list);
  } catch (_) {
    return null;
  }
}

String? buildCardFacesJson(
  Map<String, dynamic> card, {
  Map<String, Map<String, dynamic>>? uuidMap,
}) {
  final faceName = card['faceName'] as String?;
  if (faceName == null) return null;

  final ids = card['identifiers'] as Map<String, dynamic>? ?? {};
  final scryfallId = ids['scryfallId'] as String?;
  final side = card['side'] as String? ?? 'a';

  final thisFace = _buildSingleFace(card, faceName, scryfallId, side);

  Map<String, dynamic>? otherFace;
  final otherFaceIds = card['otherFaceIds'] as List<dynamic>?;
  if (otherFaceIds != null && uuidMap != null) {
    for (final otherId in otherFaceIds) {
      final otherCard = uuidMap[otherId as String];
      if (otherCard != null) {
        final otherFaceName =
            otherCard['faceName'] as String? ?? otherCard['name'] as String? ?? '';
        final otherSide = otherCard['side'] as String? ?? 'b';
        otherFace =
            _buildSingleFace(otherCard, otherFaceName, scryfallId, otherSide);
        break;
      }
    }
  }

  if (otherFace == null) {
    final nameParts = (card['name'] as String? ?? '').split(' // ');
    if (nameParts.length > 1 && scryfallId != null && scryfallId.length >= 2) {
      final otherName =
          side == 'a' ? nameParts.last.trim() : nameParts.first.trim();
      final otherSideFace = side == 'a' ? 'back' : 'front';
      otherFace = {
        'object': 'card_face',
        'name': otherName,
        'mana_cost': '',
        'type_line': '',
        'oracle_text': '',
        'image_uris': scryfallFaceImageUris(scryfallId, otherSideFace),
      };
    }
  }

  final faces = <Map<String, dynamic>>[];
  if (side == 'a') {
    faces.add(thisFace);
    if (otherFace != null) faces.add(otherFace);
  } else {
    if (otherFace != null) faces.add(otherFace);
    faces.add(thisFace);
  }

  return jsonEncode(faces);
}

Map<String, dynamic> _buildSingleFace(
  Map<String, dynamic> card,
  String faceName,
  String? scryfallId,
  String side,
) {
  final imgFace = side == 'b' ? 'back' : 'front';
  final face = <String, dynamic>{
    'object': 'card_face',
    'name': faceName,
    'mana_cost': card['manaCost'] as String? ?? '',
    'type_line': card['type'] as String? ?? '',
    'oracle_text': card['text'] as String? ?? '',
    'power': card['power'] as String?,
    'toughness': card['toughness'] as String?,
    'artist': card['artist'] as String?,
  };
  if (scryfallId != null && scryfallId.length >= 2) {
    face['image_uris'] = scryfallFaceImageUris(scryfallId, imgFace);
  }
  return face;
}

Map<String, String> scryfallFaceImageUris(String scryfallId, String face) {
  final a = scryfallId[0];
  final b = scryfallId[1];
  const base = 'https://cards.scryfall.io';
  return {
    'small': '$base/small/$face/$a/$b/$scryfallId.jpg',
    'normal': '$base/normal/$face/$a/$b/$scryfallId.jpg',
    'large': '$base/large/$face/$a/$b/$scryfallId.jpg',
    'art_crop': '$base/art_crop/$face/$a/$b/$scryfallId.jpg',
    'border_crop': '$base/border_crop/$face/$a/$b/$scryfallId.jpg',
  };
}

int? parseInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}

List<String> toStringList(dynamic value) {
  if (value == null) return [];
  if (value is List) return value.map((e) => e.toString()).toList();
  return [];
}

String computeColorString(List<String> colors) {
  const order = ['W', 'U', 'B', 'R', 'G'];
  final sorted = colors.where((c) => order.contains(c)).toList()
    ..sort((a, b) => order.indexOf(a).compareTo(order.indexOf(b)));
  return sorted.join();
}

String normLegal(dynamic value) {
  if (value == null) return 'not_legal';
  final s = (value as String).toLowerCase();
  return s.isEmpty ? 'not_legal' : s;
}

bool computeLegalInAnyFormat(Map<String, dynamic> legalities) {
  const legalStatuses = ['legal', 'restricted'];
  return legalities.values.any(
    (status) => legalStatuses.contains((status as String?)?.toLowerCase()),
  );
}

int computeRarityOrder(String rarity) {
  switch (rarity.toLowerCase()) {
    case 'common':
      return 0;
    case 'uncommon':
      return 1;
    case 'rare':
      return 2;
    case 'mythic':
      return 3;
    case 'special':
      return 4;
    case 'bonus':
      return 5;
    default:
      return 0;
  }
}

double? parseNumericStat(String? stat) {
  if (stat == null || stat.isEmpty) return null;
  final parsed = double.tryParse(stat);
  if (parsed != null) return parsed;
  final match = RegExp(r'^(\d+)').firstMatch(stat);
  if (match != null) return double.tryParse(match.group(1)!);
  return null;
}
