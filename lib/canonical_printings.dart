/// Picks one canonical printing per oracle group (or per name for cards
/// without an oracleId — basic lands, tokens). The chosen printing is the
/// one we surface in collection / deck-builder UI when the user hasn't
/// explicitly picked a specific printing.
///
/// Selection rules (applied in order; first decisive comparison wins):
///   1. Has at least one legal format → wins over has-none.
///      (Don't surface unplayable Un-set / Mystery Booster gags as the
///      default printing.)
///   2. Non-digital → wins over digital-only.
///   3. **Oldest `releasedAt`** → first printing wins.
///      (User-facing change: previously "newest". The first printing is
///      the one most players think of and the one most likely to have
///      reasonable secondary-market pricing — newer reprints tend to be
///      special-treatment showcase variants.)
///   4. "Normal" set type → expansion / core / commander / masters /
///      draft_innovation win over promo / funny / from_the_vault /
///      memorabilia / token / etc.
///   5. `borderColor == 'black'` → wins over borderless / silver / gold.
///   6. `fullArt == false` → wins over full-art.
///   7. `promo == false` → wins over promo.
///   8. `nonfoil == true` → wins over foil-only.
///   9. Lowest numeric `collectorNumber` → tiebreaker for the "main"
///      printing within a set (showcases / extended-art usually live
///      above the normal set range, e.g. ≥ 265 for a 264-card set).
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
  final String releasedAt;
  final String setType;
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
    required this.releasedAt,
    required this.setType,
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

/// Set types that represent "real" printings of a card. Anything outside
/// this set (promo, funny, memorabilia, from_the_vault, token, …) is
/// considered second-class for canonical selection.
const _normalSetTypes = {
  'expansion',
  'core',
  'commander',
  'masters',
  'draft_innovation',
};

/// Higher = more preferred. Used so a Beta card beats a From-the-Vault
/// reprint with the same (or older) release date.
int _setTypeRank(String setType) =>
    _normalSetTypes.contains(setType) ? 1 : 0;

/// Numeric portion of a collector number (`"123★"`, `"42a"`, `"265"`
/// → 123 / 42 / 265). Returns a large sentinel for unparseable values
/// so showcase-only "S1" / "GR9" entries don't beat real numbers.
int _collectorNumberRank(String cn) {
  final match = RegExp(r'^\d+').firstMatch(cn);
  if (match == null) return 1 << 30;
  return int.tryParse(match.group(0)!) ?? (1 << 30);
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
      releasedAt: m['releasedAt'] as String? ?? '',
      setType: m['setType'] as String? ?? '',
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
      // 1. Legal-in-any-format wins.
      if (a.legalInAnyFormat != b.legalInAnyFormat) {
        return a.legalInAnyFormat ? -1 : 1;
      }
      // 2. Non-digital wins.
      if (a.digital != b.digital) return a.digital ? 1 : -1;
      // 3. Oldest releasedAt wins. (Was: newest.)
      final dateCmp = a.releasedAt.compareTo(b.releasedAt);
      if (dateCmp != 0) return dateCmp;
      // 4. Normal set type wins over promo/funny/from-the-vault.
      final typeCmp = _setTypeRank(b.setType).compareTo(_setTypeRank(a.setType));
      if (typeCmp != 0) return typeCmp;
      // 5. Black border wins.
      final aBlack = a.borderColor == 'black';
      final bBlack = b.borderColor == 'black';
      if (aBlack != bBlack) return aBlack ? -1 : 1;
      // 6. Non-full-art wins.
      if (a.fullArt != b.fullArt) return a.fullArt ? 1 : -1;
      // 7. Non-promo wins.
      if (a.promo != b.promo) return a.promo ? 1 : -1;
      // 8. Has nonfoil wins.
      if (a.nonfoil != b.nonfoil) return a.nonfoil ? -1 : 1;
      // 9. Lowest collector number wins.
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
