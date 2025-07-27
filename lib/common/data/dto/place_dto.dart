import 'package:json_annotation/json_annotation.dart';
import 'package:places_surf/common/domain/entities/place.dart';

part 'place_dto.g.dart';

@JsonSerializable()
class PlaceDTO {
  int id;
  String name;
  double lat;
  double lng;
  String description;
  String type;
  List<String> urls;

  PlaceDTO({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.description,
    required this.type,
    required this.urls,
  });

  factory PlaceDTO.fromJson(Map<String, dynamic> json) =>
      _$PlaceDTOFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceDTOToJson(this);

  Place toEntity() => Place(
    id: id,
    name: name,
    lat: lat,
    lng: lng,
    description: description,
    type: typeConverter(type),
    urls: urls,
  );

  static PlaceDTO fromEntity(Place place) => PlaceDTO(
    id: place.id,
    name: place.name,
    lat: place.lat,
    lng: place.lng,
    description: place.description,
    type: place.type.name,
    urls: place.urls,
  );
}

//TODO Поменять наверное
PlaceType typeConverter(String type) {
  switch (type.toLowerCase()) {
    case 'park':
      return PlaceType.park;
    case 'monument':
      return PlaceType.monument;
    case 'theatre':
      return PlaceType.theatre;
    case 'museum':
      return PlaceType.museum;
    case 'temple':
      return PlaceType.temple;
    case 'hotel':
      return PlaceType.hotel;
    case 'restaurant':
      return PlaceType.restaurant;
    case 'cafe':
      return PlaceType.cafe;
    case 'shopping':
      return PlaceType.shopping;
    default:
      return PlaceType.other;
  }
}
