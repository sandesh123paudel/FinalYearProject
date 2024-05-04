import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/views/splash_screen/splash3.dart';
import 'package:seniorshield/widgets/responsive_text.dart';
import '../../constants/images.dart';
import '../../constants/util/util.dart';

class Splash2 extends StatefulWidget {
  const Splash2({super.key});

  @override
  State<Splash2> createState() => _Splash2State();
}

class _Splash2State extends State<Splash2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                logoNoBg,
                height: height / 3,
                width: width / 1.5,
              ),
            ],
          ),
          Image.asset(
            splash2,
            width: width,
          ),
          SizedBox(height: kVerticalMargin * 5),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: kHorizontalMargin * 2),
              child: ResponsiveText(
                "First and foremost it’s about giving back to people that helped our fight",
                textColor: kPrimaryColor,
                fontFamily: 'RobotoMono',
                fontSize: 15,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            child: SizedBox(
              width: double.infinity,
              child: Container(
                margin: EdgeInsets.only(bottom: kVerticalMargin),
                padding: EdgeInsets.symmetric(
                    horizontal: kHorizontalMargin * 2,
                    vertical: kVerticalMargin),
                decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(32)),
                child: ResponsiveText(
                  "Get Started",
                  fontSize: 16,
                  fontFamily: 'RobotoMono',
                  textColor: kDefaultIconLightColor,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            onTap: () {
              Get.to(Splash3());
            },
          )
        ],
      ),
    ));
  }
}
