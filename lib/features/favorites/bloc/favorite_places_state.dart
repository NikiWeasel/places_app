part of 'favorite_places_bloc.dart';

@immutable
sealed class FavoritePlacesState {}

final class FavoritePlacesInitial extends FavoritePlacesState {}

final class LoadingFavoritePlacesState extends FavoritePlacesState {}

final class ErrorFavoritePlacesState extends FavoritePlacesState {
  final String msg;

  ErrorFavoritePlacesState({required this.msg});
}

final class LoadedFavoritePlacesState extends FavoritePlacesState {
  final List<Place> places;

  LoadedFavoritePlacesState({required this.places});
}
