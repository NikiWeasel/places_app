part of 'map_bloc.dart';

@immutable
sealed class MapEvent {}

class BuildNewRouteMapEvent extends MapEvent {
  final Point destination;

  BuildNewRouteMapEvent(this.destination);
}

class BuildPointsMapEvent extends MapEvent {
  final List<Point> points;

  BuildPointsMapEvent(this.points);
}

class ToDefaultPointMapEvent extends MapEvent {}

class SubscribeToUser extends MapEvent {}

// class LocationUpdated extends MapEvent {}

class PlaceSelectedByMap extends MapEvent {
  final Point selectedPoint;

  PlaceSelectedByMap({required this.selectedPoint});
}
