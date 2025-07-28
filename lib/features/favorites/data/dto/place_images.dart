import 'package:drift/drift.dart';
import 'package:places_surf/features/favorites/data/dto/place_table.dart';

class PlaceImages extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Внешний ключ
  IntColumn get placeId => integer().references(PlaceTable, #id)();

  BlobColumn get image => blob()();

  TextColumn get sourceUrl => text()();
}
