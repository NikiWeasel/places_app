part of 'places_bloc.dart';

@immutable
sealed class PlacesEvent {}

class FetchPlacesEvent extends PlacesEvent {}

class ResetPlacesEvent extends PlacesEvent {}

class SearchQueryChanged extends PlacesEvent {
  final SearchPlaceQuery query;

  SearchQueryChanged(this.query);
}

class _SearchResultsReceived extends PlacesEvent {
  final List<Place> places;

  _SearchResultsReceived(this.places);
}

class ToggleFavoritePlace extends PlacesEvent {
  final Place place;

  ToggleFavoritePlace({required this.place});
}

class SetFilteredPlaces extends PlacesEvent {
  final List<Place> places;

  SetFilteredPlaces({required this.places});
}
