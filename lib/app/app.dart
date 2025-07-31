import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places_surf/app/di/app_dependencies.dart';
import 'package:places_surf/common/domain/repositories/i_places_repository.dart';
import 'package:places_surf/features/favorites/bloc/favorite_places_bloc.dart';
import 'package:places_surf/features/favorites/domain/repositories/i_favorite_places_repository.dart';
import 'package:places_surf/features/map/bloc/map_bloc.dart';
import 'package:places_surf/features/map/data/services/map_service.dart';
import 'package:places_surf/features/map/domain/repositories/i_map_repository.dart';
import 'package:places_surf/features/places/bloc/places_bloc.dart';
import 'package:places_surf/router/app_router.dart';
import 'package:places_surf/uikit/themes/app_theme_data.dart';

class App extends StatelessWidget {
  const App({super.key, required this.appRouter});

  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlacesBloc>(
          create:
              (context) => PlacesBloc(
                getIt<IPlacesRepository>(),
                getIt<IFavoritePlacesRepository>(),
              )..add(FetchPlacesEvent()),
        ),
        BlocProvider<FavoritePlacesBloc>(
          create:
              (context) =>
                  FavoritePlacesBloc(getIt<IFavoritePlacesRepository>())
                    ..add(FetchFavoritePlacesEvent())
                    ..add(StartFavoritePlacesWatch()),
        ),
        BlocProvider<MapBloc>(
          create:
              (context) =>
                  MapBloc(getIt<IMapRepository>(), getIt<MapService>())
                    ..add(ToDefaultPointMapEvent()),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppThemeData.lightTheme,
        routerConfig: appRouter.config(),
      ),
    );
  }
}
