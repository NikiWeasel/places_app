import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/features/favorites/data/data_sources/drift_favorites_dao.dart';
import 'package:places_surf/features/favorites/domain/repositories/i_saved_places_repository.dart';

class SavedPlacesRepository implements ISavedPlacesRepository {
  final DriftFavoritesDAO driftFavoritesDAO;

  SavedPlacesRepository(this.driftFavoritesDAO);

  @override
  Future<void> addFavorite(Place place) {
    return driftFavoritesDAO.updatePlace(place.copyWith(isFavorite: true));
  }

  @override
  Future<List<Place>> getSavedPlaces() {
    return driftFavoritesDAO.getAllPlaces();
  }

  @override
  Future<void> removeFavorite(Place place) {
    return driftFavoritesDAO.updatePlace(place.copyWith(isFavorite: false));
  }

  @override
  Stream<List<int>> watchFavoriteIds() {
    return driftFavoritesDAO.watchFavoritePlacesIds();
  }

  @override
  Stream<List<Place>> watchFavoritePlaces() {
    return driftFavoritesDAO.watchFavoritePlaces();
  }

  @override
  Future<void> toggleFavorite(Place place) async {
    final p = await driftFavoritesDAO.getPlaceById(place.id);

    if (p == null) return;
    if (p.isFavorite) {
      removeFavorite(place);
      return;
    }
    addFavorite(place);
  }

  @override
  Future<void> savePlaces(List<Place> places) async {
    await driftFavoritesDAO.savePlaces(places);
  }

  @override
  Future<List<Place>> getSavedFavoritePlaces() {
    return driftFavoritesDAO.getFavoritePlaces();
  }
}
