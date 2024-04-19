import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seniorshield/constants/images.dart';
import 'package:seniorshield/views/splash_screen/splash2.dart';

class Splash1 extends StatefulWidget {
  const Splash1({Key? key}) : super(key: key);

  @override
  State<Splash1> createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500), // Adjust animation duration as needed
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();

    // Delay and then navigate to next screen
    Future.delayed(Duration(seconds: 3), () {
      Get.to(() => Splash2(), transition: Transition.fade); // Using fade transition
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Image.asset(logoColor),
        ),
      ),
    );
  }
}
