import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/common/widget/default_button.dart';
import 'package:moovetrax/core/common.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/view/device/screens/calibrate_door_dialog.dart';
import 'package:moovetrax/view/device/screens/calibrate_hood_dialog.dart';
import 'package:moovetrax/view/home/widgets/lock_unlock_settings_widget.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';

enum DeviceOption { off, smoke, gas }

class DeviceEditScreen extends StatefulWidget {
  const DeviceEditScreen({super.key});

  @override
  DeviceEditScreenState createState() => DeviceEditScreenState();
}

class DeviceEditScreenState extends State<DeviceEditScreen> {
  final AuthController authController = getIt<AuthController>();

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
  bool disabledUnit = false;
  bool makeDisable = false;
  bool tintAi = false;
  dynamic deviceData;
  final DataController dataController = Get.find<DataController>();
  final DeviceController deviceController = getIt<DeviceController>();
  String carName = "";
  String vinName = "";
  String licenseTag = "";
  String odometer = "";
  String make = "";
  bool cancelingService = false;

  TextEditingController carNameEditController = TextEditingController(text: '');
  TextEditingController gpsIdEditController = TextEditingController(text: '');
  TextEditingController iccIdEditController = TextEditingController(text: '');
  TextEditingController vinEditController = TextEditingController(text: '');
  TextEditingController currentFuelEditController =
      TextEditingController(text: '');
  TextEditingController apiKeyEditController = TextEditingController(text: '');
  TextEditingController licenseEditController = TextEditingController(text: '');
  TextEditingController odometerEditController =
      TextEditingController(text: '');
  TextEditingController makeEditController = TextEditingController(text: '');
  bool updatingDeviceData = false;
  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    carNameEditController.dispose();
    gpsIdEditController.dispose();
    iccIdEditController.dispose();
    vinEditController.dispose();
    licenseEditController.dispose();
    odometerEditController.dispose();
    makeEditController.dispose();
    currentFuelEditController.dispose();
    apiKeyEditController.dispose();
    super.dispose();
  }

  void updateDeviceData() async {
    deviceData['name'] = carName;
    deviceData['vin'] = vinName;
    deviceData['license_tag'] = licenseTag;
    deviceData['odometer'] = odometer;
    deviceData['make'] = make;
    deviceData['apiKey'] = apiKeyEditController.text;
    deviceData['color'] = colorValue;
    deviceData['category'] = categoryValue;
    deviceData['abi'] = shareABI;
    deviceData['isDoubleUnlock'] = doublePlusUnlock;
    deviceData['isDoubleLock'] = doulbePlusLock;
    deviceData['enableCycle'] = cycle;
    deviceData['enableInstaller'] = enableInstaller;
    deviceData['disabled'] = disabledUnit;
    deviceData['tint_ai'] = tintAi;
    if (deviceOptionValue == DeviceOption.gas) {
      deviceData['measure_type'] = 'gas';
    }
    if (deviceOptionValue == DeviceOption.off) {
      deviceData['measure_type'] = 'off';
    }
    if (deviceOptionValue == DeviceOption.smoke) {
      deviceData['measure_type'] = 'smoke';
    }

    setState(() {
      updatingDeviceData = true;
    });
    var data = deviceData;
    await deviceController.updateSelectedDeviceData(
        dataController.currentDeviceId.value, data);
    setState(() {
      updatingDeviceData = false;
    });
    Get.back();
    // initData();
  }

  void initData() async {
    if (!mounted) return;
    await deviceController
        .getSelectedDeviceData(dataController.currentDeviceId.value);
    if (deviceController.apiStatus.value == ApiState.success) {
      if (!mounted) return;
      setState(() {
        deviceData = deviceController.selectedDeviceData.value;
        carName = deviceData['name'] ?? '';
        vinName = deviceData['vin'] ?? '';
        licenseTag = deviceData['license_tag'] ?? '';
        odometer = deviceData['odometer'] ?? '';
        make = deviceData['make'] ?? '';

        carNameEditController.text = carName;
        gpsIdEditController.text = deviceData['uniqueId'] ?? '';
        iccIdEditController.text = deviceData['iccid'] ?? '';
        vinEditController.text = deviceData['vin'] ?? '';
        licenseEditController.text = deviceData['license_tag'] ?? '';
        odometerEditController.text = deviceData['odometer'] ?? '';
        makeEditController.text = deviceData['make'] ?? '';
        currentFuelEditController.text = (deviceData['fuel'] ?? '').toString();
        apiKeyEditController.text = deviceData['apiKey'] ?? '';
        colorValue = deviceData['color'] ?? 'Black';
        categoryValue = deviceData['category'] ?? 'Default';
        shareABI = deviceData['abi'] ?? false;
        doublePlusUnlock = deviceData['isDoubleUnlock'] ?? false;
        doulbePlusLock = deviceData['isDoubleLock'] ?? false;
        cycle = deviceData['enableCycle'] ?? false;
        enableInstaller = deviceData['enableInstaller'] ?? false;
        disabledUnit = deviceData['disabled'] ?? false;
        if (deviceData['measure_type'] == 'gas') {
          deviceOptionValue = DeviceOption.gas;
        }
        if (deviceData['measure_type'] == 'off') {
          deviceOptionValue = DeviceOption.off;
        }
        if (deviceData['measure_type'] == 'smoke') {
          deviceOptionValue = DeviceOption.smoke;
        }
        tintAi = deviceData['tint_ai'] ?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: dataController.appBarHeight.value,
        title: Text(
          "Edit Device",
          style: TextStyle(fontSize: dataController.appBarTitleSize.value),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              dataController.updateDevices();
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios_new,
                size: dataController.iconSize.value)),
      ),
      body: deviceData == null
          ? const SizedBox()
          : SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.all(
                      20 * dataController.currentScaleFactor.value),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'GPS',
                            style: TextStyle(
                                fontSize: 16 *
                                    dataController.currentScaleFactor.value,
                                fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          Text(
                            "BALANCE: ${deviceData['credit']}",
                            style: TextStyle(
                                fontSize: dataController.titleTextSize.value,
                                fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              Text(
                                'Monthly(\$)',
                                style: TextStyle(
                                    fontSize:
                                        dataController.titleTextSize.value),
                              ),
                              Text(
                                deviceData['monthly_cost'],
                                style: TextStyle(
                                    fontSize:
                                        dataController.titleTextSize.value,
                                    fontWeight: FontWeight.w600),
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
                          setState(() {
                            carName = value;
                          });
                        },
                        controller: carNameEditController,
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
                                readOnly: true,
                                controller: gpsIdEditController,
                                style: TextStyle(
                                    fontSize:
                                        dataController.normalTextSize.value),
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
                                showImageViewer(
                                    context,
                                    Image.asset("asset/images/gps_id.jpg")
                                        .image,
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
                      SizedBox(
                        height: 20 * dataController.currentScaleFactor.value,
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
                                    fontSize:
                                        dataController.normalTextSize.value),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                  child: TextField(
                                readOnly: true,
                                controller: iccIdEditController,
                                style: TextStyle(
                                    fontSize:
                                        dataController.normalTextSize.value),
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
                                    showImageViewer(
                                        context,
                                        Image.asset("asset/images/iccid.jpg")
                                            .image,
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
                        controller: vinEditController,
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
                        controller: licenseEditController,
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
                        controller: odometerEditController,
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
                        controller: makeEditController,
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
                              width:
                                  20 * dataController.currentScaleFactor.value,
                              height:
                                  20 * dataController.currentScaleFactor.value,
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
                              width:
                                  20 * dataController.currentScaleFactor.value,
                              height:
                                  20 * dataController.currentScaleFactor.value,
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
                                  fontSize:
                                      dataController.normalTextSize.value)),
                          SizedBox(
                              width:
                                  20 * dataController.currentScaleFactor.value,
                              height:
                                  20 * dataController.currentScaleFactor.value,
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
                                  fontSize:
                                      dataController.normalTextSize.value)),
                        ],
                      ),
                      SizedBox(
                        height: 20 * dataController.currentScaleFactor.value,
                      ),
                      TextField(
                        readOnly: true,
                        controller: currentFuelEditController,
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                        decoration: InputDecoration(
                            labelText: 'Current Fuel',
                            labelStyle: TextStyle(
                                fontSize: dataController.normalTextSize.value)),
                      ),
                      SizedBox(
                        height: 20 * dataController.currentScaleFactor.value,
                      ),
                      if (deviceOptionValue == DeviceOption.smoke)
                        DefaultButton(
                            text: deviceData['smoke_status'] == false
                                ? "CAR HAS NO SMOKE"
                                : "",
                            press: () {}),
                      if (deviceOptionValue == DeviceOption.smoke)
                        SizedBox(
                          height: 20 * dataController.currentScaleFactor.value,
                        ),
                      if (deviceOptionValue == DeviceOption.gas)
                        DefaultButton(
                            text: "FULL",
                            press: () async {
                              await deviceController.setDeviceVoltage({
                                'device_id': deviceData['id'],
                                'type': "fuel_max_voltage"
                              });
                              if (deviceController.apiStatus.value ==
                                  ApiState.failure) {
                                Get.snackbar("Failed",
                                    deviceController.errorMessage.value,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    animationDuration:
                                        const Duration(milliseconds: 300));
                              } else {
                                Get.snackbar("Succeed",
                                    'Fuel has been Calibrated as Full',
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                    animationDuration:
                                        const Duration(milliseconds: 300));
                              }
                            }),
                      if (deviceOptionValue == DeviceOption.gas)
                        SizedBox(
                          height: 20 * dataController.currentScaleFactor.value,
                        ),
                      if (deviceOptionValue == DeviceOption.gas)
                        DefaultButton(
                            text: "QUARTER",
                            press: () async {
                              await deviceController.setDeviceVoltage({
                                'device_id': deviceData['id'],
                                'type': "fuel_min_voltage"
                              });
                              if (deviceController.apiStatus.value ==
                                  ApiState.failure) {
                                Get.snackbar("Failed",
                                    deviceController.errorMessage.value,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    animationDuration:
                                        const Duration(milliseconds: 300));
                              } else {
                                Get.snackbar("Succeed",
                                    'Fuel has been Calibrated as quarter',
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                    animationDuration:
                                        const Duration(milliseconds: 300));
                              }
                            }),
                      if (deviceOptionValue == DeviceOption.gas)
                        SizedBox(
                          height: 20 * dataController.currentScaleFactor.value,
                        ),
                      TextField(
                        controller: apiKeyEditController,
                        readOnly: true,
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                        decoration: InputDecoration(
                            labelText: 'API key',
                            labelStyle: TextStyle(
                                fontSize: dataController.normalTextSize.value)),
                      ),
                      SizedBox(
                        height: 20 * dataController.currentScaleFactor.value,
                      ),
                      DefaultButton(
                          text: "GENERATE",
                          press: () {
                            apiKeyEditController.text = randomStr(16);
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      if (deviceData['uniqueId'].toString().startsWith('MT3V'))
                        Column(
                          children: [
                            DefaultButton(
                                text: "CALIBRATE DOOR",
                                press: () {
                                  Get.dialog(Dialog(
                                      insetPadding: const EdgeInsets.all(10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: CalibrateDoorDialog(
                                          onChanged: (value) {
                                        setState(() {
                                          Get.back();
                                        });
                                      })));
                                }),
                            const SizedBox(
                              height: 20,
                            ),
                            DefaultButton(
                                text: "CALIBRATE HOOD",
                                press: () {
                                  Get.dialog(Dialog(
                                      insetPadding: const EdgeInsets.all(10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: CalibrateHoodDialog(
                                          onChanged: (value) {
                                        setState(() {
                                          Get.back();
                                        });
                                      })));
                                }),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                                onTap: () async {
                                  await deviceController.getSelectedDeviceData(
                                      deviceData['id'].toString());
                                  if (deviceController.apiStatus.value ==
                                      ApiState.success) {
                                    deviceData = deviceController
                                        .selectedDeviceData.value;
                                  }
                                  Get.dialog(Dialog(
                                      insetPadding: const EdgeInsets.all(10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: LockUnlockSettingsWidget(
                                          deviceData: deviceData)));
                                },
                                child: Text(
                                  '  LOCK AND UNLOCK SETTINGS>>',
                                  style: TextStyle(
                                      fontSize:
                                          dataController.normalTextSize.value,
                                      fontWeight: FontWeight.w600),
                                )),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
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
                                          fontSize: dataController
                                              .normalTextSize.value),
                                    )),
                                SizedBox(
                                  width: 20 *
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
                                          animationDuration: const Duration(
                                              milliseconds: 300));
                                    } else {
                                      Get.snackbar("Success",
                                          "You updated successfully!",
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white,
                                          animationDuration: const Duration(
                                              milliseconds: 300));
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 5),
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        color: Colors.green),
                                    child: Text(
                                      'All Cars',
                                      style: TextStyle(
                                          fontSize: dataController
                                              .normalTextSize.value,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Tooltip(
                                    showDuration: const Duration(seconds: 5),
                                    textStyle: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
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
                                          dataController
                                              .currentScaleFactor.value,
                                      width: 40 *
                                          dataController
                                              .currentScaleFactor.value,
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
                                      await deviceController
                                          .setUserDevicesAbi();
                                      if (deviceController.apiStatus.value ==
                                          ApiState.failure) {
                                        Get.snackbar("Failed",
                                            deviceController.errorMessage.value,
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                            animationDuration: const Duration(
                                                milliseconds: 300));
                                      } else {
                                        Get.snackbar("Success",
                                            "You updated successfully!",
                                            backgroundColor: Colors.green,
                                            colorText: Colors.white,
                                            animationDuration: const Duration(
                                                milliseconds: 300));
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30)),
                                          color: Colors.green),
                                      child: Text(
                                        'All Cars',
                                        style: TextStyle(
                                            fontSize: dataController
                                                .normalTextSize.value,
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
                                          fontSize: dataController
                                              .normalTextSize.value),
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
                              height:
                                  30 * dataController.currentScaleFactor.value,
                              width:
                                  40 * dataController.currentScaleFactor.value,
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
                                    fontSize:
                                        dataController.normalTextSize.value),
                              )),
                          SizedBox(
                            width: 20 * dataController.currentScaleFactor.value,
                          ),
                          GestureDetector(
                            onTap: () async {
                              await deviceController.setUserDevicesTintAi();
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
                              height:
                                  30 * dataController.currentScaleFactor.value,
                              width:
                                  40 * dataController.currentScaleFactor.value,
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
                                    fontSize:
                                        dataController.normalTextSize.value),
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
                              height:
                                  30 * dataController.currentScaleFactor.value,
                              width:
                                  40 * dataController.currentScaleFactor.value,
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
                                    fontSize:
                                        dataController.normalTextSize.value),
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
                              height:
                                  30 * dataController.currentScaleFactor.value,
                              width:
                                  40 * dataController.currentScaleFactor.value,
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
                                    fontSize:
                                        dataController.normalTextSize.value),
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
                              height:
                                  30 * dataController.currentScaleFactor.value,
                              width:
                                  40 * dataController.currentScaleFactor.value,
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
                                    fontSize:
                                        dataController.normalTextSize.value),
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
                          SizedBox(
                              height:
                                  30 * dataController.currentScaleFactor.value,
                              width:
                                  40 * dataController.currentScaleFactor.value,
                              child: authController
                                          .storageUserData!['administrator'] ==
                                      false
                                  ? Checkbox(
                                      value: disabledUnit, onChanged: null)
                                  : Checkbox(
                                      value: disabledUnit,
                                      onChanged: (value) {
                                        setState(() {
                                          disabledUnit = value!;
                                        });
                                      })),
                          GestureDetector(
                              onTap: () {
                                setState(() {});
                              },
                              child: Text(
                                "Disabled",
                                style: TextStyle(
                                    fontSize:
                                        dataController.normalTextSize.value),
                              )),
                          const Spacer(),
                          Tooltip(
                              showDuration: const Duration(seconds: 5),
                              message: "This function will disable the unit",
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
                                fontSize: 16 *
                                    dataController.currentScaleFactor.value,
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
                              updateDeviceData();
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
                              updatingDeviceData ? "Saving..." : "Save",
                              style: TextStyle(
                                fontSize: 16 *
                                    dataController.currentScaleFactor.value,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        Expanded(
                            child: ElevatedButton(
                          onPressed: () async {
                            if (double.parse(deviceData['credit'].toString()) >
                                0) {
                              dynamic confirmCancel = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Moove Trax',
                                      style: TextStyle(
                                          fontSize: dataController
                                              .titleTextSize.value,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    content: Text(
                                      'Please Pay Balance\$ ${deviceData['credit']}',
                                      style: TextStyle(
                                        fontSize:
                                            dataController.normalTextSize.value,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Get.back(result: true);
                                        },
                                        child: Text(
                                          'YES',
                                          style: TextStyle(
                                            fontSize: dataController
                                                .normalTextSize.value,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.back(result: false);
                                        },
                                        child: Text(
                                          'CANCEL',
                                          style: TextStyle(
                                            fontSize: dataController
                                                .normalTextSize.value,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (confirmCancel == null) return;

                              if (confirmCancel == true) {
                                dataController.setCurrentPaymentItemId(
                                    dataController.currentDeviceId.value);
                                dataController.setOneTimePaymentAmountValue(
                                    deviceData['credit'].toString());
                                Get.toNamed('/device-payment');
                              }
                            } else {
                              dynamic confirmCancel = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                      'Moove Trax',
                                      style: TextStyle(
                                          fontSize: dataController
                                              .titleTextSize.value,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    content: Text(
                                      'Are you sure?',
                                      style: TextStyle(
                                        fontSize:
                                            dataController.normalTextSize.value,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Get.back(result: true);
                                        },
                                        child: Text(
                                          'YES',
                                          style: TextStyle(
                                            fontSize: dataController
                                                .normalTextSize.value,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.back(result: false);
                                        },
                                        child: Text(
                                          'CANCEL',
                                          style: TextStyle(
                                            fontSize: dataController
                                                .normalTextSize.value,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (confirmCancel == null) return;

                              if (confirmCancel == true) {
                                setState(() {
                                  cancelingService = true;
                                });
                                await deviceController.cancelService({
                                  'deviceId':
                                      dataController.currentDeviceId.value
                                });
                                setState(() {
                                  cancelingService = false;
                                });
                                if (deviceController.apiStatus.value ==
                                    ApiState.failure) {
                                  Get.snackbar("Cancel Service Failed",
                                      deviceController.errorMessage.value,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      animationDuration:
                                          const Duration(milliseconds: 300));
                                  Get.back();
                                } else {
                                  Get.back();
                                  dataController.updateMapScreen();
                                  dataController.changeTabIndex(0);
                                }
                              }
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                const Color.fromARGB(255, 247, 2, 83)),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                          child: Text(
                            cancelingService
                                ? "Canceling..."
                                : "Cancel Service",
                            style: TextStyle(
                              fontSize:
                                  16 * dataController.currentScaleFactor.value,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ))
                      ])
                    ],
                  ))),
    );
  }
}
