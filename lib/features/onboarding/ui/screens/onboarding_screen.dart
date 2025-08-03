import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/assets/images/app_svg_icons.dart';
import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/features/onboarding/ui/widgets/page_widget.dart';
import 'package:places_surf/features/settings/bloc/settings_bloc.dart';
import 'package:places_surf/uikit/buttons/main_button.dart';
import 'package:places_surf/uikit/buttons/text_button_widget.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

@RoutePage()
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void changeIndex(value) {
    setState(() {
      pageIndex = value;
    });
  }

  void onProceed() {
    context.pop();
    context.read<SettingsBloc>().add(OnboardingFinished());
  }

  @override
  Widget build(BuildContext context) {
    final appTextTheme = AppTextTheme.of(context);
    final appColorTheme = AppColorTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          TextButtonWidget(
            title: AppStrings.onboardingSkipButton,
            onPressed: onProceed,
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Center(
              child: PageView(
                onPageChanged: changeIndex,
                controller: pageController,
                children: [
                  PageWidget(
                    svgPath: AppSvgIcons.onboardingPage1,
                    title: AppStrings.onboardingPage1Title,
                    description: AppStrings.onboardingPage1Description,
                  ),
                  PageWidget(
                    svgPath: AppSvgIcons.onboardingPage2,
                    title: AppStrings.onboardingPage2Title,
                    description: AppStrings.onboardingPage2Description,
                  ),
                  PageWidget(
                    svgPath: AppSvgIcons.onboardingPage3,
                    title: AppStrings.onboardingPage3Title,
                    description: AppStrings.onboardingPage3Description,
                  ),
                ],
              ),
            ),
          ),
          SmoothPageIndicator(
            controller: pageController,
            count: 3,
            effect: ExpandingDotsEffect(
              dotHeight: 8.r,
              dotWidth: 8.r,
              dotColor: appColorTheme.secondaryVariant.withValues(alpha: 0.56),
              activeDotColor: appColorTheme.accent,
            ),
          ),
          SizedBox(height: 32.h),
          SizedBox(
            height: 64.h,
            width: double.infinity,
            child:
                pageIndex != 2
                    ? SizedBox()
                    : Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.h,
                        horizontal: 16.w,
                      ),
                      child: MainButton(
                        onPressed: onProceed,
                        child: Text(AppStrings.onboardingStartButton),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
