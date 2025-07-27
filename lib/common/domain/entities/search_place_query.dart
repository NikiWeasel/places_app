class SearchPlaceQuery {
  final String query;
  final int? limit;
  final int? offset;

  SearchPlaceQuery(this.query, {int? limit, int? offset})
    : limit = limit ?? 20,
      offset = offset ?? 0;
}
