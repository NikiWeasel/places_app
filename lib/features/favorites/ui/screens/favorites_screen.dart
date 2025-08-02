import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/common/ui/widgets/empty_screen_widget.dart';
import 'package:places_surf/features/favorites/bloc/favorite_places_bloc.dart';
import 'package:places_surf/features/favorites/ui/widgets/favorite_places_custom_scroll.dart';
import 'package:places_surf/uikit/loading/large_progress_indicator.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';

@RoutePage()
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appTextTheme = AppTextTheme.of(context);
    final appColorTheme = AppColorTheme.of(context);

    final double screenHeight = MediaQuery.of(context).size.height;

    Future<void> refresh() async {
      context.read<FavoritePlacesBloc>().add(FetchFavoritePlacesEvent());
    }

    return BlocBuilder<FavoritePlacesBloc, FavoritePlacesState>(
      builder: (context, placesState) {
        return Scaffold(
          appBar: AppBar(
            title: Center(child: Text(AppStrings.placesScreenAppBarTitle)),
          ),
          body: switch (placesState) {
            FavoritePlacesInitial() => Center(child: LargeProgressIndicator()),
            LoadingFavoritePlacesState() => Center(
              child: LargeProgressIndicator(),
            ),
            ErrorFavoritePlacesState() => Center(
              child: Text(
                '${AppStrings.placesError} ${placesState.msg}',
                style: appTextTheme.title.copyWith(color: appColorTheme.error),
              ),
            ),
            LoadedFavoritePlacesState() =>
              placesState.places.isEmpty
                  ? Center(child: EmptyScreenWidget(onRefresh: refresh))
                  : FavoriteCustomScroll(
                    places: placesState.places,
                    onRefresh: refresh,
                  ),
          },
        );
      },
    );
  }
}
