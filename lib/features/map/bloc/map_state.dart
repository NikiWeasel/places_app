part of 'map_bloc.dart';

@immutable
sealed class MapState {}

final class MapInitial extends MapState {}

final class MapLoading extends MapState {}

final class MapLoaded extends MapState {
  final Point? selectedPoint;

  MapLoaded({required this.selectedPoint});
}

final class MapError extends MapState {
  final String msg;

  MapError({required this.msg});
}
