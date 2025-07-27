import 'package:auto_route/annotations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places_surf/features/places/bloc/places_bloc.dart';
import 'package:places_surf/features/places/ui/widgets/place_card_widget.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';

@RoutePage()
class PlacesScreen extends StatelessWidget {
  const PlacesScreen({super.key});

  Future<void> gol() async {
    //TODO placeholder
  }

  @override
  Widget build(BuildContext context) {
    final appTextTheme = AppTextTheme.of(context);
    final appColorTheme = AppColorTheme.of(context);

    return BlocBuilder<PlacesBloc, PlacesState>(
      builder: (context, placesState) {
        if (placesState is LoadedPlacesState) {
          print(placesState.places);
        }
        return Scaffold(
          appBar: AppBar(title: Center(child: Text('Surf Places'))),
          body: switch (placesState) {
            PlacesInitial() => Center(child: CircularProgressIndicator()),
            LoadingPlacesState() => Center(child: CircularProgressIndicator()),
            ErrorPlacesState() => Center(
              child: Text(
                'Ошибка ${placesState.msg}',
                style: appTextTheme.title.copyWith(color: appColorTheme.error),
              ),
            ),
            LoadedPlacesState() => Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.list),
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator.adaptive(
                    onRefresh: gol,
                    child: ListView.builder(
                      itemCount: placesState.places.length,
                      padding: EdgeInsets.all(8),
                      itemBuilder:
                          (context, index) =>
                              PlaceCardWidget(place: placesState.places[index]),
                    ),
                  ),
                ),
              ],
            ),
          },
        );
      },
    );
  }
}
