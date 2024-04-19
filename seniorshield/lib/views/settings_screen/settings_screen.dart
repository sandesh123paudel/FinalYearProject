import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seniorshield/views/auth_screen/login_screen.dart';
import 'package:seniorshield/widgets/responsive_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';
import '../../models/user_model.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var userData = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();
      setState(() {
        loggedInUser = UserModel.fromMap(userData.data()!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.man),
              ResponsiveText("${loggedInUser.fullName}"),
              ResponsiveText("${loggedInUser.address}"),

              ResponsiveText("${loggedInUser.email}"),
              ElevatedButton(
                onPressed: () {
                  logout(context);
                },
                child: ResponsiveText("Logout"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userId');
    await prefs.remove('email');

    // Sign out user
    await FirebaseAuth.instance.signOut();

    // Navigate to login screen
    Get.offAll(LoginScreen()); // Use Get.offAll() to clear the navigation stack
  }

}
