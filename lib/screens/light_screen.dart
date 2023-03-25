import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:illuminate/elements/color_selector.dart';
import 'package:illuminate/elements/slider/slider.dart';

class LightScreen extends StatefulWidget {
  final double intensity;
  final double horizontal;
  final double vertical;
  final double distance;
  final Function setSliderValue;
  final List<Color> colorWheelColor;
  final Function changeColor;
  final Function removeLight;
  final Function hideLight;
  final bool isLightOn;
  const LightScreen(
      {super.key,
      required this.setSliderValue,
      required this.intensity,
      required this.horizontal,
      required this.distance,
      required this.vertical,
      required this.hideLight,
      required this.colorWheelColor,
      required this.changeColor,
      required this.isLightOn,
      required this.removeLight});

  @override
  State<LightScreen> createState() => _LightScreenState();
}

class _LightScreenState extends State<LightScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //SizedBox(height: 0),
      Row(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Transform.scale(scale: 0.8,
          child: ColorSelector(
            colorWheelColor: widget.colorWheelColor,
            changeColor: widget.changeColor),
        ),
        const SizedBox(
          width: 15,
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
                  label: 'Horizontal',
                  selectedValue: widget.horizontal,
                  setSliderValue: widget.setSliderValue,
                  type: 2),
              MovableSlider(
                  label: 'Vertical',
                  selectedValue: widget.vertical,
                  setSliderValue: widget.setSliderValue,
                  type: 3),
              MovableSlider(
                  label: 'Distance',
                  selectedValue: widget.distance,
                  setSliderValue: widget.setSliderValue,
                  type: 4),
            ],
          ),
        Column(
          children: [
            IconButton(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(right: 10),
              iconSize: 30,
              onPressed: () => widget.hideLight(),
              icon: widget.isLightOn ? const Icon(CupertinoIcons.lightbulb) : const Icon(CupertinoIcons.lightbulb_slash),
              color: const Color.fromARGB(255, 217, 217, 217),
            ),
            SizedBox(height: 10),
            IconButton(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(right: 10),
              iconSize: 30,
              onPressed: () => widget.removeLight(),
              icon: const Icon(CupertinoIcons.trash_fill),
              color: const Color.fromARGB(255, 217, 217, 217),
            )

        ],)
      ])
    ]);
  }
}
