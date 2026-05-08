/// Stable enum of every EDHREC recommendation category we ship in the
/// bundle. The integer [id] is what gets persisted in
/// `edhrec_recommendations.category` (a 1-byte int per row, vs ~7 bytes
/// of repeated TEXT). The [displayName] is what the UI shows.
///
/// **Keep this in lock-step with the client's
/// `flutter_mtg_app/lib/models/edhrec_category.dart`** — the bundle's
/// schema_version gates compatibility, but the enum mapping itself is
/// only safe if the two sides agree on integer ids.
///
/// Adding a new category: append a new value with the next id (the
/// existing ids are stable). Removing one is a schema bump.
enum EdhrecCategory {
  topCommanders(0, 'Top Commanders'),
  newCommanders(1, 'New Commanders'),
  topCards(2, 'Top Cards'),
  highSynergyCards(3, 'High Synergy Cards'),
  highLiftCards(4, 'High Lift Cards'),
  gameChangers(5, 'Game Changers'),
  newCards(6, 'New Cards'),
  creatures(7, 'Creatures'),
  instants(8, 'Instants'),
  sorceries(9, 'Sorceries'),
  enchantments(10, 'Enchantments'),
  manaArtifacts(11, 'Mana Artifacts'),
  utilityArtifacts(12, 'Utility Artifacts'),
  utilityLands(13, 'Utility Lands'),
  lands(14, 'Lands'),
  planeswalkers(15, 'Planeswalkers'),
  battles(16, 'Battles');

  final int id;
  final String displayName;

  const EdhrecCategory(this.id, this.displayName);

  static EdhrecCategory? fromDisplayName(String? name) {
    if (name == null) return null;
    for (final c in values) {
      if (c.displayName == name) return c;
    }
    return null;
  }

  static EdhrecCategory? fromId(int? id) {
    if (id == null || id < 0 || id >= values.length) return null;
    return values[id];
  }
}
