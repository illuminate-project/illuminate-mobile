import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ColorSelector extends StatefulWidget {
  final List<Color> colorWheelColor;
  final Function changeColor;
  const ColorSelector(
      {super.key, required this.colorWheelColor, required this.changeColor});

  @override
  State<ColorSelector> createState() => _ColorSelectorState();
}

class _ColorSelectorState extends State<ColorSelector> {
  @override
  Widget build(BuildContext context) {
    void showColorPicker() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Select a Color'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: const Color.fromARGB(255, 255, 255, 255),
                  paletteType: PaletteType.hueWheel,
                  onColorChanged: (Color color) {
                    widget.changeColor(color);
                  },
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => {Navigator.pop(context)},
                    child: const Text(
                      'Close',
                      style: TextStyle(fontSize: 18),
                    ))
              ],
            );
          });
    }

    return GestureDetector(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(colors: widget.colorWheelColor)),
      ),
      onTap: () => showColorPicker(),
    );
  }
}
