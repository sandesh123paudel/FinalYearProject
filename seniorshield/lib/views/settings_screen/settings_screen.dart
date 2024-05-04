import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      });
    }
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
          child: Center(
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
                  loggedInUser.email.toString(),
                  fontSize: 20,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: kVerticalMargin),
                Container(
                  width: width,
                  padding: EdgeInsets.all(kHorizontalMargin),
                  height: kVerticalMargin*3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Colors.green.shade100
                  ),
                  child: ResponsiveText('Name: ${loggedInUser.fullName}',fontSize: 18,fontWeight:FontWeight.bold,textAlign: TextAlign.center),
                ),
                SizedBox(height: kVerticalMargin),
                Container(
                  width: width,
                  padding: EdgeInsets.all(kHorizontalMargin),
                  height: kVerticalMargin*3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Colors.green.shade100
                  ),
                  child: ResponsiveText('Address: ${loggedInUser.address}',fontSize: 18,fontWeight:FontWeight.bold,textAlign: TextAlign.center),
                ),
                SizedBox(height: kVerticalMargin),
                Container(
                  width: width,
                  padding: EdgeInsets.all(kHorizontalMargin),
                  height: kVerticalMargin*3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      color: Colors.green.shade100
                  ),
                  child: ResponsiveText('Joined On: ${MyDateUtil.getFormattedDate(context: context, time: loggedInUser.createdAt.toString())}',fontSize: 18,fontWeight:FontWeight.bold,textAlign: TextAlign.center),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) {
                  return const Center(
                    child: CircularProgressIndicator(color: kPrimaryColor,),
                  );
                },
              );

              try {
                await APIs.updateActiveStatus(false);
                await APIs.auth.signOut();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool('isLoggedIn', false);
                Navigator.pop(context); // Dismiss the progress indicator dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Sign Out'),
                      content: const Text('You have been signed out successfully.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Dismiss the dialog
                            Navigator.pop(context); // Dismiss the current screen
                            APIs.auth = FirebaseAuth.instance;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => LoginScreen()),
                            );
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } catch (e) {
                // Handle sign out error
                // You can show an error dialog or perform any other action here
                Navigator.pop(context); // Dismiss the progress indicator dialog
              }
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



}
