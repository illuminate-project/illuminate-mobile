// THIS DOES NOT WORK RIGHT NOW, MISSING A LOT OF CODE TO WORK
// Personal implementation less based on boilerplate example code from the package's Github repo.
// import 'dart:async';

// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_gl/flutter_gl.dart';
import 'package:three_dart/three_dart.dart' as three;
import 'package:three_dart_jsm/three_dart_jsm.dart' as three_jsm;

class testscene extends StatefulWidget {
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<testscene> {
  @override
  setup() {
    three.Camera camera = three.PerspectiveCamera(40, 1, 0.1, 10);
    camera.position.z = 3;

    late three.Scene scene = three.Scene();
    camera.lookAt(scene.position);

    scene.background = three.Color(1.0, 1.0, 1.0);
    scene.add(three.AmbientLight(0x222244, null));

    var geometryCylinder = three.CylinderGeometry(0.5, 0.5, 1, 32);
    var materialCylinder = three.MeshPhongMaterial({"color": 0xff0000});

    late three.Mesh mesh = three.Mesh(geometryCylinder, materialCylinder);
    scene.add(mesh);
  }

  initPage() async {
    final mqd = MediaQuery.of(context);
    Size? screenSize = mqd.size;
    double width = screenSize.width;
    double height = screenSize.height;
    three.Camera camera = three.PerspectiveCamera(45, width / height, 1, 2000);
    camera.position.z = 250;

    // scene

    late three.Scene scene = three.Scene();

    var ambientLight = three.AmbientLight(0xcccccc, 0.4);
    scene.add(ambientLight);

    var pointLight = three.PointLight(0xffffff, 0.8);
    camera.add(pointLight);
    scene.add(camera);

    // texture

    var textureLoader = three.TextureLoader(null);
    textureLoader.flipY = true;
    three.Texture texture =
        await textureLoader.loadAsync('assets/squirtle_texture.png', null);

    texture.magFilter = three.LinearFilter;
    texture.minFilter = three.LinearMipmapLinearFilter;
    texture.generateMipmaps = true;
    texture.needsUpdate = true;
    texture.flipY = true; // this flipY is only for web

    var loader = three_jsm.OBJLoader(null);
    three.Object3D object = await loader.loadAsync('assets/squirtle.obj');

    object.traverse((child) {
      if (child is three.Mesh) {
        child.material.map = texture;
      }
    });

    object.scale.set(0.5, 0.5, 0.5);
    scene.add(object);

    // var plane = three.PlaneGeometry(100, 100);
    // mesh = three.Mesh(plane, three.MeshPhongMaterial({"map": texture}));
    // scene.add(mesh);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return Container(
              alignment: Alignment.center,
              child: initPage(),
            );
          },
        ),
      ),
    );
  }
}
