import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:places_surf/features/map/domain/services/i_map_service.dart';
import 'package:yandex_maps_mapkit/directions.dart';
import 'package:yandex_maps_mapkit/image.dart' as image_provider;
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/src/mapkit/animation.dart'
    as mapkit_animation;

class MapService implements IMapService {
  MapWindow? mapWindow;

  MapService(this.mapWindow);

  void init(MapWindow newMapWindow) {
    mapWindow = newMapWindow;
  }

  @override
  void animateCameraTo(
    Point target, {
    double zoom = 17.0,
    double azimuth = 150,
    double tilt = 30,
  }) {
    final newCameraPosition = CameraPosition(
      target,
      zoom: zoom,
      azimuth: azimuth,
      tilt: tilt,
    );
    mapWindow?.map.moveWithAnimation(
      newCameraPosition,
      mapkit_animation.Animation(
        mapkit_animation.AnimationType.Smooth,
        duration: 1.0,
      ),
    );
  }

  @override
  void animateCameraToGeometry(
    Geometry geometry, {
    double zoom = 17.0,
    double azimuth = 150,
    double tilt = 30,
  }) {
    final position = mapWindow?.map.cameraPositionForGeometry(geometry);

    mapWindow?.map.moveWithAnimation(
      position!,
      mapkit_animation.Animation(
        mapkit_animation.AnimationType.Smooth,
        duration: 1.0,
      ),
    );
  }

  @override
  Future<void> clearMapObjects() async {
    mapWindow?.map.mapObjects.clear();
  }

  @override
  Future<void> placeDestinationIcon(Point position) async {
    final destinationIconImageProvider = image_provider
        .ImageProvider.fromImageProvider(
      const AssetImage("assets/images/location.png"),
    );

    mapWindow?.map.mapObjects.addPlacemark()
      ?..geometry = position
      ..setIcon(destinationIconImageProvider);
  }

  @override
  Future<Polyline> buildRoute({
    required Point start,
    required Point end,
    List<RequestPoint>? requestPoint,
  }) async {
    final completer = Completer<Polyline>();

    final drivingRouter = DirectionsFactory.instance.createDrivingRouter(
      DrivingRouterType.Combined,
    );

    final drivingOptions = DrivingOptions(routesCount: 3);
    final vehicleOptions = DrivingVehicleOptions();

    final drivingRouteListener = DrivingSessionRouteListener(
      onDrivingRoutes: (routes) {
        try {
          print(routes);
          final route = routes.first;
          final polyline = route.geometry;

          mapWindow?.map.mapObjects.addPolylineWithGeometry(polyline);
          completer.complete(polyline);
        } catch (e) {
          completer.completeError(StateError('Ошибка обработки маршрута: $e'));
        }
      },
      onDrivingRoutesError: (error) {
        completer.completeError(Exception('Ошибка получения маршрута: $error'));
      },
    );

    drivingRouter.requestRoutes(
      drivingOptions,
      vehicleOptions,
      drivingRouteListener,
      points: [
        RequestPoint(start, RequestPointType.Waypoint, null, null, null),
        ...?requestPoint,
        RequestPoint(end, RequestPointType.Waypoint, null, null, null),
      ],
    );

    return completer.future;
  }

  @override
  Future<void> trimRouteFrom(Point fromPosition) {
    // TODO: implement trimRouteFrom
    throw UnimplementedError();
  }
}
