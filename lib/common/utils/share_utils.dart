import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:share_plus/share_plus.dart';

void sharePlace(Place place) {
  SharePlus.instance.share(ShareParams(text: createShareText(place)));
}

String createShareText(Place place) {
  final buffer = StringBuffer();

  buffer.writeln(place.name);
  buffer.writeln('Тип: ${place.type.label}'); // если enum
  buffer.writeln(place.description);
  if (place.isFavorite) {
    buffer.writeln(AppStrings.shareFavorite);
  }
  buffer.writeln('https://yandex.ru/maps/?ll=${place.lng}%2C${place.lat}&z=16');
  return buffer.toString();
}
