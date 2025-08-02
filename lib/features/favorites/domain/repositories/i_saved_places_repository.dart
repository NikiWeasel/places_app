import 'package:places_surf/common/domain/entities/place.dart';

abstract interface class ISavedPlacesRepository {
  Future<List<Place>> getSavedPlaces();

  Future<List<Place>> getSavedFavoritePlaces();

  Future<void> savePlaces(List<Place> places);

  Future<void> addFavorite(Place place);

  Future<void> removeFavorite(Place place);

  Future<void> toggleFavorite(Place place);

  Stream<List<int>> watchFavoriteIds();

  Stream<List<Place>> watchFavoritePlaces();
}
