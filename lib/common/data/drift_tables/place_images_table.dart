import 'package:drift/drift.dart';
import 'package:places_surf/common/data/drift_tables/place_table.dart';

class PlaceImagesTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Внешний ключ
  IntColumn get placeId => integer().references(PlaceTable, #id)();

  BlobColumn get image => blob()();

  TextColumn get sourceUrl => text()();
}
