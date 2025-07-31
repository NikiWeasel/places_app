import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/router/app_router.gr.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';

@RoutePage()
class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: [
        const PlacesRoute(),
        MapRoute(point: null),
        const FavoritesRoute(),
        const SettingsRoute(),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        final colorTheme = AppColorTheme.of(context);

        return BottomNavigationBar(
          fixedColor: colorTheme.textPrimary,
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list_alt_outlined,
                color: colorTheme.textPrimary,
              ),
              label: AppStrings.placesScreenBottomNavPlaces,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map, color: colorTheme.textPrimary),
              label: AppStrings.placesScreenBottomNavMap,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border, color: colorTheme.textPrimary),
              label: AppStrings.placesScreenBottomNavFavorites,
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.settings_outlined,
                color: colorTheme.textPrimary,
              ),
              label: AppStrings.placesScreenBottomNavSettings,
            ),
          ],
        );
      },
    );
  }
}
