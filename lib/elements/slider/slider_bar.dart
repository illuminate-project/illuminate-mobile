import 'package:flutter/material.dart';

class SliderBar extends StatefulWidget {
  const SliderBar({super.key});

  @override
  State<SliderBar> createState() => _SliderBarState();
}

class _SliderBarState extends State<SliderBar> {
  double _selectedValue = 0;

  void _setValue(value) {
    setState(() {
      _selectedValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Slider(
      min: 0.0,
      max: 100,
      value: _selectedValue,
      divisions: 100,
      label: _selectedValue.round().toString(),
      onChanged: ((value) => _setValue(value)),
      activeColor: const Color.fromARGB(255, 217, 217, 217),
      inactiveColor: const Color.fromARGB(255, 84, 84, 84),
    );
  }
}
