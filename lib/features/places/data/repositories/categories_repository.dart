import 'package:flutter/src/material/slider_theme.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/features/map/domain/services/i_geolocation_service.dart';
import 'package:places_surf/features/places/domain/repositories/i_categories_repository.dart';
import 'package:yandex_maps_mapkit/src/mapkit/geometry/point.dart';

class CategoriesRepository implements ICategoriesRepository {
  final IGeolocationService geolocationService;

  CategoriesRepository(this.geolocationService);

  @override
  Future<List<Place>> filterPlaces(
    List<Place> places,
    List<PlaceType> placeTypes,
    RangeValues rangeValues,
  ) async {
    final currentPosition = await geolocationService.getCurrentPosition();
    final filteredPlaces =
        places.where((place) {
          final distance = geolocationService.measureDistance(
            currentPosition,
            Point(latitude: place.lat, longitude: place.lng),
          );
          final bool isInRange =
              rangeValues.start <= distance && distance <= rangeValues.end;

          if (placeTypes.contains(place.type) && isInRange) {
            return true;
          } else {
            return false;
          }
        }).toList();

    // print('filteredPlaces');
    // print(filteredPlaces);
    return filteredPlaces;
  }
}
