// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:flutter/material.dart' as _i11;
import 'package:places_surf/common/domain/entities/place.dart' as _i14;
import 'package:places_surf/common/domain/entities/place_images.dart' as _i13;
import 'package:places_surf/features/favorites/ui/screens/favorites_screen.dart'
    as _i1;
import 'package:places_surf/features/map/ui/screens/map_screen.dart' as _i3;
import 'package:places_surf/features/onboarding/ui/screens/onboarding_screen.dart'
    as _i4;
import 'package:places_surf/features/place_details/ui/screens/photos_screen.dart'
    as _i5;
import 'package:places_surf/features/place_details/ui/screens/place_details_screen.dart'
    as _i6;
import 'package:places_surf/features/places/ui/screens/filter_screen.dart'
    as _i2;
import 'package:places_surf/features/places/ui/screens/places_screen.dart'
    as _i7;
import 'package:places_surf/features/settings/ui/screens/settings_screen.dart'
    as _i9;
import 'package:places_surf/router/ui/root_screen.dart' as _i8;
import 'package:yandex_maps_mapkit/mapkit.dart' as _i12;

/// generated route for
/// [_i1.FavoritesScreen]
class FavoritesRoute extends _i10.PageRouteInfo<void> {
  const FavoritesRoute({List<_i10.PageRouteInfo>? children})
    : super(FavoritesRoute.name, initialChildren: children);

  static const String name = 'FavoritesRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i1.FavoritesScreen();
    },
  );
}

/// generated route for
/// [_i2.FilterScreen]
class FilterRoute extends _i10.PageRouteInfo<void> {
  const FilterRoute({List<_i10.PageRouteInfo>? children})
    : super(FilterRoute.name, initialChildren: children);

  static const String name = 'FilterRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i2.FilterScreen();
    },
  );
}

/// generated route for
/// [_i3.MapScreen]
class MapRoute extends _i10.PageRouteInfo<MapRouteArgs> {
  MapRoute({
    _i11.Key? key,
    required _i12.Point? point,
    List<_i10.PageRouteInfo>? children,
  }) : super(
         MapRoute.name,
         args: MapRouteArgs(key: key, point: point),
         initialChildren: children,
       );

  static const String name = 'MapRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<MapRouteArgs>();
      return _i3.MapScreen(key: args.key, point: args.point);
    },
  );
}

class MapRouteArgs {
  const MapRouteArgs({this.key, required this.point});

  final _i11.Key? key;

  final _i12.Point? point;

  @override
  String toString() {
    return 'MapRouteArgs{key: $key, point: $point}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! MapRouteArgs) return false;
    return key == other.key && point == other.point;
  }

  @override
  int get hashCode => key.hashCode ^ point.hashCode;
}

/// generated route for
/// [_i4.OnboardingScreen]
class OnboardingRoute extends _i10.PageRouteInfo<void> {
  const OnboardingRoute({List<_i10.PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i4.OnboardingScreen();
    },
  );
}

/// generated route for
/// [_i5.PhotosScreen]
class PhotosRoute extends _i10.PageRouteInfo<PhotosRouteArgs> {
  PhotosRoute({
    _i11.Key? key,
    required _i13.PlaceImages placeImages,
    required int initialPage,
    List<_i10.PageRouteInfo>? children,
  }) : super(
         PhotosRoute.name,
         args: PhotosRouteArgs(
           key: key,
           placeImages: placeImages,
           initialPage: initialPage,
         ),
         initialChildren: children,
       );

  static const String name = 'PhotosRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PhotosRouteArgs>();
      return _i5.PhotosScreen(
        key: args.key,
        placeImages: args.placeImages,
        initialPage: args.initialPage,
      );
    },
  );
}

class PhotosRouteArgs {
  const PhotosRouteArgs({
    this.key,
    required this.placeImages,
    required this.initialPage,
  });

  final _i11.Key? key;

  final _i13.PlaceImages placeImages;

  final int initialPage;

  @override
  String toString() {
    return 'PhotosRouteArgs{key: $key, placeImages: $placeImages, initialPage: $initialPage}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PhotosRouteArgs) return false;
    return key == other.key &&
        placeImages == other.placeImages &&
        initialPage == other.initialPage;
  }

  @override
  int get hashCode =>
      key.hashCode ^ placeImages.hashCode ^ initialPage.hashCode;
}

/// generated route for
/// [_i6.PlaceDetailsScreen]
class PlaceDetailsRoute extends _i10.PageRouteInfo<PlaceDetailsRouteArgs> {
  PlaceDetailsRoute({
    _i11.Key? key,
    required _i14.Place place,
    List<_i10.PageRouteInfo>? children,
  }) : super(
         PlaceDetailsRoute.name,
         args: PlaceDetailsRouteArgs(key: key, place: place),
         initialChildren: children,
       );

  static const String name = 'PlaceDetailsRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PlaceDetailsRouteArgs>();
      return _i6.PlaceDetailsScreen(key: args.key, place: args.place);
    },
  );
}

class PlaceDetailsRouteArgs {
  const PlaceDetailsRouteArgs({this.key, required this.place});

  final _i11.Key? key;

  final _i14.Place place;

  @override
  String toString() {
    return 'PlaceDetailsRouteArgs{key: $key, place: $place}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PlaceDetailsRouteArgs) return false;
    return key == other.key && place == other.place;
  }

  @override
  int get hashCode => key.hashCode ^ place.hashCode;
}

/// generated route for
/// [_i7.PlacesScreen]
class PlacesRoute extends _i10.PageRouteInfo<void> {
  const PlacesRoute({List<_i10.PageRouteInfo>? children})
    : super(PlacesRoute.name, initialChildren: children);

  static const String name = 'PlacesRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i7.PlacesScreen();
    },
  );
}

/// generated route for
/// [_i8.RootScreen]
class RootRoute extends _i10.PageRouteInfo<void> {
  const RootRoute({List<_i10.PageRouteInfo>? children})
    : super(RootRoute.name, initialChildren: children);

  static const String name = 'RootRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i8.RootScreen();
    },
  );
}

/// generated route for
/// [_i9.SettingsScreen]
class SettingsRoute extends _i10.PageRouteInfo<void> {
  const SettingsRoute({List<_i10.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i10.PageInfo page = _i10.PageInfo(
    name,
    builder: (data) {
      return const _i9.SettingsScreen();
    },
  );
}
