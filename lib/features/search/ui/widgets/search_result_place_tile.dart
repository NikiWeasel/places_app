import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/common/domain/entities/place_images.dart';
import 'package:places_surf/router/app_router.gr.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';

class SearchResultPlaceTile extends StatelessWidget {
  const SearchResultPlaceTile({
    super.key,
    required this.place,
    required this.searchQuery,
  });

  final Place place;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    final appTextTheme = AppTextTheme.of(context);
    final appColorTheme = AppColorTheme.of(context);

    void showDetails() {
      context.pushRoute(PlaceDetailsRoute(place: place));
    }

    RichText buildHighlightedText(String sPlace, String sQuery) {
      final query = sQuery.toLowerCase();
      final name = sPlace;
      final lowerName = name.toLowerCase();

      final startIndex = lowerName.indexOf(query);

      if (query.isEmpty || startIndex == -1) {
        return RichText(
          text: TextSpan(
            text: name,
            style: appTextTheme.text.copyWith(color: appColorTheme.textPrimary),
          ),
        );
      }

      final endIndex = startIndex + query.length;

      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: name.substring(0, startIndex),
              style: appTextTheme.text.copyWith(
                color: appColorTheme.textPrimary,
              ),
            ),
            TextSpan(
              text: name.substring(startIndex, endIndex),
              style: appTextTheme.textMedium.copyWith(
                color: appColorTheme.textPrimary,
              ),
            ),
            TextSpan(
              text: name.substring(endIndex),
              style: appTextTheme.text.copyWith(
                color: appColorTheme.textPrimary,
              ),
            ),
          ],
        ),
      );
    }

    return InkWell(
      onTap: showDetails,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 11.h, horizontal: 16.w),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: SizedBox(
                width: 56.r,
                height: 56.r,

                child: Builder(
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
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHighlightedText(place.name, searchQuery),
                SizedBox(height: 8.h),
                Text(place.type.label, style: appTextTheme.small),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
