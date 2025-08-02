import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/common/domain/entities/place_images.dart';
import 'package:places_surf/features/favorites/data/api/local_places_database.dart';
import 'package:places_surf/features/favorites/domain/services/i_local_places_database_service.dart';
import 'package:pool/pool.dart';

class DriftFavoritesDAO implements ILocalPlacesDatabaseService {
  final LocalPlacesDatabase _db;
  final Dio _dio;
  final _pool = Pool(5, timeout: Duration(seconds: 30));

  DriftFavoritesDAO({required LocalPlacesDatabase db, required Dio dio})
    : _db = db,
      _dio = dio;

  @override
  Future<void> savePlace(Place place) async {
    await _db
        .into(_db.placeTable)
        .insert(
          await _placeToCompanion(place),
          mode: InsertMode.insertOrReplace,
        );

    for (final url in (place.images as ImagesUrls).urls) {
      final imageCompanion = await _downloadSingleImage(place.id, url);
      if (imageCompanion != null) {
        try {
          await _db.into(_db.placeImages).insert(imageCompanion);
        } catch (e) {
          print('Ошибка вставки изображения $url: $e');
        }
      }
    }
  }

  Future<PlaceTableCompanion> _placeToCompanion(Place place) async {
    return PlaceTableCompanion(
      id: Value(place.id),
      name: Value(place.name),
      lat: Value(place.lat),
      lng: Value(place.lng),
      description: Value(place.description),
      type: Value(place.type.name),
    );
  }

  @override
  Future<void> deletePlace(int placeId) async {
    await _db.transaction(() async {
      // Удаление связанных изображений
      await (_db.delete(_db.placeImages)
        ..where((tbl) => tbl.placeId.equals(placeId))).go();

      // Удаление самого места
      await (_db.delete(_db.placeTable)
        ..where((tbl) => tbl.id.equals(placeId))).go();
    });
  }

  @override
  Future<List<Place>> getAllPlaces() async {
    // Получаем все записи из таблицы places
    final placeRows = await _db.select(_db.placeTable).get();

    // Для каждой записи подтягиваем связанные изображения
    final List<Place> result = [];

    for (final placeRow in placeRows) {
      final imageRows =
          await (_db.select(_db.placeImages)
            ..where((img) => img.placeId.equals(placeRow.id))).get();

      result.add(
        Place(
          id: placeRow.id,
          name: placeRow.name,
          lat: placeRow.lat,
          lng: placeRow.lng,
          description: placeRow.description ?? '',
          type: PlaceType.values.byName(placeRow.type),
          images: ImagesBytes(imageRows.map((e) => e.image).toList()),
          isFavorite: placeRow.isFavorite,
        ),
      );
    }

    return result;
  }

  @override
  Future<List<Place>> getFavoritePlaces() async {
    final placeRows =
        await (_db.select(_db.placeTable)
          ..where((tbl) => tbl.isFavorite.equals(true))).get();

    final List<Place> result = [];

    for (final placeRow in placeRows) {
      final imageRows =
          await (_db.select(_db.placeImages)
            ..where((img) => img.placeId.equals(placeRow.id))).get();

      result.add(
        Place(
          id: placeRow.id,
          name: placeRow.name,
          lat: placeRow.lat,
          lng: placeRow.lng,
          description: placeRow.description ?? '',
          type: PlaceType.values.byName(placeRow.type),
          images: ImagesBytes(imageRows.map((e) => e.image).toList()),
          isFavorite: placeRow.isFavorite,
        ),
      );
    }

    return result;
  }

  // Для PlacesBloc
  @override
  Stream<List<Place>> watchFavoritePlaces() {
    // Наблюдаем за таблицей places
    final placesStream =
        (_db.select(_db.placeTable)
          ..where((tbl) => tbl.isFavorite.equals(true))).watch();

    // Для каждого обновления получаем связанные изображения
    return placesStream.asyncMap((placeRows) async {
      final List<Place> placesWithImages = [];

      for (final placeRow in placeRows) {
        final imageRows =
            await (_db.select(_db.placeImages)
              ..where((tbl) => tbl.placeId.equals(placeRow.id))).get();

        placesWithImages.add(
          Place(
            id: placeRow.id,
            name: placeRow.name,
            lat: placeRow.lat,
            lng: placeRow.lng,
            description: placeRow.description ?? '',
            type: PlaceType.values.byName(placeRow.type),
            images: ImagesBytes(imageRows.map((e) => e.image).toList()),
            isFavorite: placeRow.isFavorite,
          ),
        );
      }

      return placesWithImages;
    });
  }

  // Для FavoritePlacesBloc
  @override
  Stream<List<int>> watchFavoritePlacesIds() {
    return (_db.select(_db.placeTable)..where(
      (tbl) => tbl.isFavorite.equals(true),
    )).map((place) => place.id).watch();
  }

  @override
  Future<Place?> getPlaceById(int id) async {
    final PlaceTableData? placeRow =
        await (_db.select(_db.placeTable)
          ..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

    if (placeRow == null) return null;

    final imageRows =
        await (_db.select(_db.placeImages)
          ..where((tbl) => tbl.placeId.equals(id))).get();

    return Place(
      id: placeRow.id,
      name: placeRow.name,
      lat: placeRow.lat,
      lng: placeRow.lng,
      description: placeRow.description ?? '',
      type: PlaceType.values.byName(placeRow.type),
      images: ImagesBytes(imageRows.map((e) => e.image).toList()),
      isFavorite: placeRow.isFavorite,
    );
  }

  @override
  Future<void> updatePlace(Place newPlace) async {
    await (_db.update(_db.placeTable)
      ..where((tbl) => tbl.id.equals(newPlace.id))).write(
      PlaceTableCompanion(
        description: Value(newPlace.description),
        isFavorite: Value(newPlace.isFavorite),
        lat: Value(newPlace.lat),
        lng: Value(newPlace.lng),
        name: Value(newPlace.name),
        type: Value(newPlace.type.name),
      ),
    );
  }

  @override
  Future<void> savePlaces(List<Place> places) async {
    final placeCompanions =
        places
            .map(
              (place) => PlaceTableCompanion(
                id: Value(place.id),
                name: Value(place.name),
                lat: Value(place.lat),
                lng: Value(place.lng),
                description: Value(place.description),
                type: Value(place.type.name),
                isFavorite: Value(place.isFavorite),
              ),
            )
            .toList();

    await _db.batch((batch) {
      batch.insertAllOnConflictUpdate(_db.placeTable, placeCompanions);
    });

    List<PlaceImagesCompanion> imagesToInsert = await _downloadAndPrepareImages(
      places,
    );

    if (imagesToInsert.isNotEmpty) {
      await _db.batch((batch) {
        batch.insertAll(
          _db.placeImages,
          imagesToInsert,
          mode: InsertMode.insertOrReplace,
        );
      });
    }
  }

  Future<List<PlaceImagesCompanion>> _downloadAndPrepareImages(
    List<Place> places,
  ) async {
    final List<Future<PlaceImagesCompanion?>> futures = [];

    for (final place in places) {
      final placeId = place.id;

      for (final url in (place.images as ImagesUrls).urls) {
        // Ограничаем параллелизм
        final future = _pool.withResource(
          () => _downloadSingleImage(placeId, url),
        );
        futures.add(future);
      }
    }

    final results = await Future.wait(futures);

    // Отфильтровать неудачные загрузки
    return results.whereType<PlaceImagesCompanion>().toList();
  }

  Future<PlaceImagesCompanion?> _downloadSingleImage(
    int placeId,
    String url, {
    int retries = 2,
  }) async {
    for (var attempt = 0; attempt <= retries; attempt++) {
      try {
        final response = await _dio.get<Uint8List>(
          url,
          options: Options(responseType: ResponseType.bytes),
        );

        if (response.statusCode == 200 && response.data != null) {
          return PlaceImagesCompanion(
            placeId: Value(placeId),
            image: Value(response.data!),
            sourceUrl: Value(url),
          );
        } else {
          print('Неудачный статус ${response.statusCode} при загрузке $url');
        }
      } catch (e) {
        print('Ошибка загрузки $url (попытка $attempt): $e');
      }
    }
    return null;
  }
}
