import 'package:flutter/material.dart';
import 'package:test_application/elements/slider/slider_bar.dart';
import 'package:test_application/elements/slider/slider_label.dart';

class MovableSlider extends StatefulWidget {
  final String label;
  final double selectedValue;
  final Function setSliderValue;
  final int type;
  const MovableSlider(
      {super.key,
      required this.label,
      required this.selectedValue,
      required this.setSliderValue,
      required this.type});

  @override
  State<MovableSlider> createState() => _MovableSliderState();
}

class _MovableSliderState extends State<MovableSlider> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SliderLabel(label: widget.label),
        SliderBar(
          selectedValue: widget.selectedValue,
          setSliderValue: widget.setSliderValue,
          type: widget.type,
        )
      ],
    );
  }
}
