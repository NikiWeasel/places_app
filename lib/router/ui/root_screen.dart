import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:places_surf/assets/images/app_svg_icons.dart';
import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/router/app_router.gr.dart';
import 'package:places_surf/uikit/images/svg_picture_widget.dart';
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
          showSelectedLabels: false,
          showUnselectedLabels: false,
          fixedColor: colorTheme.textPrimary,
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          items: [
            BottomNavigationBarItem(
              icon: SvgPictureWidget(AppSvgIcons.icList),
              activeIcon: SvgPictureWidget(AppSvgIcons.icListFull),
              label: AppStrings.placesScreenBottomNavPlaces,
            ),
            BottomNavigationBarItem(
              icon: SvgPictureWidget(AppSvgIcons.icMap),
              activeIcon: SvgPictureWidget(AppSvgIcons.icMapFull),
              label: AppStrings.placesScreenBottomNavMap,
            ),
            BottomNavigationBarItem(
              icon: SvgPictureWidget(AppSvgIcons.icHeart),
              activeIcon: SvgPictureWidget(AppSvgIcons.icHeartFull),
              label: AppStrings.placesScreenBottomNavFavorites,
            ),
            BottomNavigationBarItem(
              icon: SvgPictureWidget(AppSvgIcons.icSettings),
              activeIcon: SvgPictureWidget(AppSvgIcons.icSettingsFull),
              label: AppStrings.placesScreenBottomNavSettings,
            ),
          ],
        );
      },
    );
  }
}
