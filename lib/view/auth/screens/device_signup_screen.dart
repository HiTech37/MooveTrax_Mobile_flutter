import 'dart:async';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';

import 'package:moovetrax/common/widget/default_button.dart';
import 'package:moovetrax/core/common.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';

class DeviceSignupScreen extends StatefulWidget {
  const DeviceSignupScreen({super.key});

  @override
  DeviceSignupScreenState createState() => DeviceSignupScreenState();
}

class DeviceSignupScreenState extends State<DeviceSignupScreen> {
  final AuthController authController = getIt<AuthController>();
  final _formKey = GlobalKey<FormState>();
  dynamic deviceTypeList = [];
  dynamic iccIDList = [];
  dynamic selectedIccID;
  String? deviceType;
  String email = '';
  String iccID = '';
  String gpsID = '';
  String sessionCreated = '';
  DataController dataController = Get.find<DataController>();
  bool deviceLogginIn = false;
  @override
  void initState() {
    super.initState();
    initIccidPrefixList();
    initdeviceTypeList();
  }

  Future<void> checkGpsidIccidMatched() async {
    if (authController.installerKey != null &&
        authController.installerKey != '') {
      await authController
          .sendInstallerAuthEmail({"token": authController.installerKey});
      Get.toNamed('/installer-home');
      return;
    }
    // Define the polling interval
    const Duration pollingInterval = Duration(seconds: 30);
    const Duration timeoutDuration = Duration(minutes: 20);
    DateTime startTime = DateTime.now();
    // Create a periodic timer to call the API every 30 seconds
    Timer.periodic(pollingInterval, (Timer timer) async {
      Duration elapsedTime = DateTime.now().difference(startTime);
      if (elapsedTime >= timeoutDuration) {
        // If 20 minutes have passed, stop the timer and show timeout message
        timer.cancel();
      }
      if (authController.installerKey != null &&
          authController.installerKey != '') {
        timer.cancel();
        await authController
            .sendInstallerAuthEmail({"token": authController.installerKey});
        Get.toNamed('/installer-home');
      }
      await authController.checkGpsidIccidMatched({
        "iccid_prefix": selectedIccID,
        "iccid": iccID,
        "is_final": 0,
        "uniqueId": gpsID,
        "phone_email": email,
        "session": sessionCreated,
        "mobile_installer": "0"
      });

      // Check the result from the API
    });
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

  Future<void> initdeviceTypeList() async {
    setState(() {
      deviceTypeList = [
        {
          "value": "moovetrax",
          "label": 'MT',
        },
        {
          "value": "usb",
          "label": 'USB',
        }
      ];
    });
  }

  Widget deviceTypeField() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          DropdownMenu<dynamic>(
            expandedInsets: const EdgeInsets.all(0),
            initialSelection: null,
            textStyle: TextStyle(fontSize: dataController.normalTextSize.value),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            ),
            onSelected: (dynamic value) {
              setState(() {
                deviceType = value;
              });
            },
            dropdownMenuEntries:
                deviceTypeList.map<DropdownMenuEntry<dynamic>>((dynamic value) {
              return DropdownMenuEntry<dynamic>(
                  value: value['value'], label: value['label']);
            }).toList(),
          ),
        ]));
  }

  Widget gpsIdField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'GPS ID *',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * dataController.currentScaleFactor.value),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Flexible(
                  child: TextFormField(
                style: TextStyle(fontSize: dataController.normalTextSize.value),
                onChanged: (text) => setState(() => gpsID = text),
                validator: (text) {
                  if (text == null || text.isEmpty) {
                    return 'Can\'t be empty';
                  }

                  return null;
                },
              )),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                  onTap: () {
                    showImageViewer(
                        context, Image.asset("asset/images/gps_id.jpg").image,
                        swipeDismissible: true, doubleTapZoomable: true);
                  },
                  child: Image.asset(
                    "asset/images/gps_id.jpg",
                    height: 50,
                    width: 60,
                    fit: BoxFit.cover,
                  )),
            ],
          )
        ],
      ),
    );
  }

  Widget emailField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'User Email *',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * dataController.currentScaleFactor.value),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            style: TextStyle(fontSize: dataController.normalTextSize.value),
            onChanged: (text) => setState(() => email = text),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'Can\'t be empty';
              }
              if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                  .hasMatch(text)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  Widget iccidField() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'ICCID Prefix *',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * dataController.currentScaleFactor.value),
          ),
          const SizedBox(
            height: 5,
          ),
          DropdownMenu<dynamic>(
            expandedInsets: const EdgeInsets.all(0),
            initialSelection: iccIDList.length != 0 ? iccIDList.first : null,
            textStyle: TextStyle(fontSize: dataController.normalTextSize.value),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
            ),
            onSelected: (dynamic value) {
              // This is called when the user selects an item.
              setState(() {
                selectedIccID = value;
              });
            },
            dropdownMenuEntries:
                iccIDList.map<DropdownMenuEntry<dynamic>>((dynamic value) {
              return DropdownMenuEntry<dynamic>(
                  value: value, label: value['iccid_prefix']);
            }).toList(),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ICCID *',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15 * dataController.currentScaleFactor.value),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                      child: TextFormField(
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                    onChanged: (text) => setState(() => iccID = text),
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Can\'t be empty';
                      }

                      return null;
                    },
                  ))
                ],
              )),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15 * dataController.currentScaleFactor.value),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  GestureDetector(
                      onTap: () {
                        showImageViewer(context,
                            Image.asset("asset/images/iccid.jpg").image,
                            swipeDismissible: true, doubleTapZoomable: true);
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
          )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: dataController.appBarHeight.value,
          title: Text(
            "Device Signup",
            style: TextStyle(fontSize: dataController.appBarTitleSize.value),
          ),
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Get.offAllNamed('/login');
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: dataController.iconSize.value,
              )),
        ),
        body: SizedBox(
          height: height,
          child: Stack(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          // SizedBox(height: height * .1),
                          SizedBox(
                              height:
                                  30 * dataController.currentScaleFactor.value),
                          Image.asset(
                            "asset/images/logo.png",
                            height:
                                80 * dataController.currentScaleFactor.value,
                          ),
                          SizedBox(
                              height:
                                  30 * dataController.currentScaleFactor.value),
                          deviceTypeField(),
                          gpsIdField(),
                          iccidField(),
                          emailField(),
                          SizedBox(
                              height:
                                  20 * dataController.currentScaleFactor.value),
                          DefaultButton(
                              text: deviceLogginIn == true
                                  ? "LOGGING IN..."
                                  : "LOGIN",
                              press: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (deviceType == null) {
                                    Get.snackbar("Login failed.",
                                        "Please select a device type!",
                                        backgroundColor: Colors.yellow,
                                        colorText: Colors.red,
                                        animationDuration:
                                            const Duration(milliseconds: 300));
                                  } else {
                                    dataController.changeTabIndex(0);
                                    setState(() {
                                      deviceLogginIn = true;
                                      sessionCreated =
                                          "device-signup-${randomStr(9)}";
                                    });
                                    await authController.deviceSignup({
                                      "device_type": deviceType,
                                      "iccid_prefix": selectedIccID,
                                      "iccid": iccID,
                                      "uniqueId": gpsID,
                                      "phone_email": email,
                                      "session": sessionCreated,
                                    });
                                    setState(() {
                                      deviceLogginIn = false;
                                    });
                                    if (authController.apiStatus.value ==
                                        ApiState.failure) {
                                      Get.snackbar("Login Failed",
                                          authController.errorMessage.value,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                          animationDuration: const Duration(
                                              milliseconds: 300));
                                    } else if (authController
                                            .deviceSignupResult.value !=
                                        null) {
                                      if (authController.deviceSignupResult
                                              .value['error'] !=
                                          null) {
                                        Get.snackbar(
                                            "Login Failed",
                                            authController.deviceSignupResult
                                                .value['error'],
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                            animationDuration: const Duration(
                                                milliseconds: 300));
                                      } else {
                                        Get.offAllNamed('/login');
                                      }
                                    }
                                  }
                                }
                              }),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ));
  }
}
