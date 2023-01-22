import 'package:flutter/material.dart';
import 'package:test_application/elements/color_selector.dart';
import 'package:test_application/elements/slider/slider.dart';

class LightScreen extends StatefulWidget {
  final double intensity;
  final double distance;
  final double radius;
  final Function setSliderValue;
  final List<Color> colorWheelColor;
  final Function changeColor;
  final Function removeLight;
  const LightScreen(
      {super.key,
      required this.setSliderValue,
      required this.intensity,
      required this.distance,
      required this.radius,
      required this.colorWheelColor,
      required this.changeColor,
      required this.removeLight});

  @override
  State<LightScreen> createState() => _LightScreenState();
}

class _LightScreenState extends State<LightScreen> {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            width: 15,
          ),
          ColorSelector(
              colorWheelColor: widget.colorWheelColor,
              changeColor: widget.changeColor),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MovableSlider(
                  label: 'Intensity',
                  selectedValue: widget.intensity,
                  setSliderValue: widget.setSliderValue,
                  type: 1),
              MovableSlider(
                  label: 'Distance',
                  selectedValue: widget.distance,
                  setSliderValue: widget.setSliderValue,
                  type: 2),
              MovableSlider(
                  label: 'Radius',
                  selectedValue: widget.radius,
                  setSliderValue: widget.setSliderValue,
                  type: 3),
            ],
          ),
          IconButton(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(right: 10),
            iconSize: 35,
            onPressed: () => widget.removeLight(),
            icon: const Icon(Icons.delete),
            color: const Color.fromARGB(255, 255, 255, 255),
          )
        ]);
  }
}
