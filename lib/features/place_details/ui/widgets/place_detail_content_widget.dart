import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';

class PlaceDetailContentWidget extends StatelessWidget {
  const PlaceDetailContentWidget({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.base();

    return Column(
      children: [
        Container(
          // height: 120,
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(place.name, style: textTheme.title),
              SizedBox(height: 2.h),
              Text(place.type.label.toLowerCase(), style: textTheme.smallBold),
              SizedBox(height: 24.h),

              Text(
                place.description,
                softWrap: true,
                // maxLines: 3,
                overflow: TextOverflow.fade,
                style: textTheme.small,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
