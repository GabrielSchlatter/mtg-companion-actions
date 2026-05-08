/// Bundle schema version — must match the client `CardsDatabase.schemaVersion`.
///
/// Bumped when the binary cards SQLite shape changes incompatibly: a column
/// added to `cards` / `card_prices` / `filter_metadata`, an index added,
/// etc. Drift opens the file as-is (no migration runs on the client side
/// for the cards DB), so the only safe upgrade path is for the client to
/// download a bundle whose `schema_version` matches its own.
///
/// The client refuses bundles with a mismatched `schema_version` and
/// keeps using whatever cards.sqlite is already on disk until either the
/// bundle catches up or the client is updated.
///
/// Keep aligned with:
///   flutter_mtg_app/lib/core/database/drift/cards_database.dart
const int schemaVersion = 8;
