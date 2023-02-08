import 'package:flutter/material.dart';

class SliderBar extends StatefulWidget {
  final double selectedValue;
  final Function setSliderValue;
  final int type;
  const SliderBar(
      {super.key,
      required this.selectedValue,
      required this.setSliderValue,
      required this.type});

  @override
  State<SliderBar> createState() => _SliderBarState();
}

class _SliderBarState extends State<SliderBar> {
  void doNothing() {}
  @override
  Widget build(BuildContext context) {
    return Slider(
      min: 0.0,
      max: 100,
      value: widget.selectedValue,
      divisions: 100,
      label: widget.selectedValue.round().toString(),
      onChanged: ((value) => widget.setSliderValue(value, widget.type)),
      activeColor: const Color.fromARGB(255, 217, 217, 217),
      inactiveColor: const Color.fromARGB(255, 84, 84, 84),
    );
  }
}
