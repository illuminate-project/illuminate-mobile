import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'elements/lights/lights_bar.dart';
import 'elements/picture_container.dart';
import 'screens/light_screen.dart';
import 'elements/lights/light_button.dart';
import 'elements/top_app_bar.dart';
import 'elements/bottom_nav.dart';
import 'screens/screen_selector.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? _selectedImage;
  int _selectedScreen = 0;
  int _selectedLight = 0;
  List<LightScreen> lightScreens = [];
  List<LightButton> lightsButtons = [];
  List<Color> rainbowColor = [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
    const Color.fromARGB(255, 252, 0, 168)
  ];

  @override
  void initState() {
    super.initState();
    lightScreens = [
      LightScreen(
        setSliderValue: _setSliderValue,
        distance: 0,
        intensity: 0,
        radius: 0,
        colorWheelColor: rainbowColor,
        changeColor: _changeColor,
        removeLight: _removeLight,
      )
    ];

    lightsButtons = [
      LightButton(
        lightIndex: 0,
        setScreen: _setScreen,
        setLight: _setLight,
        selectedLight: 0,
      )
    ];
  }

  void _removeLight() {
    setState(() {
      lightScreens.removeAt(_selectedLight);
      if (lightScreens.isNotEmpty) {
        lightsButtons.removeRange(_selectedLight, lightsButtons.length);
        for (var i = _selectedLight; i < lightScreens.length; i++) {
          lightsButtons.add(LightButton(
            lightIndex: i,
            setScreen: _setScreen,
            setLight: _setLight,
            selectedLight: _selectedLight,
          ));
        }
        _setLight(0);
        _setScreen(0);
      } else {
        lightsButtons.removeLast();
        _setScreen(1);
      }
    });
  }

  void _changeColor(color) {
    setState(() {
      lightScreens.insert(
          _selectedLight,
          LightScreen(
            setSliderValue: _setSliderValue,
            intensity: lightScreens[_selectedLight].intensity,
            distance: lightScreens[_selectedLight].distance,
            radius: lightScreens[_selectedLight].radius,
            colorWheelColor: [color, color],
            changeColor: _changeColor,
            removeLight: _removeLight,
          ));
      lightScreens.removeAt(_selectedLight + 1);
    });
  }

  void _setSliderValue(double value, int type) {
    switch (type) {
      case 1:
        {
          setState(() {
            lightScreens.insert(
                _selectedLight,
                LightScreen(
                  setSliderValue: _setSliderValue,
                  intensity: value,
                  distance: lightScreens[_selectedLight].distance,
                  radius: lightScreens[_selectedLight].radius,
                  colorWheelColor: lightScreens[_selectedLight].colorWheelColor,
                  changeColor: _changeColor,
                  removeLight: _removeLight,
                ));
            lightScreens.removeAt(_selectedLight + 1);
          });
        }
        break;
      case 2:
        {
          setState(() {
            lightScreens.insert(
                _selectedLight,
                LightScreen(
                    setSliderValue: _setSliderValue,
                    intensity: lightScreens[_selectedLight].intensity,
                    distance: value,
                    radius: lightScreens[_selectedLight].radius,
                    changeColor: _changeColor,
                    removeLight: _removeLight,
                    colorWheelColor:
                        lightScreens[_selectedLight].colorWheelColor));
            lightScreens.removeAt(_selectedLight + 1);
          });
        }
        break;
      case 3:
        {
          setState(() {
            lightScreens.insert(
                _selectedLight,
                LightScreen(
                  setSliderValue: _setSliderValue,
                  removeLight: _removeLight,
                  intensity: lightScreens[_selectedLight].intensity,
                  distance: lightScreens[_selectedLight].distance,
                  radius: value,
                  colorWheelColor: lightScreens[_selectedLight].colorWheelColor,
                  changeColor: _changeColor,
                ));
            lightScreens.removeAt(_selectedLight + 1);
          });
          break;
        }
      default:
    }
  }

  void _addLightScreen() {
    setState(() {
      lightScreens.add(LightScreen(
        setSliderValue: _setSliderValue,
        distance: 0,
        intensity: 0,
        radius: 0,
        colorWheelColor: rainbowColor,
        changeColor: _changeColor,
        removeLight: _removeLight,
      ));
    });
  }

  void _setImage(image) {
    setState(() {
      _selectedImage = image;
    });
  }

  void _setScreen(int index) {
    setState(() {
      _selectedScreen = index;
    });
  }

  void _setLight(int index) {
    setState(() {
      _selectedLight = index;
      lightsButtons.clear();
      for (var i = 0; i < lightScreens.length; i++) {
        lightsButtons.add(LightButton(
          lightIndex: i,
          setScreen: _setScreen,
          setLight: _setLight,
          selectedLight: _selectedLight,
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(_setImage),
      backgroundColor: const Color.fromARGB(255, 31, 31, 31),
      body: Column(
        children: [
          PictureContainer(_selectedImage, _setImage),
          const SizedBox(height: 2.5),
          LightsBar(
            setLight: _setLight,
            setScreen: _setScreen,
            addLightScreen: _addLightScreen,
            lightsButtons: lightsButtons,
            selectedLight: _selectedLight,
          ),
          // const SizedBox(height: 7.5),
          ScreenSelector(
            selectedScreen: _selectedScreen,
            selectedLight: _selectedLight,
            lightScreens: lightScreens,
          ),
        ],
      ),
      bottomNavigationBar:
          BottomNav(selectedScreen: _selectedScreen, changeScreen: _setScreen),
    );
  }
}
