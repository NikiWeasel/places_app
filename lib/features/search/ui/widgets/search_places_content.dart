import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/common/domain/entities/search_place_query.dart';
import 'package:places_surf/common/ui/widgets/error_screen_widget.dart';
import 'package:places_surf/features/search/bloc/search_places_bloc.dart';
import 'package:places_surf/features/search/ui/widgets/ex_search_query_tile.dart';
import 'package:places_surf/features/search/ui/widgets/search_result_empty_widget.dart';
import 'package:places_surf/features/search/ui/widgets/search_result_place_tile.dart';
import 'package:places_surf/uikit/buttons/text_button_widget.dart';
import 'package:places_surf/uikit/loading/small_progress_indicator.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';

class SearchPlacesContent extends StatelessWidget {
  const SearchPlacesContent({super.key});

  @override
  Widget build(BuildContext context) {
    void onDelete(String searchString) {
      context.read<SearchPlacesBloc>().add(DeleteExSearchQuery(searchString));
    }

    void onHintTap(String value) {
      context.read<SearchPlacesBloc>().add(
        SearchQueryChanged(SearchPlaceQuery(value)),
      );
    }

    void clear() {
      context.read<SearchPlacesBloc>().add(CleanAllExSearchQuery());
    }

    return BlocBuilder<SearchPlacesBloc, SearchPlacesState>(
      builder: (context, state) {
        final appTextTheme = AppTextTheme.of(context);
        final appColorTheme = AppColorTheme.of(context);

        final double screenHeight = MediaQuery.of(context).size.height;

        if (state is LoadedSearchPlacesState) {
          final places = state.places;
          final query = state.currentQuery;
          final queriesList = state.sQueries;

          if (query == '') {
            if (queriesList.isEmpty) {
              return SizedBox();
            }
            return Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(height: 24.h),

                  Padding(
                    padding: EdgeInsets.only(left: 16.w, bottom: 4.h),
                    child: Text(
                      AppStrings.searchScreenExSearchStrings,
                      style: appTextTheme.superSmall.copyWith(
                        color: appColorTheme.secondaryVariant.withValues(
                          alpha: 56,
                        ),
                      ),
                    ),
                  ),
                  ...List.generate(
                    queriesList.length,
                    (index) => Column(
                      children: [
                        ExSearchQueryTile(
                          label: queriesList[index],
                          onTap: () => onHintTap(queriesList[index]),
                          onDelete: () => onDelete(queriesList[index]),
                        ),
                        if (index != queriesList.length - 1)
                          Divider(indent: 16.w, endIndent: 16.w),
                      ],
                    ),
                  ),
                  TextButtonWidget(
                    title: AppStrings.searchScreenEmptyClearExSearchStrings,
                    onPressed: clear,
                  ),
                ],
              ),
            );
          } else {
            if (places.isEmpty) {
              return SizedBox(
                height: screenHeight / 2,
                child: SearchResultEmptyWidget(),
              );
            } else {
              return Flexible(
                child: ListView.separated(
                  itemBuilder:
                      (context, index) => SearchResultPlaceTile(
                        place: places[index],
                        searchQuery: query,
                      ),
                  separatorBuilder:
                      (context, index) =>
                          Divider(indent: 88.w, endIndent: 16.w),
                  itemCount: places.length,
                ),
              );
            }
          }
        }
        if (state is LoadingSearchPlacesState) {
          return SizedBox(
            height: screenHeight / 2,
            child: SmallProgressIndicator(),
          );
        }
        return SizedBox(height: screenHeight / 2, child: ErrorScreenWidget());
      },
    );
  }
}
