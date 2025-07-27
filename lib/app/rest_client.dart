import 'package:dio/dio.dart';
import 'package:places_surf/common/data/dto/place_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'rest_client.g.dart';

@RestApi(baseUrl: 'http://109.73.206.134:8888/api/')
abstract class RestClient {
  factory RestClient(Dio dio, {String? baseUrl}) = _RestClient;

  @GET('/places')
  Future<List<PlaceDTO>> getPlaces();

  @GET('/places/{id}')
  Future<PlaceDTO> getPlaceById(@Path('id') int id);

  /// Вызов метода `toJson()` см. в [SearchPlace.toJson]
  @GET('/places/search')
  Future<List<PlaceDTO>> getPlacesBySearch(
    @Queries() Map<String, dynamic> queries,
  );
}
