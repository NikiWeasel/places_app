import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/common/domain/repositories/i_places_repository.dart';
import 'package:places_surf/features/favorites/domain/repositories/i_saved_places_repository.dart';

part 'favorite_places_event.dart';
part 'favorite_places_state.dart';

class FavoritePlacesBloc
    extends Bloc<FavoritePlacesEvent, FavoritePlacesState> {
  final ISavedPlacesRepository _savedPlacesRepository;
  final IPlacesRepository _placeRepository;
  List<Place> _places = [];

  StreamSubscription<List<Place>>? _subscription;

  FavoritePlacesBloc(this._savedPlacesRepository, this._placeRepository)
    : super(FavoritePlacesInitial()) {
    on<StartFavoritePlacesWatch>((event, emit) async {
      emit(LoadingFavoritePlacesState());

      await emit.forEach<List<Place>>(
        _savedPlacesRepository.watchFavoritePlaces(),
        onData: (places) {
          _places = List.of(places);
          return LoadedFavoritePlacesState(places: _places);
        },
        onError: (error, _) {
          return ErrorFavoritePlacesState(msg: error.toString());
        },
      );
    });

    on<FetchFavoritePlacesEvent>((event, emit) async {
      try {
        emit(LoadingFavoritePlacesState());
        _places = await _placeRepository.getFavoritePlaces();

        emit(LoadedFavoritePlacesState(places: _places));
      } on DioException catch (e) {
        _places = await _savedPlacesRepository.getSavedFavoritePlaces();
        emit(LoadedFavoritePlacesState(places: _places));
      } catch (e) {
        print(e.toString());
        emit(ErrorFavoritePlacesState(msg: e.toString()));
      }
    });

    on<RemoveFavoritePlacesEvent>((event, emit) async {
      try {
        emit(LoadingFavoritePlacesState());
        final placeToRemove = event.place;
        final index = _places.indexWhere(
          (element) => element.name == placeToRemove.name,
        );
        if (index == -1) throw Exception('Не найден индекс');

        await _savedPlacesRepository.removeFavorite(placeToRemove);

        _places = [..._places]..removeAt(index);

        emit(LoadedFavoritePlacesState(places: _places));
      } catch (e) {
        emit(ErrorFavoritePlacesState(msg: e.toString()));
      }
    });
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
