/// Mirror of `MtgjsonSyncService._computeCanonicalPrintings`.
///
/// Picks one canonical printing per oracle group (or per name for cards
/// without an oracleId — basic lands, tokens). The chosen printing is the
/// one we surface in collection / deck-builder UI when the user hasn't
/// explicitly picked a specific printing.
///
/// Selection rules (in order):
///   1. Has at least one legal format → wins over has-none
///   2. Non-digital → wins over digital-only
///   3. Non-promo → wins over promo
///   4. Has a non-foil printing → wins over foil-only
///   5. Newest releasedAt
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
  final String releasedAt;
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
    required this.releasedAt,
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
      releasedAt: m['releasedAt'] as String? ?? '',
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
      if (a.legalInAnyFormat != b.legalInAnyFormat) {
        return a.legalInAnyFormat ? -1 : 1;
      }
      if (a.digital != b.digital) return a.digital ? 1 : -1;
      if (a.promo != b.promo) return a.promo ? 1 : -1;
      if (a.nonfoil != b.nonfoil) return a.nonfoil ? -1 : 1;
      return b.releasedAt.compareTo(a.releasedAt);
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
