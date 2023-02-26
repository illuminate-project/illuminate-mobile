import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:illuminate/elements/color_selector.dart';
import 'package:illuminate/elements/slider/slider_bar.dart';
import 'package:illuminate/elements/slider/slider_label.dart';

class AmbienceScreen extends StatefulWidget {
  final double selectedValue;
  final Function setSliderValue;
  final int type;
  final List<Color> ambienceColor;
  final Function changeColor;
  const AmbienceScreen({
    super.key,
    required this.selectedValue,
    required this.setSliderValue,
    required this.type,
    required this.ambienceColor,
    required this.changeColor,
  });

  @override
  State<AmbienceScreen> createState() => _AmbienceScreenState();
}

class _AmbienceScreenState extends State<AmbienceScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 50),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        ColorSelector(
            colorWheelColor: widget.ambienceColor,
            changeColor: widget.changeColor),
        //Icon(Icons.wb_sunny_sharp, color: Colors.amber, size: 50),
        SizedBox(width: 15),
        SliderLabel(label: 'Brightness'),
        SliderBar(
          selectedValue: widget.selectedValue,
          setSliderValue: widget.setSliderValue,
          type: widget.type,
        )
      ])
    ]);
  }
}
