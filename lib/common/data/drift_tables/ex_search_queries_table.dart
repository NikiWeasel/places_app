import 'package:drift/drift.dart';

class ExSearchQueriesTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get searchString => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {searchString},
  ];
}
