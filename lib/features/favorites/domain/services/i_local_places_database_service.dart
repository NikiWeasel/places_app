import 'package:places_surf/common/domain/entities/place.dart';

abstract interface class ILocalPlacesDatabaseService {
  Future<void> savePlace(Place place);

  Future<void> deletePlace(int placeId);

  Future<List<Place>> getAllPlaces();

  Future<List<Place>> getFavoritePlaces();

  Future<Place?> getPlaceById(int id);

  // Для PlacesBloc
  Stream<List<Place>> watchFavoritePlaces();

  // Для FavoritePlacesBloc
  Stream<List<int>> watchFavoritePlacesIds();

  Future<void> updatePlace(Place place);

  Future<void> savePlaces(List<Place> places);
}
