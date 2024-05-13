import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:seniorshield/constants/images.dart';
import 'package:seniorshield/constants/util/util.dart';
import 'package:seniorshield/services/my_date_utitl.dart';
import 'package:seniorshield/views/auth_screen/login_screen.dart';
import 'package:seniorshield/widgets/responsive_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../api/apis.dart';
import '../../constants/colors.dart';
import '../../models/user_model.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    Key? key,
  });

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

  UserModel loggedInUser = UserModel();
  String?  _image;
  final _formKey = GlobalKey<FormState>();


  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _aboutController = TextEditingController();


  String defaultImageUrl =
      'https://static.vecteezy.com/system/resources/thumbnails/002/002/427/small/man-avatar-character-isolated-icon-free-vector.jpg';

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
        loggedInUser = UserModel.fromJson(userData.data()!);
        _nameController.text = loggedInUser.fullName ?? '';
        _emailController.text = loggedInUser.email ?? '';
        _addressController.text = loggedInUser.address ?? '';
        _aboutController.text = loggedInUser.about ?? '';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _aboutController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: ResponsiveText(
            "User Profile",
            textColor: kDefaultIconLightColor,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          leading: Icon(
            CupertinoIcons.person_circle,
            color: kDefaultIconLightColor,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: kHorizontalMargin * 2),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: kVerticalMargin),
                  Stack(
                    children: [
                      _image!=null?ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child:  ClipRRect(
                            borderRadius:
                            BorderRadius.circular(100),
                            child: Image.file(File(_image!),
                                width: width*0.45,
                                height:height*0.2,
                                fit: BoxFit.cover))):
                      ClipRRect(
                        borderRadius:BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          width: width*0.45,
                          height:height*0.2,
                          fit: BoxFit.fill,
                          imageUrl: loggedInUser.image.toString(),
                          errorWidget: (context, url, error) =>
                          const CircleAvatar(
                              child: Icon(CupertinoIcons.person)),
                        ),
                      ),
                      Positioned(
                        bottom:0,
                        right: 0,
                        child: MaterialButton(onPressed: (){
                          _showBottomSheet();
                        },
                          elevation: 1,
                          color: kDefaultIconLightColor,
                          shape: const CircleBorder(),
                        child:const Icon(Icons.edit,color: kPrimaryColor,) ,
                        ),
                      )
                    ],
                  ),
                  ResponsiveText(
                    loggedInUser.role.toString().toUpperCase(),
                    fontSize: 20,
                    textAlign: TextAlign.center,
                    textColor: kPrimaryColor,
                  ),
                  SizedBox(height: kVerticalMargin),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(color: kPrimaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: kPrimaryColor.withOpacity(0.5)),
                      ),
                      filled: true,
                      fillColor: kPrimaryColor.withOpacity(0.1),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },

                  ),
                  SizedBox(height: kVerticalMargin),
                  TextFormField(
                    controller: _emailController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: kPrimaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: kPrimaryColor.withOpacity(0.5)),
                      ),
                      filled: true,
                      fillColor: kPrimaryColor.withOpacity(0.1),
                    ),
                  ),
                  SizedBox(height: kVerticalMargin),
                  TextFormField(
                    controller: _aboutController,
                    decoration: InputDecoration(
                      labelText: 'About',
                      labelStyle: TextStyle(color: kPrimaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: kPrimaryColor.withOpacity(0.5)),
                      ),
                      filled: true,
                      fillColor: kPrimaryColor.withOpacity(0.1),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter something about yourself';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: kVerticalMargin),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      labelStyle: TextStyle(color: kPrimaryColor),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: kPrimaryColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: kPrimaryColor.withOpacity(0.5)),
                      ),
                      filled: true,
                      fillColor: kPrimaryColor.withOpacity(0.1),

                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),


                  SizedBox(height: kVerticalMargin),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateColor.resolveWith((states) => kPrimaryColor)
                    ),
                    onPressed: () {

                      if (_formKey.currentState!.validate()) {
                        updateUserData();
                      }

                    },
                    child: ResponsiveText(
                      'Update Profile',
                      textColor: kDefaultIconLightColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            onPressed: () {
             performLogout(context);
            },
            icon: Icon(Icons.add_comment_rounded, color: kDefaultIconLightColor),
            backgroundColor: kPrimaryColor,
            label: ResponsiveText("Logout", textColor: kDefaultIconLightColor),
          ),
        )


    );
  }


  void _showBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (_) {
        return ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(top: kVerticalMargin * 2, bottom: kVerticalMargin * 2),
          children: [
            const ResponsiveText(
              "Pick Profile Picture",
              textColor: kPrimaryColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: kVerticalMargin),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(100, 100),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.camera,imageQuality: 60);
                    if (image != null) {

                      setState(() {
                        _image = image.path;
                      });
                      APIs.updateProfilePicture(File(_image!));
                      Navigator.pop(context);
                    }
                  },
                  child: Image.asset(camera, height: 90),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(100, 100),
                  ),
                  onPressed: () async {
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(source: ImageSource.gallery,imageQuality: 60);
                    if (image != null) {
                      print('ImagePath: ${image.path}');
                      setState(() {
                        _image = image.path;
                      });
                      APIs.updateProfilePicture(File(_image!));

                      Navigator.pop(context);
                    }
                  },
                  child: Image.asset(files, height: 90),
                )
              ],
            ),
             // Show circular image if _image is not null
          ],
        );
      },
    );
  }


  void updateUserData() {
    UserModel updatedUser = UserModel(
      uid: loggedInUser.uid,
      fullName: _nameController.text.trim() != loggedInUser.fullName
          ? _nameController.text.trim()
          : loggedInUser.fullName,
      email: _emailController.text.trim() != loggedInUser.email
          ? _emailController.text.trim()
          : loggedInUser.email,
      address: _addressController.text.trim() != loggedInUser.address
          ? _addressController.text.trim()
          : loggedInUser.address,
      about: _aboutController.text.trim() != loggedInUser.about
          ? _aboutController.text.trim()
          : loggedInUser.about, // Update about field
      role: loggedInUser.role,
      image: loggedInUser.image,
      createdAt: loggedInUser.createdAt,
      isOnline: loggedInUser.isOnline,
      lastActive: loggedInUser.lastActive,
      pushToken: loggedInUser.pushToken,
    );

    APIs.updateUserData(updatedUser);

    Fluttertoast.showToast(
      msg: "User updated successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: kPrimaryColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }




}


Future<void> performLogout(BuildContext context) async {
  // Show confirmation dialog first
  bool confirmLogout = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Logout'),
        content: Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            child: Text('Cancel', style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.of(context).pop(false), // Return false on cancel
          ),
          TextButton(
            child: Text('Logout', style: TextStyle(color: kPrimaryColor)),
            onPressed: () => Navigator.of(context).pop(true), // Return true on logout
          ),
        ],
      );
    },
  );

  // Proceed with logout if confirmed
  if (confirmLogout) {
    try {
      // Showing a loading dialog with primary color
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: kPrimaryColor, // Set background color to primary color
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(backgroundColor: Colors.white),
                SizedBox(width: 20), // Spacing between spinner and text
                Text("Logging out...", style: TextStyle(color: Colors.white)),
              ],
            ),
          );
        },
      );

      // Update active status and sign out
      // await APIs.updateActiveStatus(false);
      await FirebaseAuth.instance.signOut();

      // Clear shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);

      // Dismiss all dialogs and push the user to the login screen
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));

      Fluttertoast.showToast(
        msg: "Logout successful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: kPrimaryColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      Navigator.of(context).pop(); // Close the loading dialog
      Fluttertoast.showToast(
        msg: "Logout failed: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
