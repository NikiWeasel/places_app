import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:places_surf/app/rest_client.dart';
import 'package:places_surf/common/data/repositories/places_repository.dart';
import 'package:places_surf/common/domain/repositories/i_places_repository.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final getIt = GetIt.instance;

Future<void> setupDI() async {
  // SharedPreferences (инициализация async)
  // final prefs = await SharedPreferences.getInstance();
  // getIt.registerSingleton<SharedPreferences>(prefs);

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

  getIt.registerLazySingleton<RestClient>(() => RestClient(getIt<Dio>()));

  getIt.registerLazySingleton<IPlacesRepository>(
    () => PlacesRepository(getIt<RestClient>()),
  );

  // Services
  // getIt.registerLazySingleton<ApiService>(() => ApiService(getIt<Dio>()));
  // getIt.registerLazySingleton<StorageService>(
  //   () => StorageServiceImpl(getIt()),
  // );
  // getIt.registerLazySingleton<AuthService>(() => AuthServiceImpl(getIt()));
  //
  // // BLoC
  // getIt.registerFactory<AuthBloc>(() => AuthBloc(authService: getIt()));
}
