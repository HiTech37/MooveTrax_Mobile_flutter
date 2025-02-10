import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:moovetrax/core/app_theme.dart';
import 'package:moovetrax/core/common.dart';
import 'package:moovetrax/di.dart';
import 'package:flutter/material.dart';
import 'package:moovetrax/firebase_options.dart';
import 'package:moovetrax/notification_service.dart';
import 'package:moovetrax/routes.dart';
import 'package:moovetrax/view/auth/screens/login_screen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:moovetrax/view/home/home_screen.dart';
import 'package:moovetrax/view/installer/installer_home_screen.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

void _handleMessage(RemoteMessage message) {
  if (message.data.containsKey('mapUrl')) {
    _launchURL(message.data['mapUrl']);
  }
}

void _launchURL(String url) async {
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    debugPrint('Could not launch $url');
  }
}

void main() async {
  // Ensure the Flutter framework is initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (required for all platforms)
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (e) {
    debugPrint("Error initializing Firebase: $e");
  }

  // Initialize GetStorage for local storage
  await GetStorage.init();

  // Initialize other dependencies
  await init();

  // Initialize notifications and request permissions for Firebase Cloud Messaging
  try {
    final box = GetStorage();
    final userData = await box.read('loginInfo');
    final installerKey = await box.read('installerKey');

    // Check if running on iOS simulator and skip Firebase messaging initialization
    if (Platform.isIOS) {
      bool isSimulatorDevice = await checkIfSimulator();

      // Initialize Firebase Messaging only for real iOS devices
      if (!isSimulatorDevice) {
        await NotificationService.initNotification();

        await FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        if (Platform.isAndroid) {
          await FirebaseMessaging.instance.setAutoInitEnabled(true);
        }
        FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

        // Handle the initial message if the app was opened via a notification
        FirebaseMessaging.instance
            .getInitialMessage()
            .then((RemoteMessage? message) {
          if (message != null) {
            _handleMessage(message);
          }
        });

        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          NotificationService.showLocalNotification('title', 'body', 'payload');
        });

        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          _handleMessage(message);
        });
      }
    }

    if (Platform.isAndroid) {
      await NotificationService.initNotification();

      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if (Platform.isAndroid) {
        await FirebaseMessaging.instance.setAutoInitEnabled(true);
      }
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true, badge: true, sound: true);

      // Handle when the app is opened from a terminated state
      FirebaseMessaging.instance
          .getInitialMessage()
          .then((RemoteMessage? message) {
        if (message != null) {
          _handleMessage(message);
        }
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        NotificationService.showLocalNotification(
            message.notification?.title ?? '',
            message.notification?.body ?? '',
            'payload');
      });
      // Handle when the app is opened from background/foreground
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _handleMessage(message);
      });
    }

    // Run the main app, passing userData and installerKey to MyApp
    runApp(MyApp(userData: userData, installerKey: installerKey));
  } catch (e) {
    debugPrint(
        "Error initializing Firebase Messaging or requesting permissions: $e");
  }
}

class MyApp extends StatelessWidget {
  final dynamic userData;
  final dynamic installerKey;

  const MyApp({super.key, required this.userData, required this.installerKey});

  @override
  Widget build(BuildContext context) {
    final DataController controller = Get.put(DataController());
    controller.updateCurrentScaleFactor(scaleFactor(context));

    return GetMaterialApp(
        getPages: routes,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightAppTheme,
        darkTheme: AppTheme.darkAppTheme,
        themeMode: ThemeMode.light,
        defaultTransition: Transition.leftToRight,
        home: UpgradeAlert(
          child: userData == null
              ? installerKey == null
                  ? const LoginScreen()
                  : const InstallerHomeScreen()
              : const HomeScreen(),
        ));
  }
}
