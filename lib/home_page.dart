import 'dart:async';

import 'package:flutter/material.dart';
import 'package:illuminate/elements/upload_picture.dart';
import 'package:image_picker/image_picker.dart';
import 'package:illuminate/screens/start_screen.dart';
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
  XFile? _originalImage;
  int _selectedScreen = 0;
  int _selectedLight = 0;
  bool _showLoadingBar = false;
  List<LightScreen> lightScreens = [];
  List<LightButton> lightsButtons = [];
  List<Color> rainbowColor = [
    const Color.fromARGB(255, 252, 0, 92),
    Colors.purple,
    Colors.indigo,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.red,
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
        _setScreen(0);
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

  void _setLoadingBar(show) {
    setState(() {
      _showLoadingBar = show;
    });
  }

  void _setOriginalImage(image) {
    setState(() {
      _originalImage = image;
    });
  }

  void _setImage(image) {
    setState(() {
      _selectedImage = image;
      if (image == null) {
        lightScreens.removeRange(0, lightScreens.length);
        lightsButtons.removeRange(0, lightsButtons.length);
      } else {
        if (lightScreens.isEmpty) {
          _setLoadingBar(true);
          Timer(const Duration(seconds: 3), () => {_setLoadingBar(false)});
          _addLight();
        }
      }
    });
  }

  void _addLight() {
    setState(() {
      lightsButtons.add(LightButton(
        lightIndex: lightsButtons.length,
        setScreen: _setScreen,
        setLight: _setLight,
        selectedLight: _selectedLight,
      ));

      _addLightScreen();
      _setLight(lightsButtons.length - 1);
      _setScreen(0);
    });
  }

  // void _pickImage(image) {
  //   setState(() {
  //     _showLoadingBar = true;
  //     _setImage(image);
  //     Timer(
  //         const Duration(seconds: 3),
  //         //Probably have something here like
  //         //await for normal map then dispaly and start another timer for 3 seconds then show
  //         //depth map, after 3 seconds of depth map, if 3d mesh isnt ready just repeat until its ready

  //         //Side note it could be cool to add a blurred image into this for like 0.5 seconds
  //         //for a way to have a transition effect
  //         () => {
  //               _setImage(XFile('assets/images/logo.png')),
  //               Timer(
  //                   const Duration(seconds: 3),
  //                   () => {
  //                         _setImage(XFile('assets/images/normal.png')),
  //                         _showLoadingBar = false
  //                       })
  //             });
  //   });
  // }

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
      appBar:
          _selectedImage != null ? TopAppBar(_setImage, _selectedImage) : null,
      backgroundColor: const Color.fromARGB(255, 31, 31, 31),
      body: Column(
        children: [
          _selectedImage != null
              ? PictureContainer(_selectedImage, _setImage, _setOriginalImage)
              : StartScreen(
                  selectedImage: _selectedImage,
                  changeOriginalImage: _setOriginalImage,
                  changePicture: _setImage,
                ),
          const SizedBox(height: 2.5),
          _showLoadingBar == true
              ? Column(children: [
                  SizedBox(height: 1),
                  SizedBox(width: 345, child: LinearProgressIndicator()),
                  SizedBox(height: 5)
                ])
              : Container(),
          //Probably will change this to when 3d mesh isnt null later
          _selectedImage == null
              ? const Text('Start Screen')
              : Column(children: [
                  LightsBar(
                    setLight: _setLight,
                    setScreen: _setScreen,
                    addLightScreen: _addLightScreen,
                    lightsButtons: lightsButtons,
                    selectedLight: _selectedLight,
                    addLightButton: _addLight,
                  ),
                  ScreenSelector(
                    selectedScreen: _selectedScreen,
                    selectedLight: _selectedLight,
                    lightScreens: lightScreens,
                  ),
                ])
        ],
      ),
      bottomNavigationBar: BottomNav(
        selectedScreen: _selectedScreen,
        changeScreen: _setScreen,
        selectedImage: _selectedImage,
      ),
    );
  }
}
