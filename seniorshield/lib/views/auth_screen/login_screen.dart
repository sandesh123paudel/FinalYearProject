import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/views/home_screen/homepage.dart';
import 'package:seniorshield/views/splash_screen/splash3.dart';
import 'package:seniorshield/widgets/responsive_text.dart';

import '../../constants/util/util.dart';
import '../../widgets/customLogin_textField.dart';
import '../home_screen/home.dart';

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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: kVerticalMargin * 3),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(
                   vertical: kVerticalMargin),
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
              padding: EdgeInsets.symmetric(horizontal: kHorizontalMargin*2,vertical: kVerticalMargin),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomLoginTextField(
                    labelText: 'Email',
                    hintText: 'sandeshpaudel@gmail.com',

                    keyboardType: TextInputType.emailAddress,

                  ),
                  SizedBox(height: kVerticalMargin),
                  CustomLoginTextField(
                    labelText: 'Password',
                    hintText: '***********',
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(kPrimaryColor), // Change color here
                      ),
                      child: ResponsiveText("Forget Password?",textColor: kPrimaryColor,),
                    ),
                  )

                ],
              ),
            ),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: kHorizontalMargin*2),
              child: SizedBox(
                width: double.infinity, // Set width to take full width
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(Home());
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: kHorizontalMargin * 2, vertical: kVerticalMargin),
                    child: ResponsiveText(
                      "Login",
                      fontSize: 16,
                      textColor: kDefaultIconLightColor,
                      textAlign: TextAlign.center,
                    ),
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
                  ResponsiveText("Haven't registered yet?",textColor: kDefaultIconDarkColor,),
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

