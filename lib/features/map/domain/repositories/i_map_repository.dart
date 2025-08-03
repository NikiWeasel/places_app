import 'package:yandex_maps_mapkit/mapkit.dart';

abstract interface class IMapRepository {
  Future<void> toDefaultLocation();

  Future<void> startNewRoute(Point destinationPoint);

  Future<void> clearMap();

  Future<void> buildNewPOIs(
    List<Point> points,
    void Function(Point point) callback,
  );

  Future<void> buildUserIcon(Point point);

  Stream<Point> positionStream();
}
