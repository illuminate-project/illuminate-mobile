import 'package:flutter/material.dart';
import 'package:illuminate/screens/ambience_screen.dart';
import 'package:illuminate/screens/background_screen.dart';
import 'package:illuminate/screens/filter_screen.dart';
import 'package:illuminate/screens/light_screen.dart';

class ScreenSelector extends StatefulWidget {
  final int selectedScreen;
  final int selectedLight;
  final List<LightScreen> lightScreens;

  const ScreenSelector({
    super.key,
    required this.selectedScreen,
    required this.selectedLight,
    required this.lightScreens,
  });

  @override
  State<ScreenSelector> createState() => _ScreenSelectorState();
}

class _ScreenSelectorState extends State<ScreenSelector> {
  Widget selectScreen(int value) {
    switch (value) {
      case 0:
        {
          if (widget.lightScreens.isNotEmpty) {
            return widget.lightScreens[widget.selectedLight];
          } else {
            return const Text("ADD LIGHTS SCREEN");
          }
        }
      case 1:
        {
          return const AmbienceScreen();
        }
      case 2:
        {
          return const BackgroundScreen();
        }
      case 3:
        {
          return const FilterScreen();
        }
      default:
        return const Text("ADD LIGHTS SCREEN");
    }
  }

  @override
  Widget build(BuildContext context) {
    return selectScreen(widget.selectedScreen);
  }
}
