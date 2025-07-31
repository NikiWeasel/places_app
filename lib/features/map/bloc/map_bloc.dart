import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:places_surf/features/map/data/services/map_service.dart';
import 'package:places_surf/features/map/domain/repositories/i_map_repository.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final IMapRepository _iMapRepository;
  final MapService _mapService;

  MapBloc(this._iMapRepository, this._mapService) : super(MapInitial()) {
    on<BuildNewRouteMapEvent>((event, emit) {
      emit(MapLoading());
      final end = event.destination;
      try {
        _iMapRepository.startNewRoute(end);
        emit(MapLoaded());
      } catch (e) {
        emit(MapError(msg: e.toString()));
      }
    });

    on<ToDefaultPointMapEvent>((event, emit) {
      emit(MapLoading());
      try {
        _iMapRepository.toDefaultLocation();
        emit(MapLoaded());
      } catch (e) {
        emit(MapError(msg: e.toString()));
      }
    });
  }
}
