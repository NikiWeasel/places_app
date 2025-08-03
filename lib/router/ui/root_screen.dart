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
        final color =
            Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : colorTheme.icon;

        return BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          // fixedColor: colorTheme.textPrimary,
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          items: [
            BottomNavigationBarItem(
              icon: SvgPictureWidget(AppSvgIcons.icList, color: color),
              activeIcon: SvgPictureWidget(
                AppSvgIcons.icListFull,
                color: color,
              ),
              label: AppStrings.placesScreenBottomNavPlaces,
            ),
            BottomNavigationBarItem(
              icon: SvgPictureWidget(AppSvgIcons.icMap, color: color),
              activeIcon: SvgPictureWidget(AppSvgIcons.icMapFull, color: color),
              label: AppStrings.placesScreenBottomNavMap,
            ),
            BottomNavigationBarItem(
              icon: SvgPictureWidget(AppSvgIcons.icHeart, color: color),
              activeIcon: SvgPictureWidget(
                AppSvgIcons.icHeartFull,
                color: color,
              ),
              label: AppStrings.placesScreenBottomNavFavorites,
            ),
            BottomNavigationBarItem(
              icon: SvgPictureWidget(AppSvgIcons.icSettings, color: color),
              activeIcon: SvgPictureWidget(
                AppSvgIcons.icSettingsFull,
                color: color,
              ),
              label: AppStrings.placesScreenBottomNavSettings,
            ),
          ],
        );
      },
    );
  }
}
