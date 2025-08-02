part of 'places_bloc.dart';

@immutable
sealed class PlacesState {}

final class PlacesInitial extends PlacesState {}

class LoadingPlacesState extends PlacesState {}

class LoadedPlacesState extends PlacesState {
  final List<Place> places;

  LoadedPlacesState({required this.places});
}

class ErrorPlacesState extends PlacesState {
  final String msg;

  ErrorPlacesState({required this.msg});
}
