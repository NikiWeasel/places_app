import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/features/places/domain/repositories/i_categories_repository.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {
  final ICategoriesRepository _categoriesRepository;

  CategoriesBloc(this._categoriesRepository) : super(CategoriesInitial()) {
    // List<Place> _places = [];
    List<PlaceType> placeTypes;
    RangeValues rangeValues;

    on<FilterPlaces>((event, emit) async {
      placeTypes = event.placeTypes;
      rangeValues = event.rangeValues;

      final filteredPlaces = await _categoriesRepository.filterPlaces(
        event.places,
        placeTypes,
        rangeValues,
      );
      // _places = newPlaces;
      print(filteredPlaces);
      emit(
        CategoriesSet(
          filteredPlaces: filteredPlaces,
          placeTypes: placeTypes,
          rangeValues: rangeValues,
        ),
      );
    });

    on<ResetFilters>((event, emit) async {
      placeTypes = [];
      rangeValues = const RangeValues(0, 10);
      // emit(CategoriesLoading());
      // await Future.delayed(Duration(milliseconds: 100));
      emit(
        CategoriesSet(
          filteredPlaces: null,
          placeTypes: placeTypes,
          rangeValues: rangeValues,
        ),
      );
    });
  }
}
