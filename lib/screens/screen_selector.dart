import 'package:flutter/material.dart';
import 'package:test_application/screens/ambience_screen.dart';
import 'package:test_application/screens/background_screen.dart';
import 'package:test_application/screens/filter_screen.dart';
import 'package:test_application/screens/light_screen.dart';

class ScreenSelector extends StatefulWidget {
  final int selectedScreen;
  const ScreenSelector({super.key, required this.selectedScreen});

  @override
  State<ScreenSelector> createState() => _ScreenSelectorState();
}

class _ScreenSelectorState extends State<ScreenSelector> {
  Widget selectScreen(int value) {
    switch (value) {
      case 0:
        {
          return const LightScreen();
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
        return const LightScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return selectScreen(widget.selectedScreen);
  }
}
