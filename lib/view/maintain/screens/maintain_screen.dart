import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/common/widget/default_button.dart';
import 'package:moovetrax/common/widget/youtube_player.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/view/maintain/widgets/maintain_card.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';

class MaintainScreen extends StatefulWidget {
  const MaintainScreen({super.key});

  @override
  MaintainScreenState createState() => MaintainScreenState();
}

class MaintainScreenState extends State<MaintainScreen> {
  String howToVideoId = "IgjoIAFUMMs";
  final DeviceController deviceController = getIt<DeviceController>();
  final AuthController authController = getIt<AuthController>();
  final DataController dataController = Get.find<DataController>();
  List<dynamic> maintainItemList = [];
  TextEditingController odometerTextController =
      TextEditingController(text: '');
  TextEditingController notifiationTextController =
      TextEditingController(text: '');
  dynamic deviceData;
  bool updateingMaintainData = false;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    odometerTextController.dispose();
    notifiationTextController.dispose();
    super.dispose();
  }

  void initData() async {
    if (!mounted) return;
    await deviceController
        .getDeviceMaintainData(dataController.currentDeviceId.value);

    await deviceController.getTollGuruPageData({
      'user_id': authController.storageUserData?['id'],
      'device_id': dataController.currentDeviceId.value
    });
    if (deviceController.selectedDeviceMaintainData.value != null) {
      if (!mounted) return;
      setState(() {
        deviceData =
            deviceController.selectedDeviceMaintainData.value['device'];
        maintainItemList =
            deviceController.selectedDeviceMaintainData.value['maintItemList'];
        odometerTextController.text = deviceData['odometer'].toString();
        notifiationTextController.text = deviceController
            .selectedDeviceMaintainData
            .value['device']['maint_notification_email'];
      });
    }
  }

  void showAddMaintenaunceDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => Dialog(
            insetPadding:
                EdgeInsets.all(10 * dataController.currentScaleFactor.value),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        height: 50 * dataController.currentScaleFactor.value,
                        child: TextField(
                            enabled: true,
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value),
                            decoration: InputDecoration(
                                label: Text(
                                  'title',
                                  style: TextStyle(
                                      fontSize:
                                          dataController.normalTextSize.value),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12 *
                                        dataController.currentScaleFactor.value,
                                    horizontal: 8 *
                                        dataController
                                            .currentScaleFactor.value)))),
                    SizedBox(
                      height: 20 * dataController.currentScaleFactor.value,
                    ),
                    Text(
                      'Next Serice',
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                    SizedBox(
                      height: 10 * dataController.currentScaleFactor.value,
                    ),
                    SizedBox(
                        height: 50 * dataController.currentScaleFactor.value,
                        child: Row(
                          children: [
                            Flexible(
                              child: TextField(
                                  decoration: InputDecoration(
                                      label: Text('Date',
                                          style: TextStyle(
                                              fontSize: dataController
                                                  .normalTextSize.value)),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 12 *
                                              dataController
                                                  .currentScaleFactor.value,
                                          horizontal: 8 *
                                              dataController
                                                  .currentScaleFactor.value))),
                            ),
                            SizedBox(
                              width:
                                  10 * dataController.currentScaleFactor.value,
                            ),
                            Flexible(
                              child: TextField(
                                  decoration: InputDecoration(
                                      label: Text(
                                        'Miles',
                                        style: TextStyle(
                                            fontSize: dataController
                                                .normalTextSize.value),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 12 *
                                              dataController
                                                  .currentScaleFactor.value,
                                          horizontal: 8 *
                                              dataController
                                                  .currentScaleFactor.value))),
                            ),
                          ],
                        )),
                    SizedBox(
                      height: 20 * dataController.currentScaleFactor.value,
                    ),
                    SizedBox(
                      height: 50 * dataController.currentScaleFactor.value,
                      child: Row(
                        children: [
                          Expanded(
                              child: TextField(
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12 *
                                        dataController.currentScaleFactor.value,
                                    horizontal: 8 *
                                        dataController
                                            .currentScaleFactor.value),
                                label: Text(
                                  'Note',
                                  style: TextStyle(
                                      fontSize:
                                          dataController.normalTextSize.value),
                                )),
                          )),
                          const SizedBox(
                            width: 10,
                          ),
                          Flexible(
                              child: DefaultButton(text: "ADD", press: () {}))
                        ],
                      ),
                    )
                  ],
                )))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: dataController.appBarHeight.value,
        title: Text(
          "Maintain",
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
      body: Container(
        height: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(
          children: [
            MediaQuery.of(context).size.width > 450
                ? Row(
                    children: [
                      SizedBox(
                          width: 100 * dataController.currentScaleFactor.value,
                          child: DefaultButton(
                              text: "ADD",
                              press: () {
                                showAddMaintenaunceDialog(context);
                              })),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return YouTubePlayerDialog(
                                    videoId: howToVideoId);
                              });
                        },
                        child: Text(
                          'How to Video',
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: dataController.titleTextSize.value),
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                          width: 100 * dataController.currentScaleFactor.value,
                          child: TextField(
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*$')),
                            ],
                            onChanged: (value) {
                              deviceData['odometer'] = value;
                            },
                            decoration: InputDecoration(
                                label: Text('Odometer',
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value))),
                            controller: odometerTextController,
                          ))
                    ],
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 0),
                        child: Row(
                          children: [
                            SizedBox(
                                width: 100 *
                                    dataController.currentScaleFactor.value,
                                child: DefaultButton(
                                    text: "ADD",
                                    press: () {
                                      showAddMaintenaunceDialog(context);
                                    })),
                            SizedBox(
                              width:
                                  10 * dataController.currentScaleFactor.value,
                            ),
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return YouTubePlayerDialog(
                                          videoId: howToVideoId);
                                    });
                              },
                              child: Text(
                                'How to Video',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize:
                                        dataController.titleTextSize.value),
                              ),
                            ),
                            SizedBox(
                              width:
                                  10 * dataController.currentScaleFactor.value,
                            ),
                            SizedBox(
                                width: 100 *
                                    dataController.currentScaleFactor.value,
                                height: 50 *
                                    dataController.currentScaleFactor.value,
                                child: TextField(
                                  style: TextStyle(
                                      fontSize:
                                          dataController.titleTextSize.value),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                          decimal: true),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^\d*\.?\d*$')),
                                  ],
                                  onChanged: (value) {
                                    deviceData['odometer'] = value;
                                  },
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 12 *
                                              dataController
                                                  .currentScaleFactor.value,
                                          horizontal: 8 *
                                              dataController
                                                  .currentScaleFactor.value),
                                      label: Text(
                                        'Odometer',
                                        style: TextStyle(
                                            fontSize: dataController
                                                .titleTextSize.value),
                                      )),
                                  controller: odometerTextController,
                                ))
                          ],
                        ))),
            SizedBox(
              height: 10 * dataController.currentScaleFactor.value,
            ),
            Row(
              children: [
                Text(
                  'Notification',
                  style:
                      TextStyle(fontSize: dataController.normalTextSize.value),
                ),
                const Spacer()
              ],
            ),
            SizedBox(
                height: 50 * dataController.currentScaleFactor.value,
                child: TextField(
                  controller: notifiationTextController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical:
                              12 * dataController.currentScaleFactor.value,
                          horizontal:
                              8 * dataController.currentScaleFactor.value)),
                  style:
                      TextStyle(fontSize: dataController.normalTextSize.value),
                )),
            SizedBox(
              height: 20 * dataController.currentScaleFactor.value,
            ),
            if (maintainItemList.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                    child: Column(
                  children: List.generate(maintainItemList.length, (index) {
                    final data = maintainItemList[index];
                    return MaintainCardWidget(
                      onChanged: (newValue) {
                        setState(() {
                          maintainItemList[index] = newValue;
                        });
                      },
                      deleteClicked: (value) {
                        if (value == true) {
                          setState(() {
                            maintainItemList.removeAt(index);
                          });
                        }
                      },
                      data: data,
                    );
                  }),
                )),
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        mini: dataController.currentScaleFactor < 1,
        onPressed: () async {
          setState(() {
            updateingMaintainData = true;
          });
          await deviceController
              .updateDeviceMaintainData(dataController.currentDeviceId.value, {
            'maint_charge_enabled': deviceData['maint_charge_enabled'],
            'maint_item_list': maintainItemList,
            'maint_notification_email': notifiationTextController.text,
            'maint_odometer': double.parse(odometerTextController.text)
          });
          if (deviceController.apiStatus.value == ApiState.failure) {
            Get.snackbar("Updating Failed", deviceController.errorMessage.value,
                backgroundColor: Colors.red,
                colorText: Colors.white,
                animationDuration: const Duration(milliseconds: 300));
            initData();
          } else {
            Get.snackbar("Updating Success", "Data updated successfully!",
                backgroundColor: Colors.green,
                colorText: Colors.white,
                animationDuration: const Duration(milliseconds: 300));
          }
          setState(() {
            updateingMaintainData = false;
          });
        },
        child: updateingMaintainData
            ? SizedBox(
                width: 30 * dataController.currentScaleFactor.value,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                ))
            : Icon(
                Icons.save,
                size: 30 * dataController.currentScaleFactor.value,
                color: Colors.white,
              ),
      ),
    );
  }
}
