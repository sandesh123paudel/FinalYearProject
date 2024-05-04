import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/models/user_model.dart';
import 'package:seniorshield/views/auth_screen/forget_password.dart';
import 'package:seniorshield/views/auth_screen/register_screen.dart';
import 'package:seniorshield/views/home_screen/home.dart';
import 'package:seniorshield/views/home_screen/homepage.dart';
import 'package:seniorshield/views/splash_screen/splash3.dart';
import 'package:seniorshield/widgets/customLogin_textField.dart';
import 'package:seniorshield/widgets/responsive_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/util/util.dart';
import '../../services/shared_preferences.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _emailErrorText;
  String? _passwordErrorText;
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String? validateEmail(String? value) {
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

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          _isLoading = true; // Set _isLoading to true when signing in
        });
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);

        Fluttertoast.showToast(msg: "Login Successfull");

        // Extract user information from Firestore
        DocumentSnapshot<Map<String, dynamic>> userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
        UserModel user = UserModel.fromJson(userSnapshot.data()!);

        // Save user information in SharedPreferences
        SharedPreferencesHelper sharedPreferencesHelper = SharedPreferencesHelper();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        await sharedPreferencesHelper.saveUserId(user.uid!);
        await sharedPreferencesHelper.saveFullName(user.fullName!);
        await sharedPreferencesHelper.saveEmail(user.email!);
        await sharedPreferencesHelper.saveRole(user.role!);
        await sharedPreferencesHelper.saveAddress(user.address!);


        setState(() {
          _isLoading = false; // Set _isLoading to true when signing in
        });
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Home()));
      } on FirebaseAuthException catch (error) {
        setState(() {
          _isLoading = false; // Set _isLoading to true when signing in
        });
        String errorMessage;
        switch (error.code) {
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = error.message ?? "An undefined Error happened.";
        }
        if (error.code == "invalid-credential") {
          errorMessage = "Error Logging In. Invalid Credentials!!";
        }
        Fluttertoast.showToast(msg: errorMessage,backgroundColor: Colors.red);
      } catch (e) {
        setState(() {
          _isLoading = false; // Set _isLoading to true when signing in
        });
        Fluttertoast.showToast(msg: e.toString(),backgroundColor: Colors.red);
      }
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDefaultIconLightColor,
      body: Stack(
        children:[SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Form(
            key: _formKey,
            child:Column(
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
                    padding: EdgeInsets.symmetric(vertical: kVerticalMargin),
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
                    padding: EdgeInsets.symmetric(horizontal: kHorizontalMargin * 2, vertical: kVerticalMargin),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomLoginTextField(
                          labelText: 'Email',
                          hintText: 'sandeshpaudel@gmail.com',
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          validator: validateEmail,
                          errorText: _emailErrorText,
                          onChanged: (value) {
                            setState(() {
                              _emailErrorText = null;
                            });
                          },
                        ),
                        SizedBox(height: kVerticalMargin),
                        CustomLoginTextField(
                          labelText: 'Password',
                          hintText: '***********',
                          obscureText: true,
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordController,
                          validator: validatePassword,
                          errorText: _passwordErrorText,
                          onChanged: (value) {
                            setState(() {
                              _passwordErrorText = null;
                            });
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Get.to(ForgotPasswordScreen());
                            },
                            style: ButtonStyle(
                              foregroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
                            ),
                            child: ResponsiveText("Forget Password?", textColor: kPrimaryColor,),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: kHorizontalMargin * 2),
                    child: SizedBox(
                      width: double.infinity,
                      child:ElevatedButton(
                          onPressed: () {
                            signIn(emailController.text, passwordController.text);
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
                    margin: EdgeInsets.only(bottom: kVerticalMargin * 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ResponsiveText("Haven't registered yet?", textColor: kDefaultIconDarkColor,),
                        SizedBox(width: kHorizontalMargin),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                            child: ResponsiveText("Register!", fontWeight: FontWeight.w600, textColor: kPrimaryColor,),
                          onTap: ()
                          {
                            Get.to(RegisterScreen());
                          },
                        )
                      ],
                    ),
                  )
                ],
        
            ),
          ),
        ),
          _isLoading?Container(
            color: Colors.black.withOpacity(0.5), // Transparent black color as overlay
            child: Center(
              child: CircularProgressIndicator(color: kPrimaryColor,),
            ),
          )
              : SizedBox.shrink(),
    ]
      ),
    );
  }
}
