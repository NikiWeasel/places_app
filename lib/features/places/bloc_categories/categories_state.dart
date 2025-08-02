part of 'categories_bloc.dart';

@immutable
sealed class CategoriesState {}

final class CategoriesInitial extends CategoriesState {}

final class CategoriesLoading extends CategoriesState {}

final class CategoriesSet extends CategoriesState {
  final List<Place>? filteredPlaces;
  final List<PlaceType> placeTypes;
  final RangeValues rangeValues;

  CategoriesSet({
    required this.filteredPlaces,
    required this.placeTypes,
    required this.rangeValues,
  });
}
