import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/features/favorites/data/data_sources/drift_favorites_dao.dart';
import 'package:places_surf/features/favorites/domain/repositories/i_favorite_places_repository.dart';

class FavoritePlacesRepository implements IFavoritePlacesRepository {
  final DriftFavoritesDAO driftFavoritesDAO;

  FavoritePlacesRepository(this.driftFavoritesDAO);

  @override
  Future<void> addFavorite(Place place) {
    return driftFavoritesDAO.savePlace(place);
  }

  @override
  Future<List<Place>> getFavoritePlaces() {
    return driftFavoritesDAO.getAllPlaces();
  }

  @override
  Future<void> removeFavorite(int id) {
    return driftFavoritesDAO.deletePlace(id);
  }

  @override
  Stream<List<int>> watchFavoriteIds() {
    return driftFavoritesDAO.watchPlacesIds();
  }

  @override
  Stream<List<Place>> watchFavoritePlaces() {
    return driftFavoritesDAO.watchPlaces();
  }

  @override
  Future<void> toggleFavorite(Place place) async {
    final p = await driftFavoritesDAO.getPlaceById(place.id);

    if (p != null) {
      removeFavorite(place.id);
      return;
    }
    addFavorite(place);
  }
}
