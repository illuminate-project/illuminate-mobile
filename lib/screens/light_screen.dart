import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:test_application/elements/color_selector.dart';
import 'package:test_application/elements/slider/slider.dart';

class LightScreen extends StatefulWidget {
  const LightScreen({super.key});

  @override
  State<LightScreen> createState() => _LightScreenState();
}

class _LightScreenState extends State<LightScreen> {
  List<Color> gradientColor = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    const Color.fromARGB(255, 252, 0, 168)
  ];

  void changeColor(color) {
    setState(() {
      gradientColor = [color, color];
    });
  }

  @override
  Widget build(BuildContext context) {
    void showColorPicker() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Select a color'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: const Color.fromARGB(255, 255, 255, 255),
                  paletteType: PaletteType.hueWheel,
                  onColorChanged: (Color color) {
                    changeColor(color);
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

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            width: 15,
          ),
          GestureDetector(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(colors: gradientColor)),
            ),
            onTap: () => showColorPicker(),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            children: const [
              MovableSlider(label: 'Intensity'),
              MovableSlider(label: 'Distance'),
              MovableSlider(label: 'Radius'),
            ],
          )
        ]);
  }
}
