import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/common/domain/entities/search_place_query.dart';
import 'package:places_surf/common/domain/repositories/i_places_repository.dart';
import 'package:places_surf/features/favorites/domain/repositories/i_favorite_places_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'places_event.dart';
part 'places_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  final IPlacesRepository _placeRepository;
  final IFavoritePlacesRepository _favoriteRepository;
  final BehaviorSubject<SearchPlaceQuery> _querySubject =
      BehaviorSubject<SearchPlaceQuery>();
  StreamSubscription<List<Place>>? _subscription;
  List<Place> _places = [];

  PlacesBloc(this._placeRepository, this._favoriteRepository)
    : super(PlacesInitial()) {
    _subscription = _querySubject
        .debounceTime(const Duration(milliseconds: 400))
        .distinct()
        .switchMap<List<Place>>(
          (query) =>
              Stream.fromFuture(_placeRepository.getPlacesBySearch(query)),
        )
        .listen((places) {
          add(_SearchResultsReceived(places));
        });

    on<FetchPlacesEvent>((event, emit) async {
      try {
        emit(LoadingPlacesState());
        _places = await _placeRepository.getPlaces();
        emit(LoadedPlacesState(places: _places));
      } catch (e) {
        emit(ErrorPlacesState(msg: e.toString()));
      }
    });

    // Обработка изменений ввода
    on<SearchQueryChanged>((event, emit) {
      _querySubject.add(event.query);
    });

    // Результаты поиска
    on<_SearchResultsReceived>((event, emit) {
      _places = event.places;
      emit(LoadedPlacesState(places: _places));
    });

    on<ToggleFavoritePlace>((event, emit) {
      _favoriteRepository.toggleFavorite(event.place);
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
  }
}
