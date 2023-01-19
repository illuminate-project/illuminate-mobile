import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_application/elements/picture_container.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopAppBar(_setImage),
      backgroundColor: const Color.fromARGB(255, 31, 31, 31),
      body: Center(
        child: Column(
          children: [
            PictureContainer(_selectedImage, _setImage),
            ScreenSelector(
              selectedScreen: _selectedScreen,
            )
          ],
        ),
      ),
      bottomNavigationBar:
          BottomNav(selectedScreen: _selectedScreen, changeScreen: _setScreen),
    );
  }
}
