import 'package:flutter/material.dart';
import 'package:places_surf/assets/images/app_svg_icons.dart';
import 'package:places_surf/uikit/loading/icon_progress_indicator.dart';

class LargeProgressIndicator extends StatelessWidget {
  const LargeProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    // final appColorTheme = AppColorTheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return IconProgressIndicator(
      widget: Image.asset(
        isDark
            ? AppSvgIcons.icLoaderLargeBlack
            : AppSvgIcons.icLoaderLargeWhite,
      ),
    );
  }
}
