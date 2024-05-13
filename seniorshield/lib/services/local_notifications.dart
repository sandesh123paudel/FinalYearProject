import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationHeleper{
  static final _notification=FlutterLocalNotificationsPlugin();
  
  
  
  static init()
  {
    _notification.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('ic_launcher'),
      iOS: DarwinInitializationSettings()
    ));

    tz.initializeTimeZones();

  }

  static scheduledNotification(String title, String body, DateTime scheduledTime)
  async {
    var andriodDetails = const AndroidNotificationDetails(
      'important_notifications',
      'My Channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    var iosDetails = const DarwinNotificationDetails();

    var notificationDetails = NotificationDetails(iOS: iosDetails, android: andriodDetails);

    await _notification.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }








}