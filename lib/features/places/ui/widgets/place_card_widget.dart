import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/common/domain/entities/place_images.dart';
import 'package:places_surf/features/places/bloc/places_bloc.dart';
import 'package:places_surf/router/app_router.gr.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';
import 'package:yandex_maps_mapkit/mapkit.dart' as ymk;

class PlaceCardWidget extends StatelessWidget {
  const PlaceCardWidget({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);

    Future<void> pushDetailsScreen() async {
      final result = await context.pushRoute(PlaceDetailsRoute(place: place));
      if (result != null) {
        final tabsRouter = AutoTabsRouter.of(context);
        // tabsRouter.setActiveIndex(1); // Переход к MapRoute
        context.navigateTo(MapRoute(point: (result as ymk.Point?)));
      }
    }

    return InkWell(
      onTap: pushDetailsScreen,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            SizedBox(
              height: 160,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Builder(
                    builder: (context) {
                      final images = place.images;

                      if (images is ImagesUrls) {
                        if (images.urls.isEmpty) return const SizedBox();
                        return Image.network(
                          images.urls.first,
                          fit: BoxFit.cover,
                        );
                      } else if (images is ImagesBytes) {
                        if (images.images.isEmpty) return const SizedBox();
                        return Image.memory(
                          images.images.first,
                          fit: BoxFit.cover,
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),

                  // if (place.images.isNotEmpty)
                  //   Image.network(fit: BoxFit.cover, place.images.first),
                  Positioned(
                    left: 16,
                    top: 16,
                    child: Text(
                      place.type.name,
                      style: textTheme.smallBold.copyWith(
                        color: colorTheme.neutralWhite,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      onPressed: () {
                        context.read<PlacesBloc>().add(
                          ToggleFavoritePlace(place: place),
                        );
                      },
                      icon:
                          place.isFavorite
                              ? Icon(Icons.favorite, color: Colors.red)
                              : Icon(
                                Icons.favorite_border,
                                color: Colors.white,
                              ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 120,
              width: double.infinity,
              padding: EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: textTheme.text.copyWith(
                      color: colorTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    place.description,
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.small.copyWith(
                      color: colorTheme.textSecondaryVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
