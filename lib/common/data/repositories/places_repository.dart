import 'package:places_surf/common/data/dto/search/query/search_place_query_dto.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/common/domain/entities/search_place_query.dart';
import 'package:places_surf/common/domain/repositories/i_places_repository.dart';
import 'package:places_surf/features/favorites/data/data_sources/drift_favorites_dao.dart';
import 'package:places_surf/features/places/data/api/rest_client.dart';

class PlacesRepository implements IPlacesRepository {
  final RestClient _restClient;
  final DriftFavoritesDAO _driftFavoritesDAO;

  PlacesRepository(this._restClient, this._driftFavoritesDAO);

  @override
  Future<Place> getPlaceById(int id) async {
    final placeDTO = await _restClient.getPlaceById(id);
    final place = await _driftFavoritesDAO.getPlaceById(id);
    bool isFavorite = false;
    if (place != null && place.id == id) isFavorite = true;

    return placeDTO.toEntity(isFavorite);
  }

  @override
  Future<List<Place>> getPlaces() async {
    final placesDTO = await _restClient.getPlaces();
    final localPlaces = await _driftFavoritesDAO.getFavoritePlaces();

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
  Future<List<Place>> getPlacesBySearch(SearchPlaceQuery searchPlace) async {
    final searchPlaceDTO = SearchPlaceQueryDTO.fromEntity(searchPlace);
    final localPlaces = await _driftFavoritesDAO.getAllPlaces();

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
  Future<List<Place>> getFavoritePlaces() async {
    final places = await getPlaces();
    var favPlaces = places.where((element) => element.isFavorite).toList();
    print(favPlaces);
    return favPlaces;
  }
}
