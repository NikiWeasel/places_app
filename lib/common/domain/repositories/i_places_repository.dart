import 'package:places_surf/common/domain/entities/place.dart';

abstract interface class IPlacesRepository {
  //TODO возможно стоит убрать Future
  Future<List<Place>> getPlaces();

  Future<List<Place>> getFavoritePlaces();

  Future<Place> getPlaceById(int id);
}
