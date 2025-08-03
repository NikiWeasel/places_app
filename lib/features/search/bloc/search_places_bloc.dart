import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/common/domain/entities/search_place_query.dart';
import 'package:places_surf/features/search/domain/repositories/i_search_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'search_places_event.dart';
part 'search_places_state.dart';

class SearchPlacesBloc extends Bloc<SearchPlacesEvent, SearchPlacesState> {
  final ISearchRepository _searchRepository;

  final BehaviorSubject<SearchPlaceQuery> _querySubject =
      BehaviorSubject<SearchPlaceQuery>();
  StreamSubscription<List<Place>>? _subscription;
  List<Place> _places = [];
  List<String> sQueries = [];
  String currentQuery = '';

  static const int minLength = 3;

  SearchPlacesBloc(this._searchRepository) : super(SearchPlacesInitial()) {
    _subscription = _querySubject
        .debounceTime(const Duration(milliseconds: 500))
        .distinct()
        .switchMap<List<Place>>((query) {
          currentQuery = query.query;
          // print('q');
          // print(currentQuery);
          if (query.query.length < minLength) {
            add(FetchAllExSearchQuery());
            return Stream.empty();
          }
          add(_AddExSearchQuery(query.query));
          return Stream.fromFuture(_searchRepository.getPlacesBySearch(query));
        })
        .listen((places) {
          add(_SearchResultsReceived(places));
        });

    // Обработка изменений ввода
    on<SearchQueryChanged>((event, emit) {
      _querySubject.add(event.query);
    });

    // Результаты поиска
    on<_SearchResultsReceived>((event, emit) {
      emit(LoadingSearchPlacesState());
      _places = event.places;
      emit(
        LoadedSearchPlacesState(
          places: _places,
          sQueries: [],
          currentQuery: currentQuery,
        ),
      );
    });

    on<_AddExSearchQuery>((event, emit) {
      emit(LoadingSearchPlacesState());
      _searchRepository.addExSearchString(event.query);
      emit(
        LoadedSearchPlacesState(
          places: _places,
          sQueries: [],
          currentQuery: currentQuery,
        ),
      );
    });

    on<FetchAllExSearchQuery>((event, emit) async {
      emit(LoadingSearchPlacesState());
      try {
        sQueries = await _searchRepository.getExSearchStrings();

        emit(
          LoadedSearchPlacesState(
            currentQuery: currentQuery,
            sQueries: sQueries,
            places: _places,
          ),
        );
      } catch (e) {
        print(e.toString());
        emit(ErrorSearchPlacesState(msg: e.toString()));
      }
    });

    on<DeleteExSearchQuery>((event, emit) async {
      emit(LoadingSearchPlacesState());
      try {
        await _searchRepository.deleteExSearchString(event.query);
        sQueries = sQueries.where((element) => element != event.query).toList();
        emit(
          LoadedSearchPlacesState(
            currentQuery: currentQuery,
            sQueries: sQueries,
            places: _places,
          ),
        );
      } catch (e) {
        print(e.toString());
        emit(ErrorSearchPlacesState(msg: e.toString()));
      }
    });

    on<CleanAllExSearchQuery>((event, emit) async {
      emit(LoadingSearchPlacesState());
      try {
        await _searchRepository.clearExSearchString();
        sQueries = [];
        emit(
          LoadedSearchPlacesState(
            currentQuery: currentQuery,
            sQueries: sQueries,
            places: _places,
          ),
        );
      } catch (e) {
        print(e.toString());
        emit(ErrorSearchPlacesState(msg: e.toString()));
      }
    });
  }
}
