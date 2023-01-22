import 'package:flutter/material.dart';
import 'package:test_application/elements/lights/light_button.dart';

class LightsBar extends StatefulWidget {
  final List<LightButton> lightsButtons;
  final Function setLight;
  final Function setScreen;
  final Function addLightScreen;
  final int selectedLight;
  const LightsBar({
    super.key,
    required this.setLight,
    required this.setScreen,
    required this.addLightScreen,
    required this.lightsButtons,
    required this.selectedLight,
  });

  @override
  State<LightsBar> createState() => _LightsBarState();
}

class _LightsBarState extends State<LightsBar> {
  void addLightButton() {
    setState(() {
      widget.lightsButtons.add(LightButton(
        lightIndex: widget.lightsButtons.length,
        setScreen: widget.setScreen,
        setLight: widget.setLight,
        selectedLight: widget.selectedLight,
      ));

      widget.addLightScreen();
      widget.setLight(widget.lightsButtons.length - 1);
      widget.setScreen(0);
    });
  }

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
                  addLightButton();
                },
                child: Row(children: const [
                  Icon(
                    Icons.add_circle_outline,
                    size: 15,
                    color: Color.fromARGB(255, 131, 131, 131),
                  ),
                  SizedBox(
                    width: 1,
                  ),
                  Text(
                    'Add Light',
                    style: TextStyle(color: Color.fromARGB(255, 131, 131, 131)),
                  )
                ])))
      ]),
    );
  }
}
