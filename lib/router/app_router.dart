import 'package:auto_route/auto_route.dart';
import 'package:places_surf/router/app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    /// Основной, корневой маршрут
    AutoRoute(
      page: RootRoute.page,
      initial: true,
      children: [
        /// Вложенные маршруты
        AutoRoute(page: PlacesRoute.page, initial: true),
        AutoRoute(page: MapRoute.page),
        AutoRoute(page: FavoritesRoute.page),
        AutoRoute(page: SettingsRoute.page),
      ],
    ),
    AutoRoute(page: PlaceDetailsRoute.page),
    AutoRoute(page: FilterRoute.page),
    AutoRoute(page: PhotosRoute.page),
  ];
}
