import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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
import 'elements/lights/movable_light.dart';
import 'webgl_loader_obj.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

Uint8List? screenshotImage;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> with ChangeNotifier {
  XFile? _selectedImage;
  XFile? _originalImage;
  int _selectedScreen = 0;
  int _selectedLight = 0;
  double ambience = 1;
  double dIntensity = 0;
  double dHorizontal = 0;
  double dVertical = 0;
  double dDistance = 0;
  bool dLightHidden = false;
  double blur = 20;
  bool _showLoadingBar = false;
  bool _3DMesh = false;
  bool allLightsShown = true;
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
  List<Color> directionalColor = [Colors.white, Colors.white];

  @override
  void initState() {
    super.initState();
    lightScreens = [
      LightScreen(
        setSliderValue: _setSliderValue,
        horizontal: 0.0,
        intensity: 0.0,
        vertical: 0.0,
        colorWheelColor: rainbowColor,
        distance: 0.0,
        changeColor: _changeColor,
        removeLight: _removeLight,
        hideLight: _hideLight,
        isLightOn: true,
        isMovableLightHidden: false,
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

  void _hideLight() {
    setState(() {
      if (lightScreens[_selectedLight].isLightOn) {
        lightScreens.insert(
            _selectedLight,
            LightScreen(
              setSliderValue: _setSliderValue,
              intensity: lightScreens[_selectedLight].intensity,
              horizontal: lightScreens[_selectedLight].horizontal,
              vertical: lightScreens[_selectedLight].vertical,
              distance: lightScreens[_selectedLight].distance,
              colorWheelColor: lightScreens[_selectedLight].colorWheelColor,
              changeColor: _changeColor,
              removeLight: _removeLight,
              hideLight: _hideLight,
              isLightOn: false,
              isMovableLightHidden:
                  lightScreens[_selectedLight].isMovableLightHidden,
            ));
        lightScreens.removeAt(_selectedLight + 1);
        print(lightScreens[_selectedLight].isLightOn);
      } else {
        lightScreens.insert(
            _selectedLight,
            LightScreen(
              setSliderValue: _setSliderValue,
              intensity: lightScreens[_selectedLight].intensity,
              horizontal: lightScreens[_selectedLight].horizontal,
              vertical: lightScreens[_selectedLight].vertical,
              distance: lightScreens[_selectedLight].distance,
              colorWheelColor: lightScreens[_selectedLight].colorWheelColor,
              changeColor: _changeColor,
              removeLight: _removeLight,
              hideLight: _hideLight,
              isLightOn: true,
              isMovableLightHidden:
                  lightScreens[_selectedLight].isMovableLightHidden,
            ));
        lightScreens.removeAt(_selectedLight + 1);
        print(lightScreens[_selectedLight].isLightOn);
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
            horizontal: lightScreens[_selectedLight].horizontal,
            vertical: lightScreens[_selectedLight].vertical,
            distance: lightScreens[_selectedLight].distance,
            colorWheelColor: [color, color],
            changeColor: _changeColor,
            removeLight: _removeLight,
            hideLight: _hideLight,
            isLightOn: true,
            isMovableLightHidden:
                lightScreens[_selectedLight].isMovableLightHidden,
          ));
      lightScreens.removeAt(_selectedLight + 1);
    });
  }

  void _changeAmbienceColor(color) {
    setState(() {
      ambienceColor = [color, color];
    });
  }

  void _changeDirectionalColor(color) {
    setState(() {
      directionalColor = [color, color];
    });
  }

  void _setSliderValue(double value, int type,
      [double? horizontal, double? vertical]) {
    switch (type) {
      case 1:
        {
          setState(() {
            lightScreens.insert(
                _selectedLight,
                LightScreen(
                  setSliderValue: _setSliderValue,
                  intensity: value,
                  horizontal: lightScreens[_selectedLight].horizontal,
                  vertical: lightScreens[_selectedLight].vertical,
                  colorWheelColor: lightScreens[_selectedLight].colorWheelColor,
                  distance: lightScreens[_selectedLight].distance,
                  changeColor: _changeColor,
                  removeLight: _removeLight,
                  hideLight: _hideLight,
                  isLightOn: true,
                  isMovableLightHidden:
                      lightScreens[_selectedLight].isMovableLightHidden,
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
                    horizontal: value,
                    vertical: lightScreens[_selectedLight].vertical,
                    distance: lightScreens[_selectedLight].distance,
                    changeColor: _changeColor,
                    removeLight: _removeLight,
                    hideLight: _hideLight,
                    isLightOn: true,
                    isMovableLightHidden:
                        lightScreens[_selectedLight].isMovableLightHidden,
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
                  horizontal: lightScreens[_selectedLight].horizontal,
                  vertical: value,
                  colorWheelColor: lightScreens[_selectedLight].colorWheelColor,
                  distance: lightScreens[_selectedLight].distance,
                  changeColor: _changeColor,
                  hideLight: _hideLight,
                  isLightOn: true,
                  isMovableLightHidden:
                      lightScreens[_selectedLight].isMovableLightHidden,
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
      case 5:
        {
          setState(() {
            lightScreens.insert(
                _selectedLight,
                LightScreen(
                  setSliderValue: _setSliderValue,
                  intensity: lightScreens[_selectedLight].intensity,
                  horizontal: lightScreens[_selectedLight].horizontal,
                  vertical: lightScreens[_selectedLight].vertical,
                  colorWheelColor: lightScreens[_selectedLight].colorWheelColor,
                  distance: value,
                  changeColor: _changeColor,
                  removeLight: _removeLight,
                  hideLight: _hideLight,
                  isLightOn: true,
                  isMovableLightHidden:
                      lightScreens[_selectedLight].isMovableLightHidden,
                ));
            lightScreens.removeAt(_selectedLight + 1);
          });
        }
        break;
      case 6:
        {
          setState(() {
            dIntensity = value;
          });
        }
        break;
      case 7:
        {
          setState(() {
            dHorizontal = value;
          });
        }
        break;
      case 8:
        {
          setState(() {
            dVertical = value;
          });
        }
        break;
      case 9:
        {
          setState(() {
            dDistance = value;
          });
        }
        break;
      case 10:
        {
          setState(() {
            lightScreens.insert(
                _selectedLight,
                LightScreen(
                  setSliderValue: _setSliderValue,
                  removeLight: _removeLight,
                  intensity: lightScreens[_selectedLight].intensity,
                  horizontal: horizontal != null ? horizontal : 0,
                  vertical: vertical != null ? vertical : 0,
                  colorWheelColor: lightScreens[_selectedLight].colorWheelColor,
                  distance: lightScreens[_selectedLight].distance,
                  changeColor: _changeColor,
                  hideLight: _hideLight,
                  isLightOn: true,
                  isMovableLightHidden:
                      lightScreens[_selectedLight].isMovableLightHidden,
                ));
            lightScreens.removeAt(_selectedLight + 1);
          });
          break;
        }
      case 11:
        {
          setState(() {
            dHorizontal = horizontal != null ? horizontal : 0;
            dVertical = vertical != null ? vertical : 0;
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
        horizontal: 0,
        intensity: 0.5,
        vertical: 0,
        distance: 0,
        colorWheelColor: rainbowColor,
        changeColor: _changeColor,
        removeLight: _removeLight,
        hideLight: _hideLight,
        isLightOn: true,
        isMovableLightHidden: false,
      ));
    });
  }

  void _setLoadingBar(show) {
    setState(() {
      _showLoadingBar = show;
    });
  }

  void reduceBlur(i) {
    if (i == 0 || blur == 0) {
      return;
    }
    Timer(
        const Duration(milliseconds: 900),
        () => {
              setState(() {
                blur--;
              }),
              reduceBlur(i - 0.5)
            });
  }

  void _setOriginalImage(image) {
    setState(() {
      _originalImage = image;
    });
  }

  void _setImage(image) async {
    setState(() {
      _selectedImage = image;
    });

    if (_selectedImage != null) {
      _setLoadingBar(true);
    }

    if (image == null) {
      _setMesh(false);
      blur = 20;
      lightScreens.removeRange(0, lightScreens.length);
      lightsButtons.removeRange(0, lightsButtons.length);
      ambienceColor = [Colors.white, Colors.white];
      ambience = 1.0;
    } else {
      reduceBlur(20);

      final tempDir = await getTemporaryDirectory();
      final path = await tempDir.path;

      while (true) {
        if (File('$path/mesh.obj').existsSync()) {
          _setLoadingBar(false);
          _setMesh(true);
          if (lightsButtons.isEmpty) {
            _addLight();
          }
        }
      }
    }
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

  void allLightToggle() {
    setState(() {
      if (allLightsShown) {
        for (int i = 0; i < lightScreens.length; i++) {
          LightScreen curr = LightScreen(
            setSliderValue: _setSliderValue,
            intensity: lightScreens[i].intensity,
            horizontal: lightScreens[i].horizontal,
            vertical: lightScreens[i].vertical,
            distance: lightScreens[i].distance,
            colorWheelColor: lightScreens[i].colorWheelColor,
            changeColor: _changeColor,
            removeLight: _removeLight,
            hideLight: _hideLight,
            isLightOn: false,
            isMovableLightHidden:
                lightScreens[_selectedLight].isMovableLightHidden,
          );
          lightScreens.insert(i, curr);
          lightScreens.removeAt(i + 1);
        }
        allLightsShown = false;
      } else {
        for (int i = 0; i < lightScreens.length; i++) {
          LightScreen curr = LightScreen(
            setSliderValue: _setSliderValue,
            intensity: lightScreens[i].intensity,
            horizontal: lightScreens[i].horizontal,
            vertical: lightScreens[i].vertical,
            colorWheelColor: lightScreens[i].colorWheelColor,
            distance: lightScreens[i].distance,
            changeColor: _changeColor,
            removeLight: _removeLight,
            hideLight: _hideLight,
            isLightOn: true,
            isMovableLightHidden:
                lightScreens[_selectedLight].isMovableLightHidden,
          );
          lightScreens.insert(i, curr);
          lightScreens.removeAt(i + 1);
        }
        allLightsShown = true;
      }
    });
  }

  void toggleHideMovableLight() {
    setState(() {
      if (_selectedScreen == 0) {
        lightScreens.insert(
            _selectedLight,
            LightScreen(
              setSliderValue: _setSliderValue,
              removeLight: _removeLight,
              intensity: lightScreens[_selectedLight].intensity,
              horizontal: lightScreens[_selectedLight].horizontal,
              vertical: lightScreens[_selectedLight].vertical,
              colorWheelColor: lightScreens[_selectedLight].colorWheelColor,
              distance: lightScreens[_selectedLight].distance,
              changeColor: _changeColor,
              hideLight: _hideLight,
              isLightOn: true,
              isMovableLightHidden:
                  lightScreens[_selectedLight].isMovableLightHidden
                      ? false
                      : true,
            ));
        lightScreens.removeAt(_selectedLight + 1);
      } else if (_selectedScreen == 1) {
        dLightHidden = dLightHidden == false ? true : false;
      }
    });
  }

  Uint8List? sceneCapture() {
    screenshotController.capture().then((image) {
      //Capture Done
      screenshotImage = image;
      iterator++;
      setState(() {});
      return image;
    }).catchError((onError) {
      print(onError);
    });
    return null;
  }

  saveImage() {
    sceneCapture();
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
    } else {
      return Container();
    }
    return Container();
  }

  Widget getMovableCircle(double width) {
    if (_selectedScreen == 1) {
      return MovingCircle(
        changePosition: _setSliderValue,
        horizontal: dHorizontal,
        vertical: dVertical,
        colors: directionalColor,
        setScreen: _setScreen,
        screenType: _selectedScreen,
        width: width,
      );
    } else if (_selectedScreen == 0) {
      return MovingCircle(
        changePosition: _setSliderValue,
        horizontal: lightScreens[_selectedLight].horizontal,
        vertical: lightScreens[_selectedLight].vertical,
        colors: lightScreens[_selectedLight].colorWheelColor,
        setScreen: _setScreen,
        screenType: _selectedScreen,
        width: width,
      );
    } else {
      return Container();
    }
  }

  Widget getLightType(double width) {
    if (_selectedScreen == 0) {
      if (lightScreens.length != 0 &&
          lightScreens[_selectedLight].isMovableLightHidden == false) {
        return getMovableCircle(width);
      } else {
        return Container();
      }
    } else if (_selectedScreen == 1) {
      if (dLightHidden) {
        return Container();
      } else {
        return getMovableCircle(width);
      }
    } else {
      return Container();
    }
  }

  Widget getBody(BuildContext context) {
    if (_3DMesh != false) {
      return Center(
          child: FittedBox(
              child: Column(
        children: [
          Screenshot(
              controller: screenshotController,
              child: Container(
                  child: SizedBox(
                      height: 389,
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          WebGlLoaderObj(
                              MediaQuery.of(context),
                              _selectedImage!,
                              ambienceColor,
                              lightScreens,
                              ambience,
                              directionalColor,
                              dIntensity,
                              dHorizontal,
                              dVertical,
                              dDistance),
                          getLightType(MediaQuery.of(context).size.width)
                        ],
                      )))),
          Column(children: [
            LightsBar(
              setLight: _setLight,
              setScreen: _setScreen,
              addLightScreen: _addLightScreen,
              lightsButtons: lightsButtons,
              selectedLight: _selectedLight,
              addLightButton: _addLight,
            ),
            Transform.scale(
              scale: 0.95,
              child: ScreenSelector(
                selectedScreen: _selectedScreen,
                selectedLight: _selectedLight,
                lightScreens: lightScreens,
                originalImage: _originalImage,
                setSelectedImage: _setImage,
                selectedValue: ambience,
                setSliderValue: _setSliderValue,
                type: 4,
                dDistance: dDistance,
                dIntensity: dIntensity,
                dHorizontal: dHorizontal,
                dVertical: dVertical,
                changeDirectionalColor: _changeDirectionalColor,
                directionalColor: directionalColor,
                ambienceColor: ambienceColor,
                changeAmbienceColor: _changeAmbienceColor,
              ),
            )
          ])
        ],
      )));
    } else {
      return Column(children: [
        _selectedImage != null
            ? PictureContainer(_selectedImage, blur)
            : StartScreen(
                selectedImage: _selectedImage,
                changeOriginalImage: _setOriginalImage,
                changePicture: _setImage,
              ),
        const SizedBox(height: 2.5),
        _showLoadingBar == true
            ? Column(children: [
                SizedBox(height: 17.5),
                SizedBox(
                    width: 45,
                    height: 45,
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                      color: Color.fromARGB(255, 255, 220, 128),
                    )),
                SizedBox(height: 5)
              ])
            : Container(),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _3DMesh != false
          ? TopAppBar(_setImage, sceneCapture, allLightToggle, saveImage,
              toggleHideMovableLight, _selectedImage, _selectedScreen, lightScreens, _selectedLight, dLightHidden, toggleHideMovableLight)
          : null,
      backgroundColor: const Color.fromARGB(255, 31, 31, 31),
      body: getBody(context),
      bottomNavigationBar: _3DMesh != false
          ? BottomNav(
              selectedScreen: _selectedScreen,
              changeScreen: _setScreen,
            )
          : null,
    );
  }
}
