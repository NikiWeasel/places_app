import 'package:flutter/material.dart';
import 'package:places_surf/common/domain/entities/place.dart';

abstract interface class ICategoriesRepository {
  Future<List<Place>> filterPlaces(
    List<Place> places,
    List<PlaceType> placeType,
    RangeValues rangeValues,
  );
}
