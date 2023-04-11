// This is also technically sample code, thats been modified to work with our sample objects (Squirtle)
// Currently only works on Flutter Web, displays a blank scene on Flutter Desktop, crashes on Flutter Mobile
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gl/flutter_gl.dart';
import 'package:illuminate/screens/light_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
// for some reason I had to remove this line to prevent a compilation error
// import 'package:three_dart/three3d/three.dart';
import 'package:three_dart/three_dart.dart' as three;
import 'package:three_dart_jsm/three_dart_jsm.dart' as three_jsm;
import 'package:path_provider/path_provider.dart';

import 'home_page.dart';
import 'screens/light_screen.dart';

class WebGlLoaderObj extends StatefulWidget {
  final MediaQueryData sizeOfScreen;
  final XFile _selectedImage;
  final List<LightScreen> lightScreens;
  final List<Color> ambienceColor;
  final List<Color> directionalColor;
  final double ambience;
  final double dIntensity;
  final double dHorizontal;
  final double dVertical;
  final double dDistance;
  const WebGlLoaderObj(
      this.sizeOfScreen,
      this._selectedImage,
      this.ambienceColor,
      this.lightScreens,
      this.ambience,
      this.directionalColor,
      this.dIntensity,
      this.dHorizontal,
      this.dVertical,
      this.dDistance,
      {super.key});

  @override
  State<WebGlLoaderObj> createState() => _MyAppState();
}

class _MyAppState extends State<WebGlLoaderObj> {
  bool hasInitialized = false;
  late FlutterGlPlugin three3dRender;
  three.WebGLRenderer? renderer;

  int? fboId;
  late double width;
  late double height;

  Size? screenSize;

  late three.Scene scene;
  late three.Camera camera;
  late three.Mesh mesh;

  late double screenHeight;
  late double midpoint;

  double dpr = 1.0;

  var amount = 4;

  bool verbose = true;
  bool disposed = false;

  late three.Object3D object;

  late three.Texture texture;

  late three.WebGLRenderTarget renderTarget;

  dynamic sourceTexture;

  var pointLight1 = three.PointLight(0x000000, 0.0);
  var pointLight2 = three.PointLight(0x000000, 0.0);
  var pointLight3 = three.PointLight(0x000000, 0.0);
  var pointLight4 = three.PointLight(0x000000, 0.0);
  var pointLight5 = three.PointLight(0x000000, 0.0);

  var ambientLight = three.AmbientLight(0xFFFFFF, 1.0);
  var directionalLight = three.DirectionalLight(0xFFFFFF, 0.0);

  @override
  void initState() {
    super.initState();

    initSize(
        widget.sizeOfScreen,
        widget._selectedImage,
        widget.lightScreens,
        widget.ambience,
        widget.ambienceColor,
        widget.directionalColor,
        widget.dIntensity,
        widget.dHorizontal,
        widget.dVertical,
        widget.dDistance);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState(lightScreens, ambience, ambienceColor,
      directionalColor, dIntensity, dHorizontal, dVertical, dDistance) async {
    width = screenSize!.width;
    height = screenSize!.height;

    three3dRender = FlutterGlPlugin();

    Map<String, dynamic> options = {
      "antialias": true,
      "alpha": false,
      "width": width.toInt(),
      "height": height.toInt(),
      "dpr": dpr
    };

    await three3dRender.initialize(options: options);

    setState(() {});

    // Wait for web
    Future.delayed(const Duration(milliseconds: 1000), () async {
      await three3dRender.prepareContext();

      initScene(lightScreens, ambience, ambienceColor, directionalColor,
          dIntensity, dHorizontal, dVertical, dDistance);
    });
  }

  initSize(
      MediaQueryData sizeOfScreen,
      _selectedImage,
      lightScreens,
      ambience,
      ambienceColor,
      directionalColor,
      dIntensity,
      dHorizontal,
      dVertical,
      dDistance) {
    print(_selectedImage);
    if (screenSize != null) {
      initPage(lightScreens, ambience, ambienceColor, directionalColor,
          dIntensity, dHorizontal, dVertical, dDistance);
      // render();
      return;
    }

    final mqd = sizeOfScreen;

    screenSize = mqd.size;

    dpr = mqd.devicePixelRatio;

    initPlatformState(lightScreens, ambience, ambienceColor, directionalColor,
        dIntensity, dHorizontal, dVertical, dDistance);
  }

  updateScene(lightScreens, ambient, ambientColor, dDistance, dHorizontal,
      dVertical, dIntensity, directionalColor) {
    if (hasInitialized != false) {
      /*double cameraFOV = 95;
      camera = three.PerspectiveCamera(cameraFOV, (width / height), 0.1, 1000);
      double cameraX = 0;
      double cameraY = 0;
      double cameraZ = 1.5;
      camera.position.x = cameraX;
      camera.position.y = cameraY;
      camera.position.z = cameraZ;*/

      camera.remove(pointLight1);
      camera.remove(pointLight2);
      camera.remove(pointLight3);
      camera.remove(pointLight4);
      camera.remove(pointLight5);

      for (var i = 0; i < lightScreens.length; i++) {
        switch (i) {
          case 0:
            var pointLightColor = 0x000000;
            double pointLightIntensity = 0.0;
            double pointLightX = 50.0;
            double pointLightY = 20.0;
            double pointLightZ = 6.0;

            pointLightIntensity = widget.lightScreens[0].isLightOn
                ? widget.lightScreens[0].intensity
                : 0.0;
            if (widget.lightScreens[0].colorWheelColor.length > 2) {
              pointLightColor = ARGBtoHex(Color.fromARGB(255, 255, 255, 255));
            } else {
              pointLightColor =
                  ARGBtoHex(widget.lightScreens[0].colorWheelColor[0]);
            }
            pointLightX = widget.lightScreens[0].horizontal;
            pointLightY = -widget.lightScreens[0].vertical;
            pointLightZ = widget.lightScreens[0].distance;
            pointLight1 =
                three.PointLight(pointLightColor, pointLightIntensity);

            pointLight1.position.set(pointLightX, pointLightY, pointLightZ);
            camera.add(pointLight1);
            break;
          case 1:
            var pointLightColor = 0x000000;
            double pointLightIntensity = 0.0;
            double pointLightX = 50.0;
            double pointLightY = 20.0;
            double pointLightZ = 6.0;

            pointLightIntensity = widget.lightScreens[1].isLightOn
                ? widget.lightScreens[1].intensity
                : 0.0;
            if (widget.lightScreens[1].colorWheelColor.length > 2) {
              pointLightColor = ARGBtoHex(Color.fromARGB(255, 255, 255, 255));
            } else {
              pointLightColor =
                  ARGBtoHex(widget.lightScreens[1].colorWheelColor[0]);
            }
            pointLightX = widget.lightScreens[1].horizontal;
            pointLightY = -widget.lightScreens[1].vertical;
            pointLightZ = widget.lightScreens[1].distance;
            pointLight2 =
                three.PointLight(pointLightColor, pointLightIntensity);

            pointLight2.position.set(pointLightX, pointLightY, pointLightZ);
            camera.add(pointLight2);
            break;
          case 2:
            var pointLightColor = 0x000000;
            double pointLightIntensity = 0.0;
            double pointLightX = 50.0;
            double pointLightY = 20.0;
            double pointLightZ = 6.0;

            pointLightIntensity = widget.lightScreens[2].isLightOn
                ? widget.lightScreens[2].intensity
                : 0.0;
            if (widget.lightScreens[2].colorWheelColor.length > 2) {
              pointLightColor = ARGBtoHex(Color.fromARGB(255, 255, 255, 255));
            } else {
              pointLightColor =
                  ARGBtoHex(widget.lightScreens[2].colorWheelColor[0]);
            }
            pointLightX = widget.lightScreens[2].horizontal;
            pointLightY = -widget.lightScreens[2].vertical;
            pointLightZ = widget.lightScreens[2].distance;
            pointLight3 =
                three.PointLight(pointLightColor, pointLightIntensity);

            pointLight3.position.set(pointLightX, pointLightY, pointLightZ);
            camera.add(pointLight3);
            break;
          case 3:
            var pointLightColor = 0x000000;
            double pointLightIntensity = 0.0;
            double pointLightX = 50.0;
            double pointLightY = 20.0;
            double pointLightZ = 6.0;

            pointLightIntensity = widget.lightScreens[3].isLightOn
                ? widget.lightScreens[3].intensity
                : 0.0;
            if (widget.lightScreens[3].colorWheelColor.length > 2) {
              pointLightColor = ARGBtoHex(Color.fromARGB(255, 255, 255, 255));
            } else {
              pointLightColor =
                  ARGBtoHex(widget.lightScreens[3].colorWheelColor[0]);
            }
            pointLightX = widget.lightScreens[3].horizontal;
            pointLightY = -widget.lightScreens[3].vertical;
            pointLightZ = widget.lightScreens[3].distance;
            pointLight4 =
                three.PointLight(pointLightColor, pointLightIntensity);

            pointLight4.position.set(pointLightX, pointLightY, pointLightZ);
            camera.add(pointLight4);
            break;
          case 4:
            var pointLightColor = 0x000000;
            double pointLightIntensity = 0.0;
            double pointLightX = 50.0;
            double pointLightY = 20.0;
            double pointLightZ = 6.0;

            pointLightIntensity = widget.lightScreens[4].isLightOn
                ? widget.lightScreens[4].intensity
                : 0.0;
            if (widget.lightScreens[4].colorWheelColor.length > 2) {
              pointLightColor = ARGBtoHex(Color.fromARGB(255, 255, 255, 255));
            } else {
              pointLightColor =
                  ARGBtoHex(widget.lightScreens[4].colorWheelColor[0]);
            }
            pointLightX = widget.lightScreens[4].horizontal;
            pointLightY = -widget.lightScreens[4].vertical;
            pointLightZ = widget.lightScreens[4].distance;
            pointLight5 =
                three.PointLight(pointLightColor, pointLightIntensity);

            pointLight5.position.set(pointLightX, pointLightY, pointLightZ);
            camera.add(pointLight5);
            break;
          default:
        }
      }

      scene.remove(ambientLight);
      ambientLight = three.AmbientLight(ARGBtoHex(ambientColor[0]), ambient);
      scene.add(ambientLight);

      scene.remove(directionalLight);

      bool directionalLightOn = true;
      var directionalLightColor = ARGBtoHex(directionalColor[0]);
      var directionalLightIntensity = dIntensity;
      directionalLight = three.DirectionalLight(
          directionalLightColor, directionalLightIntensity);

      if (directionalLightOn == false) {
        directionalLight = three.DirectionalLight(0x000000, 0);
      }

      double fromX = dHorizontal;
      double fromY = dVertical;
      double fromZ = dDistance;
      directionalLight.position.set(fromX, fromY, fromZ);

      scene.add(directionalLight);

      render();
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    midpoint = screenHeight / 4;

    ScrollController _scrollController = new ScrollController(
      initialScrollOffset: midpoint,
      keepScrollOffset: true,
    );
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          updateScene(
              widget.lightScreens,
              widget.ambience,
              widget.ambienceColor,
              widget.dDistance,
              widget.dHorizontal,
              widget.dVertical,
              widget.dIntensity,
              widget.directionalColor);
          return SingleChildScrollView(
              controller: _scrollController,
              //physics: NeverScrollableScrollPhysics(),
              child: _build(
                context,
              ));
        },
      ),
    );
  }

  Widget _build(BuildContext context) {
    // initSize(context, lightScreens);
    return Column(
      children: [
        Stack(
          children: [
            Container(
                width: width,
                height: height,
                color: Colors.black,
                child: Builder(builder: (BuildContext context) {
                  if (kIsWeb) {
                    return three3dRender.isInitialized
                        ? HtmlElementView(
                            viewType: three3dRender.textureId!.toString())
                        : Container();
                  } else {
                    return three3dRender.isInitialized
                        ? Texture(textureId: three3dRender.textureId!)
                        : Container();
                  }
                })),
          ],
        ),
      ],
    );
  }

  render() {
    int t = DateTime.now().millisecondsSinceEpoch;

    final gl = three3dRender.gl;

    renderer!.render(scene, camera);

    int t1 = DateTime.now().millisecondsSinceEpoch;

    if (verbose) {
      print("render cost: ${t1 - t} ");
      print(renderer!.info.memory);
      print(renderer!.info.render);
    }

    gl.flush();

    if (verbose) print(" render: sourceTexture: $sourceTexture ");
    if (!kIsWeb) {
      three3dRender.updateTexture(sourceTexture);
    }

    if (hasInitialized == false) {
      hasInitialized = true;
    }
  }

  initRenderer(lightScreens, ambience, ambienceColor, directionalColor,
      dIntensity, dHorizontal, dVertical, dDistance) {
    Map<String, dynamic> options = {
      "width": width,
      "height": height,
      "gl": three3dRender.gl,
      "antialias": true,
      "canvas": three3dRender.element
    };
    renderer = three.WebGLRenderer(options);
    renderer!.setPixelRatio(dpr);
    renderer!.setSize(width, height, false);
    renderer!.shadowMap.enabled = false;

    if (!kIsWeb) {
      var pars = three.WebGLRenderTargetOptions({"format": three.RGBAFormat});
      renderTarget = three.WebGLRenderTarget(
          (width * dpr).toInt(), (height * dpr).toInt(), pars);
      renderTarget.samples = 4;
      renderer!.setRenderTarget(renderTarget);
      sourceTexture = renderer!.getRenderTargetGLTexture(renderTarget);
    }
  }

  initScene(lightScreens, ambience, ambienceColor, directionalColor, dIntensity,
      dHorizontal, dVertical, dDistance) {
    initRenderer(lightScreens, ambience, ambienceColor, directionalColor,
        dIntensity, dHorizontal, dVertical, dDistance);
    initPage(lightScreens, ambience, ambienceColor, directionalColor,
        dIntensity, dHorizontal, dVertical, dDistance);
  }

  ARGBtoHex(colorARGB) {
    var colorHexString;
    int colorHexInt;
    String hexAppend = "0x";

    colorARGB = '${colorARGB.value.toRadixString(16)}';
    colorHexString = hexAppend + colorARGB.substring(2);
    colorHexString = colorHexString.replaceAll(new RegExp(r'[^0-9a-fA-F]'), '');
    colorHexInt = int.parse(colorHexString, radix: 16);

    return colorHexInt;
  }

  initPage(lightScreens, ambience, ambienceColor, directionalColor, dIntensity,
      dHorizontal, dVertical, dDistance) async {
    double cameraFOV = 95;
    camera = three.PerspectiveCamera(cameraFOV, (width / height), 0.1, 1000);
    double cameraX = 0;
    double cameraY = 0;
    double cameraZ = 1.5;
    camera.position.x = cameraX;
    camera.position.y = cameraY;
    camera.position.z = cameraZ;

    // scene
    scene = three.Scene();

    //Future.delayed(const Duration(milliseconds: 1000), () {});

    // ambient light settings
    // bool ambientLightOn = true;
    var ambientLightColor = ARGBtoHex(ambienceColor[0]);
    var ambientLightIntensity = ambience;
    ambientLight = three.AmbientLight(ambientLightColor, ambientLightIntensity);

    // we kinda need an ambient light to be on at all times or else we can't see anything
    // but the functionality to turn it off is here anyway if we need it for whatever reason
    // if (ambientLightOn == false)
    // {
    // ambientLight = three.AmbientLight(0xffffff, 0);
    // }

    scene.add(ambientLight);

    // directional light settings
    bool directionalLightOn = true;
    var directionalLightColor = ARGBtoHex(directionalColor[0]);
    var directionalLightIntensity = dIntensity;
    directionalLight = three.DirectionalLight(
        directionalLightColor, directionalLightIntensity);

    if (directionalLightOn == false) {
      directionalLight = three.DirectionalLight(0x000000, 0);
    }

    // directional light targeting
    // how this works is the light direction points at the origin and starts from the position set here
    // if we want to make the light come from the opposite direction, we can use negative values
    // not sure how we can make this more intuitive for the user in the app though
    double fromX = dHorizontal;
    double fromY = dVertical;
    double fromZ = dDistance;
    directionalLight.position.set(fromX, fromY, fromZ);

    scene.add(directionalLight);

    // point light 1 settings
    bool pointLight1On = false;
    var pointLight1Color = 0x000000;
    double pointLight1Intensity = 0.0;
    pointLight1 = three.PointLight(pointLight1Color, pointLight1Intensity);

    // point light 1 position
    double pointLight1X = 50.0;
    double pointLight1Y = 20.0;
    double pointLight1Z = 6.0;

    if (lightScreens.length >= 1 && lightScreens[0] != null) {
      pointLight1On = true;
      pointLight1Intensity =
          lightScreens[0].isLightOn ? lightScreens[0].intensity : 0.0;
      pointLight1Color = ARGBtoHex(Color.fromARGB(255, 255, 255, 255));
      pointLight1X = lightScreens[0].horizontal;
      pointLight1Y = lightScreens[0].vertical;
      pointLight1Z = lightScreens[0].distance;
      pointLight1 = three.PointLight(pointLight1Color, pointLight1Intensity);
    } else {
      pointLight1 = three.PointLight(0x000000, 0.0);
    }

    pointLight1.position.set(pointLight1X, pointLight1Y, pointLight1Z);
    camera.add(pointLight1);

    if (lightScreens.length < 1 || lightScreens[0] == null) {
      camera.remove(pointLight1);
    }

    // point light 2 settings
    bool pointLight2On = false;
    var pointLight2Color = 0x000000;
    double pointLight2Intensity = 0.0;
    pointLight2 = three.PointLight(pointLight2Color, pointLight2Intensity);

    // point light 2 position
    double pointLight2X = 50.0;
    double pointLight2Y = 20.0;
    double pointLight2Z = 6.0;

    if (lightScreens.length >= 2 && lightScreens[1] != null) {
      pointLight2On = true;
      pointLight2Intensity =
          lightScreens[1].isLightOn ? lightScreens[1].intensity : 0.0;
      ;
      pointLight2Color = ARGBtoHex(Color.fromARGB(255, 255, 255, 255));
      pointLight2X = lightScreens[1].horizontal;
      pointLight2Y = lightScreens[1].vertical;
      pointLight2Z = lightScreens[1].distance;
      pointLight2 = three.PointLight(pointLight2Color, pointLight2Intensity);
    } else {
      pointLight2 = three.PointLight(0x000000, 0);
    }

    pointLight2.position.set(pointLight2X, pointLight2Y, pointLight2Z);
    camera.add(pointLight2);

    if (lightScreens.length < 2) {
      camera.remove(pointLight2);
    }

    // point light 3 settings
    bool pointLight3On = false;
    var pointLight3Color = 0x000000;
    double pointLight3Intensity = 0.0;
    pointLight3 = three.PointLight(pointLight3Color, pointLight3Intensity);

    // point light 3 position
    double pointLight3X = 50.0;
    double pointLight3Y = 20.0;
    double pointLight3Z = 6.0;

    if (lightScreens.length >= 3 && lightScreens[2] != null) {
      pointLight3On = true;
      pointLight3Intensity =
          lightScreens[2].isLightOn ? lightScreens[2].intensity : 0.0;
      ;
      pointLight3Color = ARGBtoHex(Color.fromARGB(255, 255, 255, 255));
      pointLight3X = lightScreens[2].horizontal;
      pointLight3Y = lightScreens[2].vertical;
      pointLight3Z = lightScreens[2].distance;
      pointLight3 = three.PointLight(pointLight3Color, pointLight3Intensity);
    } else {
      pointLight3 = three.PointLight(0x000000, 0);
    }

    pointLight3.position.set(pointLight3X, pointLight3Y, pointLight3Z);
    camera.add(pointLight3);

    if (lightScreens.length < 3) {
      camera.remove(pointLight3);
    }

    // point light 4 settings
    bool pointLight4On = false;
    var pointLight4Color = 0x000000;
    double pointLight4Intensity = 0.0;
    pointLight4 = three.PointLight(pointLight4Color, pointLight4Intensity);

    // point light 4 position
    double pointLight4X = 50.0;
    double pointLight4Y = 20.0;
    double pointLight4Z = 6.0;

    if (lightScreens.length >= 4 && lightScreens[3] != null) {
      pointLight4On = true;
      pointLight4Intensity =
          lightScreens[3].isLightOn ? lightScreens[3].intensity : 0.0;
      ;
      pointLight4Color = ARGBtoHex(Color.fromARGB(255, 255, 255, 255));
      pointLight4X = lightScreens[3].horizontal;
      pointLight4Y = lightScreens[3].vertical;
      pointLight4Z = lightScreens[3].distance;
      pointLight4 = three.PointLight(pointLight4Color, pointLight4Intensity);
    } else {
      pointLight4 = three.PointLight(0x000000, 0);
    }

    pointLight4.position.set(pointLight4X, pointLight4Y, pointLight4Z);
    camera.add(pointLight4);

    if (lightScreens.length < 4) {
      camera.remove(pointLight4);
    }

    // point light 5 settings
    bool pointLight5On = false;
    var pointLight5Color = 0x000000;
    double pointLight5Intensity = 0.0;
    pointLight5 = three.PointLight(pointLight5Color, pointLight5Intensity);

    // point light 5 position
    double pointLight5X = 50.0;
    double pointLight5Y = 20.0;
    double pointLight5Z = 6.0;

    if (lightScreens.length >= 5 && lightScreens[4] != null) {
      pointLight5On = true;
      pointLight5Intensity =
          lightScreens[4].isLightOn ? lightScreens[4].intensity : 0.0;
      ;
      pointLight5Color = ARGBtoHex(Color.fromARGB(255, 255, 255, 255));
      pointLight5X = lightScreens[4].horizontal;
      pointLight5Y = lightScreens[4].vertical;
      pointLight5Z = lightScreens[4].distance;
      pointLight5 = three.PointLight(pointLight5Color, pointLight5Intensity);
    } else {
      pointLight5 = three.PointLight(0x000000, 0);
    }

    pointLight5.position.set(pointLight5X, pointLight5Y, pointLight5Z);
    camera.add(pointLight5);

    if (lightScreens.length < 5) {
      camera.remove(pointLight5);
    }

    // camera
    scene.add(camera);

    // textures
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    var textureLoader = three.TextureLoader(null);
    textureLoader.flipY = true;
    // texture = await textureLoader.loadAsync('assets/image_50.jpg');
    texture = await textureLoader.loadAsync('$tempPath/texture.jpg');

    texture.magFilter = three.LinearFilter;
    texture.minFilter = three.LinearMipmapLinearFilter;
    texture.generateMipmaps = true;
    texture.needsUpdate = true;
    texture.flipY = true; // this flipY is only for web

    var loader = three_jsm.OBJLoader(null);

    // object = await loader.loadAsync('assets/obama.obj');

    object = await loader.loadAsync('$tempPath/mesh.obj');

    object.traverse((child) {
      if (child is three.Mesh) {
        child.material.map = texture;
      }
    });

    object.scale.set(0.6, 0.6, 0.6);
    scene.remove(object);
    scene.add(object);

    // var plane = three.PlaneGeometry(100, 100);
    // mesh = three.Mesh(plane, three.MeshPhongMaterial({"map": texture}));
    // scene.add(mesh);

    animate();
  }

  animate() {
    if (!mounted || disposed) {
      return;
    }

    render();

    // Future.delayed(Duration(milliseconds: 40), () {
    //   animate();
    // });
  }

  @override
  void dispose() {
    print(" dispose ............. ");
    disposed = true;
    three3dRender.dispose();

    super.dispose();
  }
}
