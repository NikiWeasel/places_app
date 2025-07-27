// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceDTO _$PlaceDTOFromJson(Map<String, dynamic> json) => PlaceDTO(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  lat: (json['lat'] as num).toDouble(),
  lng: (json['lng'] as num).toDouble(),
  description: json['description'] as String,
  type: json['type'] as String,
  urls: (json['urls'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$PlaceDTOToJson(PlaceDTO instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'lat': instance.lat,
  'lng': instance.lng,
  'description': instance.description,
  'type': instance.type,
  'urls': instance.urls,
};
