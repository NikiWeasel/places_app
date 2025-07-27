import 'package:json_annotation/json_annotation.dart';
import 'package:places_surf/common/domain/entities/search_place.dart';

part 'search_place_dto.g.dart';

@JsonSerializable()
class SearchPlaceDTO {
  final String query;
  final int limit;
  final int offset;

  SearchPlaceDTO({
    required this.query,
    required this.limit,
    required this.offset,
  });

  factory SearchPlaceDTO.fromJson(Map<String, dynamic> json) =>
      _$SearchPlaceDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SearchPlaceDTOToJson(this);

  SearchPlace toEntity() =>
      SearchPlace(query: query, limit: limit, offset: offset);

  static SearchPlaceDTO fromEntity(SearchPlace sp) =>
      SearchPlaceDTO(query: sp.query, limit: sp.limit, offset: sp.offset);
}
