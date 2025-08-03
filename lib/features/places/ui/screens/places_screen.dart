import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/assets/images/app_svg_icons.dart';
import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/common/domain/entities/search_place_query.dart';
import 'package:places_surf/common/ui/widgets/empty_screen_widget.dart';
import 'package:places_surf/common/ui/widgets/error_screen_widget.dart';
import 'package:places_surf/features/places/bloc_places/places_bloc.dart';
import 'package:places_surf/features/places/ui/widgets/places_custom_scroll.dart';
import 'package:places_surf/features/search/bloc/search_places_bloc.dart';
import 'package:places_surf/features/search/ui/widgets/search_places_content.dart';
import 'package:places_surf/features/settings/bloc/settings_bloc.dart';
import 'package:places_surf/router/app_router.gr.dart';
import 'package:places_surf/uikit/buttons/icon_action_button.dart';
import 'package:places_surf/uikit/images/svg_picture_widget.dart';
import 'package:places_surf/uikit/loading/large_progress_indicator.dart';
import 'package:places_surf/uikit/themes/app_theme_data.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:places_surf/uikit/themes/input/app_text_field.dart';

@RoutePage()
class PlacesScreen extends StatefulWidget {
  const PlacesScreen({super.key});

  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  String text = '';
  late FocusNode focusNode;
  late TextEditingController _controller;
  bool showCategories = true;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    _controller = TextEditingController();
    focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    toggleSuffixButton(_controller.text);
  }

  Future<void> refresh() async {
    context.read<PlacesBloc>().add(FetchPlacesEvent());
  }

  void toggleSuffixButton(String value) {
    if (value != '' || focusNode.hasFocus) {
      setState(() {
        showCategories = false;
      });
    } else {
      setState(() {
        showCategories = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final appTextTheme = AppTextTheme.of(context);
    final appColorTheme = AppColorTheme.of(context);

    final double screenHeight = MediaQuery.of(context).size.height;
    // final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    void openFiltersScreen() {
      context.pushRoute(FilterRoute());
    }

    void onChanged(String value) {
      toggleSuffixButton(value);
      setState(() {
        text = value;
      });
      final SearchPlaceQuery sp = SearchPlaceQuery(value);
      context.read<SearchPlacesBloc>().add(SearchQueryChanged(sp));
    }

    void clearTextField() {
      if (_controller.text == '') {
        setState(() {
          FocusScope.of(context).unfocus();
        });
        return;
      }
      _controller.clear();
      final SearchPlaceQuery sp = SearchPlaceQuery('');
      context.read<SearchPlacesBloc>().add(SearchQueryChanged(sp));
    }

    changeSystemUIColor() {
      final color1 = AppThemeData.darkTheme.scaffoldBackgroundColor;
      final color2 = AppThemeData.lightTheme.scaffoldBackgroundColor;
      final brightness = Theme.of(context).brightness;
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor:
              brightness == Brightness.light ? color1 : color2,
          systemNavigationBarIconBrightness: brightness,
        ),
      );
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<SearchPlacesBloc, SearchPlacesState>(
          listener: (context, state) {
            if (state is LoadedSearchPlacesState) {
              final restoredQuery = state.currentQuery;
              if (_controller.text != restoredQuery) {
                _controller.text = restoredQuery;
                _controller.selection = TextSelection.collapsed(
                  offset: restoredQuery.length,
                );
              }
            }
          },
        ),
        BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) async {
            if (state is SettingsLoaded &&
                !state.settings.didFinishOnboarding) {
              context.pushRoute(OnboardingRoute());
            }
            // await Future.delayed(Duration(milliseconds: 1000));
            changeSystemUIColor();
          },
        ),
      ],
      child: BlocBuilder<PlacesBloc, PlacesState>(
        builder: (context, placesState) {
          return Scaffold(
            appBar: AppBar(
              title: Center(child: Text(AppStrings.placesScreenAppBarTitle)),
            ),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.r,
                    vertical: 6.r,
                  ),
                  child: AppTextField(
                    controller: _controller,
                    focusNode: focusNode,
                    onChanged: onChanged,
                    hintText: AppStrings.searchBar,
                    prefixIcon: SvgPictureWidget(
                      AppSvgIcons.icSearch,
                      color: appColorTheme.inactive,
                      fit: BoxFit.scaleDown,
                      width: 24.w,
                      height: 24.h,
                    ),
                    suffixIcon:
                        showCategories
                            ? IconActionButton(
                              onPressed: openFiltersScreen,
                              color: appColorTheme.accent,
                              svgPath: AppSvgIcons.icFilter,
                            )
                            : IconActionButton(
                              onPressed: clearTextField,
                              svgPath: AppSvgIcons.icClear,
                              color: appColorTheme.textPrimary,
                            ),
                  ),
                ),
                switch (placesState) {
                  PlacesInitial() => Padding(
                    padding: EdgeInsets.only(top: screenHeight - 220.h - 400),
                    child: Center(child: LargeProgressIndicator()),
                  ),
                  LoadingPlacesState() => Padding(
                    padding: EdgeInsets.only(top: screenHeight - 220.h - 400),
                    child: Center(child: LargeProgressIndicator()),
                  ),
                  ErrorPlacesState() => ErrorScreenWidget(),
                  LoadedPlacesState() => Builder(
                    builder: (context) {
                      if (placesState.places.isNotEmpty) {
                        if (focusNode.hasFocus || _controller.text.isNotEmpty) {
                          return SearchPlacesContent();
                        }
                        return Flexible(
                          child: PlacesCustomScroll(
                            places: placesState.places,
                            onRefresh: refresh,
                          ),
                        );
                      } else {
                        return SizedBox(
                          height: screenHeight - 220.h,
                          child: EmptyScreenWidget(onRefresh: () {}),
                        );
                      }
                    },
                  ),
                },
              ],
            ),
          );
        },
      ),
    );
  }
}
