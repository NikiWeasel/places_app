import 'package:json_annotation/json_annotation.dart';
import 'package:places_surf/common/domain/entities/search_place_query.dart';

part 'search_place_query_dto.g.dart';

@JsonSerializable()
class SearchPlaceQueryDTO {
  final String q;
  final int limit;
  final int offset;

  SearchPlaceQueryDTO({
    required this.q,
    required this.limit,
    required this.offset,
  });

  factory SearchPlaceQueryDTO.fromJson(Map<String, dynamic> json) =>
      _$SearchPlaceQueryDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SearchPlaceQueryDTOToJson(this);

  SearchPlaceQuery toEntity() =>
      SearchPlaceQuery(q, limit: limit, offset: offset);

  static SearchPlaceQueryDTO fromEntity(SearchPlaceQuery sp) =>
      SearchPlaceQueryDTO(q: sp.query, limit: sp.limit!, offset: sp.offset!);
}
