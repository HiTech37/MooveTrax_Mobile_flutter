import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/common/widget/youtube_player.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/view/home/widgets/lock_unlock_settings_widget.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';

class BluetoothWidget extends StatefulWidget {
  final dynamic deviceData;

  const BluetoothWidget({super.key, required this.deviceData});

  @override
  State<BluetoothWidget> createState() => _BluetoothWidgetState();
}

class _BluetoothWidgetState extends State<BluetoothWidget> {
  late bool bluetoothStatus;
  late double bluetoothDistance;
  late double bluetoothSignal;
  final DataController dataController = Get.find<DataController>();
  late dynamic lockUnlockSettings;
  String bluetoothName = '';
  String pin = "";
  TextEditingController bluetoothNameEditController =
      TextEditingController(text: '');
  final DeviceController deviceController = getIt<DeviceController>();

  TextEditingController pinEditController = TextEditingController(text: '');
  bool savingSettings = false;
  String youtubeVideo = "mJ5XPDmtx7Y";
  @override
  void initState() {
    super.initState();
    // Initialize your state variables here
    initData();
  }

  @override
  void dispose() {
    pinEditController.dispose();
    bluetoothNameEditController.dispose();
    super.dispose();
  }

  void initData() {
    if (!mounted) return;
    bluetoothStatus = widget.deviceData['mt2v_bt_status'] ?? false;
    int signal = widget.deviceData['mt2v_bt_signal'] ?? 1;
    int distance = widget.deviceData['mt2v_bt_distance'] ?? 12;
    lockUnlockSettings = jsonDecode(widget.deviceData['lockUnlockSetting']);
    bluetoothName = widget.deviceData['mt2v_bt_name'];
    pin = widget.deviceData['mt2v_bt_pin'];
    bluetoothDistance = distance.toDouble();
    bluetoothSignal = signal.toDouble();
    bluetoothNameEditController.text = bluetoothName;
    pinEditController.text = pin;
    setState(() {});
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
              'Bluetooth',
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
                  value: bluetoothStatus,
                  activeColor: Colors.green,
                  onChanged: (bool value) {
                    bluetoothStatus = value;
                    setState(() {});
                  },
                ),
                SizedBox(
                  width: 10 * dataController.currentScaleFactor.value,
                ),
                Text(bluetoothStatus ? 'On' : 'Off',
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value)),
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
                          return YouTubePlayerDialog(videoId: youtubeVideo);
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'Video',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: dataController.normalTextSize.value),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10 * dataController.currentScaleFactor.value,
            ),
            Text('Bluetooth',
                style:
                    TextStyle(fontSize: dataController.normalTextSize.value)),
            TextField(
              controller: bluetoothNameEditController,
              onChanged: (value) {
                bluetoothName = value;
                setState(() {});
              },
              decoration: InputDecoration(
                  labelText: '',
                  suffixStyle:
                      TextStyle(fontSize: dataController.normalTextSize.value),
                  labelStyle:
                      TextStyle(fontSize: dataController.normalTextSize.value)),
            ),
            SizedBox(
              height: 10 * dataController.currentScaleFactor.value,
            ),
            Text('Pin',
                style:
                    TextStyle(fontSize: dataController.normalTextSize.value)),
            TextField(
              controller: pinEditController,
              onChanged: (value) {
                setState(() {
                  pin = value;
                });
              },
              decoration: InputDecoration(
                  labelText: '',
                  suffixStyle:
                      TextStyle(fontSize: dataController.normalTextSize.value),
                  labelStyle:
                      TextStyle(fontSize: dataController.normalTextSize.value)),
            ),
            SizedBox(
              height: 20 * dataController.currentScaleFactor.value,
            ),
            Text('Signal',
                style:
                    TextStyle(fontSize: dataController.normalTextSize.value)),
            Slider(
              value: bluetoothSignal,
              max: 15,
              divisions: 15,
              min: 1,
              label: bluetoothSignal.round().toString(),
              onChanged: (double value) {
                bluetoothSignal = value;
                setState(() {});
              },
            ),
            Padding(
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 10 * dataController.currentScaleFactor.value,
                    vertical: 0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Weak'), Text('Strong')],
                )),
            SizedBox(
              height: 10 * dataController.currentScaleFactor.value,
            ),
            Text('Distance',
                style:
                    TextStyle(fontSize: dataController.normalTextSize.value)),
            Slider(
              value: bluetoothDistance,
              max: 99,
              divisions: 89,
              min: 10,
              label: bluetoothDistance.round().toString(),
              onChanged: (double value) {
                bluetoothDistance = value;
                setState(() {});
              },
            ),
            Padding(
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 10 * dataController.currentScaleFactor.value,
                    vertical: 0),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Near'), Text('Far')],
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
                  onPressed: () async {
                    setState(() {
                      savingSettings = true;
                    });
                    await deviceController.updateBluetoothSetting({
                      "bluetooth_setting": {
                        'mt2v_bt_name': bluetoothName,
                        "mt2v_bt_pin": pin,
                        "mt2v_bt_signal": bluetoothSignal.toInt(),
                        "mt2v_bt_status": bluetoothStatus,
                        "mt2v_bt_distance": bluetoothDistance,
                      },
                      'paymentRequired': "0",
                      "deviceId": widget.deviceData['id']
                    });
                    setState(() {
                      savingSettings = false;
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
                    savingSettings ? "Saving..." : "Save",
                    style: TextStyle(
                      fontSize: 16 * dataController.currentScaleFactor.value,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
                SizedBox(
                  width: 20 * dataController.currentScaleFactor.value,
                ),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
