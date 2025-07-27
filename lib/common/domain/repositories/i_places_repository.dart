import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/common/domain/entities/search_place.dart';

abstract interface class IPlacesRepository {
  //TODO возможно стоит убрать Future
  Future<List<Place>> getPlaces();

  Future<Place> getPlaceById(int id);

  Future<List<Place>> getPlacesBySearch(SearchPlace searchPlace);
}
