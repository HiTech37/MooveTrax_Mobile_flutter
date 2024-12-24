import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/core/common.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';

enum LockUnlockOption { double, single }

enum TrueIgnitionOption { on, off }

class InstallerHomeScreen extends StatefulWidget {
  const InstallerHomeScreen({super.key});

  @override
  InstallerHomeScreenState createState() => InstallerHomeScreenState();
}

class InstallerHomeScreenState extends State<InstallerHomeScreen> {
  final AuthController authController = getIt<AuthController>();
  final DeviceController deviceController = getIt<DeviceController>();
  final DataController dataController = Get.find<DataController>();
  TextEditingController carOwnerEditController =
      TextEditingController(text: '');
  bool showAdvance = false;
  LockUnlockOption lockOption = LockUnlockOption.single;
  LockUnlockOption unlockOption = LockUnlockOption.single;
  TrueIgnitionOption trueIgnitionOption = TrueIgnitionOption.on;
  String deviceID = '';
  dynamic installerDeviceData;
  dynamic installerCommandDetails;
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    initData();
  }

  void _cancelTimer() {
    _timer?.cancel(); // Cancel the timer if it's running
  }

  Future<void> initData() async {
    if (!mounted) return;
    await authController.getInstallerAuth(authController.installerKey!);
    if (authController.apiStatus.value == ApiState.success) {
      setState(() {
        installerDeviceData = authController.installerData.value;
        deviceID =
            authController.installerData.value['installer']['gpsId'].toString();
      });
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        if (!mounted) {
          timer.cancel(); // Stop the timer if the widget is no longer mounted
          return;
        }
        await deviceController.getInstallerCommandDetails(
            authController.installerData.value['device']['id'].toString());
        if (deviceController.apiStatus.value == ApiState.success) {
          installerCommandDetails =
              deviceController.installerCommandDetails.value;
          setState(() {});
        }
      });
    }
  }

  Future<void> updateData() async {
    if (!mounted) return;
    await authController.getInstallerAuth(authController.installerKey!);
    if (authController.apiStatus.value == ApiState.success) {
      setState(() {
        installerDeviceData = authController.installerData.value;
        deviceID =
            authController.installerData.value['installer']['gpsId'].toString();
      });
    }
  }

  @override
  void dispose() {
    _cancelTimer(); // Ensure the timer is canceled when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(deviceID),
        actions: [
          IconButton(
              onPressed: () async {
                await authController
                    .installerLogOut(authController.installerKey!);
                if (authController.apiStatus.value == ApiState.success) {
                  Get.offAllNamed('/login');
                } else {
                  Get.snackbar(
                      "Logout Failled", authController.errorMessage.value,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      animationDuration: const Duration(milliseconds: 300));
                }
              },
              icon: const Icon(Icons.close))
        ],
      ),
      body: installerDeviceData == null || installerCommandDetails == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
              padding: EdgeInsets.all(
                  16.0 * dataController.currentScaleFactor.value),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Signal',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      Text(
                        installerDeviceData['device']['signal'].toString(),
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Last Position',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      Text(
                        convertUTCtoLocal4(installerDeviceData['device']
                                ['lastPosition']
                            .toString()),
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Last Connect',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      Text(
                        convertUTCtoLocal4(installerDeviceData['device']
                                ['lastConnect']
                            .toString()),
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    installerDeviceData['installer']['address'],
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Speed',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      Text(
                        installerDeviceData['device']['speed'].toString(),
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Odometer',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      Text(
                        installerDeviceData['device']['odometer'].toString(),
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getDirection(installerDeviceData['device']['direction']
                            .toDouble()),
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      Text(
                        'South',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      dynamic confirmed = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('MooveTrax'),
                            content: SizedBox(
                                height: 70 *
                                    dataController.currentScaleFactor.value,
                                child: Column(
                                  children: [
                                    Text(
                                      'Has the Door been open for 5 or more minutes?',
                                      style: TextStyle(
                                          fontSize: dataController
                                              .normalTextSize.value),
                                    ),
                                    Text(
                                      '6.5V',
                                      style: TextStyle(
                                          fontSize: 20 *
                                              dataController
                                                  .currentScaleFactor.value),
                                    )
                                  ],
                                )),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      true); // Close the dialog and return true
                                },
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                      fontSize:
                                          dataController.normalTextSize.value),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      false); // Close the dialog and return false
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontSize:
                                          dataController.normalTextSize.value),
                                ),
                              ),
                            ],
                          );
                        },
                      );

                      // If the user confirmed, perform the API call
                      if (confirmed == true) {
                        // Call your API function here
                        await deviceController.installerDeviceSetVoltage({
                          'device_id': installerDeviceData['device']['id'],
                          'type': 'door_voltage'
                        });
                        if (deviceController.apiStatus.value ==
                            ApiState.success) {
                          Get.snackbar("Moovetrax says",
                              "Door switch has been calibrated",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              animationDuration:
                                  const Duration(milliseconds: 300));
                        }
                      }
                    },
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color.fromARGB(255, 0, 90, 0), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              0), // Set the border radius to 0 for a rectangular shape
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 219, 250, 211),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15)),
                    child: Text(
                      'Calibrate Door',
                      style: TextStyle(
                          fontSize: dataController.titleTextSize.value,
                          color: Colors.black87),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                    onPressed: () async {
                      dynamic confirmed = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('MooveTrax'),
                            content: SizedBox(
                                height: 70 *
                                    dataController.currentScaleFactor.value,
                                child: Column(
                                  children: [
                                    Text(
                                      'Has the Hood been open for 5 or more minutes?',
                                      style: TextStyle(
                                          fontSize: dataController
                                              .normalTextSize.value),
                                    ),
                                    Text(
                                      '5.8V',
                                      style: TextStyle(
                                          fontSize: 20 *
                                              dataController
                                                  .currentScaleFactor.value),
                                    )
                                  ],
                                )),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      true); // Close the dialog and return true
                                },
                                child: Text(
                                  'Yes',
                                  style: TextStyle(
                                      fontSize:
                                          dataController.normalTextSize.value),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(
                                      false); // Close the dialog and return false
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontSize:
                                          dataController.normalTextSize.value),
                                ),
                              ),
                            ],
                          );
                        },
                      );

                      // If the user confirmed, perform the API call
                      if (confirmed == true) {
                        // Call your API function here
                        await deviceController.installerDeviceSetVoltage({
                          'device_id': installerDeviceData['device']['id'],
                          'type': 'hood_voltage'
                        });
                        if (deviceController.apiStatus.value ==
                            ApiState.success) {
                          Get.snackbar(
                              "Moovetrax says", "Hood Pin has been calibrated",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              animationDuration:
                                  const Duration(milliseconds: 300));
                        }
                      }
                    },
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            color: Color.fromARGB(255, 0, 90, 0), width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              0), // Set the border radius to 0 for a rectangular shape
                        ),
                        backgroundColor:
                            const Color.fromARGB(255, 219, 250, 211),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15)),
                    child: Text(
                      'Calibrate Hood',
                      style: TextStyle(
                          fontSize: dataController.titleTextSize.value,
                          color: Colors.black87),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 100,
                          child: Text(
                            'Lock',
                            style: TextStyle(
                                fontSize: dataController.titleTextSize.value),
                          )),
                      const Spacer(),
                      SizedBox(
                          width: 40 * dataController.currentScaleFactor.value,
                          height: 40 * dataController.currentScaleFactor.value,
                          child: Radio<LockUnlockOption>(
                            value: LockUnlockOption.double,
                            groupValue: lockOption,
                            onChanged: (LockUnlockOption? value) async {
                              setState(() {
                                lockOption = value!;
                              });
                              if (lockOption == LockUnlockOption.double) {
                                await deviceController
                                    .lockAndUnlockInstallerDevices(deviceID, {
                                  "id": installerDeviceData['device']['id'],
                                  "uniqueId": installerDeviceData['device']
                                      ['uniqueId'],
                                  "isDoubleLock": true
                                });
                                if (deviceController.apiStatus.value ==
                                    ApiState.failure) {
                                  Get.snackbar("Failed",
                                      deviceController.errorMessage.value,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      animationDuration:
                                          const Duration(milliseconds: 300));
                                }
                                updateData();
                              }
                            },
                          )),
                      GestureDetector(
                        child: Text(
                          "Double",
                          style: TextStyle(
                              fontSize: dataController.titleTextSize.value),
                        ),
                        onTap: () async {
                          setState(() {
                            lockOption = LockUnlockOption.double;
                          });
                          await deviceController
                              .lockAndUnlockInstallerDevices(deviceID, {
                            "id": installerDeviceData['device']['id'],
                            "uniqueId": installerDeviceData['device']
                                ['uniqueId'],
                            "isDoubleLock": true
                          });
                          if (deviceController.apiStatus.value ==
                              ApiState.failure) {
                            Get.snackbar(
                                "Failed", deviceController.errorMessage.value,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                animationDuration:
                                    const Duration(milliseconds: 300));
                          }
                          updateData();
                        },
                      ),
                      const Spacer(),
                      SizedBox(
                          width: 40 * dataController.currentScaleFactor.value,
                          height: 40 * dataController.currentScaleFactor.value,
                          child: Radio<LockUnlockOption>(
                            value: LockUnlockOption.single,
                            groupValue: lockOption,
                            onChanged: (LockUnlockOption? value) async {
                              setState(() {
                                lockOption = value!;
                              });
                              if (lockOption == LockUnlockOption.single) {
                                await deviceController
                                    .lockAndUnlockInstallerDevices(deviceID, {
                                  "id": installerDeviceData['device']['id'],
                                  "uniqueId": installerDeviceData['device']
                                      ['uniqueId'],
                                  "isDoubleLock": false
                                });
                                if (deviceController.apiStatus.value ==
                                    ApiState.failure) {
                                  Get.snackbar("Failed",
                                      deviceController.errorMessage.value,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      animationDuration:
                                          const Duration(milliseconds: 300));
                                }
                                updateData();
                              }
                            },
                          )),
                      GestureDetector(
                        child: Text(
                          "Single",
                          style: TextStyle(
                              fontSize: dataController.titleTextSize.value),
                        ),
                        onTap: () async {
                          setState(() {
                            lockOption = LockUnlockOption.single;
                          });
                          await deviceController
                              .lockAndUnlockInstallerDevices(deviceID, {
                            "id": installerDeviceData['device']['id'],
                            "uniqueId": installerDeviceData['device']
                                ['uniqueId'],
                            "isDoubleLock": false
                          });
                          if (deviceController.apiStatus.value ==
                              ApiState.failure) {
                            Get.snackbar(
                                "Failed", deviceController.errorMessage.value,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                animationDuration:
                                    const Duration(milliseconds: 300));
                          }
                          updateData();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 100,
                          child: Text(
                            'Unlock',
                            style: TextStyle(
                                fontSize: dataController.titleTextSize.value),
                          )),
                      const Spacer(),
                      SizedBox(
                          width: 40 * dataController.currentScaleFactor.value,
                          height: 40 * dataController.currentScaleFactor.value,
                          child: Radio<LockUnlockOption>(
                            value: LockUnlockOption.double,
                            groupValue: unlockOption,
                            onChanged: (LockUnlockOption? value) async {
                              setState(() {
                                unlockOption = value!;
                              });
                              if (unlockOption == LockUnlockOption.double) {
                                await deviceController
                                    .lockAndUnlockInstallerDevices(deviceID, {
                                  "id": installerDeviceData['device']['id'],
                                  "uniqueId": installerDeviceData['device']
                                      ['uniqueId'],
                                  "isDoubleUnlock": true
                                });
                                if (deviceController.apiStatus.value ==
                                    ApiState.failure) {
                                  Get.snackbar("Failed",
                                      deviceController.errorMessage.value,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      animationDuration:
                                          const Duration(milliseconds: 300));
                                }
                                updateData();
                              }
                            },
                          )),
                      GestureDetector(
                        child: Text(
                          "Double",
                          style: TextStyle(
                              fontSize: dataController.titleTextSize.value),
                        ),
                        onTap: () async {
                          setState(() {
                            unlockOption = LockUnlockOption.double;
                          });
                          await deviceController
                              .lockAndUnlockInstallerDevices(deviceID, {
                            "id": installerDeviceData['device']['id'],
                            "uniqueId": installerDeviceData['device']
                                ['uniqueId'],
                            "isDoubleUnlock": true
                          });
                          if (deviceController.apiStatus.value ==
                              ApiState.failure) {
                            Get.snackbar(
                                "Failed", deviceController.errorMessage.value,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                animationDuration:
                                    const Duration(milliseconds: 300));
                          }
                          updateData();
                        },
                      ),
                      const Spacer(),
                      SizedBox(
                          width: 40 * dataController.currentScaleFactor.value,
                          height: 40 * dataController.currentScaleFactor.value,
                          child: Radio<LockUnlockOption>(
                            value: LockUnlockOption.single,
                            groupValue: unlockOption,
                            onChanged: (LockUnlockOption? value) async {
                              setState(() {
                                unlockOption = value!;
                              });
                              if (value == LockUnlockOption.single) {
                                await deviceController
                                    .lockAndUnlockInstallerDevices(deviceID, {
                                  "id": installerDeviceData['device']['id'],
                                  "uniqueId": installerDeviceData['device']
                                      ['uniqueId'],
                                  "isDoubleUnlock": false
                                });
                                if (deviceController.apiStatus.value ==
                                    ApiState.failure) {
                                  Get.snackbar("Failed",
                                      deviceController.errorMessage.value,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      animationDuration:
                                          const Duration(milliseconds: 300));
                                }
                              }
                            },
                          )),
                      GestureDetector(
                        child: Text(
                          "Single",
                          style: TextStyle(
                              fontSize: dataController.titleTextSize.value),
                        ),
                        onTap: () async {
                          setState(() {
                            unlockOption = LockUnlockOption.single;
                          });
                          await deviceController
                              .lockAndUnlockInstallerDevices(deviceID, {
                            "id": installerDeviceData['device']['id'],
                            "uniqueId": installerDeviceData['device']
                                ['uniqueId'],
                            "isDoubleUnlock": false
                          });
                          if (deviceController.apiStatus.value ==
                              ApiState.failure) {
                            Get.snackbar(
                                "Failed", deviceController.errorMessage.value,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                animationDuration:
                                    const Duration(milliseconds: 300));
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                      onPressed: () async {
                        if (installerDeviceData == null) return;
                        await deviceController.sendInstallerCommand(
                            'Unlock',
                            installerDeviceData['device']['id'].toString(),
                            (installerDeviceData['device']['userId'] ?? "-1")
                                .toString());
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
                              color: Color.fromARGB(255, 0, 90, 0), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                0), // Set the border radius to 0 for a rectangular shape
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 219, 250, 211),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Unlock',
                                  style: TextStyle(
                                      fontSize:
                                          dataController.titleTextSize.value,
                                      color: Colors.black87),
                                ),
                                Text(
                                  installerCommandDetails != null
                                      ? convertUTCtoLocal4(
                                          installerCommandDetails['Unlock']
                                              ['updatedAt'])
                                      : '',
                                  style: TextStyle(
                                      fontSize:
                                          dataController.normalTextSize.value,
                                      color: Colors.grey),
                                )
                              ]),
                          Icon(
                            Icons.check,
                            size: 30 * dataController.currentScaleFactor.value,
                            color: installerCommandDetails['Unlock']
                                        ['status'] ==
                                    'success'
                                ? const Color.fromARGB(255, 1, 99, 4)
                                : Colors.grey,
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                      onPressed: () async {
                        if (installerDeviceData == null) return;
                        await deviceController.sendInstallerCommand(
                            'Lock',
                            installerDeviceData['device']['id'].toString(),
                            (installerDeviceData['device']['userId'] ?? "-1")
                                .toString());
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
                              color: Color.fromARGB(255, 0, 90, 0), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                0), // Set the border radius to 0 for a rectangular shape
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 219, 250, 211),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lock',
                                  style: TextStyle(
                                      fontSize:
                                          dataController.titleTextSize.value,
                                      color: Colors.black87),
                                ),
                                Text(
                                  installerCommandDetails != null
                                      ? convertUTCtoLocal4(
                                          installerCommandDetails['Lock']
                                              ['updatedAt'])
                                      : '',
                                  style: TextStyle(
                                      fontSize:
                                          dataController.normalTextSize.value,
                                      color: Colors.grey),
                                )
                              ]),
                          Icon(
                            Icons.check,
                            size: 30 * dataController.currentScaleFactor.value,
                            color: installerCommandDetails['Lock']['status'] ==
                                    'success'
                                ? const Color.fromARGB(255, 1, 99, 4)
                                : Colors.grey,
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                      onPressed: () async {
                        if (installerDeviceData == null) return;
                        await deviceController.sendInstallerCommand(
                            'LightHorn',
                            installerDeviceData['device']['id'].toString(),
                            (installerDeviceData['device']['userId'] ?? "-1")
                                .toString());
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
                              color: Color.fromARGB(255, 0, 90, 0), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                0), // Set the border radius to 0 for a rectangular shape
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 219, 250, 211),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Horn + Light',
                                  style: TextStyle(
                                      fontSize:
                                          dataController.titleTextSize.value,
                                      color: Colors.black87),
                                ),
                                Text(
                                  installerCommandDetails != null
                                      ? convertUTCtoLocal4(
                                          installerCommandDetails['LightHorn']
                                              ['updatedAt'])
                                      : '',
                                  style: TextStyle(
                                      fontSize:
                                          dataController.normalTextSize.value,
                                      color: Colors.grey),
                                )
                              ]),
                          Icon(
                            Icons.check,
                            size: 30 * dataController.currentScaleFactor.value,
                            color: installerCommandDetails['LightHorn']
                                        ['status'] ==
                                    'success'
                                ? const Color.fromARGB(255, 1, 99, 4)
                                : Colors.grey,
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                      onPressed: () async {
                        if (installerDeviceData == null) return;
                        await deviceController.sendInstallerCommand(
                            'Unkill',
                            installerDeviceData['device']['id'].toString(),
                            (installerDeviceData['device']['userId'] ?? "-1")
                                .toString());
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
                              color: Color.fromARGB(255, 0, 90, 0), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                0), // Set the border radius to 0 for a rectangular shape
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 219, 250, 211),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Unkill',
                                  style: TextStyle(
                                      fontSize:
                                          dataController.titleTextSize.value,
                                      color: Colors.black87),
                                ),
                                Text(
                                  installerCommandDetails != null
                                      ? convertUTCtoLocal4(
                                          installerCommandDetails['Unkill']
                                              ['updatedAt'])
                                      : '',
                                  style: TextStyle(
                                      fontSize:
                                          dataController.normalTextSize.value,
                                      color: Colors.grey),
                                )
                              ]),
                          Icon(
                            Icons.check,
                            size: 30 * dataController.currentScaleFactor.value,
                            color: installerCommandDetails['Unkill']
                                        ['status'] ==
                                    'success'
                                ? const Color.fromARGB(255, 1, 99, 4)
                                : Colors.grey,
                          )
                        ],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                      onPressed: () async {
                        if (installerDeviceData == null) return;
                        await deviceController.sendInstallerCommand(
                            'Kill',
                            installerDeviceData['device']['id'].toString(),
                            (installerDeviceData['device']['userId'] ?? "-1")
                                .toString());
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
                              color: Color.fromARGB(255, 0, 90, 0), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                0), // Set the border radius to 0 for a rectangular shape
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 219, 250, 211),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kill',
                                  style: TextStyle(
                                      fontSize:
                                          dataController.titleTextSize.value,
                                      color: Colors.black87),
                                ),
                                Text(
                                  installerCommandDetails != null
                                      ? convertUTCtoLocal4(
                                          installerCommandDetails['Kill']
                                              ['updatedAt'])
                                      : '',
                                  style: TextStyle(
                                      fontSize:
                                          dataController.normalTextSize.value,
                                      color: Colors.grey),
                                )
                              ]),
                          Icon(
                            Icons.check,
                            size: 30 * dataController.currentScaleFactor.value,
                            color: installerCommandDetails['Kill']['status'] ==
                                    'success'
                                ? const Color.fromARGB(255, 1, 99, 4)
                                : Colors.grey,
                          )
                        ],
                      )),
                  if (installerDeviceData != null)
                    const SizedBox(
                      height: 20,
                    ),
                  if (installerDeviceData != null)
                    Row(
                      children: [
                        Text(
                          '\$${installerDeviceData['device']['credit']}',
                          style: TextStyle(
                              fontSize: dataController.titleTextSize.value),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        GestureDetector(
                            onTap: () {
                              if (installerDeviceData != null) {
                                dataController.setCurrentPaymentItemId(
                                    installerDeviceData['device']['id']
                                        .toString());
                                dataController.setOneTimePaymentAmountValue(
                                    installerDeviceData['device']['credit']);
                                dataController.setInstallerPaymentUserId(
                                    installerDeviceData['device']['userId']);
                                _cancelTimer();
                                Get.toNamed('/installer-payment');
                              }
                            },
                            child: Container(
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                    color: Colors.transparent),
                                height: 34 *
                                    dataController.currentScaleFactor.value,
                                child: Image.asset(
                                  "asset/images/paynow-paypal.png",
                                )))
                      ],
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showAdvance = !showAdvance;
                      });
                    },
                    child: Text(
                      'Advance >>',
                      style: TextStyle(
                          fontSize: dataController.titleTextSize.value,
                          color: Colors.blue),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (showAdvance)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'True Ignition',
                          style: TextStyle(
                              fontSize: dataController.titleTextSize.value),
                        ),
                        SizedBox(
                            width: 40 * dataController.currentScaleFactor.value,
                            height:
                                40 * dataController.currentScaleFactor.value,
                            child: Radio<TrueIgnitionOption>(
                              value: TrueIgnitionOption.on,
                              groupValue: trueIgnitionOption,
                              onChanged: (TrueIgnitionOption? value) async {
                                setState(() {
                                  trueIgnitionOption = value!;
                                });
                                if (value == TrueIgnitionOption.on) {
                                  if (installerDeviceData == null) return;

                                  await deviceController.sendInstallerCommand(
                                      'TrueIgnitionOn',
                                      installerDeviceData['device']['id']
                                          .toString(),
                                      (installerDeviceData['device']
                                                  ['userId'] ??
                                              "-1")
                                          .toString());
                                  if (deviceController.apiStatus.value ==
                                      ApiState.success) {
                                    Get.snackbar("Command", "Sent Command.",
                                        backgroundColor: Colors.green,
                                        colorText: Colors.white,
                                        animationDuration:
                                            const Duration(milliseconds: 300));
                                  }
                                }
                              },
                            )),
                        GestureDetector(
                          child: Text(
                            "On",
                            style: TextStyle(
                                fontSize: dataController.titleTextSize.value),
                          ),
                          onTap: () async {
                            setState(() {
                              trueIgnitionOption = TrueIgnitionOption.on;
                            });
                            if (installerDeviceData == null) return;

                            await deviceController.sendInstallerCommand(
                                'TrueIgnitionOn',
                                installerDeviceData['device']['id'].toString(),
                                (installerDeviceData['device']['userId'] ??
                                        "-1")
                                    .toString());
                            if (deviceController.apiStatus.value ==
                                ApiState.success) {
                              Get.snackbar("Command", "Sent Command.",
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  animationDuration:
                                      const Duration(milliseconds: 300));
                            }
                          },
                        ),
                        SizedBox(
                          width: 20 * dataController.currentScaleFactor.value,
                        ),
                        SizedBox(
                            width: 40 * dataController.currentScaleFactor.value,
                            height:
                                40 * dataController.currentScaleFactor.value,
                            child: Radio<TrueIgnitionOption>(
                              value: TrueIgnitionOption.off,
                              groupValue: trueIgnitionOption,
                              onChanged: (TrueIgnitionOption? value) async {
                                setState(() {
                                  trueIgnitionOption = value!;
                                });
                                if (value == TrueIgnitionOption.off) {
                                  if (installerDeviceData == null) return;

                                  await deviceController.sendInstallerCommand(
                                      'TrueIgnitionOff',
                                      installerDeviceData['device']['id']
                                          .toString(),
                                      (installerDeviceData['device']
                                                  ['userId'] ??
                                              "-1")
                                          .toString());
                                  if (deviceController.apiStatus.value ==
                                      ApiState.success) {
                                    Get.snackbar("Command", "Sent Command.",
                                        backgroundColor: Colors.green,
                                        colorText: Colors.white,
                                        animationDuration:
                                            const Duration(milliseconds: 300));
                                  }
                                }
                              },
                            )),
                        GestureDetector(
                          child: Text(
                            "Off",
                            style: TextStyle(
                                fontSize: dataController.titleTextSize.value),
                          ),
                          onTap: () async {
                            setState(() {
                              trueIgnitionOption = TrueIgnitionOption.off;
                            });
                            if (installerDeviceData == null) return;

                            await deviceController.sendInstallerCommand(
                                'TrueIgnitionOff',
                                installerDeviceData['device']['id'].toString(),
                                (installerDeviceData['device']['userId'] ??
                                        "-1")
                                    .toString());
                            if (deviceController.apiStatus.value ==
                                ApiState.success) {
                              Get.snackbar("Command", "Sent Command.",
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                  animationDuration:
                                      const Duration(milliseconds: 300));
                            }
                          },
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 30 * dataController.currentScaleFactor.value,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Invite Owner',
                        style: TextStyle(
                            fontSize: dataController.titleTextSize.value),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                          child: TextField(
                        onChanged: (value) {},
                        controller: carOwnerEditController,
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                        decoration:
                            const InputDecoration(hintText: "Enter car owner"),
                      )),
                      const SizedBox(
                        width: 5,
                      ),
                      OutlinedButton(
                        onPressed: () async {},
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: Color.fromARGB(255, 108, 93, 245)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  0), // Set the border radius to 0 for a rectangular shape
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15)),
                        child: Text(
                          'SUBMIT',
                          style: TextStyle(
                            fontSize: dataController.normalTextSize.value,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15 * dataController.currentScaleFactor.value,
                  ),
                  GestureDetector(
                    onTap: () {
                      _cancelTimer();
                      Get.toNamed('/installer-signup');
                    },
                    child: Text(
                      'Installer Signup',
                      style: TextStyle(
                          fontSize: dataController.titleTextSize.value,
                          color: Colors.blueAccent),
                    ),
                  ),
                  SizedBox(
                    height: 25 * dataController.currentScaleFactor.value,
                  ),
                ],
              ),
            )),
    );
  }
}
