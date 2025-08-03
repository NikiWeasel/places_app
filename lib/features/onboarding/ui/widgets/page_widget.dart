import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/uikit/images/svg_picture_widget.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';

class PageWidget extends StatelessWidget {
  const PageWidget({
    super.key,
    required this.svgPath,
    required this.title,
    required this.description,
  });

  final String svgPath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final appTextTheme = AppTextTheme.of(context);
    final appColorTheme = AppColorTheme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,

      children: [
        SvgPictureWidget(
          svgPath,
          height: 104.r,
          width: 104.r,
          color: appColorTheme.icon,
        ),
        SizedBox(height: 40.h),
        Text(title, style: appTextTheme.title, textAlign: TextAlign.center),
        SizedBox(height: 8.h),
        Text(
          description,
          style: appTextTheme.small,
          textAlign: TextAlign.center,
        ),
        // SizedBox(height: 250),
      ],
    );
  }
}
