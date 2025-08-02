import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/features/places/bloc_categories/categories_bloc.dart';
import 'package:places_surf/features/places/bloc_places/places_bloc.dart';
import 'package:places_surf/features/places/ui/widgets/filter_screen_content.dart';
import 'package:places_surf/uikit/buttons/back_button_widget.dart';
import 'package:places_surf/uikit/buttons/text_button_widget.dart';
import 'package:places_surf/uikit/loading/large_progress_indicator.dart';

@RoutePage()
class FilterScreen extends StatelessWidget {
  const FilterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void resetFilters() {
      context.read<CategoriesBloc>().add(ResetFilters());
      context.read<PlacesBloc>().add(ResetPlacesEvent());
    }

    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, catState) {
        return BlocBuilder<PlacesBloc, PlacesState>(
          builder: (context, placeState) {
            if (catState is CategoriesSet && placeState is LoadedPlacesState) {
              return Scaffold(
                appBar: AppBar(
                  leading: BackButtonWidget(),
                  actions: [
                    TextButtonWidget(
                      title: AppStrings.filterScreenAppBarClearButton,
                      onPressed: resetFilters,
                    ),
                  ],
                ),
                body: FilterScreenContent(
                  presetRange: catState.rangeValues,
                  presetPlaceTypes: catState.placeTypes,
                  allPlaces: placeState.places,
                  filteredPlaces: catState.filteredPlaces,
                ),
              );
            } else {
              return Scaffold(
                appBar: AppBar(leading: BackButtonWidget()),
                body: Center(child: LargeProgressIndicator()),
              );
            }
          },
        );
      },
    );
  }
}
