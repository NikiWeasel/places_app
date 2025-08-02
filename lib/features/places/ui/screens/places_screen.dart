import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/assets/images/app_svg_icons.dart';
import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/common/domain/entities/search_place_query.dart';
import 'package:places_surf/common/ui/widgets/empty_screen_widget.dart';
import 'package:places_surf/common/ui/widgets/error_screen_widget.dart';
import 'package:places_surf/features/places/bloc_places/places_bloc.dart';
import 'package:places_surf/features/places/ui/widgets/places_custom_scroll.dart';
import 'package:places_surf/router/app_router.gr.dart';
import 'package:places_surf/uikit/buttons/icon_action_button.dart';
import 'package:places_surf/uikit/images/svg_picture_widget.dart';
import 'package:places_surf/uikit/loading/large_progress_indicator.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:places_surf/uikit/themes/input/app_text_field.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';

@RoutePage()
class PlacesScreen extends StatelessWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appTextTheme = AppTextTheme.of(context);
    final appColorTheme = AppColorTheme.of(context);

    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    void openFiltersScreen() {
      context.pushRoute(FilterRoute());
    }

    Future<void> refresh() async {
      context.read<PlacesBloc>().add(FetchPlacesEvent());
    }

    void onChanged(String value) {
      if (value == '') {
        refresh();
        return;
      }
      final SearchPlaceQuery sp = SearchPlaceQuery(value);
      context.read<PlacesBloc>().add(SearchQueryChanged(sp));
    }

    print(keyboardHeight);
    return BlocBuilder<PlacesBloc, PlacesState>(
      builder: (context, placesState) {
        return Scaffold(
          appBar: AppBar(
            title: Center(child: Text(AppStrings.placesScreenAppBarTitle)),
          ),
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 6.r),
                child: AppTextField(
                  onChanged: onChanged,
                  hintText: AppStrings.searchBar,
                  prefixIcon: SvgPictureWidget(
                    AppSvgIcons.icSearch,
                    color: appColorTheme.inactive,
                    fit: BoxFit.scaleDown,
                    width: 24.w,
                    height: 24.h,
                  ),
                  suffixIcon: IconActionButton(
                    onPressed: openFiltersScreen,
                    color: appColorTheme.accent,
                    svgPath: AppSvgIcons.icFilter,
                  ),
                ),
              ),
              //TODO Устранить повторения
              switch (placesState) {
                PlacesInitial() => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: screenHeight - 220.h - 400),
                    child: Center(child: LargeProgressIndicator()),
                  ),
                ),
                LoadingPlacesState() => Padding(
                  padding: EdgeInsets.only(top: screenHeight - 220.h - 400),
                  child: Center(child: LargeProgressIndicator()),
                ),
                ErrorPlacesState() => ErrorScreenWidget(),
                LoadedPlacesState() =>
                  placesState.places.isNotEmpty
                      ? Flexible(
                        child: PlacesCustomScroll(
                          places: placesState.places,
                          onRefresh: refresh,
                        ),
                      )
                      : SizedBox(
                        height: screenHeight - 220.h,
                        child: EmptyScreenWidget(onRefresh: () {}),
                      ),
              },
            ],
          ),
        );
      },
    );
  }
}
