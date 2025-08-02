import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:places_surf/assets/images/app_svg_icons.dart';
import 'package:places_surf/common/domain/entities/place_images.dart';
import 'package:places_surf/features/place_details/ui/widgets/photos_page_view.dart';
import 'package:places_surf/uikit/buttons/icon_action_button.dart';
import 'package:places_surf/uikit/themes/colors/app_color_theme.dart';

@RoutePage()
class PhotosScreen extends StatefulWidget {
  const PhotosScreen({
    super.key,
    required this.placeImages,
    required this.initialPage,
  });

  final PlaceImages placeImages;
  final int initialPage;

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {
  late String title;
  late int amount;

  @override
  void initState() {
    super.initState();
    if (widget.placeImages is ImagesBytes) {
      amount = (widget.placeImages as ImagesBytes).images.length;
    } else if (widget.placeImages is ImagesUrls) {
      amount = (widget.placeImages as ImagesUrls).urls.length;
    }
    title = '${widget.initialPage + 1}/$amount';
  }

  void onChanged(int index) {
    setState(() {
      title = '${index + 1}/$amount';
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = AppColorTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(title),
        actions: [
          IconActionButton(
            svgPath: AppSvgIcons.icClose,
            color: colorScheme.accent,
            onPressed: context.pop,
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: PhotosPageView(
        placeImages: widget.placeImages,
        onPageChanged: onChanged,
        initialPage: widget.initialPage,
        fit: BoxFit.none,
        heroTag: 'PhotosPageView',
      ),
    );
  }
}
