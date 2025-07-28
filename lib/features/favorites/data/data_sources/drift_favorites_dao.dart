import 'package:dio/dio.dart';
import 'package:drift/drift.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/common/domain/entities/place_images.dart';
import 'package:places_surf/features/favorites/data/api/local_places_database.dart';
import 'package:places_surf/features/favorites/domain/services/i_local_places_database_service.dart';

class DriftFavoritesDAO implements ILocalPlacesDatabaseService {
  final LocalPlacesDatabase _db;
  final Dio _dio;

  DriftFavoritesDAO({required LocalPlacesDatabase db, required Dio dio})
    : _db = db,
      _dio = dio;

  // Должно вызываться только с экрана мест
  @override
  Future<void> savePlace(Place place) async {
    await _db
        .into(_db.placeTable)
        .insert(
          PlaceTableCompanion(
            id: Value(place.id),
            name: Value(place.name),
            lat: Value(place.lat),
            lng: Value(place.lng),
            description: Value(place.description),
            type: Value(place.type.name),
          ),
        );
    final placeId = place.id;

    for (final url in (place.images as ImagesUrls).urls) {
      try {
        final response = await _dio.get<Uint8List>(
          url,
          options: Options(responseType: ResponseType.bytes),
        );

        if (response.statusCode == 200 && response.data != null) {
          await _db
              .into(_db.placeImages)
              .insert(
                PlaceImagesCompanion(
                  placeId: Value(placeId),
                  image: Value(response.data!),
                  sourceUrl: Value(url),
                ),
              );
        }
      } catch (e) {
        print('Ошибка загрузки $url: $e');
      }
    }
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

    final placeRows1 = await _db.select(_db.placeImages).get();
    print(placeRows1);

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
          isFavorite: true,
        ),
      );
    }

    return result;
  }

  // Для PlacesBloc
  @override
  Stream<List<Place>> watchPlaces() {
    // Наблюдаем за таблицей places
    final placesStream = _db.select(_db.placeTable).watch();

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
            isFavorite: true,
          ),
        );
      }

      return placesWithImages;
    });
  }

  // Для FavoritePlacesBloc
  @override
  Stream<List<int>> watchPlacesIds() {
    return _db.select(_db.placeTable).map((place) => place.id).watch();
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
      isFavorite: true,
    );
  }
}
