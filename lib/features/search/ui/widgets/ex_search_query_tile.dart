import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/assets/images/app_svg_icons.dart';
import 'package:places_surf/uikit/buttons/icon_action_button.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';

class ExSearchQueryTile extends StatelessWidget {
  const ExSearchQueryTile({
    super.key,
    required this.label,
    required this.onTap,
    required this.onDelete,
  });

  final String label;
  final void Function() onTap;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final appTextTheme = AppTextTheme.of(context);
    final appColorTheme = AppColorTheme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
          top: 12.h,
          bottom: 11.h,
          left: 16.w,
          right: 24.w,
        ),
        child: Row(
          children: [
            Text(
              label,
              style: appTextTheme.text.copyWith(
                color: appColorTheme.secondaryVariant,
              ),
            ),
            Spacer(),
            IconActionButton(
              svgPath: AppSvgIcons.icDelete,
              color: appColorTheme.secondaryVariant,
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
