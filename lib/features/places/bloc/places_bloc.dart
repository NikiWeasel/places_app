import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:places_surf/app/di/app_dependencies.dart';
import 'package:places_surf/common/data/dto/place_dto.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/common/domain/repositories/i_places_repository.dart';

part 'places_event.dart';

part 'places_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  final IPlacesRepository _repository;


  PlacesBloc(this._repository) : super(PlacesInitial()) {
    on<FetchPlacesEvent>((event, emit) async {
      try {
        emit(LoadingPlacesState());
        var places = await _repository.getPlaces();
        emit(LoadedPlacesState(places: places));
      } catch (e) {
        emit(ErrorPlacesState(msg: e.toString()));
      }
    });
  }
}
