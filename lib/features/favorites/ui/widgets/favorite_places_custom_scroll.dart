import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/features/favorites/ui/widgets/dismiss_container.dart';
import 'package:places_surf/features/places/bloc_places/places_bloc.dart';
import 'package:places_surf/features/places/ui/widgets/place_card_widget.dart';
import 'package:places_surf/features/places/ui/widgets/refresh_indicator_delegate.dart';

class FavoriteCustomScroll extends StatefulWidget {
  const FavoriteCustomScroll({
    super.key,
    required this.places,
    required this.onRefresh,
  });

  final List<Place> places;
  final Future<void> Function() onRefresh;

  @override
  State<FavoriteCustomScroll> createState() => _FavoriteCustomScrollState();
}

class _FavoriteCustomScrollState extends State<FavoriteCustomScroll> {
  double dragOffset = 0.0;
  bool isLoading = false;

  static const double triggerOffset = 100;

  Future<void> _onRefresh() async {
    setState(() => isLoading = true);
    await Future.delayed(Duration(milliseconds: 500));
    await widget.onRefresh();
    setState(() {
      isLoading = false;
      dragOffset = 0;
    });
  }

  bool _handleScroll(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final offset = notification.metrics.pixels;
      // debugPrint('Offset: $offset');

      if (offset < 0) {
        setState(() {
          dragOffset = -offset;
        });

        if (dragOffset >= triggerOffset && !isLoading) {
          _onRefresh();
        }
      }
    }

    if (notification is ScrollEndNotification && !isLoading) {
      setState(() => dragOffset = 0);
    }

    return false;
  }

  void onDismissed(Place place) {
    context.read<PlacesBloc>().add(ToggleFavoritePlace(place: place));
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScroll,
      child: CustomScrollView(
        // physics: const BouncingScrollPhysics(),
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),

        slivers: [
          // Индикатор загрузки
          SliverPersistentHeader(
            pinned: false,
            delegate: RefreshIndicatorDelegate(
              dragOffset: dragOffset,
              isLoading: isLoading,
              // maxExtentValue: triggerOffset,
            ),
          ),

          // Список
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16.r),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: EdgeInsets.only(top: 24.r),
                  child: Stack(
                    clipBehavior: Clip.hardEdge,
                    children: <Widget>[
                      DismissContainer(), // instead of background
                      Dismissible(
                        key: ValueKey('Dismissible-$index'),
                        direction: DismissDirection.endToStart,

                        onDismissed: (d) {
                          onDismissed(widget.places[index]);
                        },
                        child: PlaceCardWidget(
                          place: widget.places[index], // ваш список мест
                          onShare: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                childCount: widget.places.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
