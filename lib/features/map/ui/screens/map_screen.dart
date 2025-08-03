import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/app/di/app_dependencies.dart';
import 'package:places_surf/assets/images/app_svg_icons.dart';
import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/common/domain/entities/search_place_query.dart';
import 'package:places_surf/common/ui/widgets/empty_screen_widget.dart';
import 'package:places_surf/common/ui/widgets/error_screen_widget.dart';
import 'package:places_surf/features/map/bloc/map_bloc.dart';
import 'package:places_surf/features/map/data/services/map_service.dart';
import 'package:places_surf/features/places/bloc_places/places_bloc.dart';
import 'package:places_surf/features/search/bloc/search_places_bloc.dart';
import 'package:places_surf/features/search/ui/widgets/search_places_content.dart';
import 'package:places_surf/router/app_router.gr.dart';
import 'package:places_surf/uikit/buttons/icon_action_button.dart';
import 'package:places_surf/uikit/images/svg_picture_widget.dart';
import 'package:places_surf/uikit/loading/large_progress_indicator.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:places_surf/uikit/themes/input/app_text_field.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/mapkit_factory.dart';
import 'package:yandex_maps_mapkit/yandex_map.dart';

@RoutePage()
class MapScreen extends StatefulWidget {
  const MapScreen({super.key, required this.point});

  final Point? point;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final AppLifecycleListener _lifecycleListener;

  // MapWindow? _mapWindow;
  bool _isMapkitActive = false;
  late final UserLocationLayer _userLocationLayer;

  // late final MapDeps mapDeps;

  String text = '';
  late FocusNode focusNode;
  late TextEditingController _controller;
  bool showCategories = true;

  bool wasMapInited = false;

  @override
  void initState() {
    super.initState();
    _startMapkit();

    _lifecycleListener = AppLifecycleListener(
      onResume: () {
        _startMapkit();
        // _setMapTheme();
      },
      onInactive: () {
        _stopMapkit();
      },
    );
    focusNode = FocusNode();
    _controller = TextEditingController();
    focusNode.addListener(_onFocusChange);
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
  void didUpdateWidget(covariant MapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    print('MapScreen updated');

    if (widget.point != null) {
      context.read<MapBloc>().add(BuildNewRouteMapEvent(widget.point!));
    } else {
      context.read<MapBloc>().add(ToDefaultPointMapEvent());
    }
  }

  @override
  void dispose() {
    _stopMapkit();
    _lifecycleListener.dispose();
    focusNode.dispose();
    _controller.dispose();
    // widget.onMapDispose?.call();
    super.dispose();
  }

  void _startMapkit() {
    if (!_isMapkitActive) {
      _isMapkitActive = true;
      mapkit.onStart();
    }
  }

  void _stopMapkit() {
    if (_isMapkitActive) {
      _isMapkitActive = false;
      mapkit.onStop();
    }
  }

  // void _setMapTheme() {
  //   mapDeps.mapWindow.map.nightModeEnabled =
  //       Theme.of(context).brightness == Brightness.dark;
  // }

  Place getPlaceByPoint(Point point, List<Place> places) {
    return places
        .where((e) => e.lng == point.longitude && e.lat == point.latitude)
        .first;
  }

  @override
  Widget build(BuildContext context) {
    final appTextTheme = AppTextTheme.of(context);
    final appColorTheme = AppColorTheme.of(context);

    final color =
        Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : appColorTheme.icon;

    final double screenHeight = MediaQuery.of(context).size.height;

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
        _startMapkit();
        return;
      }
      _controller.clear();
      final SearchPlaceQuery sp = SearchPlaceQuery('');
      context.read<SearchPlacesBloc>().add(SearchQueryChanged(sp));
    }

    void drawPOIs(List<Point> points) {
      context.read<MapBloc>().add(BuildPointsMapEvent(points));
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
        BlocListener<PlacesBloc, PlacesState>(
          listener: (context, state) {
            if (state is LoadedPlacesState) {
              final List<Point> points =
                  state.places
                      .map((e) => Point(latitude: e.lat, longitude: e.lng))
                      .toList();
              print(points);
              drawPOIs(points);
            }
          },
        ),
      ],
      child: BlocBuilder<PlacesBloc, PlacesState>(
        builder: (context, placesState) {
          return BlocBuilder<MapBloc, MapState>(
            builder: (context, state) {
              if (placesState is ErrorPlacesState || state is MapError) {
                return Center(child: ErrorScreenWidget());
              }
              if (placesState is! LoadedPlacesState) {
                return Center(child: LargeProgressIndicator());
              }
              return Scaffold(
                appBar: AppBar(
                  title: Center(
                    child: Text(
                      AppStrings.placesScreenBottomNavMap,
                      // style: appTextTheme.subtitle,
                    ),
                  ),
                ),
                body: SizedBox(
                  height: screenHeight,
                  child: Column(
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
                      switch (state) {
                        MapInitial() => Center(child: LargeProgressIndicator()),
                        MapLoading() => Center(child: LargeProgressIndicator()),
                        MapLoaded() => Builder(
                          builder: (context) {
                            if (placesState.places.isNotEmpty) {
                              if (focusNode.hasFocus ||
                                  _controller.text.isNotEmpty) {
                                return SearchPlacesContent();
                              }
                              return Expanded(
                                child: Stack(
                                  children: [
                                    YandexMap(
                                      onMapCreated: (mapWindow) {
                                        if (!wasMapInited) {
                                          final controller =
                                              getIt<MapService>();
                                          controller.init(mapWindow);

                                          // _userLocationLayer =
                                          //     mapkit.createUserLocationLayer(
                                          //         mapWindow,
                                          //       )
                                          //       ..headingModeActive = true
                                          //       ..setVisible(false);
                                          wasMapInited = true;
                                        }

                                        // mapkit.create

                                        // _userLocationLayer.
                                      },
                                    ),
                                    // Positioned(
                                    //   child: PlaceCardWidget(
                                    //     place: getPlaceByPoint(
                                    //       state.selectedPoint,
                                    //       placesState.places,
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
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
                        MapError() => ErrorScreenWidget(),
                      },
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor:
                      Theme.of(context).brightness == Brightness.light
                          ? Colors.white
                          : appColorTheme.secondary,
                  child: SvgPictureWidget(
                    AppSvgIcons.icGeolocation,
                    height: 32.r,
                    width: 32.r,
                    color: color,
                  ),
                  onPressed: () {
                    context.read<MapBloc>().add(ToDefaultPointMapEvent());
                    // if (widget.point != null) {
                    //   context.read<MapBloc>().add(
                    //     BuildNewRouteMapEvent(widget.point!),
                    //   );
                    // } else {
                    //   context.read<MapBloc>().add(ToDefaultPointMapEvent());
                    // }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
