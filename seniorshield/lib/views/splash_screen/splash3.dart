import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/constants/util/util.dart';
import 'package:seniorshield/views/auth_screen/login_screen.dart';
import 'package:seniorshield/widgets/responsive_text.dart';
import '../../constants/images.dart';

class Splash3 extends StatefulWidget {
  const Splash3({super.key});

  @override
  State<Splash3> createState() => _Splash3State();
}

class _Splash3State extends State<Splash3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(splash3),
                fit: BoxFit.cover,
              ),
            ),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), // Adjust opacity here
                BlendMode.darken, // You can change blend mode as needed
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0), // Optional: Add blur effect
                child: Container(
                  color: Colors.black.withOpacity(0), // Optional: Add additional overlay color
                ),
              ),
            ),
          ),

          // Content container
          Padding(
            padding:  EdgeInsets.all(kHorizontalMargin),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(logoNoBg,height:height/4 ,width: width/1.5,),
                  ],
                ),
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: kHorizontalMargin*2),
                  child: ResponsiveText(
                    "Fusce a consectetur velit. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Proin vitae ex neque.",
                    textColor: kPrimaryColor,
                    fontFamily: 'RobotoMono',
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: kVerticalMargin*4),
                styledButton("Login", () {
                  Get.to(LoginScreen());
                }),
                styledButton("Register", () {
                  // Handle register tap
                }),

              ],
            ),
          ),
        ],
      ),
    );
  }

}

Widget styledButton(String text, Function() onTap) {
  return GestureDetector(
    behavior: HitTestBehavior.translucent,
    onTap: onTap,
    child: SizedBox(
      width: double.infinity, // Ensures buttons take full width
      child: Container(
        margin:  EdgeInsets.only(bottom:kVerticalMargin),
        padding:  EdgeInsets.symmetric(horizontal:kHorizontalMargin*2,vertical: kVerticalMargin),
        decoration: BoxDecoration(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(32),
        ),
        child: ResponsiveText(
          text,
          fontSize: 16,
          fontFamily: 'RobotoMono',
          textColor: kDefaultIconLightColor,
          textAlign: TextAlign.center, // Aligns text in the center
        ),
      ),
    ),
  );
}
