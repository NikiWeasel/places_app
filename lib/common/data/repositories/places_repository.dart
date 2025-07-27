import 'package:places_surf/app/rest_client.dart';
import 'package:places_surf/common/data/dto/search/query/search_place_query_dto.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/common/domain/entities/search_place_query.dart';
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
  Future<List<Place>> getPlacesBySearch(SearchPlaceQuery searchPlace) async {
    final searchPlaceDTO = SearchPlaceQueryDTO.fromEntity(searchPlace);

    final placeSearchResponseDTO = await _restClient.getPlacesBySearch(
      searchPlaceDTO.toJson(),
    );
    final placesDTO = placeSearchResponseDTO.getResultDTOs();
    List<Place> entities = placesDTO.map((e) => e.toEntity()).toList();

    return entities;
  }
}
