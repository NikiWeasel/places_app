import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconProgressIndicator extends StatefulWidget {
  final Widget widget;
  final Duration duration;

  const IconProgressIndicator({
    required this.widget,
    this.duration = const Duration(seconds: 1),
    super.key,
  });

  @override
  State<IconProgressIndicator> createState() => _IconProgressIndicatorState();
}

class _IconProgressIndicatorState extends State<IconProgressIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.rotate(
          angle: -(_controller.value * 2 * math.pi),
          child: child,
        );
      },
      child: widget.widget,
    );
  }
}
