/// Picks one canonical printing per oracle group (or per name for cards
/// without an oracleId — basic lands, tokens). The chosen printing is the
/// one we surface in collection / deck-builder UI when the user hasn't
/// explicitly picked a specific printing.
///
/// **Two-tier selection model.** A printing first either *qualifies* as
/// a "normal" printing or doesn't. Qualifying printings always rank
/// above non-qualifying ones (so a Secret Lair / Promo / showcase
/// version never beats a regular reprint). Within either group we sort
/// by a sequence of preferences geared toward "modern, common,
/// playable copy".
///
/// **Qualifying** requires ALL of:
///   - legal in at least one format
///   - non-digital (Arena-only / MTGO-only printings excluded)
///   - `setCode` not in the deny-list (Secret Lair, 30th Anniversary,
///     known masterpiece-style sets MTGJSON tags as `expansion`)
///   - `setType` not in the promo/funny/memorabilia/etc. deny-list
///   - `borderColor == 'black'` (rejects borderless / silver / gold)
///   - not `fullArt`
///   - not `textless`
///   - not `promo`
///
/// Among qualifying (and as a fallback among non-qualifying) we prefer:
///   1. Modern frame (`2015` > everything else)
///   2. Higher set-type rank (expansion > core > masters > commander >
///      draft_innovation > else) — most common print runs.
///   3. Has a non-foil printing
///   4. Newest `releasedAt` — modern reprint > 1993 alpha for the
///      "looks like a current Magic card" goal.
///   5. Lowest numeric collector number — pick the standard print run
///      within the chosen set, not a high-number showcase variant.
///
/// Returns the set of `scryfallId`s that should have
/// `is_canonical_printing = TRUE`.
library;

import 'dart:convert';

class _PrintingFacts {
  final String scryfallId;
  final String oracleId;
  final String name;
  final bool legalInAnyFormat;
  final bool digital;
  final bool promo;
  final bool nonfoil;
  final bool fullArt;
  final bool textless;
  final String releasedAt;
  final String setCode;
  final String setType;
  final String frame;
  final String borderColor;
  final String collectorNumber;
  final String colorIdentityJson;
  final String colorIdentityString;

  _PrintingFacts({
    required this.scryfallId,
    required this.oracleId,
    required this.name,
    required this.legalInAnyFormat,
    required this.digital,
    required this.promo,
    required this.nonfoil,
    required this.fullArt,
    required this.textless,
    required this.releasedAt,
    required this.setCode,
    required this.setType,
    required this.frame,
    required this.borderColor,
    required this.collectorNumber,
    required this.colorIdentityJson,
    required this.colorIdentityString,
  });
}

/// Result of [computeCanonicalPrintings].
class CanonicalPrintingsResult {
  /// scryfallIds that should have `is_canonical_printing = TRUE`.
  final Set<String> canonicalIds;

  /// `scryfallId → fixed colorIdentityString` for rows where the value
  /// stored on the row didn't match the recomputed one. Usually empty
  /// when the mapper produced correct values upstream.
  final Map<String, String> colorIdentityStringFixes;

  CanonicalPrintingsResult({
    required this.canonicalIds,
    required this.colorIdentityStringFixes,
  });
}

/// Set codes hard-banned regardless of `setType`. MTGJSON tags Secret
/// Lair as `setType: expansion`, so the set-type filter alone doesn't
/// catch it. Similarly, 30th Anniversary Edition is a fancy reprint
/// product MTGJSON treats as a normal expansion.
const _denySetCodes = <String>{
  'sld', // Secret Lair Drop
  '30a', // 30th Anniversary Edition
};

/// Set types that represent "fancy" or non-tournament-legal print runs
/// — promo decks, From the Vault, Mystery Booster, etc. Anything in
/// here disqualifies the printing from the "normal" tier.
const _denySetTypes = <String>{
  'promo',
  'funny',
  'memorabilia',
  'from_the_vault',
  'spellbook',
  'premium_deck',
  'duel_deck',
  'treasure_chest',
  'starter',
  'box',
  'masterpiece',
  'token',
  'minigame',
  'vanguard',
  'planechase',
  'archenemy',
  'arsenal',
};

/// Set types that produce the most-recognizable "main set" reprints.
/// Higher = more preferred *as a tiebreaker* among already-qualifying
/// printings; this is independent of the [_denySetTypes] hard filter.
int _setTypePreferenceRank(String setType) {
  switch (setType) {
    case 'expansion':
      return 5;
    case 'core':
      return 4;
    case 'masters':
      return 3;
    case 'commander':
      return 2;
    case 'draft_innovation':
      return 1;
    default:
      return 0;
  }
}

/// Frame era preference. The 2015 modern frame is what current Magic
/// cards look like; everything older looks dated next to it.
int _framePreferenceRank(String frame) {
  switch (frame) {
    case '2015':
      return 2;
    case 'future':
      return 1;
    default:
      return 0;
  }
}

/// Numeric portion of a collector number (`"123★"`, `"42a"`, `"265"`
/// → 123 / 42 / 265). Returns a large sentinel for unparseable values
/// so showcase-only "S1" / "GR9" entries don't beat real numbers.
int _collectorNumberRank(String cn) {
  final match = RegExp(r'^\d+').firstMatch(cn);
  if (match == null) return 1 << 30;
  return int.tryParse(match.group(0)!) ?? (1 << 30);
}

bool _qualifies(_PrintingFacts p) {
  if (!p.legalInAnyFormat) return false;
  if (p.digital) return false;
  if (_denySetCodes.contains(p.setCode)) return false;
  if (_denySetTypes.contains(p.setType)) return false;
  if (p.borderColor != 'black') return false;
  if (p.fullArt) return false;
  if (p.textless) return false;
  if (p.promo) return false;
  return true;
}

CanonicalPrintingsResult computeCanonicalPrintings(
  Iterable<Map<String, dynamic>> mappedCards,
) {
  final printings = <_PrintingFacts>[];
  for (final m in mappedCards) {
    printings.add(_PrintingFacts(
      scryfallId: m['scryfallId'] as String? ?? '',
      oracleId: m['oracleId'] as String? ?? '',
      name: m['name'] as String? ?? '',
      legalInAnyFormat: m['legalInAnyFormat'] as bool? ?? false,
      digital: m['digital'] as bool? ?? false,
      promo: m['promo'] as bool? ?? false,
      nonfoil: m['nonfoil'] as bool? ?? false,
      fullArt: m['fullArt'] as bool? ?? false,
      textless: m['textless'] as bool? ?? false,
      releasedAt: m['releasedAt'] as String? ?? '',
      setCode: (m['setCode'] as String? ?? '').toLowerCase(),
      setType: m['setType'] as String? ?? '',
      frame: m['frame'] as String? ?? '',
      borderColor: m['borderColor'] as String? ?? 'black',
      collectorNumber: m['collectorNumber'] as String? ?? '',
      colorIdentityJson: _jsonOrEmpty(m['colorIdentity']),
      colorIdentityString: m['colorIdentityString'] as String? ?? '',
    ));
  }

  final oracleGroups = <String, List<_PrintingFacts>>{};
  final nameGroups = <String, List<_PrintingFacts>>{};
  for (final p in printings) {
    if (p.oracleId.isNotEmpty) {
      oracleGroups.putIfAbsent(p.oracleId, () => []).add(p);
    } else {
      nameGroups.putIfAbsent(p.name.toLowerCase(), () => []).add(p);
    }
  }

  final canonicalIds = <String>{};
  final colorIdentityFixes = <String, String>{};

  for (final group in [...oracleGroups.values, ...nameGroups.values]) {
    group.sort((a, b) {
      // Tier 1: qualifying printings beat non-qualifying. If a card
      // has at least one normal printing, that printing wins regardless
      // of date / collector number.
      final aQ = _qualifies(a);
      final bQ = _qualifies(b);
      if (aQ != bQ) return aQ ? -1 : 1;

      // Tier 2: among qualifying (or, as fallback, among non-qualifying)
      // sort by preferences geared toward "modern, common, playable".

      // 2a. Modern frame wins.
      final frameCmp = _framePreferenceRank(b.frame)
          .compareTo(_framePreferenceRank(a.frame));
      if (frameCmp != 0) return frameCmp;

      // 2b. Set-type preference (expansion > core > masters > …).
      final typeCmp = _setTypePreferenceRank(b.setType)
          .compareTo(_setTypePreferenceRank(a.setType));
      if (typeCmp != 0) return typeCmp;

      // 2c. Has a non-foil printing.
      if (a.nonfoil != b.nonfoil) return a.nonfoil ? -1 : 1;

      // 2d. Newest releasedAt — modern reprint > 1993 alpha.
      final dateCmp = b.releasedAt.compareTo(a.releasedAt);
      if (dateCmp != 0) return dateCmp;

      // 2e. Lowest collector number — pick the standard-print-run
      //     printing within the chosen set, not a high-number showcase.
      return _collectorNumberRank(a.collectorNumber)
          .compareTo(_collectorNumberRank(b.collectorNumber));
    });
    canonicalIds.add(group.first.scryfallId);
    for (final p in group) {
      final identity = _decodeStringList(p.colorIdentityJson);
      final correct = _wubrgString(identity);
      if (p.colorIdentityString != correct) {
        colorIdentityFixes[p.scryfallId] = correct;
      }
    }
  }

  return CanonicalPrintingsResult(
    canonicalIds: canonicalIds,
    colorIdentityStringFixes: colorIdentityFixes,
  );
}

String _jsonOrEmpty(dynamic v) {
  if (v == null) return '[]';
  if (v is String) return v;
  try {
    return jsonEncode(v);
  } catch (_) {
    return '[]';
  }
}

List<String> _decodeStringList(String json) {
  if (json.isEmpty || json == '[]') return const [];
  try {
    return (jsonDecode(json) as List).cast<String>();
  } catch (_) {
    return const [];
  }
}

const _wubrgOrder = ['W', 'U', 'B', 'R', 'G'];
String _wubrgString(List<String> colors) {
  final present = colors.toSet();
  return _wubrgOrder.where(present.contains).join();
}
