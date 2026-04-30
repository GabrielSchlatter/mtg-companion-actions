/// Bundle format version. Bumped when the JSON shape of an individual
/// card row in the bundle changes incompatibly (e.g., a new required
/// column is added to the app's Drift `cards` table). The web client
/// compares this to its own Drift `AppDatabase.schemaVersion` and
/// refuses to import a bundle whose number doesn't match.
///
/// Keep aligned with the app's
///   flutter_mtg_app/lib/core/database/drift/app_database.dart
/// `schemaVersion` getter.
const int schemaVersion = 10;
