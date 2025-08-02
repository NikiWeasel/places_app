import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:places_surf/app/di/app_dependencies.dart';
import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/features/map/bloc/map_bloc.dart';
import 'package:places_surf/features/map/data/services/map_service.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
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
  //   _mapWindow?.map.nightModeEnabled =
  //       Theme.of(context).brightness == Brightness.dark;
  // }

  @override
  Widget build(BuildContext context) {
    final appTextTheme = AppTextTheme.of(context);
    final appColorTheme = AppColorTheme.of(context);

    return BlocBuilder<MapBloc, MapState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Center(
              child: Text(
                AppStrings.placesScreenBottomNavMap,
                // style: appTextTheme.subtitle,
              ),
            ),
          ),
          body: switch (state) {
            MapInitial() => Center(child: CircularProgressIndicator()),
            MapLoading() => Center(child: CircularProgressIndicator()),
            MapLoaded() => YandexMap(
              onMapCreated: (mapWindow) {
                final controller = getIt<MapService>();
                controller.init(mapWindow);

                _userLocationLayer =
                    mapkit.createUserLocationLayer(mapWindow)
                      ..headingModeActive = true
                      ..setVisible(false);

                // _userLocationLayer.
              },
            ),
            MapError() => Center(
              child: Text(
                '${AppStrings.placesError} ${state.msg}',
                style: appTextTheme.title.copyWith(color: appColorTheme.error),
              ),
            ),
          },
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (widget.point != null) {
                context.read<MapBloc>().add(
                  BuildNewRouteMapEvent(widget.point!),
                );
              } else {
                context.read<MapBloc>().add(ToDefaultPointMapEvent());
              }
            },
          ),
        );
      },
    );
  }
}
