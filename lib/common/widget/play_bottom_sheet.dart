// play_bottomsheet.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/widget/bottom_sheet_switch.dart';
import 'package:moovetrax/common/widget/default_button.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';

class PlayBottomSheet extends StatefulWidget {
  const PlayBottomSheet({super.key});
  @override
  PlayCustomBottomSheet createState() => PlayCustomBottomSheet();
}

class PlayCustomBottomSheet extends State<PlayBottomSheet> {
  final DataController dataController = Get.find<DataController>();
  List<dynamic> deviceList = [];
  List<String> playSpeedList = <String>['1X', '5X', '10X'];
  List<String> periodList = <String>[
    'Today',
    'Last Hour',
    'Last 5 Hours',
    'Yesterday',
    "This Week",
    "Previous Week",
    "This Month",
    "Previous Month",
    "Custom"
  ];
  final AuthController authController = getIt<AuthController>();
  dynamic selectedDevice;
  String periodValue = 'Today';
  String playSpeed = '1X';
  bool autoPlayValue = false;

  void initData() async {
    if (!mounted) return;
    await authController.getUserProfile();
    final dynamic userData = authController.profileData.value;

    if (userData != null) {
      final dynamic devices = userData['devices'] ?? [];
      deviceList.addAll(devices);
    }
  }

  @override
  void initState() {
    super.initState();

    initData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: deviceList.isEmpty
            ? SizedBox(
                height: 300 * dataController.currentScaleFactor.value,
              )
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 20 * dataController.currentScaleFactor.value,
                    ),
                    DropdownMenu<dynamic>(
                      textStyle: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                      expandedInsets: const EdgeInsets.all(0),
                      initialSelection: deviceList.first,
                      onSelected: (dynamic value) {
                        setState(() {
                          selectedDevice = value;
                        });
                      },
                      dropdownMenuEntries: deviceList
                          .map<DropdownMenuEntry<dynamic>>((dynamic value) {
                        return DropdownMenuEntry<dynamic>(
                            value: value, label: value['name']);
                      }).toList(),
                    ),
                    SizedBox(
                      height: 20 * dataController.currentScaleFactor.value,
                    ),
                    Text(
                      'period',
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                    SizedBox(
                      height: 10 * dataController.currentScaleFactor.value,
                    ),
                    DropdownMenu<String>(
                      textStyle: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                      expandedInsets: const EdgeInsets.all(0),
                      initialSelection: periodList.first,
                      onSelected: (String? value) {
                        setState(() {
                          periodValue = value!;
                        });
                      },
                      dropdownMenuEntries: periodList
                          .map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                            value: value, label: value);
                      }).toList(),
                    ),
                    SizedBox(
                      height: 20 * dataController.currentScaleFactor.value,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Playback Speed',
                              style: TextStyle(
                                  fontSize:
                                      dataController.normalTextSize.value),
                            ),
                            SizedBox(
                              height:
                                  10 * dataController.currentScaleFactor.value,
                            ),
                            DropdownMenu<String>(
                              expandedInsets: const EdgeInsets.all(0),
                              initialSelection: playSpeedList.first,
                              textStyle: TextStyle(
                                  fontSize:
                                      dataController.normalTextSize.value),
                              onSelected: (String? value) {
                                setState(() {
                                  playSpeed = value!;
                                });
                              },
                              dropdownMenuEntries: playSpeedList
                                  .map<DropdownMenuEntry<String>>(
                                      (String value) {
                                return DropdownMenuEntry<String>(
                                    value: value, label: value);
                              }).toList(),
                            )
                          ],
                        )),
                        SizedBox(
                            width:
                                20 * dataController.currentScaleFactor.value),
                        SizedBox(
                            width:
                                120 * dataController.currentScaleFactor.value,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Auto Play',
                                  style: TextStyle(
                                      fontSize:
                                          dataController.normalTextSize.value),
                                ),
                                BottomSheetSwitch(
                                  switchValue: autoPlayValue,
                                  valueChanged: (value) {
                                    setState(() {
                                      autoPlayValue = value;
                                    });
                                  },
                                ),
                              ],
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 20 * dataController.currentScaleFactor.value,
                    ),
                    DefaultButton(
                        text: "SHOW",
                        press: () {
                          Get.back();
                        }),
                  ],
                ),
              ));
  }
}
