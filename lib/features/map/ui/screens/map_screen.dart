import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_maps_mapkit/directions.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/mapkit_factory.dart';
import 'package:yandex_maps_mapkit/yandex_map.dart';

@RoutePage()
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final AppLifecycleListener _lifecycleListener;

  MapWindow? _mapWindow;
  bool _isMapkitActive = false;

  List<MapObject> _mapObjects = [];

  final Point _startPoint = Point(
    latitude: 55.751244,
    longitude: 37.618423,
  ); // Москва
  final Point _endPoint = Point(
    latitude: 55.7749,
    longitude: 37.6321,
  ); // Пример

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Проверка: включены ли службы геолокации
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Службы геолокации отключены.');
    }

    // Проверка разрешений
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Доступ к геолокации отклонён пользователем.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Доступ к геолокации навсегда запрещён.');
    }

    // Получение текущих координат
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  void getLocation() async {
    try {
      final position = await determinePosition();
      print('Широта: ${position.latitude}, Долгота: ${position.longitude}');
    } catch (e) {
      print('Ошибка: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _startMapkit();

    _lifecycleListener = AppLifecycleListener(
      onResume: () {
        _startMapkit();
        _setMapTheme();
      },
      onInactive: () {
        _stopMapkit();
      },
    );
  }

  @override
  void dispose() {
    _stopMapkit();
    _lifecycleListener.dispose();
    // widget.onMapDispose?.call();
    super.dispose();
  }

  void _startMapkit() {
    if (!_isMapkitActive) {
      _isMapkitActive = true;
      mapkit.onStart();
    }
  }

  void _stopMapkit() {
    if (_isMapkitActive) {
      _isMapkitActive = false;
      mapkit.onStop();
    }
  }

  void _setMapTheme() {
    _mapWindow?.map.nightModeEnabled =
        Theme.of(context).brightness == Brightness.dark;
  }

  Future<void> _buildRoute() async {
    final drivingRouter = DirectionsFactory.instance.createDrivingRouter(
      DrivingRouterType.Combined,
    );

    final drivingOptions = DrivingOptions(routesCount: 3);

    final vehicleOptions = DrivingVehicleOptions();

    final points = [
      RequestPoint(
        Point(latitude: 59.8003, longitude: 30.2625),
        RequestPointType.Waypoint,
        null,
        null,
        null,
      ),
      RequestPoint(
        Point(latitude: 59.9398, longitude: 30.3146),
        RequestPointType.Waypoint,
        null,
        null,
        null,
      ),
    ];

    DrivingSessionRouteListener drivingRouteListener =
        DrivingSessionRouteListener(
          onDrivingRoutes: (routes) {
            final route = routes.first;

            final polyline = route.geometry;

            final polylineObject = _mapWindow?.map.mapObjects
                .addPolylineWithGeometry(polyline);
          },
          onDrivingRoutesError: (val) {
            print(val);
            print('Error');
          },
        );

    final drivingSession = drivingRouter.requestRoutes(
      drivingOptions,
      vehicleOptions,
      drivingRouteListener,
      points: points,
    );
    print(drivingSession);
    print('done');
  }

  void moveCam() {
    _mapWindow?.map.move(
      CameraPosition(
        Point(latitude: 59.8003, longitude: 30.2625),
        zoom: 17.0,
        azimuth: 150.0,
        tilt: 30.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YandexMap(onMapCreated: (mapWindow) => _mapWindow = mapWindow),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // _startMapkit();
          //
          // getLocation();
          moveCam();
          _buildRoute();
        },
      ),
    );
  }
}
