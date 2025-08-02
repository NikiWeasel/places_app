part of 'categories_bloc.dart';

@immutable
sealed class CategoriesEvent {}

class FilterPlaces extends CategoriesEvent {
  final List<Place> places;
  final List<PlaceType> placeTypes;
  final RangeValues rangeValues;

  FilterPlaces({
    required this.places,
    required this.rangeValues,
    required this.placeTypes,
  });
}

class ResetFilters extends CategoriesEvent {}
