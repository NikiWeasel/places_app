import 'dart:typed_data';

abstract class PlaceImages {}

class ImagesBytes extends PlaceImages {
  final List<Uint8List> images;

  ImagesBytes(this.images);
}

class ImagesUrls extends PlaceImages {
  final List<String> urls;

  ImagesUrls(this.urls);
}
