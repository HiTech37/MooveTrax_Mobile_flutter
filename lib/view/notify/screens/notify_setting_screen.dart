import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/common/widget/default_button.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';

class NotifySettingScreen extends StatefulWidget {
  const NotifySettingScreen({super.key});

  @override
  NotifySettingScreenState createState() => NotifySettingScreenState();
}

class NotifySettingScreenState extends State<NotifySettingScreen> {
  bool unlockChecked = false;
  bool lockChecked = false;
  bool hornChecked = false;
  bool killChecked = false;
  bool unkillChecked = false;
  bool overSpeedChecked = false;
  bool offlineChecked = false;
  bool smokingChecked = false;
  bool overMilesChecked = false;
  bool unlockedByBluetoothChecked = false;
  bool lockedByBluetoothChecked = false;
  bool bluetoothOnChecked = false;
  bool bluetoothOffChecked = false;
  bool lowBatteryChecked = false;
  bool hoodChecked = false;
  bool doorChecked = false;
  bool shockChecked = false;
  bool deviceSuspensionChecked = false;
  bool ignitionOnChecked = false;
  bool noPositionUpdateChecked = false;
  bool noTripMovementChecked = false;
  bool possibleTowingChecked = false;
  bool severeWeatherChecked = false;
  bool lateReturnChecked = false;
  bool pushUnlockChecked = false;
  bool pushLockChecked = false;
  bool pushHornChecked = false;
  bool pushKillChecked = false;
  bool pushUnkillChecked = false;
  bool pushOverSpeedChecked = false;
  bool pushOfflineChecked = false;
  bool pushSmokingChecked = false;
  bool pushOverMilesChecked = false;
  bool pushUnlockedByBluetoothChecked = false;
  bool pushLockedByBluetoothChecked = false;
  bool pushBluetoothOnChecked = false;
  bool pushBluetoothOffChecked = false;
  bool pushLowBatteryChecked = false;
  bool pushHoodChecked = false;
  bool pushDoorChecked = false;
  bool pushShockChecked = false;
  bool pushDeviceSuspensionChecked = false;
  bool pushIgnitionOnChecked = false;
  bool pushNoPositionUpdateChecked = false;
  bool pushNoTripMovementChecked = false;
  bool pushPossibleTowingChecked = false;
  bool pushSevereWeatherChecked = false;
  bool pushLateReturnChecked = false;
  String unlockEmail = '';
  String lockEmail = '';
  String hornEmail = '';
  String killEmail = '';
  String unkillEmail = '';
  String overSpeedEmail = '';
  String offlineEmail = '';
  String smokingEmail = '';
  String lowBatteryLevel = '';
  String overMilesEmail = '';
  String unlockedByBluetoothEmail = '';
  String lockedByBluetoothEmail = '';
  String bluetoothOnEmail = '';
  String bluetoothOffEmail = '';
  String lowBatteryEmail = '';
  String hoodEmail = '';
  String doorEmail = '';
  String shockEmail = '';
  String deviceSuspensionEmail = '';
  String ignitionOnEmail = '';
  String noPositionUpdateEmail = '';
  String noTripMovementEmail = '';
  String possibleTowingEmail = '';
  String severeWeatherEmail = '';
  String lateReturnEmail = '';

  List<String> timezoneList = [];
  String? selectedTimeZone;

  TextEditingController unlockEmailEditController =
      TextEditingController(text: '');
  TextEditingController lowBatteryLevelEditController =
      TextEditingController(text: '');
  TextEditingController lockEmailEditController =
      TextEditingController(text: '');
  TextEditingController hornEmailEditController =
      TextEditingController(text: '');
  TextEditingController unkillEmailEditController =
      TextEditingController(text: '');
  TextEditingController killEmailEditController =
      TextEditingController(text: '');
  TextEditingController overspeedEmailEditController =
      TextEditingController(text: '');
  TextEditingController lowBattterLevel = TextEditingController(text: '');
  TextEditingController offlineEmailEditController =
      TextEditingController(text: '');
  TextEditingController smokingEmailEditController =
      TextEditingController(text: '');
  TextEditingController overmilesEmailEditController =
      TextEditingController(text: '');
  TextEditingController overMilesEmailContoroller =
      TextEditingController(text: '');
  TextEditingController unlockedByBluetoothEmailContoroller =
      TextEditingController(text: '');
  TextEditingController lockedByBluetoothEmailContoroller =
      TextEditingController(text: '');
  TextEditingController bluetoothOnEmailContoroller =
      TextEditingController(text: '');
  TextEditingController bluetoothOffEmailContoroller =
      TextEditingController(text: '');
  TextEditingController lowBatteryEmailContoroller =
      TextEditingController(text: '');
  TextEditingController hoodEmailContoroller = TextEditingController(text: '');
  TextEditingController doorEmailContoroller = TextEditingController(text: '');
  TextEditingController shockEmailContoroller = TextEditingController(text: '');
  TextEditingController deviceSuspensionEmailContoroller =
      TextEditingController(text: '');
  TextEditingController ignitionOnEmailContoroller =
      TextEditingController(text: '');
  TextEditingController noPositionUpdateEmailContoroller =
      TextEditingController(text: '');
  TextEditingController noTripMovementEmailContoroller =
      TextEditingController(text: '');
  TextEditingController possibleTowingEmailContoroller =
      TextEditingController(text: '');
  TextEditingController severeWeatherEmailContoroller =
      TextEditingController(text: '');
  TextEditingController lateReturnEmailContoroller =
      TextEditingController(text: '');
  bool savingChange = false;
  final DataController dataController = Get.find<DataController>();
  final DeviceController deviceController = getIt<DeviceController>();
  late Map<String, dynamic> deviceNotificationSettingsData;
  final AuthController authController = getIt<AuthController>();

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    unlockEmailEditController.dispose();
    lockEmailEditController.dispose();
    hornEmailEditController.dispose();
    unkillEmailEditController.dispose();
    lowBatteryLevelEditController.dispose();
    killEmailEditController.dispose();
    overspeedEmailEditController.dispose();
    offlineEmailEditController.dispose();
    smokingEmailEditController.dispose();
    overmilesEmailEditController.dispose();
    overMilesEmailContoroller.dispose();
    unlockedByBluetoothEmailContoroller.dispose();
    lockedByBluetoothEmailContoroller.dispose();
    bluetoothOnEmailContoroller.dispose();
    bluetoothOffEmailContoroller.dispose();
    lowBatteryEmailContoroller.dispose();
    hoodEmailContoroller.dispose();
    doorEmailContoroller.dispose();
    shockEmailContoroller.dispose();
    deviceSuspensionEmailContoroller.dispose();
    ignitionOnEmailContoroller.dispose();
    noPositionUpdateEmailContoroller.dispose();
    noTripMovementEmailContoroller.dispose();
    possibleTowingEmailContoroller.dispose();
    severeWeatherEmailContoroller.dispose();
    lateReturnEmailContoroller.dispose();

    super.dispose();
  }

  Future<void> updateNotifiySettings() async {
    deviceNotificationSettingsData['Unlocked_by_Bluetooth'] = {
      'status': unlockedByBluetoothChecked,
      'notifyEmail': unlockedByBluetoothChecked,
      'notifyPush': pushUnlockedByBluetoothChecked,
      'email': unlockedByBluetoothEmail,
      'post_on_turo': deviceNotificationSettingsData['Unlocked_by_Bluetooth']
              ?['post_on_turo'] ??
          false
    };

    deviceNotificationSettingsData['Locked_by_Bluetooth'] = {
      'status': lockedByBluetoothChecked,
      'notifyEmail': lockedByBluetoothChecked,
      'notifyPush': pushLockedByBluetoothChecked,
      'email': lockedByBluetoothEmail,
      'post_on_turo': deviceNotificationSettingsData['Locked_by_Bluetooth']
              ?['post_on_turo'] ??
          false
    };

    deviceNotificationSettingsData['Bluetooth_On'] = {
      'status': bluetoothOnChecked,
      'notifyEmail': bluetoothOnChecked,
      'notifyPush': pushBluetoothOnChecked,
      'email': bluetoothOnEmail,
      'post_on_turo': deviceNotificationSettingsData['Bluetooth_On']
              ?['post_on_turo'] ??
          false
    };

    deviceNotificationSettingsData['Bluetooth_Off'] = {
      'status': bluetoothOffChecked,
      'notifyEmail': bluetoothOffChecked,
      'notifyPush': pushBluetoothOffChecked,
      'email': bluetoothOffEmail,
      'post_on_turo': deviceNotificationSettingsData['Bluetooth_Off']
              ?['post_on_turo'] ??
          false
    };

    deviceNotificationSettingsData['Low_Battery'] = {
      'status': lowBatteryChecked,
      'notifyEmail': lowBatteryChecked,
      'email': lowBatteryEmail,
      'notifyPush': pushLowBatteryChecked,
      'post_on_turo': deviceNotificationSettingsData['Low_Battery']
              ?['post_on_turo'] ??
          false,
      'value': lowBatteryLevel
    };

    deviceNotificationSettingsData['Hood'] = {
      'status': hoodChecked,
      'notifyEmail': hoodChecked,
      'email': hoodEmail,
      'pushNotify': pushHoodChecked,
      'post_on_turo':
          deviceNotificationSettingsData['Hood']?['post_on_turo'] ?? false
    };

    deviceNotificationSettingsData['Door'] = {
      'status': doorChecked,
      'notifyEmail': doorChecked,
      'email': doorEmail,
      'pushNotify': pushDoorChecked,
      'post_on_turo':
          deviceNotificationSettingsData['Door']?['post_on_turo'] ?? false
    };

    deviceNotificationSettingsData['Shock'] = {
      'status': shockChecked,
      'notifyEmail': shockChecked,
      'notifyPush': pushShockChecked,
      'email': shockEmail,
      'post_on_turo':
          deviceNotificationSettingsData['Shock']?['post_on_turo'] ?? false
    };

    deviceNotificationSettingsData['Device_Suspension'] = {
      'status': deviceSuspensionChecked,
      'notifyEmail': deviceSuspensionChecked,
      'notifyPush': pushDeviceSuspensionChecked,
      'email': deviceSuspensionEmail,
      'post_on_turo': deviceNotificationSettingsData['Device_Suspension']
              ?['post_on_turo'] ??
          false
    };

    deviceNotificationSettingsData['Ignition_ACC'] = {
      'status': ignitionOnChecked,
      'notifyEmail': ignitionOnChecked,
      'notifyPush': pushIgnitionOnChecked,
      'email': ignitionOnEmail,
      'post_on_turo': deviceNotificationSettingsData['Ignition_ACC']
              ?['post_on_turo'] ??
          false
    };

    deviceNotificationSettingsData['No_Position_Update'] = {
      'status': noPositionUpdateChecked,
      'notifyEmail': noPositionUpdateChecked,
      'notifyPush': pushNoPositionUpdateChecked,
      'email': noPositionUpdateEmail,
      'post_on_turo': deviceNotificationSettingsData['No_Position_Update']
              ?['post_on_turo'] ??
          false
    };

    deviceNotificationSettingsData['No_Trip_Movement'] = {
      'status': noTripMovementChecked,
      'notifyEmail': noTripMovementChecked,
      'notifyPush': pushNoTripMovementChecked,
      'email': noTripMovementEmail,
      'post_on_turo': deviceNotificationSettingsData['No_Trip_Movement']
              ?['post_on_turo'] ??
          false
    };

    deviceNotificationSettingsData['Possible_Towing'] = {
      'status': possibleTowingChecked,
      'notifyEmail': possibleTowingChecked,
      'notifyPush': pushPossibleTowingChecked,
      'email': possibleTowingEmail,
      'post_on_turo': deviceNotificationSettingsData['Possible_Towing']
              ?['post_on_turo'] ??
          false
    };

    deviceNotificationSettingsData['Severe_Weather'] = {
      'status': severeWeatherChecked,
      'notifyEmail': severeWeatherChecked,
      'notifyPush': pushSevereWeatherChecked,
      'email': severeWeatherEmail,
      'post_on_turo': deviceNotificationSettingsData['Severe_Weather']
              ?['post_on_turo'] ??
          false
    };

    deviceNotificationSettingsData['Late_Return'] = {
      'status': lateReturnChecked,
      'notifyEmail': lateReturnChecked,
      'notifyPush': pushLateReturnChecked,
      'email': lateReturnEmail,
      'post_on_turo': deviceNotificationSettingsData['Late_Return']
              ?['post_on_turo'] ??
          false
    };

    deviceNotificationSettingsData['Lock'] = {
      'status': lockChecked,
      'notifyEmail': lockChecked,
      'notifyPush': pushLockChecked,
      'email': lockEmail,
      'post_on_turo':
          deviceNotificationSettingsData['Lock']?['post_on_turo'] ?? false
    };

    deviceNotificationSettingsData['Unlock'] = {
      'status': unlockChecked,
      'notifyEmail': unlockChecked,
      'notifyPush': pushUnlockChecked,
      'email': unlockEmail,
      'post_on_turo':
          deviceNotificationSettingsData['Unlock']?['post_on_turo'] ?? false
    };

    deviceNotificationSettingsData['Horn'] = {
      'status': hornChecked,
      'notifyEmail': hornChecked,
      'notifyPush': pushHornChecked,
      'email': hornEmail,
      'post_on_turo':
          deviceNotificationSettingsData['Horn']?['post_on_turo'] ?? false
    };

    deviceNotificationSettingsData['Unkill'] = {
      'status': unkillChecked,
      'notifyEmail': unkillChecked,
      'notifyPush': pushUnkillChecked,
      'email': unkillEmail,
      'post_on_turo':
          deviceNotificationSettingsData['Unkill']?['post_on_turo'] ?? false
    };

    deviceNotificationSettingsData['Kill'] = {
      'status': killChecked,
      'notifyEmail': killChecked,
      'notifyPush': pushKillChecked,
      'email': killEmail,
      'post_on_turo':
          deviceNotificationSettingsData['Kill']?['post_on_turo'] ?? false
    };

    deviceNotificationSettingsData['Offline'] = {
      'status': offlineChecked,
      'notifyEmail': offlineChecked,
      'notifyPush': pushOfflineChecked,
      'email': offlineEmail,
      'post_on_turo':
          deviceNotificationSettingsData['Offline']?['post_on_turo'] ?? false
    };

    deviceNotificationSettingsData['Smoking'] = {
      'status': smokingChecked,
      'notifyEmail': smokingChecked,
      'notifyPush': pushSmokingChecked,
      'email': smokingEmail,
      'post_on_turo':
          deviceNotificationSettingsData['Smoking']?['post_on_turo'] ?? false
    };

    deviceNotificationSettingsData['Overmiles'] = {
      'status': overMilesChecked,
      'notifyEmail': overMilesChecked,
      'notifyPush': pushOverMilesChecked,
      'email': overMilesEmail,
      'post_on_turo':
          deviceNotificationSettingsData['Overmiles']?['post_on_turo'] ?? false
    };

    setState(() {
      savingChange = true;
    });

    await deviceController.updateNotficationSettings({
      'device_id': dataController.currentDeviceId.value,
      'user_id': authController.storageUserData?['id'],
      'user_name': authController.storageUserData?['name'],
      'notificationSettingList': jsonEncode(deviceNotificationSettingsData)
    });
    setState(() {
      savingChange = false;
    });
    if (deviceController.apiStatus.value == ApiState.failure) {
      Get.snackbar("Updating Failed", deviceController.errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          animationDuration: const Duration(milliseconds: 300));
    } else {
      Get.snackbar("Notification Settings",
          'Notification setting has been updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          animationDuration: const Duration(milliseconds: 300));
    }
    initData();
  }

  Future<void> updateTimezone(String timezone) async {
    await deviceController.updateTimeZone({
      'user_id': authController.storageUserData?['id'],
      'device_id': dataController.currentDeviceId.value,
      'timezone': timezone,
    });
    if (deviceController.apiStatus.value == ApiState.failure) {
      Get.snackbar("Updating Failed", deviceController.errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          animationDuration: const Duration(milliseconds: 300));
    } else {
      Get.snackbar(
          "Timezone Settings", 'Timezone setting has been updated successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          animationDuration: const Duration(milliseconds: 300));
    }
    setState(() {
      selectedTimeZone = timezone;
    });
  }

  void initData() async {
    if (!mounted) return;
    await deviceController
        .getSelectedDeviceData(dataController.currentDeviceId.value);
    if (!mounted) return;

    var url = Uri.parse('https://moovetrax.com:8088/timezone-list/all');

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var timezoneData = data['timezoneList'];
        setState(() {
          timezoneList = List<String>.from(
              timezoneData.map((item) => item['timezone'].toString()));
        });
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to fetch data: $e');
    }

    if (deviceController.apiStatus.value == ApiState.failure) {
      Get.snackbar("Failed", deviceController.errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          animationDuration: const Duration(milliseconds: 300));
      return;
    } else {
      setState(() {
        var deviceTimezone =
            deviceController.selectedDeviceData.value['timezone'];
        selectedTimeZone = deviceTimezone ?? "GMT";

        deviceNotificationSettingsData = jsonDecode(
            deviceController.selectedDeviceData.value['notificationSettings']);
        if (deviceNotificationSettingsData['Lock'] != null) {
          lockChecked = deviceNotificationSettingsData['Lock']['status'];
          pushLockChecked =
              deviceNotificationSettingsData['Lock']['notifyPush'] ?? false;
          lockEmailEditController.text =
              deviceNotificationSettingsData['Lock']['email'];
          lockEmail = deviceNotificationSettingsData['Lock']['email'];
        }
        if (deviceNotificationSettingsData['Unlocked_by_Bluetooth'] != null) {
          unlockedByBluetoothChecked =
              deviceNotificationSettingsData['Unlocked_by_Bluetooth']['status'];
          pushUnlockedByBluetoothChecked =
              deviceNotificationSettingsData['Unlocked_by_Bluetooth']
                      ['notifyPush'] ??
                  false;
          unlockedByBluetoothEmailContoroller.text =
              deviceNotificationSettingsData['Unlocked_by_Bluetooth']['email'];
          unlockedByBluetoothEmail =
              deviceNotificationSettingsData['Unlocked_by_Bluetooth']['email'];
        }
        if (deviceNotificationSettingsData['Unlock'] != null) {
          unlockChecked = deviceNotificationSettingsData['Unlock']['status'];

          pushUnlockChecked =
              deviceNotificationSettingsData['Unlock']['notifyPush'] ?? false;
          unlockEmailEditController.text =
              deviceNotificationSettingsData['Unlock']['email'];
          unlockEmail = deviceNotificationSettingsData['Unlock']['email'];
        }
        if (deviceNotificationSettingsData['Locked_by_Bluetooth'] != null) {
          lockedByBluetoothChecked =
              deviceNotificationSettingsData['Locked_by_Bluetooth']['status'];
          pushLockedByBluetoothChecked =
              deviceNotificationSettingsData['Locked_by_Bluetooth']
                      ['notifyPush'] ??
                  false;
          lockedByBluetoothEmailContoroller.text =
              deviceNotificationSettingsData['Locked_by_Bluetooth']['email'];
          lockedByBluetoothEmail =
              deviceNotificationSettingsData['Locked_by_Bluetooth']['email'];
        }
        if (deviceNotificationSettingsData['Bluetooth_On'] != null) {
          bluetoothOnChecked =
              deviceNotificationSettingsData['Bluetooth_On']['status'];
          pushBluetoothOnChecked =
              deviceNotificationSettingsData['Bluetooth_On']['notifyPush'] ??
                  false;
          bluetoothOnEmailContoroller.text =
              deviceNotificationSettingsData['Bluetooth_On']['email'];
          bluetoothOnEmail =
              deviceNotificationSettingsData['Bluetooth_On']['email'];
        }
        if (deviceNotificationSettingsData['No_Trip_Movement'] != null) {
          noTripMovementChecked =
              deviceNotificationSettingsData['No_Trip_Movement']['status'];
          pushNoTripMovementChecked =
              deviceNotificationSettingsData['No_Trip_Movement']
                      ['notifyPush'] ??
                  false;
          noTripMovementEmailContoroller.text =
              deviceNotificationSettingsData['No_Trip_Movement']['email'];
          noTripMovementEmail =
              deviceNotificationSettingsData['No_Trip_Movement']['email'];
        }
        if (deviceNotificationSettingsData['Possible_Towing'] != null) {
          possibleTowingChecked =
              deviceNotificationSettingsData['Possible_Towing']['status'];
          pushPossibleTowingChecked =
              deviceNotificationSettingsData['Possible_Towing']['notifyPush'] ??
                  false;
          possibleTowingEmailContoroller.text =
              deviceNotificationSettingsData['Possible_Towing']['email'];
          possibleTowingEmail =
              deviceNotificationSettingsData['Possible_Towing']['email'];
        }
        if (deviceNotificationSettingsData['Severe_Weather'] != null) {
          severeWeatherChecked =
              deviceNotificationSettingsData['Severe_Weather']['status'];
          pushSevereWeatherChecked =
              deviceNotificationSettingsData['Severe_Weather']['notifyPush'] ??
                  false;
          severeWeatherEmailContoroller.text =
              deviceNotificationSettingsData['Severe_Weather']['email'];
          severeWeatherEmail =
              deviceNotificationSettingsData['Severe_Weather']['email'];
        }
        if (deviceNotificationSettingsData['Late_Return'] != null) {
          lateReturnChecked =
              deviceNotificationSettingsData['Late_Return']['status'];
          pushLateReturnChecked = deviceNotificationSettingsData['Late_Return']
                  ['notifyPush'] ??
              false;
          lateReturnEmailContoroller.text =
              deviceNotificationSettingsData['Late_Return']['email'];
          lateReturnEmail =
              deviceNotificationSettingsData['Late_Return']['email'];
        }
        if (deviceNotificationSettingsData['Bluetooth_Off'] != null) {
          bluetoothOffChecked =
              deviceNotificationSettingsData['Bluetooth_Off']['status'];
          pushBluetoothOffChecked =
              deviceNotificationSettingsData['Bluetooth_Off']['notifyPush'] ??
                  false;
          bluetoothOffEmailContoroller.text =
              deviceNotificationSettingsData['Bluetooth_Off']['email'];
          bluetoothOffEmail =
              deviceNotificationSettingsData['Bluetooth_Off']['email'];
        }
        if (deviceNotificationSettingsData['Low_Battery'] != null) {
          lowBatteryChecked =
              deviceNotificationSettingsData['Low_Battery']['status'];
          pushLowBatteryChecked = deviceNotificationSettingsData['Low_Battery']
                  ['notifyPush'] ??
              false;
          lowBatteryEmailContoroller.text =
              deviceNotificationSettingsData['Low_Battery']['email'];
          lowBatteryEmail =
              deviceNotificationSettingsData['Low_Battery']['email'];
          lowBatteryLevel =
              deviceNotificationSettingsData['Low_Battery']['value'] ?? '11';
          lowBatteryLevelEditController.text = lowBatteryLevel;
        }
        if (deviceNotificationSettingsData['Hood'] != null) {
          hoodChecked = deviceNotificationSettingsData['Hood']['status'];
          pushHoodChecked =
              deviceNotificationSettingsData['Hood']['notifyPush'] ?? false;
          hoodEmailContoroller.text =
              deviceNotificationSettingsData['Hood']['email'];
          hoodEmail = deviceNotificationSettingsData['Hood']['email'];
        }
        if (deviceNotificationSettingsData['Door'] != null) {
          doorChecked = deviceNotificationSettingsData['Door']['status'];
          pushDoorChecked =
              deviceNotificationSettingsData['Door']['notifyPush'] ?? false;
          doorEmailContoroller.text =
              deviceNotificationSettingsData['Door']['email'];
          doorEmail = deviceNotificationSettingsData['Door']['email'];
        }
        if (deviceNotificationSettingsData['Shock'] != null) {
          shockChecked = deviceNotificationSettingsData['Shock']['status'];
          pushShockChecked =
              deviceNotificationSettingsData['Shock']['notifyPush'] ?? false;
          shockEmailContoroller.text =
              deviceNotificationSettingsData['Shock']['email'];
          shockEmail = deviceNotificationSettingsData['Shock']['email'];
        }
        if (deviceNotificationSettingsData['Device_Suspension'] != null) {
          deviceSuspensionChecked =
              deviceNotificationSettingsData['Device_Suspension']['status'];
          pushDeviceSuspensionChecked =
              deviceNotificationSettingsData['Device_Suspension']
                      ['notifyPush'] ??
                  false;
          deviceSuspensionEmailContoroller.text =
              deviceNotificationSettingsData['Device_Suspension']['email'];
          deviceSuspensionEmail =
              deviceNotificationSettingsData['Device_Suspension']['email'];
        }
        if (deviceNotificationSettingsData['Ignition_ACC'] != null) {
          ignitionOnChecked =
              deviceNotificationSettingsData['Ignition_ACC']['status'];
          pushIgnitionOnChecked = deviceNotificationSettingsData['Ignition_ACC']
                  ['notifyPush'] ??
              false;
          ignitionOnEmailContoroller.text =
              deviceNotificationSettingsData['Ignition_ACC']['email'];
          ignitionOnEmail =
              deviceNotificationSettingsData['Ignition_ACC']['email'];
        }
        if (deviceNotificationSettingsData['No_Position_Update'] != null) {
          noPositionUpdateChecked =
              deviceNotificationSettingsData['No_Position_Update']['status'];
          pushNoPositionUpdateChecked =
              deviceNotificationSettingsData['No_Position_Update']
                      ['notifyPush'] ??
                  false;
          noPositionUpdateEmailContoroller.text =
              deviceNotificationSettingsData['No_Position_Update']['email'];
          noPositionUpdateEmail =
              deviceNotificationSettingsData['No_Position_Update']['email'];
        }
        if (deviceNotificationSettingsData['Horn'] != null) {
          hornChecked = deviceNotificationSettingsData['Horn']['status'];
          pushHornChecked =
              deviceNotificationSettingsData['Horn']['notifyPush'] ?? false;
          hornEmailEditController.text =
              deviceNotificationSettingsData['Horn']['email'];
          hornEmail = deviceNotificationSettingsData['Horn']['email'];
        }
        if (deviceNotificationSettingsData['Unkill'] != null) {
          unkillChecked = deviceNotificationSettingsData['Unkill']['status'];
          pushUnkillChecked =
              deviceNotificationSettingsData['Unkill']['notifyPush'] ?? false;
          unkillEmailEditController.text =
              deviceNotificationSettingsData['Unkill']['email'];
          unkillEmail = deviceNotificationSettingsData['Unkill']['email'];
        }
        if (deviceNotificationSettingsData['Kill'] != null) {
          killChecked = deviceNotificationSettingsData['Kill']['status'];
          pushKillChecked =
              deviceNotificationSettingsData['Kill']['notifyPush'] ?? false;
          killEmailEditController.text =
              deviceNotificationSettingsData['Kill']['email'];
          killEmail = deviceNotificationSettingsData['Kill']['email'];
        }
        if (deviceNotificationSettingsData['Overspeed'] != null) {
          overSpeedChecked =
              deviceNotificationSettingsData['Overspeed']['status'];
          pushOverSpeedChecked = deviceNotificationSettingsData['Overspeed']
                  ['pushNotify'] ??
              false;
          overspeedEmailEditController.text =
              deviceNotificationSettingsData['Overspeed']['email'];
          overSpeedEmail = deviceNotificationSettingsData['Overspeed']['email'];
        }
        if (deviceNotificationSettingsData['Offline'] != null) {
          offlineChecked = deviceNotificationSettingsData['Offline']['status'];
          pushOfflineChecked =
              deviceNotificationSettingsData['Offline']['notifyPush'] ?? false;
          offlineEmailEditController.text =
              deviceNotificationSettingsData['Offline']['email'];
          offlineEmail = deviceNotificationSettingsData['Offline']['email'];
        }
        if (deviceNotificationSettingsData['Smoking'] != null) {
          smokingChecked = deviceNotificationSettingsData['Smoking']['status'];
          pushSmokingChecked =
              deviceNotificationSettingsData['Smoking']['notifyPush'] ?? false;
          smokingEmailEditController.text =
              deviceNotificationSettingsData['Smoking']['email'];
          smokingEmail = deviceNotificationSettingsData['Smoking']['email'];
        }
        if (deviceNotificationSettingsData['Overmiles'] != null) {
          overMilesChecked =
              deviceNotificationSettingsData['Overmiles']['status'];
          pushOverMilesChecked = deviceNotificationSettingsData['Overmiles']
                  ['notifyPush'] ??
              false;
          overmilesEmailEditController.text =
              deviceNotificationSettingsData['Overmiles']['email'];
          overMilesEmail = deviceNotificationSettingsData['Overmiles']['email'];
        }
      });
    }
  }

  Widget overMilesField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushOverMilesChecked,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    pushOverMilesChecked = !pushOverMilesChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: overMilesChecked,
                onChanged: (value) {
                  setState(() {
                    overMilesChecked = !overMilesChecked;
                  });
                })),
        Expanded(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Over Miles",
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value)),
                Tooltip(
                    showDuration: const Duration(seconds: 5),
                    message: "Alotted miles exceeded",
                    triggerMode: TooltipTriggerMode.tap,
                    child: Icon(
                      Icons.info,
                      size: dataController.iconSize.value,
                    ))
              ],
            ),
            TextField(
              controller: overmilesEmailEditController,
              onChanged: (value) {
                setState(
                  () {
                    overMilesEmail = value;
                  },
                );
              },
              style: TextStyle(fontSize: dataController.normalTextSize.value),
            )
          ]),
        ),
      ],
    );
  }

  Widget hornField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushHornChecked,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    pushHornChecked = !pushHornChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: hornChecked,
                onChanged: (value) {
                  setState(() {
                    hornChecked = !hornChecked;
                  });
                })),
        Expanded(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Horn",
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value)),
                Tooltip(
                    showDuration: const Duration(seconds: 5),
                    message: "Horn command sent",
                    triggerMode: TooltipTriggerMode.tap,
                    child: Icon(
                      Icons.info,
                      size: dataController.iconSize.value,
                    ))
              ],
            ),
            TextField(
              controller: hornEmailEditController,
              onChanged: (value) {
                setState(
                  () {
                    hornEmail = value;
                  },
                );
              },
              style: TextStyle(fontSize: dataController.normalTextSize.value),
            )
          ]),
        ),
      ],
    );
  }

  Widget unkillField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushUnkillChecked,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    pushUnkillChecked = !pushUnkillChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: unkillChecked,
                onChanged: (value) {
                  setState(() {
                    unkillChecked = !unkillChecked;
                  });
                })),
        Expanded(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Unkill",
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value)),
                Tooltip(
                    showDuration: const Duration(seconds: 5),
                    message: "Unkill command sent",
                    triggerMode: TooltipTriggerMode.tap,
                    child: Icon(
                      Icons.info,
                      size: dataController.iconSize.value,
                    ))
              ],
            ),
            TextField(
              controller: unkillEmailEditController,
              onChanged: (value) {
                setState(
                  () {
                    unkillEmail = value;
                  },
                );
              },
              style: TextStyle(fontSize: dataController.normalTextSize.value),
            )
          ]),
        ),
      ],
    );
  }

  Widget overSpeedField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushOverSpeedChecked,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    pushOverSpeedChecked = !pushOverSpeedChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: overSpeedChecked,
                onChanged: (value) {
                  setState(() {
                    overSpeedChecked = !overSpeedChecked;
                  });
                })),
        Expanded(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("OverSpeed",
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value)),
                Tooltip(
                    showDuration: const Duration(seconds: 5),
                    message: "Car is speeding",
                    triggerMode: TooltipTriggerMode.tap,
                    child: Icon(
                      Icons.info,
                      size: dataController.iconSize.value,
                    ))
              ],
            ),
            TextField(
              controller: overspeedEmailEditController,
              onChanged: (value) {
                setState(
                  () {
                    overMilesEmail = value;
                  },
                );
              },
              style: TextStyle(fontSize: dataController.normalTextSize.value),
            )
          ]),
        ),
      ],
    );
  }

  Widget offlineField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushOfflineChecked,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    pushOfflineChecked = !pushOfflineChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: offlineChecked,
                onChanged: (value) {
                  setState(() {
                    offlineChecked = !offlineChecked;
                  });
                })),
        Expanded(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Offline",
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value)),
                Tooltip(
                    showDuration: const Duration(seconds: 5),
                    message: "Device shows offline",
                    triggerMode: TooltipTriggerMode.tap,
                    child: Icon(
                      Icons.info,
                      size: dataController.iconSize.value,
                    )),
              ],
            ),
            TextField(
              controller: offlineEmailEditController,
              onChanged: (value) {
                setState(
                  () {
                    offlineEmail = value;
                  },
                );
              },
              style: TextStyle(fontSize: dataController.normalTextSize.value),
            )
          ]),
        ),
      ],
    );
  }

  Widget smokingField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushSmokingChecked,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    pushSmokingChecked = !pushSmokingChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: smokingChecked,
                onChanged: (value) {
                  setState(() {
                    smokingChecked = !smokingChecked;
                  });
                })),
        Expanded(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Smoking",
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value)),
                Tooltip(
                    showDuration: const Duration(seconds: 5),
                    message: "Smoking detected",
                    triggerMode: TooltipTriggerMode.tap,
                    child: Icon(
                      Icons.info,
                      size: dataController.iconSize.value,
                    ))
              ],
            ),
            TextField(
              controller: smokingEmailEditController,
              onChanged: (value) {
                setState(
                  () {
                    smokingEmail = value;
                  },
                );
              },
              style: TextStyle(fontSize: dataController.normalTextSize.value),
            )
          ]),
        ),
      ],
    );
  }

  Widget killField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushKillChecked,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    pushKillChecked = !pushKillChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: killChecked,
                onChanged: (value) {
                  setState(() {
                    killChecked = !killChecked;
                  });
                })),
        Expanded(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Kill",
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value)),
                Tooltip(
                    showDuration: const Duration(seconds: 5),
                    message: "Kill command sent",
                    triggerMode: TooltipTriggerMode.tap,
                    child: Icon(
                      Icons.info,
                      size: dataController.iconSize.value,
                    ))
              ],
            ),
            TextField(
              controller: killEmailEditController,
              onChanged: (value) {
                setState(
                  () {
                    killEmail = value;
                  },
                );
              },
              style: TextStyle(fontSize: dataController.normalTextSize.value),
            )
          ]),
        ),
      ],
    );
  }

  Widget lockField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushLockChecked,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    pushLockChecked = !pushLockChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: lockChecked,
                onChanged: (value) {
                  setState(() {
                    lockChecked = !lockChecked;
                  });
                })),
        Expanded(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Lock",
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value)),
                Tooltip(
                    showDuration: const Duration(seconds: 5),
                    message: "Lock command sent",
                    triggerMode: TooltipTriggerMode.tap,
                    child: Icon(
                      Icons.info,
                      size: dataController.iconSize.value,
                    )),
              ],
            ),
            TextField(
              controller: lockEmailEditController,
              onChanged: (value) {
                setState(
                  () {
                    lockEmail = value;
                  },
                );
              },
              style: TextStyle(fontSize: dataController.normalTextSize.value),
            )
          ]),
        ),
      ],
    );
  }

  Widget unlockField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushUnlockChecked,
                activeColor: const Color.fromARGB(255, 18, 187, 23),
                onChanged: (value) {
                  setState(() {
                    pushUnlockChecked = !pushUnlockChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: unlockChecked,
                onChanged: (value) {
                  setState(() {
                    unlockChecked = !unlockChecked;
                  });
                })),
        Expanded(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Unlock",
                  style:
                      TextStyle(fontSize: dataController.normalTextSize.value),
                ),
                Tooltip(
                    showDuration: const Duration(seconds: 5),
                    message: "Unlock command sent",
                    triggerMode: TooltipTriggerMode.tap,
                    child: Icon(
                      Icons.info,
                      size: dataController.iconSize.value,
                    )),
              ],
            ),
            TextField(
              controller: unlockEmailEditController,
              onChanged: (value) {
                setState(
                  () {
                    unlockEmail = value;
                  },
                );
              },
              style: TextStyle(fontSize: dataController.normalTextSize.value),
            )
          ]),
        ),
      ],
    );
  }

  Widget ignitionOnField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushIgnitionOnChecked,
                activeColor: const Color.fromARGB(255, 18, 187, 23),
                onChanged: (value) {
                  setState(() {
                    pushIgnitionOnChecked = !pushIgnitionOnChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: ignitionOnChecked,
                onChanged: (value) {
                  setState(() {
                    ignitionOnChecked = !ignitionOnChecked;
                  });
                })),
        Expanded(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Ignition On",
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value)),
                Tooltip(
                    showDuration: const Duration(seconds: 5),
                    message: "Ignition turned on",
                    triggerMode: TooltipTriggerMode.tap,
                    child: Icon(
                      Icons.info,
                      size: dataController.iconSize.value,
                    )),
              ],
            ),
            TextField(
              controller: ignitionOnEmailContoroller,
              onChanged: (value) {
                setState(
                  () {
                    ignitionOnEmail = value;
                  },
                );
              },
              style: TextStyle(fontSize: dataController.normalTextSize.value),
            ),
          ],
        )),
      ],
    );
  }

  Widget noPositionUpdateField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushNoPositionUpdateChecked,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    pushNoPositionUpdateChecked = !pushNoPositionUpdateChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: noPositionUpdateChecked,
                onChanged: (value) {
                  setState(() {
                    noPositionUpdateChecked = !noPositionUpdateChecked;
                  });
                })),
        Expanded(
            child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("No Position Update",
                  style:
                      TextStyle(fontSize: dataController.normalTextSize.value)),
              Tooltip(
                  showDuration: const Duration(seconds: 5),
                  message: "Car position has not updated 3+ Hours",
                  triggerMode: TooltipTriggerMode.tap,
                  child: Icon(
                    Icons.info,
                    size: dataController.iconSize.value,
                  )),
            ],
          ),
          TextField(
            controller: noPositionUpdateEmailContoroller,
            onChanged: (value) {
              setState(
                () {
                  noPositionUpdateEmail = value;
                },
              );
            },
            style: TextStyle(fontSize: dataController.normalTextSize.value),
          ),
        ])),
      ],
    );
  }

  Widget noTripMovoementField() {
    return Row(children: [
      SizedBox(
          height: 40 * dataController.currentScaleFactor.value,
          width: 40 * dataController.currentScaleFactor.value,
          child: Checkbox(
              value: pushNoTripMovementChecked,
              activeColor: Colors.green,
              onChanged: (value) {
                setState(() {
                  pushNoTripMovementChecked = !pushNoTripMovementChecked;
                });
              })),
      SizedBox(
          height: 40 * dataController.currentScaleFactor.value,
          width: 40 * dataController.currentScaleFactor.value,
          child: Checkbox(
              value: noTripMovementChecked,
              onChanged: (value) {
                setState(() {
                  noTripMovementChecked = !noTripMovementChecked;
                });
              })),
      Expanded(
          child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("No Trip Movement",
                  style:
                      TextStyle(fontSize: dataController.normalTextSize.value)),
              Tooltip(
                  showDuration: const Duration(seconds: 5),
                  message: "No trip scheduled Bu Car is moving",
                  triggerMode: TooltipTriggerMode.tap,
                  child: Icon(
                    Icons.info,
                    size: dataController.iconSize.value,
                  )),
            ],
          ),
          TextField(
            controller: noTripMovementEmailContoroller,
            onChanged: (value) {
              setState(
                () {
                  noTripMovementEmail = value;
                },
              );
            },
            style: TextStyle(fontSize: dataController.normalTextSize.value),
          ),
        ],
      )),
    ]);
  }

  Widget possibleTowingField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushPossibleTowingChecked,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    pushPossibleTowingChecked = !pushPossibleTowingChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: possibleTowingChecked,
                onChanged: (value) {
                  setState(() {
                    possibleTowingChecked = !possibleTowingChecked;
                  });
                })),
        Expanded(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Possible Towing",
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value)),
                Tooltip(
                    showDuration: const Duration(seconds: 5),
                    message: "Ignition is off But Car is Moving",
                    triggerMode: TooltipTriggerMode.tap,
                    child: Icon(
                      Icons.info,
                      size: dataController.iconSize.value,
                    )),
              ],
            ),
            TextField(
              controller: possibleTowingEmailContoroller,
              onChanged: (value) {
                setState(
                  () {
                    possibleTowingEmail = value;
                  },
                );
              },
              style: TextStyle(fontSize: dataController.normalTextSize.value),
            )
          ]),
        ),
      ],
    );
  }

  Widget lateReturnField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushLateReturnChecked,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    pushLateReturnChecked = !pushLateReturnChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: lateReturnChecked,
                onChanged: (value) {
                  setState(() {
                    lateReturnChecked = !lateReturnChecked;
                  });
                })),
        Expanded(
            child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Late Return",
                  style:
                      TextStyle(fontSize: dataController.normalTextSize.value)),
              Tooltip(
                  showDuration: const Duration(seconds: 5),
                  message: "Trip has ended but car is not at return location",
                  triggerMode: TooltipTriggerMode.tap,
                  child: Icon(
                    Icons.info,
                    size: dataController.iconSize.value,
                  )),
            ],
          ),
          TextField(
            controller: lateReturnEmailContoroller,
            onChanged: (value) {
              setState(
                () {
                  lateReturnEmail = value;
                },
              );
            },
            style: TextStyle(fontSize: dataController.normalTextSize.value),
          ),
        ])),
      ],
    );
  }

  Widget severeWeatherField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushSevereWeatherChecked,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    pushSevereWeatherChecked = !pushSevereWeatherChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: severeWeatherChecked,
                onChanged: (value) {
                  setState(() {
                    severeWeatherChecked = !severeWeatherChecked;
                  });
                })),
        Expanded(
            child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Severe Weather",
                  style:
                      TextStyle(fontSize: dataController.normalTextSize.value)),
              Tooltip(
                  showDuration: const Duration(seconds: 5),
                  message: "Severe Weather Expected Within An Hour",
                  triggerMode: TooltipTriggerMode.tap,
                  child: Icon(
                    Icons.info,
                    size: dataController.iconSize.value,
                  )),
            ],
          ),
          TextField(
            controller: severeWeatherEmailContoroller,
            onChanged: (value) {
              setState(
                () {
                  severeWeatherEmail = value;
                },
              );
            },
            style: TextStyle(fontSize: dataController.normalTextSize.value),
          ),
        ])),
      ],
    );
  }

  Widget deviceSuspensionField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushDeviceSuspensionChecked,
                activeColor: const Color.fromARGB(255, 18, 187, 23),
                onChanged: (value) {
                  setState(() {
                    pushDeviceSuspensionChecked = !pushDeviceSuspensionChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: deviceSuspensionChecked,
                onChanged: (value) {
                  setState(() {
                    deviceSuspensionChecked = !deviceSuspensionChecked;
                  });
                })),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Device Suspension",
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value)),
                  Tooltip(
                      showDuration: const Duration(seconds: 5),
                      message: "Device has been suspended",
                      triggerMode: TooltipTriggerMode.tap,
                      child: Icon(
                        Icons.info,
                        size: dataController.iconSize.value,
                      ))
                ],
              ),
              TextField(
                controller: deviceSuspensionEmailContoroller,
                onChanged: (value) {
                  setState(
                    () {
                      deviceSuspensionEmail = value;
                    },
                  );
                },
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget shockField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushShockChecked,
                activeColor: const Color.fromARGB(255, 18, 187, 23),
                onChanged: (value) {
                  setState(() {
                    pushShockChecked = !pushShockChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: shockChecked,
                onChanged: (value) {
                  setState(() {
                    shockChecked = !shockChecked;
                  });
                })),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Shock",
                style:
                    TextStyle(fontSize: dataController.normalTextSize.value)),
            TextField(
              controller: shockEmailContoroller,
              onChanged: (value) {
                setState(
                  () {
                    shockEmail = value;
                  },
                );
              },
              style: TextStyle(fontSize: dataController.normalTextSize.value),
            )
          ]),
        ),
      ],
    );
  }

  Widget doorField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushDoorChecked,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    pushDoorChecked = !pushDoorChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: doorChecked,
                onChanged: (value) {
                  setState(() {
                    doorChecked = !doorChecked;
                  });
                })),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Door",
                style:
                    TextStyle(fontSize: dataController.normalTextSize.value)),
            TextField(
              controller: doorEmailContoroller,
              onChanged: (value) {
                setState(
                  () {
                    doorEmail = value;
                  },
                );
              },
              style: TextStyle(fontSize: dataController.normalTextSize.value),
            )
          ]),
        ),
      ],
    );
  }

  Widget hoodField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushHoodChecked,
                activeColor: const Color.fromARGB(255, 18, 187, 23),
                onChanged: (value) {
                  setState(() {
                    pushHoodChecked = !pushHoodChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: hoodChecked,
                onChanged: (value) {
                  setState(() {
                    hoodChecked = !hoodChecked;
                  });
                })),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Hood",
                style:
                    TextStyle(fontSize: dataController.normalTextSize.value)),
            TextField(
              controller: hoodEmailContoroller,
              onChanged: (value) {
                setState(
                  () {
                    hoodEmail = value;
                  },
                );
              },
              style: TextStyle(fontSize: dataController.normalTextSize.value),
            )
          ]),
        ),
      ],
    );
  }

  Widget lowBatteryField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushLowBatteryChecked,
                activeColor: const Color.fromARGB(255, 18, 187, 23),
                onChanged: (value) {
                  setState(() {
                    pushLowBatteryChecked = !pushLowBatteryChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: lowBatteryChecked,
                onChanged: (value) {
                  setState(() {
                    lowBatteryChecked = !lowBatteryChecked;
                  });
                })),
        Flexible(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Low Battery",
                style:
                    TextStyle(fontSize: dataController.normalTextSize.value)),
            Row(
              children: [
                SizedBox(
                  width: 50,
                  child: TextField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: lowBatteryLevelEditController,
                    onChanged: (value) {
                      setState(
                        () {
                          lowBatteryLevel = value;
                        },
                      );
                    },
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                  ),
                ),
                const Text('V'),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: lowBatteryEmailContoroller,
                    onChanged: (value) {
                      setState(
                        () {
                          lowBatteryEmail = value;
                        },
                      );
                    },
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                  ),
                ),
              ],
            )
          ],
        )),
      ],
    );
  }

  Widget bluetoothOffField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushBluetoothOffChecked,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    pushBluetoothOffChecked = !pushBluetoothOffChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: bluetoothOffChecked,
                onChanged: (value) {
                  setState(() {
                    bluetoothOffChecked = !bluetoothOffChecked;
                  });
                })),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Bluetooth Off",
                style:
                    TextStyle(fontSize: dataController.normalTextSize.value)),
            TextField(
              controller: bluetoothOffEmailContoroller,
              onChanged: (value) {
                setState(
                  () {
                    bluetoothOffEmail = value;
                  },
                );
              },
              style: TextStyle(fontSize: dataController.normalTextSize.value),
            )
          ]),
        ),
      ],
    );
  }

  Widget bluetoothOnField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushBluetoothOnChecked,
                activeColor: const Color.fromARGB(255, 18, 187, 23),
                onChanged: (value) {
                  setState(() {
                    pushBluetoothOnChecked = !pushBluetoothOnChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: bluetoothOnChecked,
                onChanged: (value) {
                  setState(() {
                    bluetoothOnChecked = !bluetoothOnChecked;
                  });
                })),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Bluetooth On",
                style:
                    TextStyle(fontSize: dataController.normalTextSize.value)),
            TextField(
              controller: bluetoothOnEmailContoroller,
              onChanged: (value) {
                setState(
                  () {
                    bluetoothOnEmail = value;
                  },
                );
              },
              style: TextStyle(fontSize: dataController.normalTextSize.value),
            )
          ]),
        ),
      ],
    );
  }

  Widget lockedByBluetoothField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushLockedByBluetoothChecked,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    pushLockedByBluetoothChecked =
                        !pushLockedByBluetoothChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: lockedByBluetoothChecked,
                onChanged: (value) {
                  setState(() {
                    lockedByBluetoothChecked = !lockedByBluetoothChecked;
                  });
                })),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Locked by Bluetooth",
                style:
                    TextStyle(fontSize: dataController.normalTextSize.value)),
            TextField(
              controller: lockedByBluetoothEmailContoroller,
              onChanged: (value) {
                setState(
                  () {
                    lockedByBluetoothEmail = value;
                  },
                );
              },
              style: TextStyle(fontSize: dataController.normalTextSize.value),
            )
          ]),
        ),
      ],
    );
  }

  Widget unlockedByBloothField() {
    return Row(
      children: [
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: pushUnlockedByBluetoothChecked,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    pushUnlockedByBluetoothChecked =
                        !pushUnlockedByBluetoothChecked;
                  });
                })),
        SizedBox(
            height: 40 * dataController.currentScaleFactor.value,
            width: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: unlockedByBluetoothChecked,
                onChanged: (value) {
                  setState(() {
                    unlockedByBluetoothChecked = !unlockedByBluetoothChecked;
                  });
                })),
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Unlocked by Bluetooth",
                style:
                    TextStyle(fontSize: dataController.normalTextSize.value)),
            TextField(
              controller: unlockedByBluetoothEmailContoroller,
              onChanged: (value) {
                setState(
                  () {
                    unlockedByBluetoothEmail = value;
                  },
                );
              },
              style: TextStyle(fontSize: dataController.normalTextSize.value),
            )
          ]),
        ),
      ],
    );
  }

  Widget headerField() {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5))),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'AT&T:      ',
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                  ),
                  SizedBox(
                    width: 10 * dataController.currentScaleFactor.value,
                  ),
                  Text(
                      authController.storageUserData?['userDetail']['phone'] !=
                              null
                          ? (authController.storageUserData?['userDetail']
                                  ['phone'] +
                              '@txt.att.net')
                          : 'Yourphonenumber@txt.att.net',
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value))
                ],
              ),
              Row(
                children: [
                  Text('T-Mobile:',
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value)),
                  SizedBox(
                    width: 10 * dataController.currentScaleFactor.value,
                  ),
                  Text(
                      authController.storageUserData?['userDetail']['phone'] !=
                              null
                          ? (authController.storageUserData?['userDetail']
                                  ['phone'] +
                              '@tmomail.net')
                          : 'Yourphonenumber@tmomail.net',
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value))
                ],
              ),
              Row(
                children: [
                  Text('Verizon:  ',
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value)),
                  SizedBox(
                    width: 10 * dataController.currentScaleFactor.value,
                  ),
                  Text(
                      authController.storageUserData?['userDetail']['phone'] !=
                              null
                          ? (authController.storageUserData?['userDetail']
                                  ['phone'] +
                              '@vtext.com')
                          : 'Yourphonenumber@vtext.com',
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value))
                ],
              )
            ],
          ),
        ));
  }

  Widget timeZoneField() {
    return DropdownButton<String>(
      isExpanded: true,
      value: selectedTimeZone,
      hint: Text(
        'Select a time zone',
        style: TextStyle(fontSize: dataController.normalTextSize.value),
      ),
      items: timezoneList.map((String timeZone) {
        return DropdownMenuItem<String>(
          value: timeZone,
          child: Text(
            timeZone,
            style: TextStyle(fontSize: dataController.normalTextSize.value),
          ),
        );
      }).toList(),
      onChanged: (String? value) async {
        await updateTimezone(value!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: dataController.appBarHeight.value,
          title: Text("Notify Setting",
              style: TextStyle(fontSize: dataController.appBarTitleSize.value)),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: dataController.iconSize.value,
              )),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.all(10 * dataController.currentScaleFactor.value),
          child: Column(
            children: [
              headerField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.end, // Push content to edges
                children: [
                  Text(
                    'Timezone',
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                  ),
                  const SizedBox(width: 30), // Optional spacing
                  SizedBox(
                    width: 210, // Set a fixed width for Dropdown
                    child: timeZoneField(),
                  ),
                ],
              ),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              Row(
                children: [
                  Text('Push ',
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value)),
                  const SizedBox(
                    width: 10,
                  ),
                  Text('Email',
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value)),
                  const Spacer(),
                  Text('Send Email to `\n(separate with comma)',
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value))
                ],
              ),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              unlockField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              lockField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              hornField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              unkillField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              killField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              overSpeedField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              offlineField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              smokingField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              overMilesField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              unlockedByBloothField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              lockedByBluetoothField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              bluetoothOnField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              bluetoothOffField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              lowBatteryField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              hoodField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              doorField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              shockField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              deviceSuspensionField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              ignitionOnField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              noPositionUpdateField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              noTripMovoementField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              possibleTowingField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              severeWeatherField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              lateReturnField(),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              Row(
                children: [
                  Expanded(
                      child: DefaultButton(
                          text: savingChange ? "SAVING..." : "SAVE",
                          press: () async {
                            await updateNotifiySettings();
                          })),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: SizedBox(
                          height: 50 * dataController.currentScaleFactor.value,
                          child: OutlinedButton(
                            onPressed: () {
                              Get.back();
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    5), // Set the border radius to 0 for a rectangular shape
                              ),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 108, 93, 245)),
                            ),
                            child: Text(
                              'CLOSE',
                              style: TextStyle(
                                  fontSize:
                                      dataController.normalTextSize.value),
                            ),
                          ))),
                ],
              )
            ],
          ),
        )));
  }
}
