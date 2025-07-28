import 'package:drift/drift.dart';

class PlaceTable extends Table {
  IntColumn get id => integer()();

  TextColumn get name => text()();

  RealColumn get lat => real()();

  RealColumn get lng => real()();

  TextColumn get description => text().nullable()();

  // enum → сохраняем как текст
  TextColumn get type => text()(); // Можно использовать enumName
}
