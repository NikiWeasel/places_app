// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_place_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchPlaceDTO _$SearchPlaceDTOFromJson(Map<String, dynamic> json) =>
    SearchPlaceDTO(
      query: json['query'] as String,
      limit: (json['limit'] as num).toInt(),
      offset: (json['offset'] as num).toInt(),
    );

Map<String, dynamic> _$SearchPlaceDTOToJson(SearchPlaceDTO instance) =>
    <String, dynamic>{
      'query': instance.query,
      'limit': instance.limit,
      'offset': instance.offset,
    };
