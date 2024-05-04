import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/constants/util/util.dart';
import 'package:seniorshield/widgets/responsive_text.dart';

import '../../api/apis.dart';
import '../../models/user_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class SensorData {
  final int sensorValue;
  final int bpm;
  final int spo2;

  SensorData({required this.sensorValue, required this.bpm, required this.spo2});

  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      sensorValue: json['piezo_electric']['sensor_value'],
      bpm: json['pulse_oximeter']['BPM'],
      spo2: json['pulse_oximeter']['SpO2'],
    );
  }
}

class FCMToken {
  final String token;

  FCMToken({required this.token});

  factory FCMToken.fromJson(Map<String, dynamic> json) {
    return FCMToken(
      token: json['token'],
    );
  }
}

class _HomePageState extends State<HomePage> {
  String? mtoken = " ";
  String _welcomeMessage = 'Welcome';
  String _fallDetection = 'Inactive';
  SensorData? _sensorData;
  UserModel loggedInUser = UserModel();


  DatabaseReference _sensorDataRef = FirebaseDatabase.instance.reference().child('pulse_oximeter');

  @override
  void initState() {
    super.initState();
    requestPermission();
    getToken();
    _retrieveSensorData();
    fetchUserData();

  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print("User granted provisional permission");
    } else {
      print("Permission Denied");
    }
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

  Future<void> getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print("My Token is $mtoken");
      });
      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    final DatabaseReference _database = FirebaseDatabase().reference();
    _database.child('fcm-token/token').set(token);
  }

  void _retrieveSensorData() {
    _sensorDataRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      if (snapshot.value != null && snapshot.value is Map<String, dynamic>) {
        setState(() {
          _sensorData = SensorData.fromJson(snapshot.value as Map<String, dynamic>);
        });
      }
    });
  }








  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double kVerticalMargin = 16.0;
    double kHorizontalMargin = 16.0;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Card
            Container(
              height: height / 5,
              padding: EdgeInsets.only(left: kHorizontalMargin, top: kVerticalMargin * 3),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [kPrimaryColor, Colors.greenAccent.shade700],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveText(
                    _welcomeMessage,
                    textAlign: TextAlign.start,
                    fontSize: 32,
                    textColor: kDefaultIconLightColor,
                  ),
                  SizedBox(height: kVerticalMargin),
                  Row(
                    children: [
                      ResponsiveText(
                        "Good Day,",
                        textAlign: TextAlign.start,
                        fontSize: 24,
                        textColor: kDefaultIconLightColor,
                      ),
                      ResponsiveText(
                       loggedInUser.fullName.toString(),
                        textAlign: TextAlign.start,
                        fontSize: 24,
                        textColor: kDefaultIconLightColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: kVerticalMargin),
            // Quote Card
            Container(
              height: height / 5,
              margin: EdgeInsets.only(left: kHorizontalMargin * 1.5, right: kHorizontalMargin * 1.5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [kPrimaryColor, Colors.greenAccent.shade700],
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ResponsiveText(
                      "Quote of the Day",
                      fontSize: 18,
                      textColor: kDefaultIconLightColor,
                    ),
                    ResponsiveText(
                      " 'Tit For Tat'",
                      fontSize: 20,
                      textColor: kDefaultIconLightColor,
                    )
                  ],
                ),
              ),
            ),
            // Heart Rate and SpO2 Cards
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 4,
                    color: kPrimaryColor,
                    margin: EdgeInsets.all(20),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ResponsiveText(
                            'Heart Rate',
                            fontSize: 20,
                            textColor: kDefaultIconLightColor,
                          ),
                          SizedBox(height: 10),
                          ResponsiveText(
                            _sensorData != null ? '${_sensorData!.bpm} bpm' : 'Unknown',
                            fontSize: 20,
                            textColor: kDefaultIconLightColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Card(
                    elevation: 4,
                    color: kPrimaryColor,
                    margin: EdgeInsets.all(20),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ResponsiveText(
                            'SpO2',
                            fontSize: 20,
                            textColor: kDefaultIconLightColor,
                          ),
                          SizedBox(height: 10),
                          ResponsiveText(
                            _sensorData != null ? '${_sensorData!.spo2} %' : 'Unknown',
                            fontSize: 20,
                            textColor: kDefaultIconLightColor,
                          ),
                          SizedBox(height: 25),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Fall Detection Card
            Card(
              elevation: 4,
              color: kPrimaryColor,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: ResponsiveText(
                  'Health Status: "Normal"',
                  fontSize: 20,
                  textColor: kDefaultIconLightColor,
                ),
              ),
            ),
            SizedBox(height: 20),
            Card(
              elevation: 4,
              color: kPrimaryColor,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: ResponsiveText(
                  'Fall Detection: $_fallDetection',
                  fontSize: 20,
                  textColor: kDefaultIconLightColor,
                ),
              ),
            ),

            SizedBox(height: 20),
            // Refresh Button
            Center(
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.refresh, color: kPrimaryColor),
                label: Text('Refresh'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

