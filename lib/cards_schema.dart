/// SQLite DDL for the `cards` table — must match the Drift schema in
///   flutter_mtg_app/lib/core/database/drift/tables/cards.dart
/// exactly. Drift converts camelCase Dart names to snake_case SQL columns;
/// this file mirrors the resulting SQL shape so the bundle drops straight
/// into the app's IndexedDB-backed Drift on web.
///
/// When the app's Drift schema changes:
///   1. Update [createCardsSql] / [createIndexesSql] / [columnOrder] here.
///   2. Bump [schemaVersion] to match the app's `AppDatabase.schemaVersion`.
///   3. Update the camelCase-to-snake_case overrides if you added a column
///      whose name doesn't follow the obvious rule.
///   4. Regenerate the bundle.

import 'dart:convert';

const int schemaVersion = 10;

const String createCardsSql = '''
CREATE TABLE cards (
  id INTEGER PRIMARY KEY AUTOINCREMENT,

  scryfall_id TEXT NOT NULL,
  mtgjson_uuid TEXT,
  oracle_id TEXT NOT NULL,
  name TEXT NOT NULL,
  flavor_name TEXT,
  lang TEXT NOT NULL,

  released_at TEXT NOT NULL,
  uri TEXT NOT NULL,
  scryfall_uri TEXT NOT NULL,
  layout TEXT NOT NULL,

  mana_cost TEXT,
  cmc REAL NOT NULL,

  type_line TEXT NOT NULL,
  oracle_text TEXT,
  flavor_text TEXT,
  power TEXT,
  toughness TEXT,

  colors_json TEXT NOT NULL DEFAULT '[]',
  color_identity_json TEXT NOT NULL DEFAULT '[]',
  keywords_json TEXT,
  colors_string TEXT NOT NULL DEFAULT '',
  color_identity_string TEXT NOT NULL DEFAULT '',

  legal_in_any_format INTEGER NOT NULL DEFAULT 0,
  is_canonical_printing INTEGER NOT NULL DEFAULT 0,

  set_code TEXT NOT NULL,
  set_name TEXT NOT NULL,
  set_type TEXT NOT NULL,
  collector_number TEXT NOT NULL,
  digital INTEGER NOT NULL,
  rarity TEXT NOT NULL,
  rarity_order INTEGER NOT NULL DEFAULT 0,

  power_numeric REAL,
  toughness_numeric REAL,

  artist TEXT,
  border_color TEXT NOT NULL,
  frame TEXT NOT NULL,
  full_art INTEGER NOT NULL,
  textless INTEGER NOT NULL,
  booster INTEGER NOT NULL,
  story_spotlight INTEGER NOT NULL,

  image_status TEXT NOT NULL,
  image_small TEXT,
  image_normal TEXT,
  image_large TEXT,
  image_png TEXT,
  image_art_crop TEXT,
  image_border_crop TEXT,

  legal_standard TEXT NOT NULL,
  legal_future TEXT NOT NULL,
  legal_historic TEXT NOT NULL,
  legal_gladiator TEXT NOT NULL,
  legal_pioneer TEXT NOT NULL,
  legal_explorer TEXT,
  legal_modern TEXT NOT NULL,
  legal_legacy TEXT NOT NULL,
  legal_pauper TEXT NOT NULL,
  legal_vintage TEXT NOT NULL,
  legal_penny TEXT NOT NULL,
  legal_commander TEXT NOT NULL,
  legal_oathbreaker TEXT NOT NULL,
  legal_brawl TEXT NOT NULL,
  legal_historicbrawl TEXT,
  legal_alchemy TEXT NOT NULL,
  legal_paupercommander TEXT NOT NULL,
  legal_duel TEXT NOT NULL,
  legal_oldschool TEXT NOT NULL,
  legal_premodern TEXT NOT NULL,
  legal_predh TEXT NOT NULL,

  price_usd TEXT,
  price_usd_foil TEXT,
  price_usd_etched TEXT,
  price_eur TEXT,
  price_eur_foil TEXT,
  price_tix TEXT,
  price_numeric REAL,

  card_faces_json TEXT,
  rulings_json TEXT,

  object TEXT NOT NULL,
  oversized INTEGER NOT NULL,
  promo INTEGER NOT NULL,
  reprint INTEGER NOT NULL,
  variation INTEGER NOT NULL,

  games_json TEXT NOT NULL DEFAULT '[]',
  reserved INTEGER NOT NULL,
  foil INTEGER NOT NULL,
  nonfoil INTEGER NOT NULL,
  finishes_json TEXT NOT NULL DEFAULT '[]',
  produced_mana_json TEXT NOT NULL DEFAULT '[]',

  edhrec_rank INTEGER,
  is_game_changer INTEGER,

  related_token_ids_json TEXT NOT NULL DEFAULT '[]',

  mtgo_id INTEGER,
  arena_id INTEGER,
  tcgplayer_id INTEGER,
  cardmarket_id INTEGER
)
''';

const List<String> createIndexesSql = [
  'CREATE UNIQUE INDEX idx_card_scryfall_id ON cards(scryfall_id)',
  'CREATE INDEX idx_card_mtgjson_uuid ON cards(mtgjson_uuid)',
  'CREATE INDEX idx_card_oracle_id ON cards(oracle_id)',
  'CREATE INDEX idx_card_name ON cards(name)',
  'CREATE INDEX idx_card_flavor_name ON cards(flavor_name)',
  'CREATE INDEX idx_card_lang ON cards(lang)',
  'CREATE INDEX idx_card_type_line ON cards(type_line)',
  'CREATE INDEX idx_card_colors_string ON cards(colors_string)',
  'CREATE INDEX idx_card_color_identity_string ON cards(color_identity_string)',
  'CREATE INDEX idx_card_legal_in_any_format ON cards(legal_in_any_format)',
  'CREATE INDEX idx_card_is_canonical_printing ON cards(is_canonical_printing)',
  'CREATE INDEX idx_card_set_code ON cards(set_code)',
  'CREATE INDEX idx_card_rarity ON cards(rarity)',
  'CREATE INDEX idx_card_price_numeric ON cards(price_numeric)',
];

/// Column order for the INSERT statement, in SQL (snake_case) form.
const List<String> columnOrder = [
  'scryfall_id', 'mtgjson_uuid', 'oracle_id', 'name', 'flavor_name', 'lang',
  'released_at', 'uri', 'scryfall_uri', 'layout', 'mana_cost', 'cmc',
  'type_line', 'oracle_text', 'flavor_text', 'power', 'toughness',
  'colors_json', 'color_identity_json', 'keywords_json',
  'colors_string', 'color_identity_string',
  'legal_in_any_format', 'is_canonical_printing',
  'set_code', 'set_name', 'set_type', 'collector_number',
  'digital', 'rarity', 'rarity_order',
  'power_numeric', 'toughness_numeric',
  'artist', 'border_color', 'frame',
  'full_art', 'textless', 'booster', 'story_spotlight',
  'image_status', 'image_small', 'image_normal', 'image_large', 'image_png',
  'image_art_crop', 'image_border_crop',
  'legal_standard', 'legal_future', 'legal_historic', 'legal_gladiator',
  'legal_pioneer', 'legal_explorer', 'legal_modern', 'legal_legacy',
  'legal_pauper', 'legal_vintage', 'legal_penny', 'legal_commander',
  'legal_oathbreaker', 'legal_brawl', 'legal_historicbrawl', 'legal_alchemy',
  'legal_paupercommander', 'legal_duel', 'legal_oldschool', 'legal_premodern',
  'legal_predh',
  'price_usd', 'price_usd_foil', 'price_usd_etched',
  'price_eur', 'price_eur_foil', 'price_tix', 'price_numeric',
  'card_faces_json', 'rulings_json',
  'object', 'oversized', 'promo', 'reprint', 'variation',
  'games_json', 'reserved', 'foil', 'nonfoil',
  'finishes_json', 'produced_mana_json',
  'edhrec_rank', 'is_game_changer',
  'related_token_ids_json',
  'mtgo_id', 'arena_id', 'tcgplayer_id', 'cardmarket_id',
];

/// Override map for snake_case → camelCase translation when the mapper
/// emits a different key than a straight underscore-strip would suggest
/// (mostly the `*Json` suffix on List/Map fields).
const Map<String, String> _snakeToCamelOverride = {
  'colors_json': 'colors',
  'color_identity_json': 'colorIdentity',
  'keywords_json': 'keywords',
  'games_json': 'games',
  'finishes_json': 'finishes',
  'produced_mana_json': 'producedMana',
  'related_token_ids_json': 'relatedTokenIds',
};

String _snakeToCamel(String snake) {
  final override = _snakeToCamelOverride[snake];
  if (override != null) return override;
  final parts = snake.split('_');
  return parts.first +
      parts
          .skip(1)
          .map((p) => p.isEmpty ? '' : p[0].toUpperCase() + p.substring(1))
          .join();
}

final String insertSql = () {
  final cols = columnOrder.join(', ');
  final placeholders = List.filled(columnOrder.length, '?').join(', ');
  return 'INSERT OR IGNORE INTO cards ($cols) VALUES ($placeholders)';
}();

/// Translate one mapper output map into the positional parameters expected
/// by [insertSql]. Booleans → 0/1, Lists/Maps → JSON-encoded text, missing
/// keys → NULL (the schema's NOT NULL DEFAULT clauses will catch the ones
/// that genuinely shouldn't be null).
List<Object?> insertParametersFor(Map<String, dynamic> mapped) {
  return columnOrder.map<Object?>((sqlCol) {
    final camel = _snakeToCamel(sqlCol);
    return _coerce(mapped[camel]);
  }).toList(growable: false);
}

Object? _coerce(Object? v) {
  if (v == null) return null;
  if (v is bool) return v ? 1 : 0;
  if (v is num || v is String) return v;
  // Lists / Maps → JSON-encode. Mapper hands us the decoded form so we
  // round-trip it here to match Drift's *Json TEXT columns.
  try {
    return jsonEncode(v);
  } catch (_) {
    return v is List ? '[]' : 'null';
  }
}
