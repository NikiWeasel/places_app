part of 'places_bloc.dart';

@immutable
sealed class PlacesEvent {}

class FetchPlacesEvent extends PlacesEvent {}
