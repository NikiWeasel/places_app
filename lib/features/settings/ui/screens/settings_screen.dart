import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/common/ui/widgets/error_screen_widget.dart';
import 'package:places_surf/features/settings/bloc/settings_bloc.dart';
import 'package:places_surf/features/settings/ui/widgets/theme_switch_button.dart';
import 'package:places_surf/features/settings/ui/widgets/tutorial_button.dart';
import 'package:places_surf/router/app_router.gr.dart';
import 'package:places_surf/uikit/loading/large_progress_indicator.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void onTutorialTap() {
      context.pushRoute(OnboardingRoute());
    }

    void onToggle() {
      context.read<SettingsBloc>().add(ToggleTheme());
    }

    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        // print(state);
        if (state is SettingsLoading || state is SettingsInitial) {
          return Center(child: LargeProgressIndicator());
        }
        if (state is SettingsError) {
          return Center(child: ErrorScreenWidget());
        }
        if (state is SettingsLoaded) {
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(AppStrings.settingsScreenAppBarTitle),
            ),
            body: Column(
              children: [
                SizedBox(height: 24.h),
                ThemeSwitchButton(
                  onToggle: onToggle,
                  initValue: state.settings.isDark,
                ),
                Divider(indent: 16.w, endIndent: 16.w),
                TutorialButton(onTap: onTutorialTap),
              ],
            ),
          );
        }
        return Center(child: ErrorScreenWidget());
      },
    );
  }
}
