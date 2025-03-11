import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/core/common.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/view/home/widgets/bluetooth_widget.dart';
import 'package:moovetrax/view/home/widgets/shock_alam_widet.dart';
import 'package:moovetrax/view/home/widgets/batter_status_icon.dart';
import 'package:moovetrax/view/home/widgets/credit_balance_widget.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class DeviceSettingWidget extends StatefulWidget {
  const DeviceSettingWidget({
    super.key,
    required this.onChanged,
  });

  final ValueChanged onChanged;

  @override
  State<DeviceSettingWidget> createState() => _DeviceSettingWidgetState();
}

class _DeviceSettingWidgetState extends State<DeviceSettingWidget> {
  final DataController dataController = Get.find<DataController>();
  final DeviceController deviceController = getIt<DeviceController>();
  final AuthController authController = getIt<AuthController>();
  bool closeWidget = false;
  bool lockStatus = false;
  bool unlockStatus = false;
  bool overSpeedStatus = false;
  bool hornStatus = false;
  bool unkillStatus = false;
  bool killStatus = false;
  String lastUnlockCommandDate = '';
  String lastHornCommandDate = '';
  String lastLockCommandDate = '';
  String lastUnkillCommandDate = '';
  String lastKillCommandDate = '';
  String overSpeedStr = '';
  dynamic selectedDeviceData;
  dynamic emnifyConnectivity;
  String streetName = '';

  TextEditingController overSpeedEditController =
      TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    ever(dataController.updateDevice, (_) {
      initData();
    });
    initData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  String generateGoogleMapsUrl(double latitude, double longitude) {
    return 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  }

  void initData() async {
    if (!mounted) return;
    await deviceController
        .getSelectedDeviceData(dataController.currentDeviceId.value);
    if (deviceController.apiStatus.value == ApiState.success) {
      if (!mounted) return;
      setState(() {
        selectedDeviceData = deviceController.selectedDeviceData.value;
      });
    }
    await deviceController.checkEmnifyConnectivity(
        {'device_id': dataController.currentDeviceId.value});
    if (deviceController.apiStatus.value == ApiState.success) {
      if (!mounted) return;
      setState(() {
        emnifyConnectivity =
            deviceController.selectedDeviceEmnifyConnectivity.value;
      });
    }

    if (!mounted) return;
  }

  @override
  void dispose() {
    overSpeedEditController.dispose();
    super.dispose();
  }

  Color _getProgressColor(double value) {
    if (value <= 0.3) {
      return Colors.red; // Low value - Red
    } else if (value > 0.3 && value <= 0.7) {
      return Colors.orange; // Medium value - Orange
    } else {
      return Colors.green; // High value - Green
    }
  }

  Future<void> updateCommandStatus() async {
    await deviceController
        .getDeviceCommandsDetail(dataController.currentDeviceId.value);
    if (deviceController.apiStatus.value == ApiState.failure) {
      Get.snackbar("Command Status", deviceController.errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          animationDuration: const Duration(milliseconds: 300));
      return;
    }
    setState(() {
      if (deviceController.selectedDeviceCommandDetailsData.value['commands']
              ['Unlock'] !=
          null) {
        lastUnlockCommandDate = convertUTCtoLocal4(deviceController
            .selectedDeviceCommandDetailsData
            .value['commands']['Unlock']['updatedAt']);
        if (deviceController.selectedDeviceCommandDetailsData.value['commands']
                ['Unlock']['status'] ==
            "success") {
          unlockStatus = true;
        } else {
          unlockStatus = false;
        }
      }

      if (deviceController.selectedDeviceCommandDetailsData.value['commands']
              ['Lock'] !=
          null) {
        lastLockCommandDate = convertUTCtoLocal4(deviceController
            .selectedDeviceCommandDetailsData
            .value['commands']['Lock']['updatedAt']);
        if (deviceController.selectedDeviceCommandDetailsData.value['commands']
                ['Lock']['status'] ==
            "success") {
          lockStatus = true;
        } else {
          lockStatus = false;
        }
      }

      if (deviceController.selectedDeviceCommandDetailsData.value['commands']
              ['Horn'] !=
          null) {
        lastHornCommandDate = convertUTCtoLocal4(deviceController
            .selectedDeviceCommandDetailsData
            .value['commands']['Horn']['updatedAt']);
        if (deviceController.selectedDeviceCommandDetailsData.value['commands']
                ['Horn']['status'] ==
            "success") {
          hornStatus = true;
        } else {
          hornStatus = false;
        }
      }

      if (deviceController.selectedDeviceCommandDetailsData.value['commands']
              ['Unkill'] !=
          null) {
        lastUnkillCommandDate = convertUTCtoLocal4(deviceController
            .selectedDeviceCommandDetailsData
            .value['commands']['Unkill']['updatedAt']);
        if (deviceController.selectedDeviceCommandDetailsData.value['commands']
                ['Unkill']['status'] ==
            "success") {
          unkillStatus = true;
        } else {
          unkillStatus = false;
        }
      }

      if (deviceController.selectedDeviceCommandDetailsData.value['commands']
              ['Kill'] !=
          null) {
        lastKillCommandDate = convertUTCtoLocal4(deviceController
            .selectedDeviceCommandDetailsData
            .value['commands']['Kill']['updatedAt']);
        if (deviceController.selectedDeviceCommandDetailsData.value['commands']
                ['Kill']['status'] ==
            "success") {
          killStatus = true;
        } else {
          killStatus = false;
        }
      }

      if (deviceController.selectedDeviceCommandDetailsData.value['commands']
              ['Overspeed'] !=
          null) {
        overSpeedStr = deviceController.selectedDeviceCommandDetailsData
            .value['commands']['Overspeed']['count']
            .toString();
        overSpeedEditController.text = deviceController
            .selectedDeviceCommandDetailsData
            .value['commands']['Overspeed']['count']
            .toString();
        if (deviceController.selectedDeviceCommandDetailsData.value['commands']
                ['Overspeed']['status'] ==
            "success") {
          overSpeedStatus = true;
        } else {
          overSpeedStatus = false;
        }
      }
    });
  }

  Widget overSpeedBottomSheet() {
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
                'Overspeed',
                style: TextStyle(
                    fontSize: 20 * dataController.currentScaleFactor.value,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10 * dataController.currentScaleFactor.value,
              ),
              Text(
                'Please enter your value here...',
                style: TextStyle(
                    fontSize: 14 * dataController.currentScaleFactor.value),
              ),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              TextField(
                controller: overSpeedEditController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (value) {
                  setState(() {
                    overSpeedStr = value;
                  });
                },
                decoration: InputDecoration(
                    labelText: 'overspeed',
                    suffixText: "mph",
                    suffixStyle: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                    labelStyle: TextStyle(
                        fontSize: dataController.normalTextSize.value)),
              ),
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
                      await deviceController.sendCommand({
                        'command': 'Overspeed',
                        'count': overSpeedStr,
                        'deviceId': dataController.currentDeviceId.value
                      });
                      if (deviceController.apiStatus.value ==
                          ApiState.success) {
                        Get.snackbar("Command", "Sent Command.",
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            animationDuration:
                                const Duration(milliseconds: 300));
                      }
                      await updateCommandStatus();
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
                      "Send",
                      style: TextStyle(
                        fontSize: 16 * dataController.currentScaleFactor.value,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ))
                ],
              ),
            ],
          )),
    );
  }

  void showControlDialog() async {
    await updateCommandStatus();
    Get.dialog(Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Set the border radius
        ),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 40 * dataController.currentScaleFactor.value,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "${selectedDeviceData['uniqueId']} => ${selectedDeviceData['deviceType']}",
                style: TextStyle(
                    fontSize: dataController.titleTextSize.value,
                    fontWeight: FontWeight.w600),
              )
            ]),
            SizedBox(
              height: 30 * dataController.currentScaleFactor.value,
            ),
            if (selectedDeviceData['deviceType'].toString() != "usb")
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                onTap: () async {
                  await deviceController.sendCommand({
                    'command': 'Unlock',
                    'userId': authController.storageUserData?['id'],
                    'deviceId': dataController.currentDeviceId.value
                  });

                  Get.back();
                  if (deviceController.apiStatus.value == ApiState.success) {
                    Get.snackbar("Command", "Sent Command.",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        animationDuration: const Duration(milliseconds: 300));
                  }
                },
                title: Text(
                  'Unlock',
                  style: TextStyle(
                      fontSize: dataController.normalTextSize.value,
                      fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  lastUnlockCommandDate,
                  style:
                      TextStyle(fontSize: dataController.smallTextSize.value),
                ),
                trailing: Icon(
                  unlockStatus ? Icons.done_all : Icons.check,
                  size: dataController.iconSize.value,
                  color: unlockStatus ? Colors.green : Colors.grey[600],
                ),
              ),
            if (selectedDeviceData['deviceType'].toString() != "usb")
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                onTap: () async {
                  await deviceController.sendCommand({
                    'command': 'Lock',
                    'userId': authController.storageUserData?['id'],
                    'deviceId': dataController.currentDeviceId.value
                  });
                  Get.back();

                  if (deviceController.apiStatus.value == ApiState.success) {
                    Get.snackbar("Command", "Sent Command.",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        animationDuration: const Duration(milliseconds: 300));
                  }
                },
                title: Text(
                  'Lock',
                  style: TextStyle(
                      fontSize: dataController.normalTextSize.value,
                      fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  lastLockCommandDate,
                  style:
                      TextStyle(fontSize: dataController.smallTextSize.value),
                ),
                trailing: Icon(lockStatus ? Icons.done_all : Icons.check,
                    size: dataController.iconSize.value,
                    color: lockStatus ? Colors.green : Colors.grey[600]),
              ),
            if (!(selectedDeviceData['uniqueId']
                        .toString()
                        .startsWith('MT3V') ||
                    selectedDeviceData['uniqueId']
                        .toString()
                        .startsWith('MT2V')) &&
                selectedDeviceData['deviceType'].toString() != "tesla" &&
                selectedDeviceData['deviceType'].toString() != "usb")
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                onTap: () async {
                  await deviceController.sendCommand({
                    'command': 'Horn',
                    'userId': authController.storageUserData?['id'],
                    'deviceId': dataController.currentDeviceId.value
                  });
                  Get.back();

                  if (deviceController.apiStatus.value == ApiState.success) {
                    Get.snackbar("Command", "Sent Command.",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        animationDuration: const Duration(milliseconds: 300));
                  }
                },
                title: Text(
                  'Horn',
                  style: TextStyle(
                      fontSize: dataController.normalTextSize.value,
                      fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  lastHornCommandDate,
                  style:
                      TextStyle(fontSize: dataController.smallTextSize.value),
                ),
                trailing: Icon(hornStatus ? Icons.done_all : Icons.check,
                    size: dataController.iconSize.value,
                    color: hornStatus ? Colors.green : Colors.grey[600]),
              ),
            if (selectedDeviceData['uniqueId'].toString().startsWith('MT3V') ||
                selectedDeviceData['uniqueId'].toString().startsWith('MT2V'))
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                onTap: () async {
                  await deviceController.sendCommand({
                    'command': 'LightHorn',
                    'userId': authController.storageUserData?['id'],
                    'deviceId': dataController.currentDeviceId.value
                  });
                  Get.back();

                  if (deviceController.apiStatus.value == ApiState.success) {
                    Get.snackbar("Command", "Sent Command.",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        animationDuration: const Duration(milliseconds: 300));
                  }
                },
                title: Text(
                  'Horn + Light',
                  style: TextStyle(
                      fontSize: dataController.normalTextSize.value,
                      fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  lastHornCommandDate,
                  style:
                      TextStyle(fontSize: dataController.smallTextSize.value),
                ),
                trailing: Icon(hornStatus ? Icons.done_all : Icons.check,
                    size: dataController.iconSize.value,
                    color: hornStatus ? Colors.green : Colors.grey[600]),
              ),
            if (selectedDeviceData['deviceType'].toString() == "tesla")
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                onTap: () async {
                  await deviceController.sendCommand({
                    'command': 'HonkHorn',
                    'userId': authController.storageUserData?['id'],
                    'deviceId': dataController.currentDeviceId.value
                  });
                  Get.back();

                  if (deviceController.apiStatus.value == ApiState.success) {
                    Get.snackbar("Command", "Sent Command.",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        animationDuration: const Duration(milliseconds: 300));
                  }
                },
                title: Text(
                  'HonkHorn',
                  style: TextStyle(
                      fontSize: dataController.normalTextSize.value,
                      fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  lastHornCommandDate,
                  style:
                      TextStyle(fontSize: dataController.smallTextSize.value),
                ),
                trailing: Icon(hornStatus ? Icons.done_all : Icons.check,
                    size: dataController.iconSize.value,
                    color: hornStatus ? Colors.green : Colors.grey[600]),
              ),
            if (selectedDeviceData['uniqueId'].toString().startsWith('MT3V') ||
                selectedDeviceData['uniqueId'].toString().startsWith('MT2V') ||
                selectedDeviceData['deviceType'].toString() == "tesla")
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                onTap: () async {
                  await deviceController.sendCommand({
                    'command': 'Light',
                    'userId': authController.storageUserData?['id'],
                    'deviceId': dataController.currentDeviceId.value
                  });
                  Get.back();

                  if (deviceController.apiStatus.value == ApiState.success) {
                    Get.snackbar("Command", "Sent Command.",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        animationDuration: const Duration(milliseconds: 300));
                  }
                },
                title: Text(
                  'Light',
                  style: TextStyle(
                      fontSize: dataController.normalTextSize.value,
                      fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  lastHornCommandDate,
                  style:
                      TextStyle(fontSize: dataController.smallTextSize.value),
                ),
                trailing: Icon(hornStatus ? Icons.done_all : Icons.check,
                    size: dataController.iconSize.value,
                    color: hornStatus ? Colors.green : Colors.grey[600]),
              ),
            if (selectedDeviceData['deviceType'].toString() != "smartcar" &&
                selectedDeviceData['deviceType'].toString() != "tesla" &&
                selectedDeviceData['deviceType'].toString() != "usb")
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                onTap: () async {
                  bool confirm = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Unkill"),
                          content: const Text("Are you sure?"),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text("No"),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      });
                  if (!confirm) return;
                  await deviceController.sendCommand({
                    'command': 'Unkill',
                    'userId': authController.storageUserData?['id'],
                    'deviceId': dataController.currentDeviceId.value
                  });
                  Get.back();
                  if (deviceController.apiStatus.value == ApiState.success) {
                    Get.snackbar("Command", "Sent Command.",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        animationDuration: const Duration(milliseconds: 300));
                  }
                },
                trailing: Icon(unkillStatus ? Icons.done_all : Icons.check,
                    size: dataController.iconSize.value,
                    color: unkillStatus ? Colors.green : Colors.grey[600]),
                title: Text(
                  'Unkill',
                  style: TextStyle(
                      fontSize: dataController.normalTextSize.value,
                      fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  lastUnkillCommandDate,
                  style:
                      TextStyle(fontSize: dataController.smallTextSize.value),
                ),
              ),
            if (selectedDeviceData['deviceType'].toString() != "smartcar" &&
                selectedDeviceData['deviceType'].toString() != "tesla" &&
                selectedDeviceData['deviceType'].toString() != "usb")
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                onTap: () async {
                  bool confirm = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Kill"),
                          content: const Text("Are you sure?"),
                          actions: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text("No"),
                                ),
                                const Spacer(),
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      });
                  if (!confirm) return;
                  await deviceController.sendCommand({
                    'command': 'Kill',
                    'userId': authController.storageUserData?['id'],
                    'deviceId': dataController.currentDeviceId.value
                  });
                  Get.back();
                  if (deviceController.apiStatus.value == ApiState.success) {
                    Get.snackbar("Command", "Sent Command.",
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        animationDuration: const Duration(milliseconds: 300));
                  }
                },
                trailing: Icon(killStatus ? Icons.done_all : Icons.check,
                    size: dataController.iconSize.value,
                    color: killStatus ? Colors.green : Colors.grey[600]),
                title: Text(
                  'Kill',
                  style: TextStyle(
                      fontSize: dataController.normalTextSize.value,
                      fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  lastKillCommandDate,
                  style:
                      TextStyle(fontSize: dataController.smallTextSize.value),
                ),
              ),
            ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              onTap: () {
                // Get.back();
                showModalBottomSheet<void>(
                  isScrollControlled: true,
                  constraints: const BoxConstraints(maxWidth: double.infinity),
                  context: context,
                  builder: (BuildContext context) {
                    return SingleChildScrollView(
                        child: StatefulBuilder(
                      builder: (context, setStateSB) => overSpeedBottomSheet(),
                    ));
                  },
                );
              },
              title: Text(
                'Overspeed',
                style: TextStyle(
                    fontSize: dataController.normalTextSize.value,
                    fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                '${overSpeedStr}mph',
                style: TextStyle(fontSize: dataController.smallTextSize.value),
              ),
              trailing: Icon(
                overSpeedStatus ? Icons.done_all : Icons.check,
                size: dataController.iconSize.value,
                color: overSpeedStatus ? Colors.green : Colors.grey[600],
              ),
            ),
            ListTile(
              onTap: () {
                dataController.setGeoFenceEditing(true);
                dataController.changeTabIndex(0);
                Get.back();
                Get.back();
              },
              title: Text(
                'Geofence',
                style: TextStyle(
                    fontSize: dataController.normalTextSize.value,
                    fontWeight: FontWeight.w500),
              ),
            ),
            if (selectedDeviceData['uniqueId'].toString().startsWith('MT3V') &&
                selectedDeviceData['deviceType'].toString() != "usb")
              ListTile(
                onTap: () async {
                  dynamic deviceData = selectedDeviceData;
                  await deviceController.getSelectedDeviceData(
                      selectedDeviceData['id'].toString());
                  if (deviceController.apiStatus.value == ApiState.success) {
                    deviceData = deviceController.selectedDeviceData.value;
                  }
                  if (mounted) {
                    showModalBottomSheet<void>(
                      isScrollControlled: true,
                      constraints:
                          const BoxConstraints(maxWidth: double.infinity),
                      context: context,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: StatefulBuilder(
                            builder: (context, setStateSB) {
                              return ShockAlamWidget(deviceData: deviceData);
                            },
                          ),
                        );
                      },
                    );
                  }
                },
                title: Text(
                  'Shock Alam',
                  style: TextStyle(
                      fontSize: dataController.normalTextSize.value,
                      fontWeight: FontWeight.w500),
                ),
              ),
            if ((selectedDeviceData['uniqueId'].toString().startsWith('MT3V') ||
                    selectedDeviceData['uniqueId']
                        .toString()
                        .startsWith('MT2V')) &&
                selectedDeviceData['deviceType'].toString() != "usb")
              ListTile(
                onTap: () async {
                  dynamic deviceData = selectedDeviceData;
                  await deviceController.getSelectedDeviceData(
                      selectedDeviceData['id'].toString());
                  if (deviceController.apiStatus.value == ApiState.success) {
                    deviceData = deviceController.selectedDeviceData.value;
                  }
                  if (mounted) {
                    showModalBottomSheet<void>(
                      isScrollControlled: true,
                      constraints:
                          const BoxConstraints(maxWidth: double.infinity),
                      context: context,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: StatefulBuilder(
                            builder: (context, setStateSB) {
                              return BluetoothWidget(deviceData: deviceData);
                            },
                          ),
                        );
                      },
                    );
                  }
                },
                title: Text(
                  'Bluetooth',
                  style: TextStyle(
                      fontSize: dataController.normalTextSize.value,
                      fontWeight: FontWeight.w500),
                ),
              ),
          ],
        ))));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width > 400
            ? 400 * dataController.currentScaleFactor.value
            : MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(
            horizontal: 15 * dataController.currentScaleFactor.value,
            vertical: 20 * dataController.currentScaleFactor.value),
        child: selectedDeviceData == null
            ? const SizedBox(
                height: 500,
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Row(children: [
                      // IconButton(
                      //     onPressed: () {
                      //       Get.back();
                      //       Get.toNamed('/video-to-image');
                      //     },
                      //     icon: const Icon(Icons.camera_alt)),
                      Expanded(
                        child: Text(
                          selectedDeviceData['name'] ?? '',
                          style: TextStyle(
                            fontSize: dataController.titleTextSize.value,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow
                              .ellipsis, // Handle overflow with ellipsis
                        ),
                      ),
                      SizedBox(
                        width: 10 * dataController.currentScaleFactor.value,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Get.dialog(Dialog(
                              insetPadding: const EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child:
                                  CreditBalanceWidget(onChanged: (vale) {})));
                        },
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  0), // Set the border radius to 0 for a rectangular shape
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10 *
                                    dataController.currentScaleFactor.value,
                                vertical: 5 *
                                    dataController.currentScaleFactor.value)),
                        child: Text(
                          selectedDeviceData != null
                              ? '\$ ${selectedDeviceData['credit']}'
                              : '',
                          style: TextStyle(
                              fontSize: dataController.normalTextSize.value,
                              color: Colors.green),
                        ),
                      )
                    ]),
                    SizedBox(
                      height: 20 * dataController.currentScaleFactor.value,
                    ),
                    Row(
                      children: [
                        Text(
                          emnifyConnectivity != null &&
                                  emnifyConnectivity['operatorName'] != null
                              ? emnifyConnectivity['operatorName']
                              : '',
                          style: TextStyle(
                            fontSize: dataController.normalTextSize.value,
                          ),
                        ),
                        const Spacer(),
                        if (selectedDeviceData['deviceType'] != 'smartcar' &&
                            selectedDeviceData['deviceType'] != 'tesla')
                          TriangleIcon(
                            percentage: (selectedDeviceData['mt2v_dc_volt'] ==
                                    null
                                ? 100
                                : selectedDeviceData['deviceType'] == 'tesla'
                                    ? double.parse(
                                        selectedDeviceData['mt2v_dc_volt'])
                                    : double.parse(selectedDeviceData[
                                            'mt2v_dc_volt']) *
                                        100 /
                                        15),
                          ),
                        if (selectedDeviceData['deviceType'] != 'smartcar' &&
                            selectedDeviceData['deviceType'] != 'tesla')
                          const SizedBox(
                            width: 10,
                          ),
                        if (selectedDeviceData['deviceType'] != 'smartcar' &&
                            selectedDeviceData['deviceType'] != 'tesla')
                          Text(
                            selectedDeviceData['mt2v_dc_volt'] == null
                                ? '100%'
                                : selectedDeviceData['deviceType'] == 'tesla'
                                    ? selectedDeviceData['mt2v_dc_volt']
                                        .toString()
                                    : '${(double.parse(selectedDeviceData['mt2v_dc_volt']) * 100 / 15).toInt()}%',
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value),
                          )
                      ],
                    ),
                    SizedBox(
                      height: 20 * dataController.currentScaleFactor.value,
                    ),
                    Row(
                      children: [
                        Text(
                          'Last Position',
                          style: TextStyle(
                              fontSize: dataController.normalTextSize.value),
                        ),
                        const Spacer(),
                        Text(
                            selectedDeviceData['lastPosition'] != null
                                ? convertUTCtoLocal4(
                                    selectedDeviceData['lastPosition'] ?? '')
                                : "",
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value))
                      ],
                    ),
                    SizedBox(
                      height: 20 * dataController.currentScaleFactor.value,
                    ),
                    Row(
                      children: [
                        Text(
                          'Last Connection',
                          style: TextStyle(
                              fontSize: dataController.normalTextSize.value),
                        ),
                        const Spacer(),
                        Text(
                            selectedDeviceData['lastConnect'] != null
                                ? convertUTCtoLocal4(
                                    selectedDeviceData['lastConnect'])
                                : "",
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value))
                      ],
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        streetName != ''
                            ? GestureDetector(
                                onTap: () async {
                                  String url = generateGoogleMapsUrl(
                                      selectedDeviceData['latitude'],
                                      selectedDeviceData['longitude']);
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(
                                      Uri.parse(url),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } else {
                                    throw "Could not launch this url";
                                  }
                                },
                                child: Text(
                                  streetName,
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize:
                                          dataController.normalTextSize.value),
                                ))
                            : GestureDetector(
                                onTap: () async {
                                  String address = await getStreetName(
                                      selectedDeviceData['latitude'] ?? -1000,
                                      selectedDeviceData['longitude'] ?? -1000);
                                  setState(() {
                                    streetName = address;
                                  });
                                },
                                child: Text(
                                  'Show Address',
                                  style: TextStyle(
                                      fontSize:
                                          dataController.normalTextSize.value,
                                      color: Colors.blueAccent),
                                ),
                              ),
                        if (streetName != '')
                          IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: streetName));
                                Get.snackbar("Copied to Clipboard", '',
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                    animationDuration:
                                        const Duration(milliseconds: 300));
                              },
                              icon: Icon(
                                Icons.copy,
                                size: dataController.iconSize.value,
                              )),
                      ],
                    ),
                    SizedBox(
                      height: 20 * dataController.currentScaleFactor.value,
                    ),
                    Row(
                      children: [
                        Text(
                          'Speed',
                          style: TextStyle(
                              fontSize: dataController.normalTextSize.value),
                        ),
                        const Spacer(),
                        Text(
                            selectedDeviceData['speed'] != null
                                ? '${selectedDeviceData['speed']} mi/h'
                                : '0 mi/h',
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value))
                      ],
                    ),
                    SizedBox(
                      height: 20 * dataController.currentScaleFactor.value,
                    ),
                    Row(
                      children: [
                        Text(
                          'Odometer',
                          style: TextStyle(
                              fontSize: dataController.normalTextSize.value),
                        ),
                        const Spacer(),
                        Text(selectedDeviceData['odometer'] ?? '',
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value))
                      ],
                    ),
                    SizedBox(
                      height: 20 * dataController.currentScaleFactor.value,
                    ),
                    Row(
                      children: [
                        Text(
                          'Directon',
                          style: TextStyle(
                              fontSize: dataController.normalTextSize.value),
                        ),
                        const Spacer(),
                        Text(
                          selectedDeviceData != null &&
                                  selectedDeviceData['direction'] != null
                              ? getDirection(
                                  selectedDeviceData['direction'].toDouble())
                              : '',
                          style: TextStyle(
                              fontSize: dataController.normalTextSize.value),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20 * dataController.currentScaleFactor.value,
                    ),
                    if (selectedDeviceData['mt2v_dc_volt'] != null &&
                        selectedDeviceData['deviceType'] != 'smartcar')
                      Row(
                        children: [
                          Text(
                            selectedDeviceData['deviceType'] != 'tesla'
                                ? 'Battery: ${selectedDeviceData['mt2v_dc_volt']}V'
                                : 'Battery: ${selectedDeviceData['mt2v_dc_volt']}%',
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: LinearProgressIndicator(
                            minHeight:
                                20 * dataController.currentScaleFactor.value,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            value: selectedDeviceData['deviceType'] == 'tesla'
                                ? double.parse(
                                        selectedDeviceData['mt2v_dc_volt']) /
                                    100
                                : double.parse(
                                        selectedDeviceData['mt2v_dc_volt']) /
                                    15,
                            backgroundColor: Colors.grey[
                                300], // Optional: Background color of the bar
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getProgressColor(
                                selectedDeviceData['deviceType'] == 'tesla'
                                    ? double.parse(selectedDeviceData[
                                            'mt2v_dc_volt']) /
                                        100
                                    : double.parse(selectedDeviceData[
                                            'mt2v_dc_volt']) /
                                        15,
                              ),
                            ),
                          )),
                        ],
                      ),
                    SizedBox(
                      height: 20 * dataController.currentScaleFactor.value,
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                                onTap: () {
                                  Get.back();
                                  Get.toNamed('/share');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'SHARE',
                                    style: TextStyle(
                                        fontSize:
                                            dataController.normalTextSize.value,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                            InkWell(
                              onTap: () {
                                showControlDialog();
                              },
                              child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'CONTROL',
                                    style: TextStyle(
                                        fontSize:
                                            dataController.normalTextSize.value,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  )),
                            ),
                            InkWell(
                                onTap: () {
                                  Get.back();
                                  dataController
                                      .setShowPlayPositionsHistory(true);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'REPLAY',
                                    style: TextStyle(
                                        fontSize:
                                            dataController.normalTextSize.value,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                            InkWell(
                                onTap: () {
                                  Get.toNamed('/notify-setting');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'NOTIFY',
                                    style: TextStyle(
                                        fontSize:
                                            dataController.normalTextSize.value,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ))
                          ],
                        )),
                    SizedBox(
                      height: 20 * dataController.currentScaleFactor.value,
                    ),
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                                onTap: () async {
                                  String url = generateGoogleMapsUrl(
                                      selectedDeviceData['latitude'],
                                      selectedDeviceData['longitude']);
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(
                                      Uri.parse(url),
                                      mode: LaunchMode.externalApplication,
                                    );
                                  } else {
                                    throw "Could not launch this url";
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'NAV',
                                    style: TextStyle(
                                        fontSize:
                                            dataController.normalTextSize.value,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                            InkWell(
                                onTap: () {
                                  Get.toNamed('/device-edit');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'EDIT',
                                    style: TextStyle(
                                        fontSize:
                                            dataController.normalTextSize.value,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                            InkWell(
                                onTap: () {
                                  Get.toNamed('/reports/events');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'LOG',
                                    style: TextStyle(
                                        fontSize:
                                            dataController.normalTextSize.value,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                            InkWell(
                                onTap: () {
                                  Get.toNamed('/toll-search');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'TOLL',
                                    style: TextStyle(
                                        fontSize:
                                            dataController.normalTextSize.value,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                            InkWell(
                                onTap: () {
                                  Get.back();
                                  Get.toNamed('/maintenaunce');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'MAINT',
                                    style: TextStyle(
                                        fontSize:
                                            dataController.normalTextSize.value,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                            InkWell(
                                onTap: () {
                                  Get.back();
                                  Get.toNamed('/PL');
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    'P&L',
                                    style: TextStyle(
                                        fontSize:
                                            dataController.normalTextSize.value,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ))
                          ],
                        )),
                    SizedBox(
                      height: 20 * dataController.currentScaleFactor.value,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: OutlinedButton(
                          onPressed: () async {
                            await deviceController.sendCommand({
                              'command': 'Unlock',
                              'userId': authController.storageUserData?['id'],
                              'deviceId': dataController.currentDeviceId.value
                            });
                            if (deviceController.apiStatus.value ==
                                ApiState.success) {
                              Get.snackbar("Command", "Sent Command.",
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  animationDuration:
                                      const Duration(milliseconds: 300));
                            }
                          },
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    0), // Set the border radius to 0 for a rectangular shape
                              ),
                              side: const BorderSide(color: Colors.green),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5)),
                          child: Text(
                            'UNLOCK',
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value,
                                color: Colors.green),
                          ),
                        )),
                        SizedBox(
                          width: 20 * dataController.currentScaleFactor.value,
                        ),
                        Expanded(
                            child: OutlinedButton(
                          onPressed: () async {
                            await deviceController.sendCommand({
                              'command': 'Lock',
                              'userId': authController.storageUserData?['id'],
                              'deviceId': dataController.currentDeviceId.value
                            });
                            if (deviceController.apiStatus.value ==
                                ApiState.success) {
                              Get.snackbar("Command", "Sent Command.",
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  animationDuration:
                                      const Duration(milliseconds: 300));
                            }
                          },
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 108, 93, 245)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    0), // Set the border radius to 0 for a rectangular shape
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5)),
                          child: Text(
                            'LOCK',
                            style: TextStyle(
                              fontSize: dataController.normalTextSize.value,
                            ),
                          ),
                        ))
                      ],
                    ),
                  ],
                ),
              ));
  }
}
