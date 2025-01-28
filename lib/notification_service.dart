import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';

class NotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  static AndroidInitializationSettings initializationSettingsAndroid =
      const AndroidInitializationSettings('@drawable/app_icon');

  static DarwinInitializationSettings initializationSettingsIOS =
      const DarwinInitializationSettings();

  static initNotification() async {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  static showLocalNotification(String title, String body, String payload) {
    const androidNotificationDetail = AndroidNotificationDetails('0', 'general',
        priority: Priority.high,
        autoCancel: false,
        fullScreenIntent: true,
        enableVibration: true,
        importance: Importance.high,
        playSound: true,
        icon: '@drawable/app_icon');

    const iosNotificatonDetail = DarwinNotificationDetails();
    const notificationDetails = NotificationDetails(
      iOS: iosNotificatonDetail,
      android: androidNotificationDetail,
    );

    String msgBody = "";
    String msgTitle = "";
    String userName = "";
    try {
      final Map<String, dynamic> bodyData = jsonDecode(body);
      userName = bodyData['userName'] ?? bodyData['userEmail'] ?? '';
      switch (title) {
        case "Lock":
          msgTitle = bodyData['deviceName'] + " " + "Locked";
          msgBody = bodyData['deviceName'] + " Locked by " + userName;
          break;
        case "Unlock":
          msgTitle = bodyData['deviceName'] + " " + "Unlocked";
          msgBody = bodyData['deviceName'] + " Unlocked by " + userName;
          break;
        case "LightHorn":
          msgTitle = bodyData['deviceName'] + " " + "Horn";
          msgBody = bodyData['deviceName'] + " Horn by " + userName;
          break;
        case "Kill":
          msgTitle = "";
          msgBody = bodyData['deviceName'] + " killed by " + userName;
          break;
        case "Unkill":
          msgTitle = "";
          msgBody = bodyData['deviceName'] + " Un-Killed by " + userName;
          break;
        default:
          msgTitle = "";
          msgBody = bodyData['deviceName'] + " " + title + " by " + userName;
          break;
      }
    } catch (e) {
      print("Error decoding JSON body: $e");
    }

    flutterLocalNotificationsPlugin
        .show(0, msgTitle, msgBody, notificationDetails, payload: payload);
  }
}
