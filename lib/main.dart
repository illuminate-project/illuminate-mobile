import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prototype_app/picture_container.dart';
import 'package:prototype_app/testscene.dart';
import 'package:three_dart/three_dart.dart';
import 'package:prototype_app/webgl_loader_obj.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  XFile? _selectedImage;

  void _setImage(image) {
    setState(() {
      _selectedImage = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebGlLoaderObj();
  }
}
