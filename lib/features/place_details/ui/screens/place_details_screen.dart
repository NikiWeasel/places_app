import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/features/place_details/ui/widgets/place_detail_content_widget.dart';
import 'package:places_surf/features/place_details/ui/widgets/places_detail_photo_slider_widget.dart';

@RoutePage()
class PlaceDetailsScreen extends StatelessWidget {
  const PlaceDetailsScreen({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 360,

            flexibleSpace: PlacesDetailPhotoSliderWidget(
              placeImages: place.images,
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: PlaceDetailContentWidget(place: place),
              ),
              const SizedBox(height: 24),

              // MainButton(onPressed: () {}, child: Text('data')),
              // TextButtonWidget(title: 'title', onPressed: () {}),
              ElevatedButton.icon(
                icon: Icon(Icons.route),
                label: Text('Построить маршрут'),
                onPressed: () {},
              ),
              const SizedBox(height: 24),
              Divider(indent: 16, endIndent: 16),
              const SizedBox(height: 8),
              TextButton.icon(onPressed: () {}, label: Text('В Избранное')),
            ]),
          ),
        ],
      ),
    );
  }
}
