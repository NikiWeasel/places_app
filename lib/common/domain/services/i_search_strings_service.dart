abstract interface class ISearchStringsService {
  Future<List<String>> getExSearchStrings();

  Future<void> deleteExSearchString(String search);

  Future<void> addExSearchString(String search);

  Future<void> clearExSearchString();
}
