import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';

class PlacesDetailPhotoSliderWidget extends StatelessWidget {
  const PlacesDetailPhotoSliderWidget({super.key, required this.images});

  final List<String> images;

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorTheme.light();
    return Stack(
      children: [
        PageView.builder(
          itemCount: images.length,
          itemBuilder:
              (context, index) =>
              Image.network(
                images[index],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;

                  final total = loadingProgress.expectedTotalBytes;
                  final loaded = loadingProgress.cumulativeBytesLoaded;

                  return Container(
                    color: colorScheme.secondary,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      value: total != null ? loaded / total : null,
                    ),
                  );
                },
                errorBuilder:
                    (context, error, stackTrace) =>
                    Container(color: Colors.white),
              ),
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
