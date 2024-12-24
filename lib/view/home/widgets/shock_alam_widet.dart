import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/view/home/widgets/lock_unlock_settings_widget.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';

class ShockAlamWidget extends StatefulWidget {
  final dynamic deviceData;

  const ShockAlamWidget({super.key, required this.deviceData});

  @override
  State<ShockAlamWidget> createState() => _ShockAlamWidgetState();
}

class _ShockAlamWidgetState extends State<ShockAlamWidget> {
  late bool shockAlamStatus;
  late double currentSensitivity;
  late double hornDuration;
  final DataController dataController = Get.find<DataController>();
  late dynamic lockUnlockSettings;
  final DeviceController deviceController = getIt<DeviceController>();
  bool saving = false;

  @override
  void initState() {
    super.initState();
    // Initialize your state variables here
    initData();
  }

  void initData() {
    if (!mounted) return;
    shockAlamStatus = widget.deviceData['mt3v_shock_status'] ?? false;
    int sensitivity = widget.deviceData['mt3v_shock_sensitivity'] ?? 1;
    int duration = widget.deviceData['mt3v_shock_duration'] ?? 12;
    lockUnlockSettings = jsonDecode(widget.deviceData['lockUnlockSetting']);
    currentSensitivity = sensitivity.toDouble();
    hornDuration = duration.toDouble();
    setState(() {});
  }

  void onStatusChanged(bool value) {
    setState(() {
      shockAlamStatus = value;
    });
  }

  void onSensitivityChanged(double value) {
    setState(() {
      currentSensitivity = value;
    });
  }

  void onHorndurationChanged(double value) {
    setState(() {
      hornDuration = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 20 * dataController.currentScaleFactor.value,
            ),
            Text(
              'Shock Alam',
              style: TextStyle(
                  fontSize: 20 * dataController.currentScaleFactor.value,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 10 * dataController.currentScaleFactor.value,
            ),
            Row(
              children: [
                Text('Status',
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value)),
                SizedBox(
                  width: 10 * dataController.currentScaleFactor.value,
                ),
                Switch(
                  value: shockAlamStatus,
                  activeColor: Colors.green,
                  onChanged: (bool value) {
                    onStatusChanged(value);
                  },
                ),
                SizedBox(
                  width: 10 * dataController.currentScaleFactor.value,
                ),
                Text(shockAlamStatus ? 'On' : 'Off',
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value)),
              ],
            ),
            SizedBox(
              height: 10 * dataController.currentScaleFactor.value,
            ),
            Text('Sensitivity',
                style:
                    TextStyle(fontSize: dataController.normalTextSize.value)),
            Slider(
              value: currentSensitivity,
              max: 15,
              divisions: 12,
              min: 3,
              label: currentSensitivity.round().toString(),
              onChanged: (double value) {
                onSensitivityChanged(value);
              },
            ),
            Padding(
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 10 * dataController.currentScaleFactor.value,
                    vertical: 0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Most'), Text('Least')],
                )),
            SizedBox(
              height: 20 * dataController.currentScaleFactor.value,
            ),
            Text('Horn Duration',
                style:
                    TextStyle(fontSize: dataController.normalTextSize.value)),
            Slider(
              value: hornDuration,
              max: 99,
              divisions: 89,
              min: 10,
              label: hornDuration.round().toString(),
              onChanged: (double value) {
                onHorndurationChanged(value);
              },
            ),
            Padding(
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 10 * dataController.currentScaleFactor.value,
                    vertical: 0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Short'), Text('Long')],
                )),
            SizedBox(
              height: 20 * dataController.currentScaleFactor.value,
            ),
            GestureDetector(
                onTap: () async {
                  dynamic deviceData = widget.deviceData;
                  await deviceController.getSelectedDeviceData(
                      widget.deviceData['id'].toString());
                  if (deviceController.apiStatus.value == ApiState.success) {
                    deviceData = deviceController.selectedDeviceData.value;
                  }
                  Get.dialog(Dialog(
                      insetPadding: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: LockUnlockSettingsWidget(deviceData: deviceData)));
                },
                child: Text(
                  '  LOCK AND UNLOCK SETTINGS>>',
                  style: TextStyle(
                      fontSize: dataController.normalTextSize.value,
                      fontWeight: FontWeight.w600),
                )),
            SizedBox(
              height: 20 * dataController.currentScaleFactor.value,
            ),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                  onPressed: () {
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
                    "Cancel",
                    style: TextStyle(
                      fontSize: 16 * dataController.currentScaleFactor.value,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
                SizedBox(
                  width: 20 * dataController.currentScaleFactor.value,
                ),
                Expanded(
                    child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      saving = true;
                    });
                    await deviceController.updateShockSensorSetting({
                      'deviceId': widget.deviceData['id'],
                      'paymentRequired': "0",
                      "shock_sensor_setting": {
                        "mt3v_shock_duration": hornDuration.toInt(),
                        "mt3v_shock_sensitivity": currentSensitivity.toInt(),
                        "mt3v_shock_status": shockAlamStatus
                      }
                    });
                    setState(() {
                      saving = false;
                    });
                    if (deviceController.apiStatus.value == ApiState.failure) {
                      Get.snackbar(
                          "Failed", deviceController.errorMessage.value,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          animationDuration: const Duration(milliseconds: 300));
                    }
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
                    saving ? "Saving..." : "Save",
                    style: TextStyle(
                      fontSize: 16 * dataController.currentScaleFactor.value,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
