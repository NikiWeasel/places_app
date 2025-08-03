part of 'search_places_bloc.dart';

@immutable
sealed class SearchPlacesState {}

final class SearchPlacesInitial extends SearchPlacesState {}

class LoadingSearchPlacesState extends SearchPlacesState {}

class LoadedSearchPlacesState extends SearchPlacesState {
  final List<Place> places;
  final List<String> sQueries;
  final String currentQuery;

  LoadedSearchPlacesState({
    required this.currentQuery,
    required this.sQueries,
    required this.places,
  });
}

class ErrorSearchPlacesState extends SearchPlacesState {
  final String msg;

  ErrorSearchPlacesState({required this.msg});
}
