import 'package:flutter/material.dart';

class RangeSliderWidget extends StatefulWidget {
  const RangeSliderWidget({
    super.key,
    required this.currentRange,
    required this.changeRange,
  });

  final RangeValues currentRange;
  final void Function(RangeValues) changeRange;

  @override
  State<RangeSliderWidget> createState() => _RangeSliderWidgetState();
}

class _RangeSliderWidgetState extends State<RangeSliderWidget> {
  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: widget.currentRange,
      min: 0,
      max: 30,
      divisions: 6,
      labels: RangeLabels(
        widget.currentRange.start.round().toString(),
        widget.currentRange.end.round().toString(),
      ),
      onChanged: widget.changeRange,
    );
  }
}
