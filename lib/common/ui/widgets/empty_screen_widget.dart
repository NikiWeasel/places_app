import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/assets/images/app_svg_icons.dart';
import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/uikit/images/svg_picture_widget.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';

class EmptyScreenWidget extends StatelessWidget {
  const EmptyScreenWidget({super.key, required this.onRefresh});

  final void Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final appTextTheme = AppTextTheme.of(context);
    final appColorTheme = AppColorTheme.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPictureWidget(
            AppSvgIcons.icGo,
            height: 64.r,
            width: 64.r,
            color: appColorTheme.secondaryVariant.withValues(alpha: 0.56),
          ),
          SizedBox(height: 24.h),
          Text(
            AppStrings.placesEmptyScreen,
            style: appTextTheme.subtitle.copyWith(
              color: appColorTheme.secondaryVariant.withValues(alpha: 0.56),
            ),
          ),
        ],
      ),
    );
  }
}
