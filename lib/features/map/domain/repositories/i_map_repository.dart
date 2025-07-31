import 'package:yandex_maps_mapkit/mapkit.dart';

abstract interface class IMapRepository {
  Future<void> toDefaultLocation();

  Future<void> startNewRoute(Point destinationPoint);

  Future<void> clearMap();
}
