import 'package:flutter/material.dart';
import 'package:test_application/elements/slider/slider_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test_application/elements/slider/slider_label.dart';

class MovableSlider extends StatefulWidget {
  final String label;
  const MovableSlider({super.key, required this.label});

  @override
  State<MovableSlider> createState() => _MovableSliderState();
}

class _MovableSliderState extends State<MovableSlider> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [SliderLabel(label: widget.label), const SliderBar()],
    );
  }
}
