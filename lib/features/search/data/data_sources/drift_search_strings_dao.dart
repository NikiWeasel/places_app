import 'package:drift/drift.dart';
import 'package:places_surf/common/data/api_db/local_places_database.dart';
import 'package:places_surf/features/search/domain/services/i_search_strings_service.dart';

class DriftSearchStringsDAO implements ISearchStringsService {
  final LocalPlacesDatabase _db;

  DriftSearchStringsDAO(this._db);

  @override
  Future<void> addExSearchString(String search, {int limit = 5}) async {
    await _db.transaction(() async {
      await _db
          .into(_db.exSearchQueriesTable)
          .insert(
            ExSearchQueriesTableCompanion(searchString: Value(search)),
            mode: InsertMode.insertOrIgnore,
          );

      await _enforceSearchStringLimit(limit);
    });
  }

  Future<void> _enforceSearchStringLimit(int limit) async {
    final countExp = _db.exSearchQueriesTable.id.count();
    final countRes =
        await (_db.selectOnly(_db.exSearchQueriesTable)
          ..addColumns([countExp])).getSingle();
    final totalCount = countRes.read(countExp)!;

    if (totalCount <= limit) return;

    final toDeleteCount = totalCount - limit;

    final query = _db.select(_db.exSearchQueriesTable);
    query.orderBy([(t) => OrderingTerm(expression: t.id)]);
    query.limit(toDeleteCount);

    final oldEntries = await query.get();

    for (final entry in oldEntries) {
      await (_db.delete(_db.exSearchQueriesTable)
        ..where((t) => t.id.equals(entry.id))).go();
    }
  }

  @override
  Future<void> clearExSearchString() async {
    await _db.delete(_db.exSearchQueriesTable).go();
  }

  @override
  Future<void> deleteExSearchString(String search) async {
    await (_db.delete(_db.exSearchQueriesTable)
      ..where((tbl) => tbl.searchString.equals(search))).go();
  }

  @override
  Future<List<String>> getExSearchStrings() async {
    final rows = await _db.select(_db.exSearchQueriesTable).get();
    return rows.map((row) => row.searchString).toList();
  }
}
