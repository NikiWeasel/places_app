import 'package:places_surf/common/domain/entities/place.dart';

abstract interface class IFavoritePlacesRepository {
  Future<List<Place>> getFavoritePlaces();

  Future<void> addFavorite(Place place);

  Future<void> removeFavorite(int id);

  Future<void> toggleFavorite(Place place);

  Stream<List<int>> watchFavoriteIds();

  Stream<List<Place>> watchFavoritePlaces();
}
