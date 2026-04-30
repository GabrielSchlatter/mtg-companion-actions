/// Parse MTGJSON's `AllDeckFiles.zip` into rows for the `precon_decks`
/// table. Mirrors the in-isolate logic in `PreconSyncService` on the
/// client side.
///
/// `AllDeckFiles.zip` contains one JSON file per precon deck. Each deck
/// JSON has a top-level `data` envelope with `name`, `code`, `type`,
/// `releaseDate`, and `mainBoard` / `sideBoard` / `commander` card
/// arrays. We project each card to a small `{name, count, scryfallId,
/// uuid}` shape and store those as JSON blobs on the row — same shape
/// the existing `precon_browser_screen` consumes.
library;

import 'dart:convert';

class ParsedPrecon {
  final String name;
  final String setCode;
  final String type;
  final String releaseDate;

  /// Pre-encoded JSON for the matching column.
  final String mainBoardJson;
  final String sideBoardJson;
  final String commandersJson;

  /// Used by the browser tile to pick a hero card image.
  final String? featuredCardScryfallId;

  ParsedPrecon({
    required this.name,
    required this.setCode,
    required this.type,
    required this.releaseDate,
    required this.mainBoardJson,
    required this.sideBoardJson,
    required this.commandersJson,
    required this.featuredCardScryfallId,
  });
}

ParsedPrecon? parsePreconDeckJson(Map<String, dynamic> root) {
  final data =
      (root['data'] as Map<String, dynamic>?) ?? root; // some files unwrap

  final name = data['name'] as String? ?? '';
  if (name.isEmpty) return null;

  final code = (data['code'] as String? ?? '').toLowerCase();
  final type = data['type'] as String? ?? '';
  final releaseDate = data['releaseDate'] as String? ?? '';

  final mainBoard = _projectCardList(data['mainBoard']);
  final sideBoard = _projectCardList(data['sideBoard']);
  final commanders = _projectCardList(data['commander']);

  String? featuredId;
  if (commanders.isNotEmpty) {
    featuredId = commanders.first['scryfallId'] as String?;
  } else if (mainBoard.isNotEmpty) {
    featuredId = mainBoard.first['scryfallId'] as String?;
  }

  return ParsedPrecon(
    name: name,
    setCode: code,
    type: type,
    releaseDate: releaseDate,
    mainBoardJson: jsonEncode(mainBoard),
    sideBoardJson: jsonEncode(sideBoard),
    commandersJson: jsonEncode(commanders),
    featuredCardScryfallId: featuredId,
  );
}

List<Map<String, dynamic>> _projectCardList(dynamic raw) {
  if (raw is! List) return const [];
  return raw.map<Map<String, dynamic>>((card) {
    final c = card as Map<String, dynamic>;
    return {
      'name': c['name'] ?? '',
      'count': c['count'] ?? 1,
      if (c['identifiers'] != null)
        'scryfallId':
            (c['identifiers'] as Map<String, dynamic>)['scryfallId'],
      if (c['uuid'] != null) 'uuid': c['uuid'],
    };
  }).toList();
}
