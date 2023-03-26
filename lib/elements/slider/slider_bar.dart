import 'package:flutter/material.dart';

class SliderBar extends StatefulWidget {
  final double selectedValue;
  final Function setSliderValue;
  final int type;
  final double minSliderValue;
  final double maxSliderValue;
  const SliderBar(
      {super.key,
      required this.selectedValue,
      required this.setSliderValue,
      required this.minSliderValue,
      required this.maxSliderValue,
      required this.type});

  @override
  State<SliderBar> createState() => _SliderBarState();
}

class _SliderBarState extends State<SliderBar> {
  String sliderLabel() {
    switch (widget.type) {
      case 1:
        return (widget.selectedValue * 50).round().toString();

      case 4:
        return (widget.selectedValue * 50).round().toString();

      case 6:
        return (widget.selectedValue * 50).round().toString();

      default:
        return widget.selectedValue.round().toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      min: widget.minSliderValue,
      max: widget.maxSliderValue,
      value: widget.selectedValue,
      divisions: 100,
      label: sliderLabel(),
      onChanged: ((value) => widget.setSliderValue(value, widget.type)),
      activeColor: const Color.fromARGB(255, 217, 217, 217),
      inactiveColor: const Color.fromARGB(255, 84, 84, 84),
    );
  }
}
