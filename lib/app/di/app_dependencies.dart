import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:places_surf/common/data/repositories/places_repository.dart';
import 'package:places_surf/common/domain/repositories/i_places_repository.dart';
import 'package:places_surf/features/favorites/data/api/local_places_database.dart';
import 'package:places_surf/features/favorites/data/data_sources/drift_favorites_dao.dart';
import 'package:places_surf/features/favorites/data/repositories/favorite_places_repository.dart';
import 'package:places_surf/features/favorites/domain/repositories/i_favorite_places_repository.dart';
import 'package:places_surf/features/places/data/api/rest_client.dart';

final getIt = GetIt.instance;

Future<void> setupDI() async {
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

  getIt.registerLazySingleton<IPlacesRepository>(
    () => PlacesRepository(getIt<RestClient>(), getIt<DriftFavoritesDAO>()),
  );

  getIt.registerLazySingleton<IFavoritePlacesRepository>(
    () => FavoritePlacesRepository(getIt<DriftFavoritesDAO>()),
  );
}
