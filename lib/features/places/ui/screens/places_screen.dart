import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/common/domain/entities/search_place_query.dart';
import 'package:places_surf/features/places/bloc/places_bloc.dart';
import 'package:places_surf/features/places/ui/widgets/place_card_widget.dart';
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

    return BlocBuilder<PlacesBloc, PlacesState>(
      builder: (context, placesState) {
        return Scaffold(
          appBar: AppBar(title: Center(child: Text('Surf Places'))),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: AppTextField(
                  onChanged: onChanged,
                  hintText: AppStrings.searchBar,
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.list),
                  ),
                ),
              ),
              //TODO Устранить повторения
              switch (placesState) {
                PlacesInitial() => Padding(
                  padding: EdgeInsets.only(top: screenHeight / 2 - 100),
                  child: Center(child: CircularProgressIndicator()),
                ),
                LoadingPlacesState() => Padding(
                  padding: EdgeInsets.only(top: screenHeight / 2 - 100),
                  child: Center(child: CircularProgressIndicator()),
                ),
                ErrorPlacesState() => Center(
                  child: Text(
                    'Ошибка ${placesState.msg}',
                    style: appTextTheme.title.copyWith(
                      color: appColorTheme.error,
                    ),
                  ),
                ),
                LoadedPlacesState() => Expanded(
                  child: RefreshIndicator.adaptive(
                    onRefresh: refresh,
                    child: ListView.builder(
                      itemCount: placesState.places.length,
                      padding: EdgeInsets.all(8),
                      itemBuilder:
                          (context, index) =>
                              PlaceCardWidget(place: placesState.places[index]),
                    ),
                  ),
                ),
              },
            ],
          ),
        );
      },
    );
  }
}
