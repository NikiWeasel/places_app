import 'package:places_surf/features/map/data/services/map_service.dart';
import 'package:places_surf/features/map/domain/repositories/i_map_repository.dart';
import 'package:places_surf/features/map/domain/services/i_geolocation_service.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';

class MapRepository implements IMapRepository {
  final MapService mapService;

  final IGeolocationService geolocationService;

  MapRepository(this.geolocationService, this.mapService);

  @override
  Future<void> toDefaultLocation() async {
    // await mapService.clearMapObjects();

    final point = await geolocationService.getCurrentPosition();
    mapService.animateCameraTo(point);
  }

  @override
  Future<void> startNewRoute(Point end) async {
    await mapService.clearMapObjects();
    final start = await geolocationService.getCurrentPosition();

    final polyline = await mapService.buildRoute(start: start, end: end);

    final geometry = Geometry.fromPolyline(polyline);

    mapService.animateCameraToGeometry(geometry);

    mapService.placeDestinationIcon(end);
  }

  @override
  Future<void> clearMap() async {
    mapService.clearMapObjects();
  }

  @override
  Future<void> buildNewPOIs(
    List<Point> points,

    void Function(Point point) callback,
  ) async {
    await clearMap();
    for (var position in points) {
      await mapService.placeInteractiveDestinationIcon(
        position,
        callback: callback,
      );
      // await mapService.placeDestinationIcon(position);
    }
    // await mapService.placeDestinationIcon(points[points.length - 1]);
  }

  @override
  Stream<Point> positionStream() {
    return geolocationService.positionStream();
  }

  @override
  Future<void> buildUserIcon(Point point) async {
    print(point);
    mapService.placeUserIcon(point);
  }
}
