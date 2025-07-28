import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:places_surf/features/favorites/data/dto/place_images.dart';
import 'package:places_surf/features/favorites/data/dto/place_table.dart';

part 'local_places_database.g.dart';

@DriftDatabase(tables: [PlaceTable, PlaceImages])
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
