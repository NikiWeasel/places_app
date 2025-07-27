import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:places_surf/common/data/dto/place_dto.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/features/place_details/ui/screens/place_details_screen.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';

class PlaceCardWidget extends StatelessWidget {
  const PlaceCardWidget({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.of(context);
    final colorTheme = AppColorTheme.of(context);

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PlaceDetailsScreen(place: place),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            SizedBox(
              height: 160,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,

                children: [
                  if (place.urls.isNotEmpty)
                    Image.network(fit: BoxFit.cover, place.urls.first),

                  Positioned(
                    left: 16,
                    top: 16,
                    child: Text(
                      place.type.name,
                      style: textTheme.smallBold.copyWith(
                        color: colorTheme.neutralWhite,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.favorite_border, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 120,
              width: double.infinity,
              padding: EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: textTheme.text.copyWith(
                      color: colorTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Text(
                    place.description,
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.small.copyWith(
                      color: colorTheme.textSecondaryVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
