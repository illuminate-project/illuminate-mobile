import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:illuminate/screens/start_screen.dart';
import 'elements/lights/lights_bar.dart';
import 'elements/picture_container.dart';
import 'screens/light_screen.dart';
import 'elements/lights/light_button.dart';
import 'elements/top_app_bar.dart';
import 'elements/bottom_nav.dart';
import 'screens/screen_selector.dart';
import 'webgl_loader_obj.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

Uint8List? screenshotImage;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();

}

class HomePageState extends State<HomePage> with ChangeNotifier{
  XFile? _selectedImage;
  XFile? _originalImage;
  int _selectedScreen = 0;
  int _selectedLight = 0;
  double ambience = 0;
  bool _showLoadingBar = false;
  bool _3DMesh = false;
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

  List<Color> ambienceColor = [Colors.white, Colors.white];

  @override
  void initState() {
    super.initState();
    lightScreens = [
      LightScreen(
        setSliderValue: _setSliderValue,
        distance: 0,
        intensity: 1.0,
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

    print(lightScreens);

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

  void _changeAmbienceColor(color) {
    setState(() {
      ambienceColor = [color, color];
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
      case 4:
        {
          setState(() {
            ambience = value;
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
        _setMesh(false);
        lightScreens.removeRange(0, lightScreens.length);
        lightsButtons.removeRange(0, lightsButtons.length);
        ambienceColor = [Colors.white, Colors.white];
        ambience = 0;
      } else {
        _setLoadingBar(true);
        Timer(
          const Duration(seconds: 3),
          () => {_setLoadingBar(false), _setMesh(true)},
        );
        if (lightsButtons.isEmpty) {
          _addLight();
        }
      }
    });
  }

  void _setMesh(mesh) {
    _3DMesh = mesh;
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

  ScreenshotController screenshotController = ScreenshotController();
  
  int iterator = 0;

  Future<bool> newSave(File currImage) async {
    await GallerySaver.saveImage(currImage.path)
        .catchError((error, stackTrace) => false);
    return true;
  }

  Uint8List? sceneCapture() {
    screenshotController.capture().then((image) {
      //Capture Done
      screenshotImage = image;
      iterator++;
      setState(() {
        
      });
      return image;
    }).catchError((onError) {
      print(onError);
    });
    return null;
  }

  saveImage() {
    ImageGallerySaver.saveImage(screenshotImage!);
  }

  Widget downloadFAB() {
    if (_selectedImage != null) {
      FloatingActionButton(
            onPressed: () async {
              sceneCapture();
              File temp = File.fromRawPath(screenshotImage!);
              GallerySaver.saveImage(temp.path)
                .catchError((error, stackTrace) => false);
            },
            child: const Icon(Icons.download));
    }
    else {
      return Container();
    }
    return Container();
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
              ? Screenshot(
                  controller: screenshotController,
                  child: Container(
                      child: SizedBox(height: 400, child: WebGlLoaderObj(ambienceColor, lightScreens))))
              //PictureContainer(_selectedImage, _setImage, _setOriginalImage)
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
          //iterator > 0 ? Container(child:Image.memory(screenshotImage!)) : Container(),
          _3DMesh == false
              ? Container()
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
                    originalImage: _originalImage,
                    setSelectedImage: _setImage,
                    selectedValue: ambience,
                    setSliderValue: _setSliderValue,
                    type: 4,
                    ambienceColor: ambienceColor,
                    changeAmbienceColor: _changeAmbienceColor,
                  ),
                ])
        ],
      ),
      floatingActionButton: FloatingActionButton(
            onPressed: () {
              sceneCapture();
              print(screenshotImage);
              //saveImage();
            },
            child: const Icon(Icons.download)),
      bottomNavigationBar: _selectedImage != null
          ? BottomNav(
              selectedScreen: _selectedScreen,
              changeScreen: _setScreen,
            )
          : null,
    );
  }
}
