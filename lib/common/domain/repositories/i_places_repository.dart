import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/common/domain/entities/search_place_query.dart';

abstract interface class IPlacesRepository {
  //TODO возможно стоит убрать Future
  Future<List<Place>> getPlaces();

  Future<List<Place>> getFavoritePlaces();

  Future<Place> getPlaceById(int id);

  Future<List<Place>> getPlacesBySearch(SearchPlaceQuery searchPlace);
}
