import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/views/auth_screen/login_screen.dart';
import 'package:seniorshield/widgets/responsive_text.dart';

import '../../constants/util/util.dart';
import '../../widgets/customRegister_textField.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _emailError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text("Forget Password"),
        foregroundColor: kDefaultIconLightColor,
      ),
      backgroundColor: kDefaultIconLightColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: kHorizontalMargin * 2),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: kVerticalMargin),
                ResponsiveText(
                  "Forgot your password? Don't worry!",
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: kPrimaryColor,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: kVerticalMargin / 2),
                ResponsiveText(
                  "Enter your email and we will send you a password reset link",
                  textColor: kPrimaryColor,
                ),
                SizedBox(height: kVerticalMargin),
                CustomRegisterTextField(
                  labelText: 'Email',
                  hintText: 'Enter your Email',
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: _validateEmail,
                  errorText: _emailError,
                ),
                SizedBox(height: kVerticalMargin),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        passwordReset();
                      }
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
                        "Reset Password",
                        fontSize: 16,
                        textColor: kDefaultIconLightColor,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: kVerticalMargin),
                TextButton(
                  onPressed: () {
                    Get.to(LoginScreen());
                  },
                  child: Row(
                    children: [
                      Icon(Icons.keyboard_arrow_left, color: kPrimaryColor),
                      ResponsiveText(
                        "Back to Login",
                        fontWeight: FontWeight.w600,
                        textColor: kPrimaryColor,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  Future<bool> checkIfEmailExists(String email) async {
    try {
      // Query the users collection to check if any document has the provided email
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      // If any documents match the query, the email exists
      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      // Handle any errors, such as network issues or database errors
      print("Error checking if email exists: $e");
      return false; // Assuming the email doesn't exist in case of error
    }
  }

  Future<void> passwordReset() async {
    // Check if email is valid before attempting password reset
    String? emailError = _validateEmail(_emailController.text.trim());
    if (emailError == null) {
      // Check if the email exists in the database
      bool emailExists = await checkIfEmailExists(_emailController.text.trim());
      if (emailExists) {
        try {
          await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim());
          Fluttertoast.showToast(msg: "Reset Link Has Been Sent to your email");
          Get.to(LoginScreen());
        } on FirebaseAuthException catch (e) {
          Fluttertoast.showToast(msg: e.message!);
        }
      } else {
        Fluttertoast.showToast(msg: "This email is not registered.");
      }
    } else {
      setState(() {
        _emailError = emailError;
      });
    }
  }




  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}
