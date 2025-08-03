import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:places_surf/common/data/drift_tables/ex_search_queries_table.dart';
import 'package:places_surf/common/data/drift_tables/place_images_table.dart';
import 'package:places_surf/common/data/drift_tables/place_table.dart';

part 'local_places_database.g.dart';

@DriftDatabase(tables: [PlaceTable, PlaceImagesTable, ExSearchQueriesTable])
class LocalPlacesDatabase extends _$LocalPlacesDatabase {
  LocalPlacesDatabase([QueryExecutor? executor])
    : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'local_places_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
