import 'package:places_surf/common/domain/entities/place.dart';

abstract interface class ILocalPlacesDatabaseService {
  Future<void> savePlace(Place place);

  Future<void> deletePlace(int placeId);

  Future<List<Place>> getAllPlaces();

  Future<Place?> getPlaceById(int id);

  // Для PlacesBloc
  Stream<List<Place>> watchPlaces();

  // Для FavoritePlacesBloc
  Stream<List<int>> watchPlacesIds();
}
