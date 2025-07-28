// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:flutter/material.dart' as _i8;
import 'package:places_surf/common/domain/entities/place.dart' as _i9;
import 'package:places_surf/features/favorites/ui/screens/favorites_screen.dart'
    as _i1;
import 'package:places_surf/features/map/ui/screens/map_screen.dart' as _i2;
import 'package:places_surf/features/place_details/ui/screens/place_details_screen.dart'
    as _i3;
import 'package:places_surf/features/places/ui/screens/places_screen.dart'
    as _i4;
import 'package:places_surf/features/settings/ui/screens/settings_screen.dart'
    as _i6;
import 'package:places_surf/router/ui/root_screen.dart' as _i5;

/// generated route for
/// [_i1.FavoritesScreen]
class FavoritesRoute extends _i7.PageRouteInfo<void> {
  const FavoritesRoute({List<_i7.PageRouteInfo>? children})
    : super(FavoritesRoute.name, initialChildren: children);

  static const String name = 'FavoritesRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i1.FavoritesScreen();
    },
  );
}

/// generated route for
/// [_i2.MapScreen]
class MapRoute extends _i7.PageRouteInfo<void> {
  const MapRoute({List<_i7.PageRouteInfo>? children})
    : super(MapRoute.name, initialChildren: children);

  static const String name = 'MapRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.MapScreen();
    },
  );
}

/// generated route for
/// [_i3.PlaceDetailsScreen]
class PlaceDetailsRoute extends _i7.PageRouteInfo<PlaceDetailsRouteArgs> {
  PlaceDetailsRoute({
    _i8.Key? key,
    required _i9.Place place,
    List<_i7.PageRouteInfo>? children,
  }) : super(
         PlaceDetailsRoute.name,
         args: PlaceDetailsRouteArgs(key: key, place: place),
         initialChildren: children,
       );

  static const String name = 'PlaceDetailsRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PlaceDetailsRouteArgs>();
      return _i3.PlaceDetailsScreen(key: args.key, place: args.place);
    },
  );
}

class PlaceDetailsRouteArgs {
  const PlaceDetailsRouteArgs({this.key, required this.place});

  final _i8.Key? key;

  final _i9.Place place;

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
/// [_i4.PlacesScreen]
class PlacesRoute extends _i7.PageRouteInfo<void> {
  const PlacesRoute({List<_i7.PageRouteInfo>? children})
    : super(PlacesRoute.name, initialChildren: children);

  static const String name = 'PlacesRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.PlacesScreen();
    },
  );
}

/// generated route for
/// [_i5.RootScreen]
class RootRoute extends _i7.PageRouteInfo<void> {
  const RootRoute({List<_i7.PageRouteInfo>? children})
    : super(RootRoute.name, initialChildren: children);

  static const String name = 'RootRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.RootScreen();
    },
  );
}

/// generated route for
/// [_i6.SettingsScreen]
class SettingsRoute extends _i7.PageRouteInfo<void> {
  const SettingsRoute({List<_i7.PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.SettingsScreen();
    },
  );
}
