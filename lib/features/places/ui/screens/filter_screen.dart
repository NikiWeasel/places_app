import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/assets/images/app_svg_icons.dart';
import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/features/places/ui/widgets/category_button.dart';
import 'package:places_surf/features/places/ui/widgets/range_slider_widget.dart';
import 'package:places_surf/uikit/buttons/back_button_widget.dart';
import 'package:places_surf/uikit/buttons/main_button.dart';
import 'package:places_surf/uikit/buttons/text_button_widget.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';

@RoutePage()
class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late Map<PlaceType, bool> map;
  RangeValues currentRange = const RangeValues(0, 10);

  @override
  void initState() {
    super.initState();
    map = {
      PlaceType.hotel: false,
      PlaceType.restaurant: false,
      PlaceType.other: false,
      PlaceType.park: false,
      PlaceType.museum: false,
      PlaceType.cafe: false,
      PlaceType.monument: false,
      PlaceType.shopping: false,
      PlaceType.theatre: false,
      PlaceType.temple: false,
    };
  }

  void toggleMapValue(PlaceType placeType) {
    setState(() {
      map[placeType] = !map[placeType]!;
    });
  }

  void changeRange(RangeValues rv) {
    setState(() {
      currentRange = rv;
    });
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

    return Scaffold(
      appBar: AppBar(
        leading: BackButtonWidget(),
        actions: [
          TextButtonWidget(
            title: AppStrings.filterScreenAppBarClearButton,
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
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
                    onPressed: () {},
                    child: Text(AppStrings.filterScreenShowButton),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
