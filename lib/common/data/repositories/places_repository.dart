import 'package:places_surf/app/rest_client.dart';
import 'package:places_surf/common/data/dto/place_dto.dart';
import 'package:places_surf/common/data/dto/search_place_dto.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/common/domain/entities/search_place.dart';
import 'package:places_surf/common/domain/repositories/i_places_repository.dart';

class PlacesRepository implements IPlacesRepository {
  final RestClient _restClient;

  PlacesRepository(this._restClient);

  @override
  Future<Place> getPlaceById(int id) async {
    final placeDTO = await _restClient.getPlaceById(id);
    return placeDTO.toEntity();
  }

  @override
  Future<List<Place>> getPlaces() async {
    final placesDTO = await _restClient.getPlaces();
    List<Place> entities = placesDTO.map((e) => e.toEntity()).toList();
    return entities;
  }

  @override
  Future<List<Place>> getPlacesBySearch(SearchPlace searchPlace) async {
    final searchPlaceDTO = SearchPlaceDTO.fromEntity(searchPlace);

    final placesDTO = await _restClient.getPlacesBySearch(
      searchPlaceDTO.toJson(),
    );
    List<Place> entities = placesDTO.map((e) => e.toEntity()).toList();
    return entities;
  }
}
