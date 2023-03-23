// This is also technically sample code, thats been modified to work with our sample objects (Squirtle)
// Currently only works on Flutter Web, displays a blank scene on Flutter Desktop, crashes on Flutter Mobile
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gl/flutter_gl.dart';
import 'package:illuminate/screens/light_screen.dart';
import 'package:provider/provider.dart';
// for some reason I had to remove this line to prevent a compilation error
// import 'package:three_dart/three3d/three.dart';
import 'package:three_dart/three_dart.dart' as three;
import 'package:three_dart_jsm/three_dart_jsm.dart' as three_jsm;

import 'home_page.dart';
import 'screens/light_screen.dart';

class WebGlLoaderObj extends StatefulWidget {
  final List<LightScreen> lightScreens;
  final List<Color> ambienceColor;
  final double ambience;
  const WebGlLoaderObj(this.ambienceColor, this.lightScreens, this.ambience, {super.key});

  @override
  State<WebGlLoaderObj> createState() => _MyAppState();
}

class _MyAppState extends State<WebGlLoaderObj> { 
  late FlutterGlPlugin three3dRender;
  three.WebGLRenderer? renderer;

  int? fboId;
  late double width;
  late double height;

  Size? screenSize;

  late three.Scene scene;
  late three.Camera camera;
  late three.Mesh mesh;

  double dpr = 1.0;

  var amount = 4;

  bool verbose = true;
  bool disposed = false;

  late three.Object3D object;

  late three.Texture texture;

  late three.WebGLRenderTarget renderTarget;

  dynamic sourceTexture;

  @override
  void initState() {
    // initSize(context, widget.lightScreens);
    super.initState();
    
    // initPage(widget.lightScreens);
    // WidgetsBinding.instance.addPostFrameCallback((_) => initSize(context, widget.lightScreens));
  }

   @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      print('hi');
      }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState(lightScreens, ambience) async {
    print('initPlatformState called');
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
    Future.delayed(const Duration(milliseconds: 100), () async {
      await three3dRender.prepareContext();

      initScene(lightScreens, ambience);
    });
  }

  initSize(BuildContext context, lightScreens, ambience) {
    print('initSize called');
    
    if (screenSize != null) {
      print('screenSize != null');
      initPage(lightScreens, ambience);
      // render();
      return;
    }

    final mqd = MediaQuery.of(context);
    
    screenSize = mqd.size;
    
    dpr = mqd.devicePixelRatio;

    initPlatformState(lightScreens, ambience);
  }

  @override
  Widget build(BuildContext context) {    
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          initSize(context, widget.lightScreens, widget.ambience);
          return SingleChildScrollView(child: _build(context, widget.lightScreens, widget.ambience));
        },
      ),
      /* floatingActionButton: FloatingActionButton(
        child: const Text("render"),
        onPressed: () {
          render();
        },
      ), */
    );
  }

  Widget _build(BuildContext context, lightScreens, ambience) {
    // initSize(context, lightScreens);
    return Column(
      children: [
        Stack(
          children: [
            Text('Hello'),
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
  }

  initRenderer(lightScreens, ambience) {
    print('initRenderer called');
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

  initScene(lightScreens, ambience) {
    initRenderer(lightScreens, ambience);
    initPage(lightScreens, ambience);
  }

  initPage(lightScreens, ambience) async {
    print('initPage called');
    // camera settings
    // print(lightScreens[0].intensity);
    double cameraFOV = 45;
    camera = three.PerspectiveCamera(cameraFOV, (width / height), 1, 1000);
    double cameraX = 0;
    double cameraY = 0;
    double cameraZ = 15;
    camera.position.x = cameraX;
    camera.position.y = cameraY;
    camera.position.z = cameraZ;

    // scene
    scene = three.Scene();

    // ambient light settings
    // bool ambientLightOn = true;
    var ambientLightColor = 0xffffff;
    var ambientLightIntensity = ambience;
    var ambientLight =
        three.AmbientLight(ambientLightColor, ambientLightIntensity);

    // we kinda need an ambient light to be on at all times or else we can't see anything
    // but the functionality to turn it off is here anyway if we need it for whatever reason
    // if (ambientLightOn == false)
    // {
    // ambientLight = three.AmbientLight(0xffffff, 0);
    // }

    scene.add(ambientLight);

    // TO DO: Add in directional light functionality when the UI stuff exists
    // directional light settings
    /* bool directionalLightOn = false;
    var directionalLightColor = 0xfdcf60;
    var directionalLightIntensity = 0.9;
    var directionalLight = three.DirectionalLight(
        directionalLightColor, directionalLightIntensity);

    if (directionalLightOn == false) {
      directionalLight = three.DirectionalLight(0x000000, 0);
    }

    // directional light targeting
    // how this works is the light direction points at the origin and starts from the position set here
    // if we want to make the light come from the opposite direction, we can use negative values
    // not sure how we can make this more intuitive for the user in the app though
    double fromX = -60;
    double fromY = -10;
    double fromZ = 100;
    directionalLight.position.set(fromX, fromY, fromZ);

    scene.add(directionalLight); */

    // point light 1 settings
    bool pointLight1On = false;
    var pointLight1Color = 0xe59f3e;
    double pointLight1Intensity = 0.0;
    var pointLight1 = three.PointLight(0x000000, 0);
    print(pointLight1Intensity);

    // point light 1 position
    double pointLight1X = 50.0;
    double pointLight1Y = 20.0;
    double pointlight1Z = 6.0;

    if (lightScreens.length >= 1)
    {
      pointLight1On = true;
      pointLight1Intensity = lightScreens[0].intensity;
      pointLight1X = lightScreens[0].distance;
      pointLight1Y = lightScreens[0].radius;
      pointLight1 = three.PointLight(pointLight1Color, pointLight1Intensity);
    }

    else
    {
      pointLight1 = three.PointLight(0x000000, 0);
    }

    pointLight1.position.set(pointLight1X, pointLight1Y, pointlight1Z);
    camera.add(pointLight1);

    if (lightScreens.length < 1)
    {
      camera.remove(pointLight1);
    }

    // point light 2 settings
    bool pointLight2On = false;
    var pointLight2Color = 0xe59f3e;
    double pointLight2Intensity = 0.0;
    var pointLight2 = three.PointLight(0x000000, 0);
    print(pointLight2Intensity);

    // point light 2 position
    double pointLight2X = 50.0;
    double pointLight2Y = 20.0;
    double pointlight2Z = 6.0;

    if (lightScreens.length >= 2 && lightScreens[1] != null)
    {
      pointLight2On = true;
      pointLight2Intensity = lightScreens[1].intensity;
      pointLight2X = lightScreens[1].distance;
      pointLight2Y = lightScreens[1].radius;
      print(pointLight2Intensity);
      pointLight2 = three.PointLight(pointLight2Color, pointLight2Intensity);
    }

    else
    {
      pointLight2 = three.PointLight(0x000000, 0);
    }
    
    pointLight2.position.set(pointLight2X, pointLight2Y, pointlight2Z);
    camera.add(pointLight2);

    if (lightScreens.length < 2)
    {
      camera.remove(pointLight2);
    }

    // point light 3 settings
    bool pointLight3On = false;
    var pointLight3Color = 0xe59f3e;
    double pointLight3Intensity = 0.0;
    var pointLight3 = three.PointLight(0x000000, 0);
    print(pointLight3Intensity);

    // point light 3 position
    double pointLight3X = 50.0;
    double pointLight3Y = 20.0;
    double pointlight3Z = 6.0;

    if (lightScreens.length >= 3 && lightScreens[2] != null)
    {
      pointLight3On = true;
      pointLight3Intensity = lightScreens[2].intensity;
      pointLight3X = lightScreens[2].distance;
      pointLight3Y = lightScreens[2].radius;
      print(pointLight3Intensity);
      pointLight3 = three.PointLight(pointLight3Color, pointLight3Intensity);
    }

    else
    {
      pointLight3 = three.PointLight(0x000000, 0);
    }
    
    pointLight3.position.set(pointLight3X, pointLight3Y, pointlight3Z);
    camera.add(pointLight3);

    if (lightScreens.length < 3)
    {
      camera.remove(pointLight3);
    }

    // point light 4 settings
    bool pointLight4On = false;
    var pointLight4Color = 0xe59f3e;
    double pointLight4Intensity = 0.0;
    var pointLight4 = three.PointLight(0x000000, 0);
    print(pointLight4Intensity);

    // point light 4 position
    double pointLight4X = 50.0;
    double pointLight4Y = 20.0;
    double pointlight4Z = 6.0;

    if (lightScreens.length >= 4 && lightScreens[3] != null)
    {
      pointLight4On = true;
      pointLight4Intensity = lightScreens[3].intensity;
      pointLight4X = lightScreens[3].distance;
      pointLight4Y = lightScreens[3].radius;
      print(pointLight4Intensity);
      pointLight4 = three.PointLight(pointLight4Color, pointLight4Intensity);
    }

    else
    {
      pointLight4 = three.PointLight(0x000000, 0);
    }
    
    pointLight4.position.set(pointLight4X, pointLight4Y, pointlight4Z);
    camera.add(pointLight4);

    if (lightScreens.length < 4)
    {
      camera.remove(pointLight4);
    }

    // point light 5 settings
    bool pointLight5On = false;
    var pointLight5Color = 0xe59f3e;
    double pointLight5Intensity = 0.0;
    var pointLight5 = three.PointLight(0x000000, 0);
    print(pointLight5Intensity);

    // point light 5 position
    double pointLight5X = 50.0;
    double pointLight5Y = 20.0;
    double pointlight5Z = 6.0;

    if (lightScreens.length >= 5 && lightScreens[4] != null)
    {
      pointLight5On = true;
      pointLight5Intensity = lightScreens[4].intensity;
      pointLight5X = lightScreens[4].distance;
      pointLight5Y = lightScreens[4].radius;
      print(pointLight5Intensity);
      pointLight5 = three.PointLight(pointLight5Color, pointLight5Intensity);
    }

    else
    {
      pointLight5 = three.PointLight(0x000000, 0);
    }
    
    pointLight5.position.set(pointLight5X, pointLight5Y, pointlight5Z);
    camera.add(pointLight5);

    if (lightScreens.length < 5)
    {
      camera.remove(pointLight5);
    }

    // camera
    scene.add(camera);

    // textures

    var textureLoader = three.TextureLoader(null);
    textureLoader.flipY = true;
    texture = await textureLoader.loadAsync('assets/squirtle_texture.png');

    texture.magFilter = three.LinearFilter;
    texture.minFilter = three.LinearMipmapLinearFilter;
    texture.generateMipmaps = true;
    texture.needsUpdate = true;
    texture.flipY = true; // this flipY is only for web

    var loader = three_jsm.OBJLoader(null);
    object = await loader.loadAsync('assets/squirtle.obj');

    object.traverse((child) {
      if (child is three.Mesh) {
        child.material.map = texture;
      }
    });

    object.scale.set(1, 1, 1);
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
