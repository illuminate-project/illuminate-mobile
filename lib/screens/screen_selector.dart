import 'package:flutter/material.dart';
import 'package:illuminate/screens/ambience_screen.dart';
import 'package:illuminate/screens/background_screen.dart';
import 'package:illuminate/screens/directional_screen.dart';
import 'package:illuminate/screens/filter_screen.dart';
import 'package:illuminate/screens/light_screen.dart';
import 'package:image_picker/image_picker.dart';

class ScreenSelector extends StatefulWidget {
  final int selectedScreen;
  final int selectedLight;
  final List<LightScreen> lightScreens;
  final XFile? originalImage;
  final Function setSelectedImage;
  final List<Color> ambienceColor;
  final Function changeAmbienceColor;
  final Function changeDirectionalColor;
  final List<Color> directionalColor;
  final double selectedValue;
  final Function setSliderValue;
  final int type;
  final double dIntensity;
  final double dHorizontal;
  final double dVertical;
  final double dDistance;

  const ScreenSelector({
    super.key,
    required this.selectedScreen,
    required this.selectedLight,
    required this.lightScreens,
    required this.originalImage,
    required this.setSelectedImage,
    required this.selectedValue,
    required this.setSliderValue,
    required this.type,
    required this.ambienceColor,
    required this.changeAmbienceColor,
    required this.changeDirectionalColor,
    required this.directionalColor,
    required this.dIntensity,
    required this.dHorizontal,
    required this.dVertical,
    required this.dDistance,
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
            return Container();
          }
        }
      case 1:
        {
          return Center(
            child: DirectionalScreen(
              selectedValue: widget.selectedValue,
              setSliderValue: widget.setSliderValue,
              directionalColor: widget.directionalColor,
              changeColor: widget.changeDirectionalColor,
              intensity: widget.dIntensity,
              horizontal: widget.dHorizontal,
              vertical: widget.dVertical,
              distance: widget.dDistance,
            ),
            );
        }
      case 2:
        {
          return Center(
              child: AmbienceScreen(
              selectedValue: widget.selectedValue,
              setSliderValue: widget.setSliderValue,
              type: widget.type,
              ambienceColor: widget.ambienceColor,
              changeColor: widget.changeAmbienceColor,
          ));
        }
      /*case 2:
        {
          return FilterScreen(
            originalImage: widget.originalImage,
            setSelectedImage: widget.setSelectedImage,
          );
        }*/
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return selectScreen(widget.selectedScreen);
  }
}
