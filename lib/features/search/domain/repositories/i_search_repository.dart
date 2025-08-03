import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/common/domain/entities/search_place_query.dart';

abstract interface class ISearchRepository {
  Future<List<Place>> getPlacesBySearch(SearchPlaceQuery searchPlace);

  Future<List<String>> getExSearchStrings();

  Future<void> deleteExSearchString(String search);

  Future<void> addExSearchString(String search);

  Future<void> clearExSearchString();
}
