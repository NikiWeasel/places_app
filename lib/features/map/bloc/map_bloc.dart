import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:places_surf/features/map/domain/repositories/i_map_repository.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final IMapRepository _iMapRepository;

  StreamSubscription<Point>? _positionSubscription;

  MapBloc(this._iMapRepository) : super(MapInitial()) {
    on<BuildNewRouteMapEvent>((event, emit) {
      emit(MapLoading());
      final end = event.destination;
      try {
        _iMapRepository.startNewRoute(end);
        emit(MapLoaded(selectedPoint: null));
      } catch (e) {
        emit(MapError(msg: e.toString()));
      }
    });

    on<ToDefaultPointMapEvent>((event, emit) {
      emit(MapLoading());
      try {
        _iMapRepository.toDefaultLocation();
        add(SubscribeToUser());
        emit(MapLoaded(selectedPoint: null));
      } catch (e) {
        emit(MapError(msg: e.toString()));
      }
    });

    on<SubscribeToUser>((event, emit) async {
      // emit(LocationLoadInProgress());

      await _positionSubscription?.cancel();

      _positionSubscription = _iMapRepository.positionStream().listen(
        (point) => _iMapRepository.buildUserIcon(point),
      );

      emit(MapLoading());
      try {
        _iMapRepository.toDefaultLocation();
        emit(MapLoaded(selectedPoint: null));
      } catch (e) {
        emit(MapError(msg: e.toString()));
      }
    });

    on<BuildPointsMapEvent>((event, emit) {
      emit(MapLoading());
      try {
        _iMapRepository.buildNewPOIs(event.points, (point) {
          // print('object');
          // print(point);
          add(PlaceSelectedByMap(selectedPoint: point));
        });
        emit(MapLoaded(selectedPoint: null));
      } catch (e) {
        emit(MapError(msg: e.toString()));
      }
    });

    on<PlaceSelectedByMap>((event, emit) {
      emit(MapLoading());
      try {
        // _iMapRepository.toDefaultLocation();
        emit(MapLoaded(selectedPoint: event.selectedPoint));
      } catch (e) {
        emit(MapError(msg: e.toString()));
      }
    });
  }
}
