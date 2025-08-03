import 'package:places_surf/common/data/data_sources/drift_places_dao.dart';
import 'package:places_surf/common/data/dto/search/query/search_place_query_dto.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/common/domain/entities/search_place_query.dart';
import 'package:places_surf/features/places/data/api/rest_client.dart';
import 'package:places_surf/features/search/data/data_sources/drift_search_strings_dao.dart';
import 'package:places_surf/features/search/domain/repositories/i_search_repository.dart';

class SearchRepository implements ISearchRepository {
  final RestClient _restClient;
  final DriftSearchStringsDAO _driftSearchStringsDAO;
  final DriftPlacesDAO _driftPlacesDAO;

  SearchRepository(
    this._restClient,
    this._driftSearchStringsDAO,
    this._driftPlacesDAO,
  );

  @override
  Future<List<Place>> getPlacesBySearch(SearchPlaceQuery searchPlace) async {
    final searchPlaceDTO = SearchPlaceQueryDTO.fromEntity(searchPlace);
    final localPlaces = await _driftPlacesDAO.getAllPlaces();

    final placeSearchResponseDTO = await _restClient.getPlacesBySearch(
      searchPlaceDTO.toJson(),
    );
    final placesDTO = placeSearchResponseDTO.getResultDTOs();
    List<Place> entities =
        placesDTO
            .map(
              (e) => e.toEntity(
                localPlaces.any((localPlace) => localPlace.id == e.id),
              ),
            )
            .toList();

    return entities;
  }

  @override
  Future<void> addExSearchString(String search) async {
    _driftSearchStringsDAO.addExSearchString(search);
  }

  @override
  Future<void> clearExSearchString() async {
    _driftSearchStringsDAO.clearExSearchString();
  }

  @override
  Future<void> deleteExSearchString(String search) async {
    _driftSearchStringsDAO.deleteExSearchString(search);
  }

  @override
  Future<List<String>> getExSearchStrings() async {
    final List<String> list = await _driftSearchStringsDAO.getExSearchStrings();
    return list.reversed.toList();
  }
}
