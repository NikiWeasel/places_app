import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:places_surf/features/map/domain/services/i_geolocation_service.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';

import 'i_geolocation_service_test.mocks.dart';

@GenerateMocks([IGeolocationService])
void main() {
  late MockIGeolocationService mockGeoService;

  setUp(() {
    mockGeoService = MockIGeolocationService();
  });

  test('getCurrentLocation returns test point', () async {
    final testPoint = Point(longitude: 51.674438, latitude: 39.212244);

    when(
      mockGeoService.getCurrentPosition(),
    ).thenAnswer((_) async => testPoint);

    final result = await mockGeoService.getCurrentPosition();

    expect(result.latitude, 55.7558);
    expect(result.longitude, 37.6173);
  });
}
