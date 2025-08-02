import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:places_surf/common/domain/entities/place_images.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';

class PhotosPageView extends StatefulWidget {
  const PhotosPageView({
    super.key,
    required this.placeImages,
    this.onPageChanged,
    this.initialPage,
    this.fit,
    required this.heroTag,
  });

  final PlaceImages placeImages;
  final void Function(int index)? onPageChanged;
  final int? initialPage;
  final BoxFit? fit;
  final String heroTag;

  @override
  State<PhotosPageView> createState() => _PhotosPageViewState();
}

class _PhotosPageViewState extends State<PhotosPageView> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialPage ?? 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorTheme.of(context);
    return Builder(
      builder: (context) {
        if (widget.placeImages is ImagesUrls) {
          final List<String> images = (widget.placeImages as ImagesUrls).urls;

          return PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: widget.onPageChanged,
            itemBuilder:
                (context, index) => Hero(
                  tag: ('${widget.heroTag}-$index'),
                  child: CachedNetworkImage(
                    imageUrl: images[index],
                    fit: widget.fit ?? BoxFit.cover,
                    progressIndicatorBuilder: (context, url, downloadProgress) {
                      final progress = downloadProgress.progress;
                      return Container(
                        color: colorScheme.secondary,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(value: progress),
                      );
                    },
                    errorWidget:
                        (context, url, error) => Container(color: Colors.white),
                  ),
                ),
          );
        } else if (widget.placeImages is ImagesBytes) {
          final List<Uint8List> images =
              (widget.placeImages as ImagesBytes).images;

          return PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: widget.onPageChanged,
            itemBuilder:
                (context, index) => Image.memory(
                  images[index],
                  fit: widget.fit ?? BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) =>
                          Container(color: Colors.white),
                ),
          );
        }
        return SizedBox();
      },
    );
  }
}
