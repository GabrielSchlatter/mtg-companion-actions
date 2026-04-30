import 'package:drift/drift.dart';

/// Precomputed filter metadata (sets, rarities, keywords, set-info aggregations)
/// for fast filter UI loading. Mirrors the `FilterMetadata` table the client
/// used to populate via `MtgjsonSyncService._computeFilterMetadata`.
///
/// Single-row table keyed by `'card_filters'`. Lives next to [Cards] in the
/// reference-data DB so it ships in the bundle alongside the data it derives
/// from.
@DataClassName('FilterMetadataRow')
@TableIndex(name: 'idx_filter_metadata_key', columns: {#key}, unique: true)
class FilterMetadata extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text()();
  TextColumn get setsJson => text().withDefault(const Constant('[]'))();
  TextColumn get setsMapJson => text().withDefault(const Constant('{}'))();
  TextColumn get raritiesJson => text().withDefault(const Constant('[]'))();
  TextColumn get keywordsJson => text().withDefault(const Constant('[]'))();
  TextColumn get setMetadataJson => text().withDefault(const Constant('[]'))();
  DateTimeColumn get updatedAt => dateTime()();
}
