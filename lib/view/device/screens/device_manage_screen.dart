import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';

enum DeviceOption { off, smoke, gas }

class DeviceManageScreen extends StatefulWidget {
  const DeviceManageScreen({super.key});

  @override
  DeviceManageScreenState createState() => DeviceManageScreenState();
}

class DeviceManageScreenState extends State<DeviceManageScreen> {
  List<String> colorList = <String>[
    'Black',
    'Blue',
    'Brown',
    'Gold',
    'Gray',
    'Green',
    'Red',
    'Silver',
    'White',
    'Yellow'
  ];
  String colorValue = 'Black';
  List<String> categoryList = <String>[
    'Default',
    'Atv',
    'Bus',
    'Convertable',
    'Coupe',
    'Minivan',
    'Motorcycle',
    'Pickup',
    'Sedan',
    'Suv',
    'Truck',
    'Van'
  ];

  String categoryValue = 'Default';
  DeviceOption? deviceOptionValue = DeviceOption.off;
  bool shareABI = false;
  bool doulbePlusLock = false;
  bool doublePlusUnlock = false;
  bool cycle = false;
  bool enableInstaller = false;
  bool makeDisable = false;
  bool tintAi = false;
  String model = '';
  final DataController dataController = Get.find<DataController>();
  final DeviceController deviceController = getIt<DeviceController>();
  String carName = "";
  String vinName = "";
  String licenseTag = "";
  String odometer = "";
  String make = "";

  bool savingDeviceData = false;
  dynamic iccIDList = [];
  final AuthController authController = getIt<AuthController>();
  dynamic selectedIccID;
  String iccID = '';
  String gpsID = '';

  @override
  void initState() {
    super.initState();
    initIccidPrefixList();
  }

  Future<void> initIccidPrefixList() async {
    await authController.getIccidPrefixList();
    iccIDList = authController.iccidPrefixList.value;
    if (!mounted) return;
    if (iccIDList.length != 0) {
      setState(() {
        selectedIccID = iccIDList[0]['iccid_prefix'];
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void saveDeviceData() async {
    dynamic deviceData = {
      "enableCycle": cycle,
      "iccid": iccID,
      "iccid_prefix": selectedIccID,
      "isAdmin": authController.storageUserData?['administrator'],
      "license_tag": licenseTag,
      "make": make,
      "measure_type": deviceOptionValue.toString(),
      "model": model,
      "name": carName,
      "odometer": odometer,
      "uniqueId": gpsID,
      "userId": authController.storageUserData?['id'],
      "vin": vinName,
      "abi": shareABI,
      "category": categoryValue,
      "color": colorValue,
      "enableInstaller": enableInstaller,
      "isDoubleLock": doulbePlusLock,
      "isDoubleUnlock": doublePlusUnlock,
      "tint_ai": tintAi,
    };
    if (gpsID == "") {
      Get.snackbar("Validation Error", "Please input Gps ID",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          animationDuration: const Duration(milliseconds: 200));
      return;
    }
    if (iccID == "") {
      Get.snackbar("Validation Error", "Please input ICCID",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          animationDuration: const Duration(milliseconds: 200));
      return;
    }

    Get.snackbar("Processing", "Please wait. Processing can take up 20minutes.",
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        animationDuration: const Duration(milliseconds: 100));
    setState(() {
      savingDeviceData = true;
    });
    await deviceController.addDeviceData(deviceData);
    setState(() {
      savingDeviceData = false;
    });
    if (deviceController.apiStatus.value == ApiState.success) {
      Get.snackbar("Device Added", 'Device successfully added!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          animationDuration: const Duration(milliseconds: 300));
      return;
    }
    if (deviceController.apiStatus.value == ApiState.failure) {
      Get.snackbar("Adding Failed", deviceController.errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          animationDuration: const Duration(milliseconds: 300));
    } else {
      if (deviceController.addDeviceDataResult.value['error'] != "" ||
          deviceController.addDeviceDataResult.value['error'] != null) {
        Get.snackbar("Adding Failed",
            deviceController.addDeviceDataResult.value['error'].toString(),
            backgroundColor: Colors.red,
            colorText: Colors.white,
            animationDuration: const Duration(milliseconds: 300));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: dataController.appBarHeight.value,
        title: Text(
          "Device",
          style: TextStyle(fontSize: dataController.appBarTitleSize.value),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new,
                size: dataController.iconSize.value)),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding:
                  EdgeInsets.all(20 * dataController.currentScaleFactor.value),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'GPS',
                        style: TextStyle(
                            fontSize:
                                16 * dataController.currentScaleFactor.value,
                            fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      Text(
                        "BALANCE: 0.00",
                        style: TextStyle(
                          fontSize: dataController.titleTextSize.value,
                        ),
                      ),
                      const Spacer(),
                      Column(
                        children: [
                          Text(
                            'Monthly(\$)',
                            style: TextStyle(
                                fontSize: dataController.titleTextSize.value),
                          ),
                          Text(
                            '15.00',
                            style: TextStyle(
                              fontSize: dataController.titleTextSize.value,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20 * dataController.currentScaleFactor.value,
                  ),
                  TextField(
                    onChanged: (value) {
                      carName = value;
                    },
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                    decoration: InputDecoration(
                      labelText: 'CAR NAME',
                      labelStyle: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                  ),
                  SizedBox(
                    height: 20 * dataController.currentScaleFactor.value,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextField(
                            onChanged: (value) {
                              setState(() {
                                gpsID = value;
                              });
                            },
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value),
                            decoration: InputDecoration(
                              labelText: 'GPS ID*',
                              labelStyle: TextStyle(
                                  fontSize:
                                      dataController.normalTextSize.value),
                            )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                          onTap: () {
                            showImageViewer(context,
                                Image.asset("asset/images/gps_id.jpg").image,
                                swipeDismissible: true,
                                doubleTapZoomable: true);
                          },
                          child: Image.asset(
                            "asset/images/gps_id.jpg",
                            height: 50,
                            width: 60,
                            fit: BoxFit.cover,
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 20 * dataController.currentScaleFactor.value,
                  ),
                  Text(
                    'ICCID Prefix *',
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  DropdownMenu<dynamic>(
                    expandedInsets: const EdgeInsets.all(0),
                    initialSelection:
                        iccIDList.length != 0 ? iccIDList.first : null,
                    textStyle: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                    inputDecorationTheme: const InputDecorationTheme(
                      filled: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                    ),
                    onSelected: (dynamic value) {
                      // This is called when the user selects an item.
                      setState(() {
                        selectedIccID = value['iccid_prefix'];
                      });
                    },
                    dropdownMenuEntries: iccIDList
                        .map<DropdownMenuEntry<dynamic>>((dynamic value) {
                      return DropdownMenuEntry<dynamic>(
                          value: value, label: value['iccid_prefix']);
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ICCID *',
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                              child: TextField(
                            onChanged: (value) {
                              setState(() {
                                iccID = value;
                              });
                            },
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value),
                            decoration: InputDecoration(
                              hintText: '0026000000',
                              hintStyle: TextStyle(
                                  fontSize:
                                      dataController.normalTextSize.value),
                            ),
                          ))
                        ],
                      )),
                      SizedBox(
                        width: 10 * dataController.currentScaleFactor.value,
                      ),
                      SizedBox(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          GestureDetector(
                              onTap: () {
                                showImageViewer(context,
                                    Image.asset("asset/images/iccid.jpg").image,
                                    swipeDismissible: true,
                                    doubleTapZoomable: true);
                              },
                              child: Image.asset(
                                "asset/images/iccid.jpg",
                                height: 50,
                                width: 60,
                                fit: BoxFit.cover,
                              )),
                        ],
                      )),
                    ],
                  ),
                  SizedBox(
                    height: 20 * dataController.currentScaleFactor.value,
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        vinName = value;
                      });
                    },
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                    decoration: InputDecoration(
                        labelText: 'VIN',
                        labelStyle: TextStyle(
                            fontSize: dataController.normalTextSize.value)),
                  ),
                  SizedBox(
                    height: 20 * dataController.currentScaleFactor.value,
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        licenseTag = value;
                      });
                    },
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                    decoration: InputDecoration(
                        labelText: 'License Tag',
                        labelStyle: TextStyle(
                            fontSize: dataController.normalTextSize.value)),
                  ),
                  SizedBox(
                    height: 20 * dataController.currentScaleFactor.value,
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        odometer = value;
                      });
                    },
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                    decoration: InputDecoration(
                        labelText: 'Odometer',
                        labelStyle: TextStyle(
                            fontSize: dataController.normalTextSize.value)),
                  ),
                  SizedBox(
                    height: 20 * dataController.currentScaleFactor.value,
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        make = value;
                      });
                    },
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                    decoration: InputDecoration(
                        labelText: 'Make',
                        labelStyle: TextStyle(
                            fontSize: dataController.normalTextSize.value)),
                  ),
                  SizedBox(
                    height: 20 * dataController.currentScaleFactor.value,
                  ),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        model = value;
                      });
                    },
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                    decoration: InputDecoration(
                        labelText: 'Model',
                        labelStyle: TextStyle(
                            fontSize: dataController.normalTextSize.value)),
                  ),
                  SizedBox(
                    height: 20 * dataController.currentScaleFactor.value,
                  ),
                  DropdownMenu<String>(
                    label: Text(
                      'Color',
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                    expandedInsets: const EdgeInsets.all(0),
                    initialSelection: colorValue,
                    trailingIcon: Icon(
                      Icons.arrow_drop_down,
                      size: dataController.iconSize.value,
                    ),
                    onSelected: (String? value) {
                      setState(() {
                        colorValue = value!;
                      });
                    },
                    textStyle: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                    dropdownMenuEntries: colorList
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownMenu<String>(
                    label: Text(
                      "Category",
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                    textStyle: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                    expandedInsets: const EdgeInsets.all(0),
                    initialSelection: categoryValue,
                    onSelected: (String? value) {
                      setState(() {
                        categoryValue = value!;
                      });
                    },
                    trailingIcon: Icon(
                      Icons.arrow_drop_down,
                      size: dataController.iconSize.value,
                    ),
                    dropdownMenuEntries: categoryList
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  ),
                  SizedBox(
                    height: 20 * dataController.currentScaleFactor.value,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          width: 20 * dataController.currentScaleFactor.value,
                          height: 20 * dataController.currentScaleFactor.value,
                          child: Radio<DeviceOption>(
                            value: DeviceOption.off,
                            groupValue: deviceOptionValue,
                            onChanged: (DeviceOption? value) {
                              setState(() {
                                deviceOptionValue = value;
                              });
                            },
                          )),
                      Text(
                        'Off',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      SizedBox(
                          width: 20 * dataController.currentScaleFactor.value,
                          height: 20 * dataController.currentScaleFactor.value,
                          child: Radio<DeviceOption>(
                            value: DeviceOption.smoke,
                            groupValue: deviceOptionValue,
                            onChanged: (DeviceOption? value) {
                              setState(() {
                                deviceOptionValue = value;
                              });
                            },
                          )),
                      Text('Smoke',
                          style: TextStyle(
                              fontSize: dataController.normalTextSize.value)),
                      SizedBox(
                          width: 20 * dataController.currentScaleFactor.value,
                          height: 20 * dataController.currentScaleFactor.value,
                          child: Radio<DeviceOption>(
                            value: DeviceOption.gas,
                            groupValue: deviceOptionValue,
                            onChanged: (DeviceOption? value) {
                              setState(() {
                                deviceOptionValue = value;
                              });
                            },
                          )),
                      Text('Gas',
                          style: TextStyle(
                              fontSize: dataController.normalTextSize.value)),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MediaQuery.of(context).size.width > 450
                      ? Row(
                          children: [
                            SizedBox(
                                height: 30 *
                                    dataController.currentScaleFactor.value,
                                width: 40 *
                                    dataController.currentScaleFactor.value,
                                child: Checkbox(
                                    value: shareABI,
                                    onChanged: (value) {
                                      setState(() {
                                        shareABI = value!;
                                      });
                                    })),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    shareABI = !shareABI;
                                  });
                                },
                                child: Text(
                                  "Share ABI with Insurance",
                                  style: TextStyle(
                                      fontSize:
                                          dataController.normalTextSize.value),
                                )),
                            SizedBox(
                              width:
                                  10 * dataController.currentScaleFactor.value,
                            ),
                            GestureDetector(
                              onTap: () async {
                                await deviceController.setUserDevicesAbi();
                                if (deviceController.apiStatus.value ==
                                    ApiState.failure) {
                                  Get.snackbar("Failed",
                                      deviceController.errorMessage.value,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      animationDuration:
                                          const Duration(milliseconds: 300));
                                } else {
                                  Get.snackbar(
                                      "Success", "You updated successfully!",
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                      animationDuration:
                                          const Duration(milliseconds: 300));
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    color: Colors.green),
                                child: Text(
                                  'All Cars',
                                  style: TextStyle(
                                      fontSize:
                                          dataController.normalTextSize.value,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Tooltip(
                                showDuration: const Duration(seconds: 5),
                                textStyle: TextStyle(
                                    fontSize:
                                        dataController.normalTextSize.value),
                                message:
                                    "By enabling this option you will be sharing your car position and other details with American Business Insurance.",
                                triggerMode: TooltipTriggerMode.tap,
                                child: Icon(
                                  Icons.info,
                                  size: dataController.iconSize.value,
                                ))
                          ],
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(
                                  height: 30 *
                                      dataController.currentScaleFactor.value,
                                  width: 40 *
                                      dataController.currentScaleFactor.value,
                                  child: Checkbox(
                                      value: shareABI,
                                      onChanged: (value) {
                                        setState(() {
                                          shareABI = value!;
                                        });
                                      })),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      shareABI = !shareABI;
                                    });
                                  },
                                  child: Text(
                                    "Share ABI with Insurance",
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  )),
                              SizedBox(
                                width: 10 *
                                    dataController.currentScaleFactor.value,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await deviceController.setUserDevicesAbi();
                                  if (deviceController.apiStatus.value ==
                                      ApiState.failure) {
                                    Get.snackbar("Failed",
                                        deviceController.errorMessage.value,
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                        animationDuration:
                                            const Duration(milliseconds: 300));
                                  } else {
                                    Get.snackbar(
                                        "Success", "You updated successfully!",
                                        backgroundColor: Colors.green,
                                        colorText: Colors.white,
                                        animationDuration:
                                            const Duration(milliseconds: 300));
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      color: Colors.green),
                                  child: Text(
                                    'All Cars',
                                    style: TextStyle(
                                        fontSize:
                                            dataController.normalTextSize.value,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10 *
                                    dataController.currentScaleFactor.value,
                              ),
                              Tooltip(
                                  showDuration: const Duration(seconds: 5),
                                  textStyle: TextStyle(
                                      fontSize:
                                          dataController.normalTextSize.value),
                                  message:
                                      "By enabling this option you will be sharing your car position and other details with American Business Insurance.",
                                  triggerMode: TooltipTriggerMode.tap,
                                  child: Icon(
                                    Icons.info,
                                    size: dataController.iconSize.value,
                                  ))
                            ],
                          )),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          height: 30 * dataController.currentScaleFactor.value,
                          width: 40 * dataController.currentScaleFactor.value,
                          child: Checkbox(
                              value: tintAi,
                              onChanged: (value) {
                                setState(() {
                                  tintAi = value!;
                                });
                              })),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              tintAi = !tintAi;
                            });
                          },
                          child: Text(
                            "Share with Tint.Ai",
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value),
                          )),
                      SizedBox(
                        width: 20 * dataController.currentScaleFactor.value,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await deviceController.setUserDevicesTintAi();
                          if (deviceController.apiStatus.value ==
                              ApiState.failure) {
                            Get.snackbar(
                                "Failed", deviceController.errorMessage.value,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                animationDuration:
                                    const Duration(milliseconds: 300));
                          } else {
                            Get.snackbar("Success", "You updated successfully!",
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                                animationDuration:
                                    const Duration(milliseconds: 300));
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 5),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                              color: Colors.green),
                          child: Text(
                            'All Cars',
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Tooltip(
                          showDuration: const Duration(seconds: 5),
                          textStyle: TextStyle(
                              fontSize: dataController.normalTextSize.value),
                          message:
                              "By enabling this option you will be sharing your car position and other details with Tint.Ai",
                          triggerMode: TooltipTriggerMode.tap,
                          child: Icon(
                            Icons.info,
                            size: dataController.iconSize.value,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 20 * dataController.currentScaleFactor.value,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          height: 30 * dataController.currentScaleFactor.value,
                          width: 40 * dataController.currentScaleFactor.value,
                          child: Checkbox(
                              value: doulbePlusLock,
                              onChanged: (value) {
                                setState(() {
                                  doulbePlusLock = value!;
                                });
                              })),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              doulbePlusLock = !doulbePlusLock;
                            });
                          },
                          child: Text(
                            "Double Pulse Lock",
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value),
                          )),
                      const Spacer(),
                      Tooltip(
                          showDuration: const Duration(seconds: 5),
                          message:
                              "Some cars need a double pulse to lock or unlock a door, your installer can tell you about your car.",
                          triggerMode: TooltipTriggerMode.tap,
                          child: Icon(Icons.info,
                              size: dataController.iconSize.value))
                    ],
                  ),
                  SizedBox(
                    height: 20 * dataController.currentScaleFactor.value,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          height: 30 * dataController.currentScaleFactor.value,
                          width: 40 * dataController.currentScaleFactor.value,
                          child: Checkbox(
                              value: doublePlusUnlock,
                              onChanged: (value) {
                                setState(() {
                                  doublePlusUnlock = value!;
                                });
                              })),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              doublePlusUnlock = !doublePlusUnlock;
                            });
                          },
                          child: Text(
                            "Double Pulse Unlock",
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value),
                          )),
                      const Spacer(),
                      Tooltip(
                          showDuration: const Duration(seconds: 5),
                          message:
                              "Some cars need a double pulse to lock or unlock a door, your installer can tell you about your car",
                          triggerMode: TooltipTriggerMode.tap,
                          child: Icon(
                            Icons.info,
                            size: dataController.iconSize.value,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 20 * dataController.currentScaleFactor.value,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          height: 30 * dataController.currentScaleFactor.value,
                          width: 40 * dataController.currentScaleFactor.value,
                          child: Checkbox(
                              value: cycle,
                              onChanged: (value) {
                                setState(() {
                                  cycle = value!;
                                });
                              })),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              cycle = !cycle;
                            });
                          },
                          child: Text(
                            "Cycle",
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value),
                          )),
                      const Spacer(),
                      Tooltip(
                          showDuration: const Duration(seconds: 5),
                          message:
                              "Some cars go to sleep if left for an extended time. This function will wake the car up every 10 hours.",
                          triggerMode: TooltipTriggerMode.tap,
                          child: Icon(Icons.info,
                              size: dataController.iconSize.value))
                    ],
                  ),
                  SizedBox(
                    height: 20 * dataController.currentScaleFactor.value,
                  ),
                  Row(
                    children: [
                      SizedBox(
                          height: 30 * dataController.currentScaleFactor.value,
                          width: 40 * dataController.currentScaleFactor.value,
                          child: Checkbox(
                              value: enableInstaller,
                              onChanged: (value) {
                                setState(() {
                                  enableInstaller = value!;
                                });
                              })),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              enableInstaller = !enableInstaller;
                            });
                          },
                          child: Text(
                            "Enable Installer",
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value),
                          )),
                      const Spacer(),
                      Tooltip(
                          showDuration: const Duration(seconds: 5),
                          message:
                              "When this function is on, an installer can test the device using the iccid.",
                          triggerMode: TooltipTriggerMode.tap,
                          child: Icon(Icons.info,
                              size: dataController.iconSize.value))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {},
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
                            fontSize:
                                16 * dataController.currentScaleFactor.value,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () {
                          saveDeviceData();
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
                          savingDeviceData ? "Saving..." : "Save",
                          style: TextStyle(
                            fontSize:
                                16 * dataController.currentScaleFactor.value,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ))
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ))),
    );
  }
}
