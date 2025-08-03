import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/assets/images/app_svg_icons.dart';
import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/features/place_details/ui/widgets/photos_page_view.dart';
import 'package:places_surf/features/place_details/ui/widgets/place_detail_content_widget.dart';
import 'package:places_surf/features/places/bloc_places/places_bloc.dart';
import 'package:places_surf/router/app_router.gr.dart';
import 'package:places_surf/uikit/buttons/back_button_widget.dart';
import 'package:places_surf/uikit/buttons/text_button_widget.dart';
import 'package:places_surf/uikit/images/svg_picture_widget.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';

@RoutePage()
class PlaceDetailsScreen extends StatefulWidget {
  const PlaceDetailsScreen({super.key, required this.place});

  final Place place;

  @override
  State<PlaceDetailsScreen> createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);

    final color =
        Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : colorTheme.icon;

    void openMap() {
      context.navigateTo(
        MapRoute(
          point: (Point(
            latitude: widget.place.lat,
            longitude: widget.place.lng,
          )),
        ),
      );
    }

    void openPhotoScreen() {
      context.pushRoute(
        PhotosRoute(
          placeImages: widget.place.images,
          initialPage: currentIndex,
        ),
      );
    }

    void toFavorites() {
      context.read<PlacesBloc>().add(ToggleFavoritePlace(place: widget.place));
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 360.h,

            flexibleSpace: InkWell(
              onTap: openPhotoScreen,
              child: Stack(
                children: [
                  PhotosPageView(
                    initialPage: currentIndex,
                    placeImages: widget.place.images,
                    onPageChanged: (index) {
                      currentIndex = index;
                    },
                    heroTag: 'PhotosPageView',
                  ),
                  Positioned(top: 50, left: 15, child: BackButtonWidget()),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16.h,
                  horizontal: 0.5.w,
                ),
                child: PlaceDetailContentWidget(place: widget.place),
              ),
              SizedBox(height: 24.h),
              Divider(indent: 16.w, endIndent: 16.w),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 40.h,
                      width: 164.w,
                      child: TextButtonWidget.icon(
                        title: AppStrings.placeDetailsShareButton,
                        color: colorTheme.textPrimary,
                        onPressed: () {
                          //TODO реализовать поделиться
                        },
                        icon: SvgPictureWidget(
                          AppSvgIcons.icShare,
                          color: color,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40.h,
                      width: 164.w,
                      child: TextButtonWidget.icon(
                        title:
                            widget.place.isFavorite
                                ? AppStrings.placeDetailsInFavoritesButton
                                : AppStrings.placeDetailsFavoritesButton,
                        color: color,
                        onPressed: toFavorites,
                        icon: SvgPictureWidget(
                          widget.place.isFavorite
                              ? AppSvgIcons.icHeartFull
                              : AppSvgIcons.icHeart,
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
