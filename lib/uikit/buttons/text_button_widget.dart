import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';

/// {@template text_button_widget.class}
/// Текстовая кнопка.
/// {@endtemplate}
class TextButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final Widget? icon;

  /// {@macro text_button_widget.class}
  const TextButtonWidget({
    required this.title,
    required this.onPressed,
    this.color,
    this.padding,
    this.icon,
    super.key,
  });

  const TextButtonWidget.icon({
    required this.title,
    required this.onPressed,
    required this.icon,
    this.color,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color ?? colorTheme.accent,
        textStyle: textTheme.text,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
        ),
      ),
      child:
          icon == null
              ? Text(title)
              : Row(
                mainAxisSize: MainAxisSize.min,
                children: [icon!, const SizedBox(width: 8), Text(title)],
              ),
    );
  }
}
