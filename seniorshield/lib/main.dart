import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/views/home_screen/home.dart';
import 'package:seniorshield/views/splash_screen/splash1.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Senior Shield',
      theme: ThemeData(
        scaffoldBackgroundColor: kDefaultIconLightColor,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      ),
      home: Splash1(),
    );
  }
}
