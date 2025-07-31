import 'package:yandex_maps_mapkit/mapkit.dart';

abstract interface class IGeolocationService {
  /// Запрашивает и возвращает разрешение на использование геолокации
  Future<bool> ensurePermissionGranted();

  /// Возвращает последнюю известную позицию пользователя
  Future<Point> getCurrentPosition();

  /// Поток обновлений позиции пользователя
  Stream<Point> positionStream();
}
