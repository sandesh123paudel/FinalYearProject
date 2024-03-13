import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/views/splash_screen/splash3.dart';
import 'package:seniorshield/widgets/responsive_text.dart';

import '../../constants/util/util.dart';
import '../../widgets/customRegister_textField.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDefaultIconLightColor,
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: kVerticalMargin * 3),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kHorizontalMargin),
              child: GestureDetector(
                onTap: () {
                  Get.to(const Splash3());
                },
                behavior: HitTestBehavior.translucent,
                child: const Icon(
                  Icons.arrow_back_outlined,
                  size: 32,
                  color: kPrimaryColor,
                ),
              ),
            ),
            SizedBox(
                height: kVerticalMargin),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kHorizontalMargin * 2),
              child: const Align(
                alignment: Alignment.centerRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ResponsiveText(
                      "SignUp",
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      textColor: kPrimaryColor,
                    ),
                    ResponsiveText(
                      "To Get Started!",
                      fontSize: 25,
                      textColor: kPrimaryColor,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: kVerticalMargin),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: kHorizontalMargin * 2, vertical: kVerticalMargin),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomRegisterTextField(
                    labelText: 'Full Name',
                    hintText: 'Enter your Full Name',
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: kVerticalMargin),

                  CustomRegisterTextField(
                    labelText: 'Email',
                    hintText: 'Enter your Email',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: kVerticalMargin),

                  CustomRegisterTextField(
                    labelText: 'Address',
                    hintText: 'Enter your Address',
                    keyboardType: TextInputType.text,
                  ),
                  SizedBox(height: kVerticalMargin),

                  DropdownButton<String>(
                    padding: EdgeInsets.all(kHorizontalMargin/2),
                    isExpanded: true,
                    dropdownColor: kPrimaryColor,
                    focusColor: kGreenBorderColor,
                    borderRadius: BorderRadius.circular(16),
                    items: [
                      DropdownMenuItem<String>(
                        value: "role1",
                        child: ResponsiveText("User",textColor: kDefaultIconLightColor,),
                      ),
                      DropdownMenuItem<String>(
                        value: "role2",
                        child: ResponsiveText("Care Taker",textColor: kDefaultIconLightColor,),
                      ),


                    ],
                    onChanged: (value) {
                      value=value;
                    },
                    hint: ResponsiveText(
                      'Select Role',
                      fontWeight: FontWeight.bold,
                      textColor: kPrimaryColor,
                      fontSize: 16,
                    ),
                    icon: Icon(Icons.arrow_drop_down,color: kPrimaryColor,), // Custom dropdown icon
                    elevation: 1, // Custom dropdown elevation
                    style: TextStyle(color: kPrimaryColor), // Custom text style
                    underline: Container(
                      // Custom underline
                      height: 1,
                      width: double.infinity,
                      color: kPrimaryColor,
                    ),
                  ),
                  SizedBox(height: kVerticalMargin),
                  CustomRegisterTextField(
                    labelText: 'Password',
                    hintText: 'Enter Password',
                    obscureText: true,
                  ),
                  SizedBox(height: kVerticalMargin),

                  CustomRegisterTextField(
                    labelText: 'Confirm Password',
                    hintText: 'Re-enter your Password',
                    obscureText: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: kVerticalMargin),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: kHorizontalMargin*2),
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
                    "Register",
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
                  ResponsiveText("Already registered?",textColor: kDefaultIconDarkColor,),
                  SizedBox(width: kHorizontalMargin),
                  ResponsiveText("Login Now",fontWeight: FontWeight.w600,textColor: kPrimaryColor,)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
