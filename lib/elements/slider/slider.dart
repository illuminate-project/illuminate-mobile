import 'package:flutter/material.dart';
import 'package:illuminate/elements/slider/slider_bar.dart';
import 'package:illuminate/elements/slider/slider_label.dart';

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
  double marginValue() {
    return widget.type == 34 ? 12.75 : 0;
  }

  double getMinSliderValue() {
    switch (widget.type) {
      case 1:
        return 0;
      case 2:
        return -100;
      case 3:
        return -100;
      case 4:
        return -100;
      case 5:
        return -100;
      default:
        return 0.0;
    }
  }

  double getMaxSliderValue() {
    switch (widget.type) {
      case 1:
        return 2.0;
      case 2:
        return 100;
      case 3:
        return 100;
      case 4:
        return 100;
      case 5:
        return 100;
      default:
        return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            margin: EdgeInsets.only(right: marginValue()),
            child: SliderLabel(label: widget.label)),
        Container(
            width: 160,
            child: SliderBar(
              selectedValue: widget.selectedValue,
              setSliderValue: widget.setSliderValue,
              type: widget.type,
              minSliderValue: getMinSliderValue(),
              maxSliderValue: getMaxSliderValue(),
            )),
      ],
    );
  }
}
