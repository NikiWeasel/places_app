import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:places_surf/features/map/domain/services/i_geolocation_service.dart';
import 'package:yandex_maps_mapkit/src/mapkit/geometry/point.dart';

class GeolocationServiceMock implements IGeolocationService {
  const GeolocationServiceMock();

  @override
  Future<bool> ensurePermissionGranted() async {
    final status = await Permission.location.status;

    if (status.isGranted) {
      return true;
    }

    final result = await Permission.location.request();
    return result.isGranted;
  }

  @override
  Stream<Point> positionStream() {
    const settings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 10,
    );

    return Geolocator.getPositionStream(
      locationSettings: settings,
    ).map((pos) => Point(latitude: pos.latitude, longitude: pos.longitude));
  }

  @override
  Future<Point> getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return Point(latitude: 55.7749, longitude: 37.6321);
  }
}
