import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:illuminate/home_page.dart';
import 'package:illuminate/screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(ChangeNotifierProvider(
    create: (context) => HomePageState(),
    child: const MyApp())
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Illuminate',
      theme: ThemeData(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
