import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/features/favorites/domain/repositories/i_favorite_places_repository.dart';

part 'favorite_places_event.dart';
part 'favorite_places_state.dart';

class FavoritePlacesBloc
    extends Bloc<FavoritePlacesEvent, FavoritePlacesState> {
  final IFavoritePlacesRepository _favoriteRepository;
  List<Place> _localPlaces = [];

  StreamSubscription<List<Place>>? _subscription;

  FavoritePlacesBloc(this._favoriteRepository)
    : super(FavoritePlacesInitial()) {
    on<StartFavoritePlacesWatch>((event, emit) async {
      emit(LoadingFavoritePlacesState());

      await emit.forEach<List<Place>>(
        _favoriteRepository.watchFavoritePlaces(),
        onData: (places) {
          _localPlaces = List.of(places);
          return LoadedFavoritePlacesState(places: _localPlaces);
        },
        onError: (error, _) {
          return ErrorFavoritePlacesState(msg: error.toString());
        },
      );
    });

    on<FetchFavoritePlacesEvent>((event, emit) async {
      try {
        emit(LoadingFavoritePlacesState());
        _localPlaces = await _favoriteRepository.getFavoritePlaces();
        emit(LoadedFavoritePlacesState(places: _localPlaces));
      } catch (e) {
        emit(ErrorFavoritePlacesState(msg: e.toString()));
      }
    });

    on<RemoveFavoritePlacesEvent>((event, emit) async {
      try {
        emit(LoadingFavoritePlacesState());
        final placeToRemove = event.place;
        final index = _localPlaces.indexWhere(
          (element) => element.name == placeToRemove.name,
        );
        if (index == -1) throw Exception('Не найден индекс');

        await _favoriteRepository.removeFavorite(placeToRemove.id);

        _localPlaces = [..._localPlaces]..removeAt(index);

        emit(LoadedFavoritePlacesState(places: _localPlaces));
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
