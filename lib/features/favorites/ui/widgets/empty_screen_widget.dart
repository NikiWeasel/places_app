import 'package:flutter/cupertino.dart';
import 'package:places_surf/assets/strings/app_strings.dart';
import 'package:places_surf/uikit/buttons/text_button_widget.dart';

class EmptyScreenWidget extends StatelessWidget {
  const EmptyScreenWidget({super.key, required this.onRefresh});

  final void Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(AppStrings.favoritePlacesScreenEmpty),
          TextButtonWidget(
            title: AppStrings.favoritePlacesScreenRefresh,
            onPressed: onRefresh,
          ),
        ],
      ),
    );
  }
}
