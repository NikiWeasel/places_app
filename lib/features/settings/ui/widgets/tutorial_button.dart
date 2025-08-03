import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/assets/images/app_svg_icons.dart';
import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/uikit/buttons/icon_action_button.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';

class TutorialButton extends StatelessWidget {
  const TutorialButton({super.key, required this.onTap});

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final appTextTheme = AppTextTheme.of(context);
    final appColorTheme = AppColorTheme.of(context);

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 56.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Text(
                AppStrings.settingsScreenWatchTutorial,
                style: appTextTheme.text,
              ),
              Spacer(),
              IconActionButton(
                svgPath: AppSvgIcons.icInfo,
                color: appColorTheme.accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
