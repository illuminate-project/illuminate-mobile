import 'package:flutter/material.dart';
import 'package:test_application/elements/lights/light_button.dart';

class LightsBar extends StatefulWidget {
  final List<LightButton> lightsButtons;
  final Function setLight;
  final Function setScreen;
  final Function addLightScreen;
  final Function addLightButton;
  final int selectedLight;
  const LightsBar(
      {super.key,
      required this.setLight,
      required this.setScreen,
      required this.addLightScreen,
      required this.lightsButtons,
      required this.selectedLight,
      required this.addLightButton});

  @override
  State<LightsBar> createState() => _LightsBarState();
}

class _LightsBarState extends State<LightsBar> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        Row(children: widget.lightsButtons),
        SizedBox(
            height: 32.5,
            child: TextButton(
                onPressed: () {
                  widget.addLightButton();
                },
                child: Row(children: const [
                  Icon(
                    Icons.add_circle_outline,
                    size: 15,
                    color: Color.fromARGB(255, 217, 217, 217),
                  ),
                  SizedBox(
                    width: 1,
                  ),
                  Text(
                    'Add Light',
                    style: TextStyle(color: Color.fromARGB(255, 217, 217, 217)),
                  )
                ])))
      ]),
    );
  }
}
