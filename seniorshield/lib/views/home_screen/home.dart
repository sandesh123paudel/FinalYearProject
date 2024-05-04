import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/views/bmi_screen/bmi_screen.dart';
import 'package:seniorshield/views/chat_screen/chat_screen.dart';

import 'package:seniorshield/views/home_screen/homepage.dart';
import 'package:seniorshield/views/pill_remainder_screen/pillremainder_screen.dart';
import 'package:seniorshield/views/settings_screen/settings_screen.dart';
import '../../constants/images.dart';
import '../../controllers/homepage_controller.dart';

class Home extends StatefulWidget {

  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {

    //init home controller
    var controller = Get.put(HomeController());

    var navbarItem = [
      BottomNavigationBarItem(
        icon: Image.asset(home, height: 35, width: 35),
        label: "Home",
      ),
      BottomNavigationBarItem(
        icon: Image.asset(bmi, height: 35, width: 35),
        label: "BMI",
      ),
      BottomNavigationBarItem(
        icon: Image.asset(pill, height: 35, width: 35),
        label: "Pill Remainder",
      ),
      BottomNavigationBarItem(
        icon: Image.asset(chat, height: 35, width: 35,),
        label: "Chat",
      ),
      BottomNavigationBarItem(
        icon: Image.asset(settings, height: 35, width: 35),
        label: "Settings",
      ),
    ];


    var navBody = [
       const HomePage(),
      const BMIScreen(),
      const PillRemainderScreen(),
      const ChatScreen(),
       const SettingScreen(),
    ];

    return Scaffold(
      body: Column(
        children: [
          Obx(
                () => Expanded(
              child: _buildAnimatedSwitcher(controller, navBody),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          currentIndex: controller.currentNavIndex.value,
          unselectedItemColor: kDefaultIconLightColor,
          selectedItemColor: kDefaultIconLightColor,
          unselectedLabelStyle:const  TextStyle(fontFamily: 'RobotMono'),
          selectedLabelStyle: const TextStyle(fontFamily: 'RobotoMono'),
          type: BottomNavigationBarType.fixed,
          backgroundColor: kPrimaryColor,
          items: navbarItem,
          onTap: (value) {
            controller.currentNavIndex.value = value;
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedSwitcher(HomeController controller, List<Widget> navBody) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500), // Adjust duration as needed
      child: navBody[controller.currentNavIndex.value],
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0), // Slide from right to left
            end: const Offset(0.0, 0.0),
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}
