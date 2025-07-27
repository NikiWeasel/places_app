import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/common/domain/entities/search_place_query.dart';
import 'package:places_surf/common/domain/repositories/i_places_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'places_event.dart';
part 'places_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  final IPlacesRepository _repository;
  final BehaviorSubject<SearchPlaceQuery> _querySubject =
      BehaviorSubject<SearchPlaceQuery>();
  StreamSubscription<List<Place>>? _subscription;

  PlacesBloc(this._repository) : super(PlacesInitial()) {
    _subscription = _querySubject
        .debounceTime(const Duration(milliseconds: 400))
        .distinct()
        .switchMap<List<Place>>(
          (query) => Stream.fromFuture(_repository.getPlacesBySearch(query)),
        )
        .listen((places) {
          add(_SearchResultsReceived(places));
          print('\nLISTENER RESULTS\n');
        });

    on<FetchPlacesEvent>((event, emit) async {
      try {
        emit(LoadingPlacesState());
        var places = await _repository.getPlaces();
        emit(LoadedPlacesState(places: places));
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
      emit(LoadedPlacesState(places: event.places));
    });
  }
}
