import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/common/domain/entities/place_images.dart';

enum PlaceType {
  other(AppStrings.filterScreenSpecial),
  park(AppStrings.filterScreenPark),
  monument(AppStrings.filterScreenMonument),
  theatre(AppStrings.filterScreenTheatre),
  museum(AppStrings.filterScreenMuseum),
  temple(AppStrings.filterScreenTemple),
  hotel(AppStrings.filterScreenHotel),
  restaurant(AppStrings.filterScreenRestaurant),
  cafe(AppStrings.filterScreenCafe),
  shopping(AppStrings.filterScreenShopping);

  final String label;

  const PlaceType(this.label);
}

class Place {
  final int id;
  final String name;
  final double lat;
  final double lng;
  final String description;
  final PlaceType type;
  final bool isFavorite;
  final PlaceImages images;

  Place({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.description,
    required this.type,
    required this.isFavorite,
    required this.images,
  });

  Place copyWith({
    int? id,
    String? name,
    double? lat,
    double? lng,
    String? description,
    PlaceType? type,
    bool? isFavorite,
    PlaceImages? images,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      description: description ?? this.description,
      type: type ?? this.type,
      isFavorite: isFavorite ?? this.isFavorite,
      images: images ?? this.images,
    );
  }
}
