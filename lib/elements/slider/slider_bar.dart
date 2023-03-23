import 'package:flutter/material.dart';

class SliderBar extends StatefulWidget {
  final double selectedValue;
  final Function setSliderValue;
  final int type;
  final double maxSliderValue;
  const SliderBar(
      {super.key,
      required this.selectedValue,
      required this.setSliderValue,
      required this.maxSliderValue,
      required this.type});

  @override
  State<SliderBar> createState() => _SliderBarState();
}

class _SliderBarState extends State<SliderBar> {
  @override
  Widget build(BuildContext context) {
    return Slider(
      min: 0.0,
      max: widget.maxSliderValue,
      value: widget.selectedValue,
      divisions: 200,
      label: widget.selectedValue.toString(),
      onChanged: ((value) => widget.setSliderValue(value, widget.type)),
      activeColor: const Color.fromARGB(255, 217, 217, 217),
      inactiveColor: const Color.fromARGB(255, 84, 84, 84),
    );
  }
}
