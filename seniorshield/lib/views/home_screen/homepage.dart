import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seniorshield/constants/colors.dart';
import 'package:seniorshield/constants/util/util.dart';
import 'package:seniorshield/widgets/responsive_text.dart';
import '../../models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'quotes.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel loggedInUser = UserModel();
  final databaseRef = FirebaseDatabase.instance.ref();
  String healthStatus = "--";
  final _healthStatusController = StreamController<String>.broadcast();
  Timer? _healthStatusTimer;
  final _sensorDataController = StreamController<Map<String, dynamic>>.broadcast(); // Define _sensorDataController here
  late String selectedQuote;
  late FlutterLocalNotificationsPlugin? localNotification;

  void selectRandomQuote() {
    final Random random = Random();
    selectedQuote = quotes[random.nextInt(quotes.length)];
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
    selectRandomQuote();
    _startHealthStatusUpdates();
    initLocalNotification();

    _sensorDataController.stream.listen((sensorData) {
      final bpm = sensorData['BPM'];
      final spo2 = sensorData['SpO2'];

      if (bpm != null && spo2 != null) {
        _updateHealthStatus(bpm.toString(), spo2.toString());
      }
    });

  }

  @override
  void dispose() {
    _healthStatusTimer?.cancel();
    _healthStatusController.close();
    _sensorDataController.close();
    super.dispose();
  }
  void _startHealthStatusUpdates() {
    const duration = Duration(seconds: 10); // Update health status every 10 seconds
    _healthStatusTimer = Timer.periodic(duration, (_) {
      final bpm = _latestSensorData['BPM'];
      final spo2 = _latestSensorData['SpO2'];

      if (bpm != null && spo2 != null) {
        _updateHealthStatus(bpm.toString(), spo2.toString());
      }
    });
  }

  Future<void> _updateHealthStatus(String bpm, String spo2) async {
    final bpm = _latestSensorData['BPM'];
    final spo2 = _latestSensorData['SpO2'];

    if (bpm != null && spo2 != null) {
      final healthStatus = await _loadCSV(
        10.toString(),
        bpm.toString(),
        spo2.toString(),
      );
      _healthStatusController.sink.add(healthStatus);
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
  Future<String> _loadCSV(String time, String hr, String spo2) async {
    String apiLink = "192.168.254.2:8000";
    final client = http.Client();
    var result = "";
    try {
      var url = Uri.http(apiLink, 'predict/');
      var response = await http.post(
        url,
        body: {"time": time, "hr": hr, "spo2": spo2},
        // Set timeout to 30 seconds
        // headers: {'Content-Type': 'application/json'},
      ).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        // Parse JSON response if successful
        final data = jsonDecode(response.body);
        result = data["status"];
      } else if (response.statusCode >= 400 && response.statusCode < 500) {
        // Handle client errors (e.g., 404 Not Found)
        print("Client Error: ${response.statusCode}");
        result = "Client Error";
      } else if (response.statusCode >= 500 && response.statusCode < 600) {
        // Handle server errors (e.g., 500 Internal Server Error)
        print("Server Error: ${response.statusCode}");
        result = "Server Error";
      } else {
        // Handle other status codes
        print("Unexpected Error: ${response.statusCode}");
        result = "Unexpected Error";
      }
    } on SocketException catch (e) {
      // Handle SocketException
      print("Socket Exception: ${e.message}");
      result = "Socket Exception";
    } on http.ClientException catch (e) {
      // Handle http.ClientException
      print("Client Exception: ${e.message}");
      result = "Client Exception";
    } catch (e) {
      // Handle other exceptions
      print("Exception: $e");
      result = "Error";
    } finally {
      client.close(); // Close the client when done
      return result;
    }


  }

  void initLocalNotification() {
    var androidInitialize = new AndroidInitializationSettings('ic_launcher');
    var initializationsSettings = new InitializationSettings(
        android: androidInitialize);
    localNotification = new FlutterLocalNotificationsPlugin();
    localNotification?.initialize(initializationsSettings);
  }

  Future<void> showNotification(String title, String body) async {
    var androidDetails = new AndroidNotificationDetails(
      "channelId",
      "Local Notification",
      channelDescription: "Channel Description",
      importance: Importance.high,
    );
    var generalNotificationDetails = new NotificationDetails(
        android: androidDetails);

    await localNotification?.show(0, title, body, generalNotificationDetails);
  }









  // Add a variable to hold the latest sensor data
  Map<String, dynamic> _latestSensorData = {};

// Modify the getSensorDataStream method to capture the latest sensor data
  Stream<Map<String, dynamic>> getSensorDataStream() {
    return databaseRef.child('sensorData').onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      Map<String, dynamic> latestData = {};

      if (data != null) {
        var sortedEntries = data.entries.toList()
          ..sort((a, b) {
            var aTime = DateTime.parse(
                '${DateTime.now().toIso8601String().split("T")[0]}T${a.value["fields"]["timestamp"]}');
            var bTime = DateTime.parse(
                '${DateTime.now().toIso8601String().split("T")[0]}T${b.value["fields"]["timestamp"]}');
            return bTime.compareTo(aTime);
          });

        var newestEntry = sortedEntries.first.value['fields'];
        latestData['BPM'] = newestEntry['BPM'];
        latestData['SpO2'] = newestEntry['SpO2'];
        latestData['piezoValue'] = newestEntry['piezoValue'];
      } else {
        latestData['BPM'] = 'N/A';
        latestData['SpO2'] = 'N/A';
        latestData['piezoValue'] = 'N/A';
      }

      // Update the latest sensor data variable
      _latestSensorData = latestData;
      _sensorDataController.sink.add(latestData);
      return latestData;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Card
            Container(
              height: height / 5,
              padding: EdgeInsets.only(
                  left: kHorizontalMargin, top: kVerticalMargin * 3),
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
                  Padding(
                    padding: EdgeInsets.only(right: kHorizontalMargin),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ResponsiveText(
                          'Welcome',
                          textAlign: TextAlign.start,
                          fontSize: 32,
                          textColor: kDefaultIconLightColor,
                        ),
                        ClipRRect(
                          borderRadius:BorderRadius.circular(100),
                          child: CachedNetworkImage(
                            width:50,
                            height:50,
                            fit: BoxFit.fill,
                            imageUrl: loggedInUser.image.toString(),
                            errorWidget: (context, url, error) =>
                            const CircleAvatar(
                                child: Icon(CupertinoIcons.person)),
                          ),
                        ),
                      ],
                    ),
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
                        textColor: Colors.grey.shade800,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: kVerticalMargin),
            // Quote Card
            SizedBox(
              height: MediaQuery.of(context).size.height / 5 + // Base height
                  (selectedQuote.length > 50 ? 20.0 : 0.0), // Additional height if quote is longer
              child: Container(
                margin: EdgeInsets.only(
                  left: kHorizontalMargin * 1.5,
                  right: kHorizontalMargin * 1.5,
                ),
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
                        fontSize: 20,
                        textColor: kDefaultIconLightColor,
                      ),
                      SizedBox(height: kVerticalMargin),
                      ResponsiveText(
                        "\"${selectedQuote}\"",
                        fontSize: 18,
                        textAlign: TextAlign.center,
                        textColor:kDefaultIconLightColor
                      )

                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: kVerticalMargin),
            // Heart Rate and SpO2 Cards
            StreamBuilder<Map<String, dynamic>>(
                stream: getSensorDataStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: kPrimaryColor,));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data != null) {
                    var data = snapshot.data!;
                    // Fall Detection Notification
                    if (data['piezoValue'] > 10) {
                      showNotification("Fall Alert", "A fall has been detected.");
                    }

                    return Column(
                      children: [
                        Row(
                          children: [
                            SensorValueCard(
                              title: 'Heart Rate',
                              value: '${data['BPM']} bpm',
                              icon: Icons.monitor_heart_outlined,
                            ),
                            SensorValueCard(
                              title: 'SpO2 Level',
                              value: '${data['SpO2']}%',
                              icon: Icons.water_drop_outlined,
                            ),
                          ],
                        ),
                        SizedBox(height: kVerticalMargin),
                        FallDetectionCard(
                          title: 'Fall Detection',
                          value: data['piezoValue'] > 10 ? 'Fall Detected' : 'No Fall',
                        ),
                        SizedBox(height: kVerticalMargin),
                        // Nested StreamBuilder for Health Status
                        StreamBuilder<String>(
                          stream: _healthStatusController.stream,
                          builder: (context, healthSnapshot) {
                            if (healthSnapshot.connectionState == ConnectionState.waiting) {
                              return FallDetectionCard(
                                title: 'Health Status',
                                value: 'Loading...',
                              );
                            } else if (healthSnapshot.hasError) {
                              return FallDetectionCard(
                                title: 'Health Status',
                                value: 'Error: ${healthSnapshot.error}',
                              );
                            } else if (healthSnapshot.hasData) {
                              // Health Status Notification
                              if (healthSnapshot.data == "Abnormal") {
                                showNotification("Health Alert", "Your health status is abnormal.");
                              }
                              return FallDetectionCard(
                                title: 'Health Status',
                                value: healthSnapshot.data!,
                              );
                            } else {
                              return FallDetectionCard(
                                title: 'Health Status',
                                value: 'No health status available.',
                              );
                            }
                          },
                        ),
                      ],
                    );
                  } else {
                    return Center(child: Text('No data available.'));
                  }
                }
            ),



          ],
        ),
      ),
    );
  }
}

class SensorValueCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const SensorValueCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 4,
        color: kPrimaryColor,
        margin: EdgeInsets.all(kHorizontalMargin),
        child: Padding(
          padding: EdgeInsets.all(kHorizontalMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: Colors.red,
                size: 30,
              ),
              ResponsiveText(
                title,
                fontSize: 18,
                textColor: kDefaultIconLightColor,
              ),
              ResponsiveText(
                value,
                fontSize: 20,
                textColor: kDefaultIconLightColor,
                fontWeight: FontWeight.bold,

              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FallDetectionCard extends StatelessWidget {
  final String title;
  final String value;

  const FallDetectionCard({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor;
    if (value == 'Fall Detected' || value.contains('Abnormal')) {
      textColor = Colors.red; // Set text color to red for abnormal values
    } else {
      textColor = kDefaultIconLightColor; // Use the default text color
    }

    return Container(
      width: double.infinity,
      child: Card(
        elevation: 4,
        color: kPrimaryColor,
        margin: EdgeInsets.symmetric(horizontal: kHorizontalMargin),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ResponsiveText(
            '$title: $value',
            fontSize: 20,
            textColor: textColor, // Use the calculated text color
          ),
        ),
      ),
    );
  }
}