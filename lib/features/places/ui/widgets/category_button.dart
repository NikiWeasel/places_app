import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/assets/images/app_svg_icons.dart';
import 'package:places_surf/uikit/images/svg_picture_widget.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';

class CategoryButton extends StatelessWidget {
  const CategoryButton({
    super.key,
    required this.isSelected,
    required this.title,
    required this.svgPath,
    required this.onTap,
  });

  final bool isSelected;
  final String title;
  final String svgPath;

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final appTextTheme = AppTextTheme.of(context);
    final appColorTheme = AppColorTheme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.5.w),
      child: SizedBox(
        width: 96.w,
        height: 92.h,
        child: Column(
          children: [
            Stack(
              children: [
                InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.all(Radius.circular(90)),
                  child: Container(
                    width: 64.r,
                    height: 64.r,
                    decoration: BoxDecoration(
                      color: appColorTheme.accent.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.all(Radius.circular(90)),
                    ),
                    child: SvgPictureWidget(
                      svgPath,
                      width: 32.r,
                      height: 32.r,
                      fit: BoxFit.scaleDown,
                      color: appColorTheme.accent,
                    ),
                  ),
                ),
                isSelected
                    ? Positioned(
                      bottom: 0,
                      right: 0,
                      child: SvgPictureWidget(
                        AppSvgIcons.icIsChose,
                        width: 24.r,
                        height: 24.r,
                        fit: BoxFit.fill,
                      ),
                    )
                    : SizedBox(),
              ],
            ),

            SizedBox(height: 12.h),
            Text(title, style: appTextTheme.superSmall),
          ],
        ),
      ),
    );
  }
}
