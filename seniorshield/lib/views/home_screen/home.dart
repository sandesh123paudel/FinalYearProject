

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/views/bmi_screen/bmi_screen.dart';
import 'package:seniorshield/views/chat_screen/chat_screen.dart';
import 'package:seniorshield/views/home_screen/homepage.dart';
import 'package:seniorshield/views/pill_remainder_screen/pillremainder_screen.dart';
import 'package:seniorshield/views/settings_screen/settings_screen.dart';

import '../../constants/images.dart';
import '../../controllers/homepage_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
      const SettingScreen()
    ];

    return Scaffold(
      body: Column(
        children: [
          Obx(
                () => Expanded(
              child: navBody.elementAt(controller.currentNavIndex.value),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          currentIndex: controller.currentNavIndex.value,
          unselectedItemColor: kDefaultIconLightColor,
          selectedItemColor: kDefaultIconLightColor,
          unselectedLabelStyle: TextStyle(fontFamily: 'RobotMono'),
          selectedLabelStyle: TextStyle(fontFamily: 'RobotoMono'),
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
}
