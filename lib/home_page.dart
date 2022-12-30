import 'package:flutter/material.dart';
import 'package:test_application/elements/picture_container.dart';
import 'elements/top_app_bar.dart';
import 'elements/bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void doNothing() {}

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopAppBar(),
      backgroundColor: Color.fromARGB(255, 31, 31, 31),
      body: Center(
        child: PictureContainer(),
      ),
      bottomNavigationBar: BottomNav(),
    );
  }
}
