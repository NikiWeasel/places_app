import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:places_surf/common/data/repositories/places_repository.dart';
import 'package:places_surf/common/domain/repositories/i_places_repository.dart';
import 'package:places_surf/features/favorites/data/api/local_places_database.dart';
import 'package:places_surf/features/favorites/data/data_sources/drift_favorites_dao.dart';
import 'package:places_surf/features/favorites/data/repositories/saved_places_repository.dart';
import 'package:places_surf/features/favorites/domain/repositories/i_saved_places_repository.dart';
import 'package:places_surf/features/map/data/repositories/map_repository.dart';
import 'package:places_surf/features/map/data/services/geolocation_service.dart';
import 'package:places_surf/features/map/data/services/map_service.dart';
import 'package:places_surf/features/map/domain/repositories/i_map_repository.dart';
import 'package:places_surf/features/map/domain/services/i_geolocation_service.dart';
import 'package:places_surf/features/places/data/api/rest_client.dart';
import 'package:places_surf/features/places/data/repositories/categories_repository.dart';
import 'package:places_surf/features/places/domain/repositories/i_categories_repository.dart';
import 'package:places_surf/test_mocks/geolocation_service_mock.dart';

final getIt = GetIt.instance;

Future<void> setupDI({required bool useMocks}) async {
  // Dio
  getIt.registerLazySingleton<Dio>(
    () => Dio(
      BaseOptions(
        baseUrl: 'http://109.73.206.134:8888',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    ),
  );

  // Drift
  getIt.registerLazySingleton(() => LocalPlacesDatabase());

  // Retrofit
  getIt.registerLazySingleton<RestClient>(() => RestClient(getIt<Dio>()));

  getIt.registerLazySingleton<DriftFavoritesDAO>(
    () =>
        DriftFavoritesDAO(db: getIt<LocalPlacesDatabase>(), dio: getIt<Dio>()),
  );

  if (useMocks) {
    getIt.registerLazySingleton<IGeolocationService>(
      () => GeolocationServiceMock(),
    );
  } else {
    getIt.registerLazySingleton<IGeolocationService>(
      () => GeolocationService(),
    );
  }

  getIt.registerLazySingleton<MapService>(() => MapService(null));

  //repositories

  getIt.registerLazySingleton<IPlacesRepository>(
    () => PlacesRepository(getIt<RestClient>(), getIt<DriftFavoritesDAO>()),
  );

  getIt.registerLazySingleton<ISavedPlacesRepository>(
    () => SavedPlacesRepository(getIt<DriftFavoritesDAO>()),
  );

  getIt.registerLazySingleton<IMapRepository>(
    () => MapRepository(getIt<IGeolocationService>(), getIt<MapService>()),
  );

  getIt.registerLazySingleton<ICategoriesRepository>(
    () => CategoriesRepository(getIt<IGeolocationService>()),
  );
}
