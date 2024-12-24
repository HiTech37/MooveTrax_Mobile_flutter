import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/common/widget/default_button.dart';
import 'package:moovetrax/common/widget/youtube_player.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';

class TollSearchScreen extends StatefulWidget {
  const TollSearchScreen({super.key});

  @override
  TollSearchScreenState createState() => TollSearchScreenState();
}

class TollSearchScreenState extends State<TollSearchScreen> {
  List<String> paymentMethodList = <String>[
    'Transponder',
    'Cash',
    'License',
    'Most Expensive',
    'Least Expensive'
  ];
  String howToVideoId = "RJmkKwgAzbc";
  String paymentMethod = 'Transponder';
  DateTime selectedFromDate = DateTime.now().subtract(const Duration(days: 7));
  TimeOfDay selectedFromTime = TimeOfDay.now();
  DateTime selectedToDate = DateTime.now();
  TimeOfDay selectedToTime = TimeOfDay.now();
  bool isSearching = false;
  final DataController dataController = Get.find<DataController>();
  final DeviceController deviceController = getIt<DeviceController>();
  final AuthController authController = getIt<AuthController>();
  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    if (!mounted) return;
    await deviceController.getTollGuruPageData({
      'user_id': authController.storageUserData?['id'],
      'device_id': dataController.currentDeviceId.value
    });
  }

  Future<void> selectFromDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedFromDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedFromDate) {
      setState(() {
        selectedFromDate = pickedDate;
      });
    }
  }

  Future<void> selectFromTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedFromTime,
    );
    if (pickedTime != null && pickedTime != selectedFromTime) {
      setState(() {
        selectedFromTime = pickedTime;
      });
    }
  }

  Future<void> selectToDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedToDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedToDate) {
      setState(() {
        selectedToDate = pickedDate;
      });
    }
  }

  Future<void> selectToTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedToTime,
    );
    if (pickedTime != null && pickedTime != selectedToTime) {
      setState(() {
        selectedToTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: dataController.appBarHeight.value,
          title: Text(
            "Toll Search",
            style: TextStyle(fontSize: dataController.appBarTitleSize.value),
          ),
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
        body: Padding(
          padding: EdgeInsets.all(20 * dataController.currentScaleFactor.value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return YouTubePlayerDialog(videoId: howToVideoId);
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Text(
                    "How To Video",
                    style: TextStyle(
                        color: Colors.blue[600],
                        fontSize: dataController.normalTextSize.value),
                  ),
                ),
              ),
              SizedBox(
                height: 10 * dataController.currentScaleFactor.value,
              ),
              SizedBox(
                width: double.infinity,
                child: TextField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  style:
                      TextStyle(fontSize: dataController.normalTextSize.value),
                  decoration: InputDecoration(
                      label: Text(
                    'Turo trip',
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                  )),
                ),
              ),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ' From',
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value),
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () => selectFromDate(context),
                                child: Padding(
                                    padding: EdgeInsets.all(5 *
                                        dataController
                                            .currentScaleFactor.value),
                                    child: Text(
                                      DateFormat('yyyy-MM-dd')
                                          .format(selectedFromDate)
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: dataController
                                              .normalTextSize.value),
                                    )),
                              ),
                              InkWell(
                                onTap: () => selectFromTime(context),
                                child: Padding(
                                    padding: EdgeInsets.all(5 *
                                        dataController
                                            .currentScaleFactor.value),
                                    child: Text(
                                      selectedFromTime.format(context),
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: dataController
                                              .normalTextSize.value),
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 10 * dataController.currentScaleFactor.value,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(' To',
                              style: TextStyle(
                                  fontSize:
                                      dataController.normalTextSize.value)),
                          Row(
                            children: [
                              InkWell(
                                onTap: () => selectToDate(context),
                                child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      DateFormat('yyyy-MM-dd')
                                          .format(selectedToDate)
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: dataController
                                              .normalTextSize.value),
                                    )),
                              ),
                              SizedBox(
                                width:
                                    5 * dataController.currentScaleFactor.value,
                              ),
                              InkWell(
                                onTap: () => selectToTime(context),
                                child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      selectedToTime.format(context),
                                      style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: dataController
                                              .normalTextSize.value),
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )),
              Text(
                'payment method',
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
              DropdownMenu<String>(
                expandedInsets: const EdgeInsets.all(0),
                initialSelection: paymentMethodList.first,
                onSelected: (String? value) {
                  setState(() {
                    paymentMethod = value!;
                  });
                },
                textStyle:
                    TextStyle(fontSize: dataController.normalTextSize.value),
                dropdownMenuEntries: paymentMethodList
                    .map<DropdownMenuEntry<String>>((String value) {
                  return DropdownMenuEntry<String>(
                      value: value,
                      label: value,
                      style: ButtonStyle(
                          textStyle: WidgetStateProperty.all(TextStyle(
                              fontSize: dataController.normalTextSize.value))));
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                      child: DefaultButton(
                          text: isSearching ? "LOADING..." : "SEARCH",
                          press: () async {
                            setState(() {
                              isSearching = true;
                            });
                            DateTime selectedFromDateTime = DateTime(
                              selectedFromDate.year,
                              selectedFromDate.month,
                              selectedFromDate.day,
                              selectedFromTime.hour,
                              selectedFromTime.minute,
                            );
                            DateTime selectedToDateTime = DateTime(
                              selectedToDate.year,
                              selectedToDate.month,
                              selectedToDate.day,
                              selectedToTime.hour,
                              selectedToTime.minute,
                            );

                            String selectedFromTimestamp = selectedFromDateTime
                                .millisecondsSinceEpoch
                                .toString();
                            String selectedToTimestamp = selectedToDateTime
                                .millisecondsSinceEpoch
                                .toString();
                            await deviceController.submitTollGuru({
                              'user_id': authController.storageUserData?['id'],
                              'device_id': dataController.currentDeviceId.value,
                              'from': selectedFromTimestamp,
                              'paymentMethod': paymentMethod,
                              'timeZone': 'America/Los_Angeles',
                              'to': selectedToTimestamp,
                              'trip': "null",
                            });
                            setState(() {
                              isSearching = false;
                            });
                            if (authController.apiStatus.value ==
                                ApiState.failure) {
                              Get.snackbar("Login Failed",
                                  authController.errorMessage.value,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  animationDuration:
                                      const Duration(milliseconds: 300));
                            } else if (authController.storageUserData != null) {
                              if (deviceController
                                      .submitTollGuruData.value['error'] !=
                                  null) {
                                Get.snackbar(
                                    deviceController
                                        .submitTollGuruData.value['error'],
                                    '',
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                    animationDuration:
                                        const Duration(milliseconds: 300));
                              }
                            }
                          })),
                  SizedBox(
                    width: 20 * dataController.currentScaleFactor.value,
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
        ));
  }
}
