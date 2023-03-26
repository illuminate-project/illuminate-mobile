import 'package:flutter/material.dart';
import 'package:illuminate/elements/color_selector.dart';
import 'package:illuminate/elements/slider/slider.dart';
import 'package:illuminate/elements/slider/slider_bar.dart';
import 'package:illuminate/elements/slider/slider_label.dart';

class DirectionalScreen extends StatefulWidget {
  final double selectedValue;
  final Function setSliderValue;
  final List<Color> directionalColor;
  final double intensity;
  final double horizontal;
  final double vertical;
  final double distance;
  final Function changeColor;
  const DirectionalScreen({
    super.key,
    required this.selectedValue,
    required this.setSliderValue,
    required this.intensity,
    required this.horizontal,
    required this.distance,
    required this.vertical,
    required this.directionalColor,
    required this.changeColor,
  });

  @override
  State<DirectionalScreen> createState() => _DirectionalScreenState();
}

class _DirectionalScreenState extends State<DirectionalScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ColorSelector(
            colorWheelColor: widget.directionalColor,
            changeColor: widget.changeColor),
        //Icon(Icons.wb_sunny_sharp, color: Colors.amber, size: 50),
        SizedBox(width: 15),
        Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          MovableSlider(
              label: 'Intensity',
              selectedValue: widget.intensity,
              setSliderValue: widget.setSliderValue,
              type: 6),
          MovableSlider(
              label: 'Horizontal',
              selectedValue: widget.horizontal,
              setSliderValue: widget.setSliderValue,
              type: 7),
          MovableSlider(
              label: 'Vertical',
              selectedValue: widget.vertical,
              setSliderValue: widget.setSliderValue,
              type: 8),
          MovableSlider(
              label: 'Distance',
              selectedValue: widget.distance,
              setSliderValue: widget.setSliderValue,
              type: 9),
        ]),
      ])
    ]);
  }
}
