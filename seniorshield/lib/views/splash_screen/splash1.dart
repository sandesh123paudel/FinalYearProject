import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:seniorshield/constants/images.dart';
import 'package:seniorshield/views/splash_screen/splash2.dart';

class Splash1 extends StatefulWidget {
  const Splash1({super.key});

  @override
  State<Splash1> createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> {

  //creating the method to change screen

  changeScreen()
  {
    Future.delayed(Duration(seconds:3),(){
      Get.to(()=>Splash2());
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    changeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body:Center(child: Image.asset(logoNoBg)));
  }
}
