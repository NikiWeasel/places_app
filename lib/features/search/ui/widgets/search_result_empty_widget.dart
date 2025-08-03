import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/assets/images/app_svg_icons.dart';
import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/uikit/images/svg_picture_widget.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';

class SearchResultEmptyWidget extends StatelessWidget {
  const SearchResultEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appTextTheme = AppTextTheme.of(context);
    final appColorTheme = AppColorTheme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPictureWidget(
            AppSvgIcons.icSearch,
            height: 64.r,
            width: 64.r,
            color: appColorTheme.secondaryVariant.withValues(alpha: 0.56),
          ),
          SizedBox(height: 24.h),
          Text(
            AppStrings.searchScreenEmptyTitle,
            style: appTextTheme.subtitle.copyWith(
              color: appColorTheme.secondaryVariant.withValues(alpha: 0.56),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            AppStrings.searchScreenEmptySubTitle,
            style: appTextTheme.small.copyWith(
              color: appColorTheme.secondaryVariant.withValues(alpha: 0.56),
            ),
          ),
        ],
      ),
    );
  }
}
