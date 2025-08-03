part of 'search_places_bloc.dart';

@immutable
sealed class SearchPlacesEvent {}

class SearchQueryChanged extends SearchPlacesEvent {
  final SearchPlaceQuery query;

  SearchQueryChanged(this.query);
}

class _SearchResultsReceived extends SearchPlacesEvent {
  final List<Place> places;

  _SearchResultsReceived(this.places);
}

class _AddExSearchQuery extends SearchPlacesEvent {
  final String query;

  _AddExSearchQuery(this.query);
}

class DeleteExSearchQuery extends SearchPlacesEvent {
  final String query;

  DeleteExSearchQuery(this.query);
}

class FetchAllExSearchQuery extends SearchPlacesEvent {}

class CleanAllExSearchQuery extends SearchPlacesEvent {}
