part of 'favorite_places_bloc.dart';

@immutable
sealed class FavoritePlacesEvent {}

class FetchFavoritePlacesEvent extends FavoritePlacesEvent {}

class RemoveFavoritePlacesEvent extends FavoritePlacesEvent {
  final Place place;

  RemoveFavoritePlacesEvent({required this.place});
}

class StartFavoritePlacesWatch extends FavoritePlacesEvent {}
