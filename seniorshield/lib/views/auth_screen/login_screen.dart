import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/views/splash_screen/splash3.dart';
import 'package:seniorshield/widgets/responsive_text.dart';

import '../../constants/util/util.dart';
import '../../widgets/custom_textField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDefaultIconLightColor,
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: kVerticalMargin * 3),
            GestureDetector(
              onTap: () {
                Get.to(Splash3());
              },
              behavior: HitTestBehavior.translucent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: kHorizontalMargin),
                child: Icon(
                  Icons.arrow_back_outlined,
                  size: 32,
                  color: kPrimaryColor,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: kHorizontalMargin * 3, vertical: kVerticalMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveText(
                    "Let's Sign you in.",
                    fontSize: 30,
                    fontWeight: FontWeight.w600,

                    textColor: kPrimaryColor,
                  ),
                  ResponsiveText(
                    "Welcome Back",
                    fontSize: 25,

                    textColor: kPrimaryColor,
                  ),
                  ResponsiveText(
                    "You've been missed!",
                    fontSize: 25,

                    textColor: kPrimaryColor,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: kHorizontalMargin*3,vertical: kVerticalMargin),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    labelText: 'Email',
                    hintText: 'sandeshpaudel@gmail.com',

                    keyboardType: TextInputType.emailAddress,

                  ),
                  SizedBox(height: kVerticalMargin),
                  CustomTextField(
                    labelText: 'Password',
                    hintText: '***********',
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                ],
              ),
            ),
            SizedBox(height: kVerticalMargin),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kHorizontalMargin*3),
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
                    "Login",
                    fontSize: 16,
                    textColor: kDefaultIconLightColor,
                    textAlign: TextAlign.center, // Aligns text in the center
                  ),
                ),
              ),
            ),
            SizedBox(height: kVerticalMargin),
            Container(
              margin:  EdgeInsets.only(bottom: kVerticalMargin*2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ResponsiveText("Haven't registerd yet?",textColor: kDefaultIconDarkColor,),
                  SizedBox(width: kHorizontalMargin),
                  ResponsiveText("Register!",fontWeight: FontWeight.w600,textColor: kPrimaryColor,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

