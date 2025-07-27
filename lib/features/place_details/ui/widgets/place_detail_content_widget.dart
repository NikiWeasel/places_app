import 'package:flutter/cupertino.dart';
import 'package:places_surf/common/data/dto/place_dto.dart';
import 'package:places_surf/common/domain/entities/place.dart';
import 'package:places_surf/uikit/themes/text/app_text_theme.dart';

class PlaceDetailContentWidget extends StatelessWidget {
  const PlaceDetailContentWidget({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    final textTheme = AppTextTheme.base();

    return Column(
      children: [
        Container(
          // height: 120,
          width: double.infinity,
          padding: EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                place.name,
                style: textTheme.title.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                place.type.name,
                style: textTheme.subtitle.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                place.description,
                softWrap: true,
                // maxLines: 3,
                overflow: TextOverflow.fade,
                style: textTheme.text.copyWith(fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
