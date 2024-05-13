import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/services/local_notifications.dart';

import 'package:seniorshield/views/auth_screen/login_screen.dart';

import 'package:seniorshield/views/home_screen/home.dart';
import 'package:seniorshield/views/splash_screen/splash1.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationHeleper.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  // Setup local and Firebase messaging notifications
  runApp(MyApp(isLoggedIn: isLoggedIn));
}


class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({required this.isLoggedIn, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Senior Shield',
      theme: ThemeData(
        scaffoldBackgroundColor: kDefaultIconLightColor,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        timePickerTheme: TimePickerThemeData(
          confirmButtonStyle: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(kDefaultIconLightColor),
            backgroundColor: MaterialStateProperty.all(kPrimaryColor),
            overlayColor: MaterialStateProperty.all(kPrimaryColor),
          ),
          cancelButtonStyle: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(kDefaultIconLightColor),
            backgroundColor: MaterialStateProperty.all(kPrimaryColor),
            overlayColor: MaterialStateProperty.all(kPrimaryColor),
          ),
          backgroundColor:
          kDefaultIconLightColor, // Change the background color of the time picker dialog
          hourMinuteColor:
          kPrimaryColor, // Use your primary color for hour and minute numbers
          dialHandColor: kPrimaryColor, // Use your primary color for the clock hands
          dialBackgroundColor:
          Colors.white, // Change the color of the clock face background
          entryModeIconColor:
          kPrimaryColor, // Use your primary color for the clock/keyboard toggle icon
          hourMinuteTextColor:
          kDefaultIconLightColor, // Use your primary color for the hour and minute text
          inputDecorationTheme: InputDecorationTheme(
            // Customize input decoration theme
            border: OutlineInputBorder(
              borderSide:
              BorderSide(color: kPrimaryColor), // Use your primary color for input border
            ),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,

      home: isLoggedIn ? Home() : Splash1(), // Show home screen if logged in, otherwise show splash screen
    );
  }
}
