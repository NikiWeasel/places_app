import 'package:json_annotation/json_annotation.dart';
import 'package:places_surf/common/data/dto/place_dto.dart';
import 'package:places_surf/common/data/dto/search/response/search_result_dto.dart';

part 'place_search_response_dto.g.dart';

@JsonSerializable()
class PlaceSearchResponseDTO {
  final String query;
  final int total;
  final List<SearchResultDTO> results;

  PlaceSearchResponseDTO({
    required this.query,
    required this.total,
    required this.results,
  });

  factory PlaceSearchResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$PlaceSearchResponseDTOFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceSearchResponseDTOToJson(this);

  List<PlaceDTO> getResultDTOs() {
    List<PlaceDTO> dtos = results.map((e) => e.place).toList();
    return dtos;
  }
}
