import 'package:flutter/material.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';

class AppTextField extends StatelessWidget {
  final String? hintText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  const AppTextField({
    super.key,
    this.hintText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = TextTheme.of(context);

    // Выбор контрастного цвета относительно surface
    final contrastFill = colorTheme.background.withValues(alpha: 0.7);

    return Material(
      elevation: 4,
      shadowColor: colorTheme.secondaryVariant.withValues(alpha: 0.2),
      borderRadius: BorderRadius.circular(12),
      color: colorTheme.secondary.withValues(alpha: 0.7),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        cursorColor: colorTheme.textPrimary,
        style: textTheme.bodyLarge?.copyWith(
          color: colorTheme.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: textTheme.bodyLarge?.copyWith(
            color: colorTheme.textSecondaryVariant,
          ),
          filled: true,
          fillColor: contrastFill,
          prefixIcon:
              prefixIcon != null
                  ? IconTheme(
                    data: IconThemeData(color: colorTheme.icon, size: 24),
                    child: prefixIcon!,
                  )
                  : null,
          suffixIcon:
              suffixIcon != null
                  ? IconTheme(
                    data: IconThemeData(color: colorTheme.icon, size: 24),
                    child: suffixIcon!,
                  )
                  : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
