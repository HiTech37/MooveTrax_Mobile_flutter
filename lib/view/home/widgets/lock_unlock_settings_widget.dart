import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/common/widget/youtube_player.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';

class LockUnlockSettingsWidget extends StatefulWidget {
  final dynamic deviceData;
  const LockUnlockSettingsWidget({super.key, required this.deviceData});

  @override
  State<LockUnlockSettingsWidget> createState() =>
      _LockUnlockSettingsWidgetState();
}

class _LockUnlockSettingsWidgetState extends State<LockUnlockSettingsWidget> {
  final DataController dataController = Get.find<DataController>();
  late dynamic lockUnlockSettings;
  bool savingLockUnlockSetting = false;
  final DeviceController deviceController = getIt<DeviceController>();
  final AuthController authController = getIt<AuthController>();

  @override
  void initState() {
    super.initState();
    // Initialize your state variables here
    initData();
  }

  void initData() {
    if (!mounted) return;
    lockUnlockSettings = jsonDecode(widget.deviceData['lockUnlockSetting']);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 400 * dataController.currentScaleFactor.value,
        padding: EdgeInsets.all(10 * dataController.currentScaleFactor.value),
        child: Column(
          children: [
            SizedBox(
              height: 20 * dataController.currentScaleFactor.value,
            ),
            Row(
              children: [
                Text(
                  'Lock and Unlock Settings',
                  style: TextStyle(
                      fontSize: dataController.titleTextSize.value,
                      fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Tooltip(
                    showDuration: const Duration(seconds: 5),
                    message:
                        "Renter will be forced to upload some pictures in order to access the car",
                    triggerMode: TooltipTriggerMode.tap,
                    child: Icon(
                      Icons.info,
                      size: dataController.iconSize.value,
                    )),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const YouTubePlayerDialog(
                              videoId: '9_ODNwaxxO8');
                        });
                  },
                  child: Text(
                    'Video',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: dataController.normalTextSize.value),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20 * dataController.currentScaleFactor.value),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 80 * dataController.currentScaleFactor.value,
                ),
                Text(
                  'Light',
                  style:
                      TextStyle(fontSize: dataController.normalTextSize.value),
                ),
                Text(
                  'Horn',
                  style:
                      TextStyle(fontSize: dataController.normalTextSize.value),
                ),
                Text(
                  'KillSwitch',
                  style:
                      TextStyle(fontSize: dataController.normalTextSize.value),
                ),
                Text(
                  'Shock',
                  style:
                      TextStyle(fontSize: dataController.normalTextSize.value),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 80 * dataController.currentScaleFactor.value,
                    child: Text(
                      'BT Lock',
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    )),
                Checkbox(
                  activeColor: Colors.green,
                  value: lockUnlockSettings['BT_lock']['Light'] == "1",
                  onChanged: (bool? value) {
                    lockUnlockSettings['BT_lock']['Light'] =
                        value == true ? "1" : "0";
                    setState(() {});
                  },
                ),
                Checkbox(
                  activeColor: Colors.green,
                  value: lockUnlockSettings['BT_lock']['Horn'] == "1",
                  onChanged: (bool? value) {
                    lockUnlockSettings['BT_lock']['Horn'] =
                        value == true ? "1" : "0";
                    setState(() {});
                  },
                ),
                Checkbox(
                  activeColor: Colors.green,
                  value: lockUnlockSettings['BT_lock']['KillSwitch'] == "1",
                  onChanged: (bool? value) {
                    lockUnlockSettings['BT_lock']['KillSwitch'] =
                        value == true ? "1" : "0";
                    setState(() {});
                  },
                ),
                Checkbox(
                  activeColor: Colors.green,
                  value: lockUnlockSettings['BT_lock']['Shock'] == "1",
                  onChanged: (bool? value) {
                    lockUnlockSettings['BT_lock']['Shock'] =
                        value == true ? "1" : "0";
                    setState(() {});
                  },
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 80 * dataController.currentScaleFactor.value,
                    child: Text(
                      'App Lock',
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    )),
                Checkbox(
                  activeColor: Colors.green,
                  value: lockUnlockSettings['app_lock']['Light'] == "1",
                  onChanged: (bool? value) {
                    lockUnlockSettings['app_lock']['Light'] =
                        value == true ? "1" : "0";
                    setState(() {});
                  },
                ),
                Checkbox(
                  activeColor: Colors.green,
                  value: lockUnlockSettings['app_lock']['Horn'] == "1",
                  onChanged: (bool? value) {
                    lockUnlockSettings['app_lock']['Horn'] =
                        value == true ? "1" : "0";
                    setState(() {});
                  },
                ),
                Checkbox(
                  activeColor: Colors.green,
                  value: lockUnlockSettings['app_lock']['KillSwitch'] == "1",
                  onChanged: (bool? value) {
                    lockUnlockSettings['app_lock']['KillSwitch'] =
                        value == true ? "1" : "0";
                    setState(() {});
                  },
                ),
                Checkbox(
                  activeColor: Colors.green,
                  value: lockUnlockSettings['app_lock']['Shock'] == "1",
                  onChanged: (bool? value) {
                    lockUnlockSettings['app_lock']['Shock'] =
                        value == true ? "1" : "0";
                    setState(() {});
                  },
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 80 * dataController.currentScaleFactor.value,
                    child: Text(
                      'BT Unlock',
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    )),
                Checkbox(
                  activeColor: Colors.green,
                  value: lockUnlockSettings['BT_unlock']['Light'] == "1",
                  onChanged: (bool? value) {
                    lockUnlockSettings['BT_unlock']['Light'] =
                        value == true ? "1" : "0";
                    setState(() {});
                  },
                ),
                Checkbox(
                  activeColor: Colors.green,
                  value: lockUnlockSettings['BT_unlock']['Horn'] == "1",
                  onChanged: (bool? value) {
                    lockUnlockSettings['BT_unlock']['Horn'] =
                        value == true ? "1" : "0";
                    setState(() {});
                  },
                ),
                Checkbox(
                  activeColor: Colors.green,
                  value: lockUnlockSettings['BT_unlock']['KillSwitch'] == "1",
                  onChanged: (bool? value) {
                    lockUnlockSettings['BT_unlock']['KillSwitch'] =
                        value == true ? "1" : "0";
                    setState(() {});
                  },
                ),
                Checkbox(
                  activeColor: Colors.green,
                  value: lockUnlockSettings['BT_unlock']['Shock'] == "1",
                  onChanged: (bool? value) {
                    lockUnlockSettings['BT_unlock']['Shock'] =
                        value == true ? "1" : "0";
                    setState(() {});
                  },
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: 80 * dataController.currentScaleFactor.value,
                    child: Text(
                      'App Unlock',
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    )),
                Checkbox(
                  activeColor: Colors.green,
                  value: lockUnlockSettings['app_unlock']['Light'] == "1",
                  onChanged: (bool? value) {
                    lockUnlockSettings['app_unlock']['Light'] =
                        value == true ? "1" : "0";
                    setState(() {});
                  },
                ),
                Checkbox(
                  activeColor: Colors.green,
                  value: lockUnlockSettings['app_unlock']['Horn'] == "1",
                  onChanged: (bool? value) {
                    lockUnlockSettings['app_unlock']['Horn'] =
                        value == true ? "1" : "0";
                    setState(() {});
                  },
                ),
                Checkbox(
                  activeColor: Colors.green,
                  value: lockUnlockSettings['app_unlock']['KillSwitch'] == "1",
                  onChanged: (bool? value) {
                    lockUnlockSettings['app_unlock']['KillSwitch'] =
                        value == true ? "1" : "0";
                    setState(() {});
                  },
                ),
                Checkbox(
                  activeColor: Colors.green,
                  value: lockUnlockSettings['app_unlock']['Shock'] == "1",
                  onChanged: (bool? value) {
                    lockUnlockSettings['app_unlock']['Shock'] =
                        value == true ? "1" : "0";
                    setState(() {});
                  },
                ),
              ],
            ),
            const Divider(),
            const Spacer(),
            Row(
              children: [
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      savingLockUnlockSetting = true;
                    });
                    await deviceController.saveLockUnlockSetting({
                      'device_id': widget.deviceData['id'],
                      'user_id': authController.storageUserData?['id'],
                      "lockUnlockSetting": jsonEncode(lockUnlockSettings)
                    });
                    if (deviceController.apiStatus.value == ApiState.failure) {
                      Get.snackbar(
                          "Failed", deviceController.errorMessage.value,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          animationDuration: const Duration(milliseconds: 300));
                    } else {
                      Get.snackbar("Success", "Settings successfully updated!",
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          animationDuration: const Duration(milliseconds: 300));
                    }
                    setState(() {
                      savingLockUnlockSetting = false;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(Colors.blue),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: Text(
                    savingLockUnlockSetting ? "SAVING..." : "SAVE",
                    style: TextStyle(
                      fontSize: 16 * dataController.currentScaleFactor.value,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () async {
                    Get.back();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(255, 71, 71, 71)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: Text(
                    "CLOSE",
                    style: TextStyle(
                      fontSize: 16 * dataController.currentScaleFactor.value,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            )
          ],
        ));
  }
}
