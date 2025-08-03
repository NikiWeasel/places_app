import 'package:yandex_maps_mapkit/mapkit.dart';

abstract class IMapService {
  /// Построение маршрута от [start] до [end], с опциональными точками
  Future<Polyline> buildRoute({
    required Point start,
    required Point end,
    List<RequestPoint> requestPoint,
  });

  /// Плавно перемещает камеру карты к заданной позиции
  void animateCameraTo(
    Point target, {
    double zoom = 17.0,
    double azimuth = 150,
    double tilt = 30,
  });

  /// Плавно перемещает камеру карты к заданной геометрии
  void animateCameraToGeometry(
    Geometry geometry, {
    double zoom = 17.0,
    double azimuth = 150,
    double tilt = 30,
  });

  /// Удаляет все пользовательские объекты с карты
  Future<void> clearMapObjects();

  /// Размещает иконки интереса (POI) на карте
  Future<void> placeDestinationIcon(Point position);

  /// Размещает иконки интереса (POI) на карте (кликабельные)
  Future<void> placeInteractiveDestinationIcon(
    Point position, {
    required void Function(Point point) callback,
  });

  /// Размещает иконку пользователя на карте
  Future<void> placeUserIcon(Point position);

  /// Укорачивает отображаемую полилинию маршрута до [fromPosition]
  Future<void> trimRouteFrom(Point fromPosition);
}
