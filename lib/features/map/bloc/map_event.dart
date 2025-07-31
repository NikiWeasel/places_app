part of 'map_bloc.dart';

@immutable
sealed class MapEvent {}

class BuildNewRouteMapEvent extends MapEvent {
  final Point destination;

  BuildNewRouteMapEvent(this.destination);
}

class ToDefaultPointMapEvent extends MapEvent {}
