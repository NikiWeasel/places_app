import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:places_surf/common/domain/entities/place_images.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';

class PlacesDetailPhotoSliderWidget extends StatelessWidget {
  const PlacesDetailPhotoSliderWidget({super.key, required this.placeImages});

  final PlaceImages placeImages;

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorTheme.light();
    return Stack(
      children: [
        Builder(
          builder: (context) {
            if (placeImages is ImagesUrls) {
              final List<String> images = (placeImages as ImagesUrls).urls;

              return PageView.builder(
                itemCount: images.length,
                itemBuilder:
                    (context, index) => CachedNetworkImage(
                      imageUrl: images[index],
                      fit: BoxFit.cover,
                      progressIndicatorBuilder: (
                        context,
                        url,
                        downloadProgress,
                      ) {
                        final progress = downloadProgress.progress;
                        return Container(
                          color: colorScheme.secondary,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(value: progress),
                        );
                      },
                      errorWidget:
                          (context, url, error) =>
                              Container(color: Colors.white),
                    ),
              );
            } else if (placeImages is ImagesBytes) {
              final List<Uint8List> images =
                  (placeImages as ImagesBytes).images;

              return PageView.builder(
                itemCount: images.length,
                itemBuilder:
                    (context, index) => Image.memory(
                      images[index],
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) =>
                              Container(color: Colors.white),
                    ),
              );
            }
            return SizedBox();
          },
        ),
        Positioned(
          top: 50,
          left: 15,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
          ),
        ),
      ],
    );
  }
}
