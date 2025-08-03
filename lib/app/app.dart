import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places_surf/app/di/app_dependencies.dart';
import 'package:places_surf/common/domain/repositories/i_places_repository.dart';
import 'package:places_surf/features/favorites/bloc/favorite_places_bloc.dart';
import 'package:places_surf/features/favorites/domain/repositories/i_saved_places_repository.dart';
import 'package:places_surf/features/map/bloc/map_bloc.dart';
import 'package:places_surf/features/map/data/services/map_service.dart';
import 'package:places_surf/features/map/domain/repositories/i_map_repository.dart';
import 'package:places_surf/features/places/bloc_categories/categories_bloc.dart';
import 'package:places_surf/features/places/bloc_places/places_bloc.dart';
import 'package:places_surf/features/places/domain/repositories/i_categories_repository.dart';
import 'package:places_surf/features/search/bloc/search_places_bloc.dart';
import 'package:places_surf/features/search/domain/repositories/i_search_repository.dart';
import 'package:places_surf/features/settings/bloc/settings_bloc.dart';
import 'package:places_surf/features/settings/domain/repositories/i_settings_repository.dart';
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
                getIt<ISavedPlacesRepository>(),
              )..add(FetchPlacesEvent()),
        ),
        BlocProvider<FavoritePlacesBloc>(
          create:
              (context) =>
                  FavoritePlacesBloc(
                      getIt<ISavedPlacesRepository>(),
                      getIt<IPlacesRepository>(),
                    )
                    ..add(FetchFavoritePlacesEvent())
                    ..add(StartFavoritePlacesWatch()),
        ),
        BlocProvider<MapBloc>(
          create:
              (context) =>
                  MapBloc(getIt<IMapRepository>(), getIt<MapService>())
                    ..add(ToDefaultPointMapEvent()),
        ),
        BlocProvider<CategoriesBloc>(
          create:
              (context) =>
                  CategoriesBloc(getIt<ICategoriesRepository>())
                    ..add(ResetFilters()),
        ),
        BlocProvider<SearchPlacesBloc>(
          create:
              (context) =>
                  SearchPlacesBloc(getIt<ISearchRepository>())
                    ..add(FetchAllExSearchQuery()),
        ),
        BlocProvider<SettingsBloc>(
          create:
              (context) =>
                  SettingsBloc(getIt<ISettingsRepository>())
                    ..add(FetchSettings()),
        ),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoaded) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              theme:
                  state.settings.isDark
                      ? AppThemeData.darkTheme
                      : AppThemeData.lightTheme,
              routerConfig: appRouter.config(),
            );
          }

          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppThemeData.lightTheme,
            routerConfig: appRouter.config(),
          );
        },
      ),
    );
  }
}
