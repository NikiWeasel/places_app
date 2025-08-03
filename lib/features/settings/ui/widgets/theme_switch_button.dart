import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';

class ThemeSwitchButton extends StatefulWidget {
  const ThemeSwitchButton({
    super.key,
    required this.onToggle,
    required this.initValue,
  });

  final bool initValue;
  final void Function() onToggle;

  @override
  State<ThemeSwitchButton> createState() => _ThemeSwitchButtonState();
}

class _ThemeSwitchButtonState extends State<ThemeSwitchButton> {
  late bool switchValue;

  @override
  void initState() {
    super.initState();
    switchValue = widget.initValue;
  }

  void toggle(bool val) {
    setState(() {
      switchValue = val;
    });
    widget.onToggle();
  }

  @override
  Widget build(BuildContext context) {
    final appTextTheme = AppTextTheme.of(context);
    final appColorTheme = AppColorTheme.of(context);

    return InkWell(
      onTap: () {
        toggle(!switchValue);
      },
      child: SizedBox(
        height: 56.h,

        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Text(AppStrings.settingsScreenDarkMode, style: appTextTheme.text),
              Spacer(),
              Switch(
                activeColor: appColorTheme.accent,
                value: switchValue,
                onChanged: toggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
