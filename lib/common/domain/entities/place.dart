enum PlaceType {
  other,
  park,
  monument,
  theatre,
  museum,
  temple,
  hotel,
  restaurant,
  cafe,
  shopping,
}

class Place {
  int id;
  String name;
  double lat;
  double lng;
  String description;
  PlaceType type;
  List<String> urls;

  Place({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.description,
    required this.type,
    required this.urls,
  });
}
