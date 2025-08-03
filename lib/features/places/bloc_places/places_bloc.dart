import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/common/domain/repositories/i_places_repository.dart';
import 'package:places_surf/features/favorites/domain/repositories/i_saved_places_repository.dart';

part 'places_event.dart';
part 'places_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  final IPlacesRepository _placeRepository;
  final ISavedPlacesRepository _savedPlacesRepository;
  List<Place> _places = [];

  PlacesBloc(this._placeRepository, this._savedPlacesRepository)
    : super(PlacesInitial()) {
    on<FetchPlacesEvent>((event, emit) async {
      try {
        emit(LoadingPlacesState());
        _places = await _placeRepository.getPlaces();
        _savedPlacesRepository.savePlaces(_places);
        emit(LoadedPlacesState(places: _places));
      } on DioException catch (e) {
        _places = await _savedPlacesRepository.getSavedPlaces();
        emit(LoadedPlacesState(places: _places));
      } catch (e) {
        print(e.toString());
        emit(ErrorPlacesState(msg: e.toString()));
      }
    });

    //TODO убрать в другой блок наверное
    on<ToggleFavoritePlace>((event, emit) {
      _savedPlacesRepository.toggleFavorite(event.place);
      final newPlaces =
          _places.map((element) {
            if (element.id == event.place.id) {
              return element.copyWith(isFavorite: !element.isFavorite);
            }
            return element;
          }).toList();
      _places = newPlaces;
      emit(LoadedPlacesState(places: _places));
    });

    on<ResetPlacesEvent>((event, emit) async {
      emit(LoadedPlacesState(places: _places));
    });

    on<SetFilteredPlaces>((event, emit) async {
      emit(LoadedPlacesState(places: event.places));
    });
  }
}
