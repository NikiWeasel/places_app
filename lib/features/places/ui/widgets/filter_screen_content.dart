import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/assets/images/app_svg_icons.dart';
import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/features/places/bloc_categories/categories_bloc.dart';
import 'package:places_surf/features/places/bloc_places/places_bloc.dart';
import 'package:places_surf/features/places/ui/widgets/category_button.dart';
import 'package:places_surf/features/places/ui/widgets/range_slider_widget.dart';
import 'package:places_surf/uikit/buttons/main_button.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';

class FilterScreenContent extends StatefulWidget {
  const FilterScreenContent({
    super.key,
    required this.presetRange,
    required this.presetPlaceTypes,
    required this.allPlaces,
    required this.filteredPlaces,
  });

  final List<Place> allPlaces;
  final List<Place>? filteredPlaces;
  final RangeValues presetRange;
  final List<PlaceType> presetPlaceTypes;

  @override
  State<FilterScreenContent> createState() => _FilterScreenContentState();
}

class _FilterScreenContentState extends State<FilterScreenContent> {
  late Map<PlaceType, bool> map;
  late RangeValues currentRange;

  late final CategoriesBloc bloc;

  @override
  void didUpdateWidget(covariant FilterScreenContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (!setEquals(
      widget.presetPlaceTypes.toSet(),
      oldWidget.presetPlaceTypes.toSet(),
    )) {
      final Set<PlaceType> presetSet = widget.presetPlaceTypes.toSet();
      setState(() {
        map = {
          for (final type in PlaceType.values) type: presetSet.contains(type),
        };
      });
    }

    if (widget.presetRange != oldWidget.presetRange) {
      setState(() {
        currentRange = widget.presetRange;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final Set<PlaceType> presetSet = widget.presetPlaceTypes.toSet();
    map = {for (final type in PlaceType.values) type: presetSet.contains(type)};

    currentRange = widget.presetRange;
    bloc = context.read<CategoriesBloc>();
  }

  void toggleMapValue(PlaceType placeType) {
    setState(() {
      map[placeType] = !map[placeType]!;
    });
    onFilterChanged();
  }

  void changeRange(RangeValues rv) {
    setState(() {
      currentRange = rv;
    });
    onFilterChanged();
  }

  void onFilterChanged() {
    final List<PlaceType> placesList =
        map.entries
            .where((entry) => entry.value)
            .map((entry) => entry.key)
            .toList();

    bloc.add(
      FilterPlaces(
        places: widget.allPlaces,
        rangeValues: currentRange,
        placeTypes: placesList,
      ),
    );
  }

  void showFilteredPlaces() {
    if (widget.filteredPlaces == null) return;
    context.read<PlacesBloc>().add(
      SetFilteredPlaces(places: widget.filteredPlaces!),
    );
    context.pop();
  }

  String _iconPathFor(PlaceType type) {
    switch (type) {
      case PlaceType.other:
        return AppSvgIcons.icOther;
      case PlaceType.park:
        return AppSvgIcons.icPark;
      case PlaceType.monument:
        return AppSvgIcons.icMonument;
      case PlaceType.theatre:
        return AppSvgIcons.icTheatre;
      case PlaceType.museum:
        return AppSvgIcons.icMuseum;
      case PlaceType.temple:
        return AppSvgIcons.icTemple;
      case PlaceType.hotel:
        return AppSvgIcons.icHotel;
      case PlaceType.restaurant:
        return AppSvgIcons.icRestaurant;
      case PlaceType.cafe:
        return AppSvgIcons.icCafe;
      case PlaceType.shopping:
        return AppSvgIcons.icOther;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTextTheme = AppTextTheme.of(context);
    final appColorTheme = AppColorTheme.of(context);

    print(widget.filteredPlaces);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      AppStrings.filterScreenCategories,
                      style: appTextTheme.superSmall.copyWith(
                        color: appColorTheme.secondaryVariant.withValues(
                          alpha: 0.56,
                        ),
                      ),
                    ),
                    Center(
                      child: Wrap(
                        children:
                            PlaceType.values.map((type) {
                              return CategoryButton(
                                isSelected: map[type] ?? false,
                                title: type.label,
                                svgPath: _iconPathFor(type),
                                onTap: () {
                                  toggleMapValue(type);
                                },
                              );
                            }).toList(),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          AppStrings.filterScreenDistance,
                          style: appTextTheme.text,
                        ),
                        Spacer(),
                        Text(
                          '${AppStrings.filterScreenFrom} ${currentRange.start.toInt()} ${AppStrings.filterScreenTo} ${currentRange.end.toInt()} ${AppStrings.filterScreenKM}',
                          style: appTextTheme.text.copyWith(
                            color: appColorTheme.secondaryVariant,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    RangeSliderWidget(
                      currentRange: currentRange,
                      changeRange: changeRange,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: SizedBox(
                width: double.infinity,
                child: MainButton(
                  onPressed: showFilteredPlaces,
                  child:
                      widget.filteredPlaces != null
                          ? Text(
                            '${AppStrings.filterScreenShowButton} (${widget.filteredPlaces!.length})',
                          )
                          : Text(AppStrings.filterScreenShowButton),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
