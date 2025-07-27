part of 'places_bloc.dart';

@immutable
sealed class PlacesEvent {}

class FetchPlacesEvent extends PlacesEvent {}

class SearchQueryChanged extends PlacesEvent {
  final SearchPlaceQuery query;

  SearchQueryChanged(this.query);
}

class _SearchResultsReceived extends PlacesEvent {
  final List<Place> places;

  _SearchResultsReceived(this.places);
}
