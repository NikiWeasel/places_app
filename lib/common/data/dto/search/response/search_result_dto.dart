import 'package:json_annotation/json_annotation.dart';
import 'package:places_surf/common/data/dto/place_dto.dart';

part 'search_result_dto.g.dart';

@JsonSerializable()
class SearchResultDTO {
  final PlaceDTO place;
  final double? relevanceScore;

  SearchResultDTO({required this.place, required this.relevanceScore});

  factory SearchResultDTO.fromJson(Map<String, dynamic> json) =>
      _$SearchResultDTOFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultDTOToJson(this);
}
