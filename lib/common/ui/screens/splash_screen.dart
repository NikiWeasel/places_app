import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/assets/images/app_svg_icons.dart';
import 'package:places_surf/uikit/images/svg_picture_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFCDD3D), Color(0xFF4CAF50)],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Center(
          child: SvgPictureWidget(
            AppSvgIcons.icSplashLogo,
            width: 160.r,
            height: 160.r,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
