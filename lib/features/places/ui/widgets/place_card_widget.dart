import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/assets/images/app_svg_icons.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/common/domain/entities/place_images.dart';
import 'package:places_surf/features/places/bloc_places/places_bloc.dart';
import 'package:places_surf/router/app_router.gr.dart';
import 'package:places_surf/uikit/buttons/icon_action_button.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';

class PlaceCardWidget extends StatelessWidget {
  const PlaceCardWidget({super.key, required this.place, this.onShare});

  final Place place;
  final void Function()? onShare;

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);

    Future<void> pushDetailsScreen() async {
      context.pushRoute(PlaceDetailsRoute(place: place));
    }

    void toggleFavorite() {
      context.read<PlacesBloc>().add(ToggleFavoritePlace(place: place));
    }

    return InkWell(
      onTap: pushDetailsScreen,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            // borderRadius: BorderRadius.all(Radius.circular(12)),
            color: colorTheme.background,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 96.h,
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
                        place.type.label.toLowerCase(),
                        style: textTheme.smallBold.copyWith(
                          color: colorTheme.neutralWhite,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child:
                          onShare != null
                              ? Row(
                                children: [
                                  IconActionButton(
                                    onPressed: onShare,
                                    svgPath: AppSvgIcons.icShare,
                                    color: Colors.white,
                                  ),
                                  IconActionButton(
                                    onPressed: toggleFavorite,
                                    svgPath: AppSvgIcons.icClose,
                                    color: Colors.white,
                                  ),
                                ],
                              )
                              : IconActionButton(
                                onPressed: toggleFavorite,
                                svgPath:
                                    place.isFavorite
                                        ? AppSvgIcons.icHeartFull
                                        : AppSvgIcons.icHeart,
                                color: Colors.white,
                              ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 102.h,
                width: double.infinity,
                padding: EdgeInsets.all(16.r),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name,
                      style: textTheme.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      place.description,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.text,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
