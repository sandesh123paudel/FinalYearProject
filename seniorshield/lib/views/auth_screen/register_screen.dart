import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/models/user_model.dart';
import 'package:seniorshield/views/auth_screen/login_screen.dart';
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
  final _formKey = GlobalKey<FormState>();

  String? _fullNameErrorText;
  String? _emailErrorText;
  String? _addressErrorText;
  String? _passwordErrorText;
  String? _confirmPasswordErrorText;
  String? _selectedRole;
  bool _showError = false;
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kDefaultIconLightColor,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: kVerticalMargin * 3),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: kHorizontalMargin),
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
                    height: kVerticalMargin,
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: kHorizontalMargin * 2),
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
                        horizontal: kHorizontalMargin * 2,
                        vertical: kVerticalMargin),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomRegisterTextField(
                          labelText: 'Full Name',
                          hintText: 'Enter your Full Name',
                          keyboardType: TextInputType.text,
                          validator: _validateFullName,
                          controller: fullNameController,
                          errorText: _fullNameErrorText,
                          onChanged: (value) {
                            setState(() {
                              _fullNameErrorText = null;
                            });
                          },
                        ),
                        SizedBox(height: kVerticalMargin),
                        CustomRegisterTextField(
                          labelText: 'Email',
                          hintText: 'Enter your Email',
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          validator: _validateEmail,
                          errorText: _emailErrorText,
                          onChanged: (value) {
                            setState(() {
                              _emailErrorText = null;
                            });
                          },
                        ),
                        SizedBox(height: kVerticalMargin),
                        CustomRegisterTextField(
                          labelText: 'Address',
                          hintText: 'Enter your Address',
                          keyboardType: TextInputType.text,
                          validator: _validateAddress,
                          controller: addressController,
                          errorText: _addressErrorText,
                          onChanged: (value) {
                            setState(() {
                              _addressErrorText = null;
                            });
                          },
                        ),
                        SizedBox(height: kVerticalMargin),
                        ResponsiveText(
                          'Role',
                          fontSize: 16,
                          textColor: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: kPrimaryColor, width: 2),
                                borderRadius: BorderRadius.circular(8)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: kPrimaryColor, width: 2),
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          iconEnabledColor: kPrimaryColor,
                          value: _selectedRole,
                          onChanged: (value) {
                            setState(() {
                              _selectedRole = value;
                              _showError = false;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select a role';
                            }
                            return null;
                          },
                          items: [
                            DropdownMenuItem<String>(
                              value: "user",
                              child: ResponsiveText(
                                "User",
                                textColor: kPrimaryColor,
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "caretaker",
                              child: ResponsiveText(
                                "Care Taker",
                                textColor: kPrimaryColor,
                              ),
                            ),
                          ],
                          hint: ResponsiveText(
                            'Select Role',
                            fontWeight: FontWeight.bold,
                            textColor: kPrimaryColor,
                            fontSize: 16,
                          ),
                          style: TextStyle(color: kPrimaryColor),
                          dropdownColor: kDefaultIconLightColor,
                          focusColor: kPrimaryColor,
                        ),
                        _showError
                            ? Text(
                                'Please select a role',
                                style: TextStyle(color: Colors.redAccent),
                              )
                            : SizedBox(),
                        SizedBox(height: kVerticalMargin),
                        CustomRegisterTextField(
                          labelText: 'Password',
                          hintText: 'Enter Password',
                          obscureText: true,
                          validator: _validatePassword,
                          controller: passwordController,
                          errorText: _passwordErrorText,
                          onChanged: (value) {
                            setState(() {
                              _passwordErrorText = null;
                            });
                          },
                        ),
                        SizedBox(height: kVerticalMargin),
                        CustomRegisterTextField(
                          labelText: 'Confirm Password',
                          hintText: 'Re-enter your Password',
                          obscureText: true,
                          validator: (value) => _validateConfirmPassword(
                              passwordController.text, value),
                          controller: confirmPasswordController,
                          errorText: _confirmPasswordErrorText,
                          onChanged: (value) {
                            setState(() {
                              _confirmPasswordErrorText = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: kVerticalMargin),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: kHorizontalMargin * 2),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          signUp(emailController.text, passwordController.text);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(kPrimaryColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: kHorizontalMargin * 2,
                              vertical: kVerticalMargin),
                          child: ResponsiveText(
                            "Register",
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
                        ResponsiveText(
                          "Already registered?",
                          textColor: kDefaultIconDarkColor,
                        ),
                        SizedBox(width: kHorizontalMargin),
                        GestureDetector(
                          onTap: () {
                            Get.to(LoginScreen());
                          },
                          child: ResponsiveText(
                            "Login Now",
                            fontWeight: FontWeight.w600,
                            textColor: kPrimaryColor,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          _isLoading
              ? Container(
                  color: Colors.black
                      .withOpacity(0.5), // Transparent black color as overlay
                  child: Center(
                    child: CircularProgressIndicator(color: kPrimaryColor,),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    return null;
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

  String? _validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  String? _validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  void signUp(String email, String password) async {
    // Validate all fields
    _fullNameErrorText = _validateFullName(fullNameController.text);
    _emailErrorText = _validateEmail(emailController.text);
    _selectedRole = _selectedRole;
    _addressErrorText = _validateAddress(addressController.text);
    _passwordErrorText = _validatePassword(passwordController.text);
    _confirmPasswordErrorText = _validateConfirmPassword(
        passwordController.text, confirmPasswordController.text);
    // Check if any error exists
    _showError = _fullNameErrorText != null ||
        _selectedRole == null ||
        _emailErrorText != null ||
        _addressErrorText != null ||
        _passwordErrorText != null ||
        _confirmPasswordErrorText != null;

    // If any error exists, update the state to show the errors
    if (_showError) {
      setState(() {});
      return;
    }

    setState(() {
      // Show loading indicator
      _isLoading = true;
    });

    try {
      // Attempt to create user account
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      // If successful, post user details to Firestore
      await postDetailsToFirestore(email);
    } catch (e) {
      // Handle exceptions
      String errorMessage = 'An error occurred';
      if (e is FirebaseAuthException) {
        if (e.code == 'email-already-in-use') {
          errorMessage = 'The email address is already in use';
        } else {
          errorMessage = 'Authentication failed: ${e.message}';
        }
      }
      // Show error message
      Fluttertoast.showToast(msg: errorMessage);
    } finally {
      // Hide loading indicator
      setState(() {
        _isLoading = false;
      });
    }
  }

  postDetailsToFirestore(String email) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    final time=DateTime.now().millisecondsSinceEpoch.toString();

    if (user != null) {
      UserModel userModel = UserModel(
        email: user.email.toString(),
        uid: user.uid,
        fullName: fullNameController.text,
        role: _selectedRole.toString(),
        address: addressController.text,
        image:'https://static.vecteezy.com/system/resources/thumbnails/002/002/427/small/man-avatar-character-isolated-icon-free-vector.jpg',
        about: 'Senior Shield Chat Is Best',
        createdAt: time,
        isOnline: false,
        lastActive: time,
        pushToken: '1skl',
      );

      try {
        await firebaseFirestore
            .collection("users")
            .doc(user.uid)
            .set(userModel.toJson());
        Fluttertoast.showToast(msg: "Account Created Successfully :) ");

        Get.to(LoginScreen());
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }
}
