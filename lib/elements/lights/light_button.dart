import 'package:flutter/material.dart';

class LightButton extends StatefulWidget {
  final int lightIndex;
  final int selectedLight;
  final Function setScreen;
  final Function setLight;
  const LightButton(
      {super.key,
      required this.lightIndex,
      required this.setScreen,
      required this.setLight,
      required this.selectedLight});

  @override
  State<LightButton> createState() => _LightButtonState();
}

class _LightButtonState extends State<LightButton> {
  void selectLight() {
    widget.setLight(widget.lightIndex);

    widget.setScreen(0);
  }

  Color changeColor() {
    if (widget.lightIndex == widget.selectedLight) {
      return const Color.fromARGB(255, 255, 255, 255);
    } else {
      return const Color.fromARGB(255, 31, 31, 31);
    }
  }

  Color changeTextColor() {
    if (widget.lightIndex == widget.selectedLight) {
      return const Color.fromARGB(255, 0, 0, 0);
    } else {
      return const Color.fromARGB(255, 131, 131, 131);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(right: 10),
        height: 32.5,
        child: TextButton(
          style: TextButton.styleFrom(backgroundColor: changeColor()),
          onPressed: () {
            selectLight();
          },
          child: Row(children: [
            Icon(
              Icons.lightbulb_outline,
              size: 15,
              color: changeTextColor(),
            ),
            const SizedBox(
              width: 1,
            ),
            Text('Light ${widget.lightIndex + 1}',
                style: TextStyle(color: changeTextColor())),
          ]),
        ));
  }
}
