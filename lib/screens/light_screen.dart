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
  void doNothing(color) {}
  @override
  Widget build(BuildContext context) {
    void showColorPicker() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Pick a color"),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: const Color(0xff443a49),
                  paletteType: PaletteType.hueWheel,
                  onColorChanged: (Color value) {
                    doNothing(value);
                  },
                ),
              ),
            );
          });
    }

    return Row(children: [
      IconButton(
          iconSize: 85,
          onPressed: (() => showColorPicker()),
          icon: const Icon(
              color: Color.fromARGB(255, 1, 1, 1), Icons.color_lens_outlined)),
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
