import 'package:flutter/material.dart';
import 'package:places_surf/assets/images/app_svg_icons.dart';
import 'package:places_surf/uikit/loading/icon_progress_indicator.dart';

class RefreshIndicatorDelegate extends SliverPersistentHeaderDelegate {
  final bool isLoading;
  final double dragOffset;
  final double maxHeight;

  RefreshIndicatorDelegate({
    required this.isLoading,
    required this.dragOffset,
    this.maxHeight = 60,
  });

  @override
  double get minExtent => isLoading ? maxHeight : 0;

  @override
  double get maxExtent =>
      isLoading ? maxHeight : dragOffset.clamp(0.0, maxHeight);

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    if (!isLoading && dragOffset <= 0) {
      return const SizedBox.shrink();
    }

    final double opacity =
        isLoading ? 1.0 : (dragOffset / maxHeight).clamp(0.0, 1.0);

    return SizedBox(
      height: maxHeight,
      child: Center(
        child: Opacity(
          opacity: opacity,
          child: IconProgressIndicator(
            widget: Image.asset(AppSvgIcons.icLoaderLargeBlack),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant RefreshIndicatorDelegate oldDelegate) {
    return isLoading != oldDelegate.isLoading ||
        dragOffset != oldDelegate.dragOffset;
  }
}
