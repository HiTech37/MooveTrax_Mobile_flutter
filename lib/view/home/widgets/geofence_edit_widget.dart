import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class GeoFenceEditWidget extends StatefulWidget {
  const GeoFenceEditWidget({
    super.key,
    required this.onChanged,
  });

  final ValueChanged onChanged;

  @override
  State<GeoFenceEditWidget> createState() => _GeoFenceEditWidgetState();
}

class _GeoFenceEditWidgetState extends State<GeoFenceEditWidget> {
  final DataController dataController = Get.find<DataController>();
  final DeviceController deviceController = getIt<DeviceController>();
  final AuthController authController = getIt<AuthController>();
  String defaultEnterSubject = '{{Car_Name}} has entered {{Fence_name}}';
  String defaultLeaveSubject = '{{Car_Name}} has left {{Fence_name}}';
  bool updatingGeoFenceData = false;
  bool postToTuro = false;
  List<dynamic> deviceList = [];

  dynamic selectedGeoFenceData;
  final MultiSelectController<dynamic> _deviceSelectController =
      MultiSelectController();

  TextEditingController geoFenceNameEditController =
      TextEditingController(text: '');
  TextEditingController geoFenceEnterNotifyEmailController =
      TextEditingController(text: '');
  TextEditingController geoFenceLeaveNotifyEmailController =
      TextEditingController(text: '');
  TextEditingController geoFenceEnterSubjectController =
      TextEditingController(text: '{{Car_Name}} has entered {{Fence_name}}');
  TextEditingController geoFenceLeaveSubjectController =
      TextEditingController(text: '{{Car_Name}} has left {{Fence_name}}');
  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    if (!mounted) return;
    await authController.getUserProfile();
    final dynamic userData = authController.profileData.value;

    if (userData != null) {
      final dynamic devices = userData['devices'] ?? [];
      deviceList.addAll(devices);
    }
    await deviceController
        .getGeoFenceById(dataController.selectedGeoFenceId.value);
    if (deviceController.apiStatus.value == ApiState.success) {
      selectedGeoFenceData = deviceController.selectedGeoFenceData.value;
      geoFenceNameEditController.text = selectedGeoFenceData['name'];
      _deviceSelectController.selectedOptions.clear();
      for (int i = 0; i < selectedGeoFenceData['deviceIds'].length; i++) {
        List<dynamic> device = deviceList
            .where((deviceData) =>
                deviceData['id'] == selectedGeoFenceData['deviceIds'][i])
            .toList();
        if (device.isNotEmpty) {
          _deviceSelectController.selectedOptions.add(ValueItem<dynamic>(
            label: device.first['name'],
            value: device.first,
          ));
        }
      }
      geoFenceEnterNotifyEmailController.text =
          selectedGeoFenceData['notify_email_enter'];
      geoFenceLeaveNotifyEmailController.text =
          selectedGeoFenceData['notify_email_leave'];
      if (selectedGeoFenceData['enter_subject'] != '') {
        geoFenceEnterSubjectController.text =
            selectedGeoFenceData['enter_subject'];
      }
      if (selectedGeoFenceData['leave_subject'] != '') {
        geoFenceLeaveSubjectController.text =
            selectedGeoFenceData['leave_subject'];
      }
      postToTuro = selectedGeoFenceData['post_turo'];
      if (!mounted) return;
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width > 400
            ? 400
            : MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(
            horizontal: 15 * dataController.currentScaleFactor.value,
            vertical: 20 * dataController.currentScaleFactor.value),
        child: selectedGeoFenceData == null
            ? const SizedBox(
                height: 500,
              )
            : SingleChildScrollView(
                child: SingleChildScrollView(
                child: Column(children: [
                  Text(
                    'Geofence Name',
                    style:
                        TextStyle(fontSize: dataController.titleTextSize.value),
                  ),
                  SizedBox(
                    height: 20 * dataController.currentScaleFactor.value,
                  ),
                  SizedBox(
                      height: 50 * dataController.currentScaleFactor.value,
                      child: TextField(
                        controller: geoFenceNameEditController,
                        enabled: true,
                        decoration: InputDecoration(
                            label: Text(
                              'Name',
                              style: TextStyle(
                                  fontSize:
                                      dataController.normalTextSize.value),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12 *
                                    dataController.currentScaleFactor.value,
                                horizontal: 8 *
                                    dataController.currentScaleFactor.value)),
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                        onChanged: (value) {},
                      )),
                  SizedBox(
                    height: 20 * dataController.currentScaleFactor.value,
                  ),
                  MultiSelectDropDown<dynamic>(
                    controller: _deviceSelectController,
                    fieldBackgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.black54
                            : const Color.fromARGB(255, 231, 227, 227),
                    clearIcon: const Icon(Icons.delete),
                    onOptionSelected: (options) {},
                    dropdownBackgroundColor:
                        Theme.of(context).brightness == Brightness.dark
                            ? Colors.black
                            : Colors.grey[200],
                    borderRadius: 5,
                    hintStyle: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                    options:
                        deviceList.map<ValueItem<dynamic>>((dynamic value) {
                      return ValueItem<dynamic>(
                        label: value['name'],
                        value: value,
                      );
                    }).toList(),
                    singleSelectItemStyle: TextStyle(
                        fontSize: dataController.normalTextSize.value,
                        fontWeight: FontWeight.bold),
                    chipConfig: const ChipConfig(
                        wrapType: WrapType.wrap, backgroundColor: Colors.green),
                    optionTextStyle: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                    selectedOptionIcon: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: dataController.iconSize.value,
                    ),
                    selectedOptionTextColor: Colors.blue,
                    dropdownMargin: 2,
                    onOptionRemoved: (index, option) {},
                    optionBuilder: (context, valueItem, isSelected) {
                      return ListTile(
                        title: Text(valueItem.label,
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value)),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle,
                                size: dataController.iconSize.value,
                              )
                            : Icon(
                                Icons.radio_button_unchecked,
                                size: dataController.iconSize.value,
                              ),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20 * dataController.currentScaleFactor.value,
                  ),
                  SizedBox(
                      height: 50 * dataController.currentScaleFactor.value,
                      child: TextField(
                        controller: geoFenceEnterNotifyEmailController,
                        enabled: true,
                        decoration: InputDecoration(
                            label: Text(
                              'Email address to notify if car enters fence.',
                              style: TextStyle(
                                  fontSize:
                                      dataController.normalTextSize.value),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12 *
                                    dataController.currentScaleFactor.value,
                                horizontal: 8 *
                                    dataController.currentScaleFactor.value)),
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                        onChanged: (value) {},
                      )),
                  SizedBox(
                    height: 20 * dataController.currentScaleFactor.value,
                  ),
                  SizedBox(
                      height: 50 * dataController.currentScaleFactor.value,
                      child: TextField(
                        controller: geoFenceEnterSubjectController,
                        enabled: true,
                        decoration: InputDecoration(
                            label: Text(
                              'Subject',
                              style: TextStyle(
                                  fontSize:
                                      dataController.normalTextSize.value),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12 *
                                    dataController.currentScaleFactor.value,
                                horizontal: 8 *
                                    dataController.currentScaleFactor.value)),
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                        onChanged: (value) {},
                      )),
                  SizedBox(
                    height: 20 * dataController.currentScaleFactor.value,
                  ),
                  SizedBox(
                      height: 50 * dataController.currentScaleFactor.value,
                      child: TextField(
                        controller: geoFenceLeaveNotifyEmailController,
                        enabled: true,
                        decoration: InputDecoration(
                            label: Text(
                              'Email address to notify if car leave fence.',
                              style: TextStyle(
                                  fontSize:
                                      dataController.normalTextSize.value),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12 *
                                    dataController.currentScaleFactor.value,
                                horizontal: 8 *
                                    dataController.currentScaleFactor.value)),
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                        onChanged: (value) {},
                      )),
                  SizedBox(
                    height: 20 * dataController.currentScaleFactor.value,
                  ),
                  SizedBox(
                      height: 50 * dataController.currentScaleFactor.value,
                      child: TextField(
                        controller: geoFenceLeaveSubjectController,
                        enabled: true,
                        decoration: InputDecoration(
                            label: Text(
                              'Subject',
                              style: TextStyle(
                                  fontSize:
                                      dataController.normalTextSize.value),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12 *
                                    dataController.currentScaleFactor.value,
                                horizontal: 8 *
                                    dataController.currentScaleFactor.value)),
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                        onChanged: (value) {},
                      )),
                  Row(children: [
                    SizedBox(
                        height: 30 * dataController.currentScaleFactor.value,
                        width: 40 * dataController.currentScaleFactor.value,
                        child: Checkbox(
                            value: postToTuro,
                            onChanged: (value) {
                              setState(() {
                                postToTuro = value!;
                              });
                            })),
                    GestureDetector(
                        onTap: () {
                          setState(() {
                            postToTuro = !postToTuro;
                          });
                        },
                        child: Text(
                          "Post To Turo",
                          style: TextStyle(
                              fontSize: dataController.normalTextSize.value),
                        ))
                  ]),
                  SizedBox(
                    height: 40 * dataController.currentScaleFactor.value,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: OutlinedButton(
                        onPressed: () async {
                          Get.back();
                        },
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  0), // Set the border radius to 0 for a rectangular shape
                            ),
                            side: const BorderSide(
                                color: Color.fromARGB(255, 108, 93, 245)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5)),
                        child: Text(
                          'CANCEL',
                          style: TextStyle(
                              fontSize: dataController.normalTextSize.value,
                              color: const Color.fromARGB(255, 108, 93, 245)),
                        ),
                      )),
                      SizedBox(
                        width: 20 * dataController.currentScaleFactor.value,
                      ),
                      Expanded(
                          child: OutlinedButton(
                        onPressed: () async {
                          selectedGeoFenceData['name'] =
                              geoFenceNameEditController.text;
                          selectedGeoFenceData['post_turo'] = postToTuro;
                          selectedGeoFenceData['notify_email_enter'] =
                              geoFenceEnterNotifyEmailController.text;
                          selectedGeoFenceData['notify_email_leave'] =
                              geoFenceLeaveNotifyEmailController.text;
                          selectedGeoFenceData['leave_subject'] =
                              geoFenceLeaveSubjectController.text;
                          selectedGeoFenceData['enter_subject'] =
                              geoFenceEnterSubjectController.text;
                          if (_deviceSelectController.selectedOptions.isEmpty) {
                            selectedGeoFenceData['deviceIds'] = [];
                          }
                          for (int i = 0;
                              i <
                                  _deviceSelectController
                                      .selectedOptions.length;
                              i++) {
                            selectedGeoFenceData['deviceIds'].add(
                                _deviceSelectController
                                    .selectedOptions[i].value['id']);
                          }
                          setState(() {
                            updatingGeoFenceData = true;
                          });
                          await deviceController.updateSelectedGeoFenceById(
                              dataController.selectedGeoFenceId.value,
                              selectedGeoFenceData);
                          setState(() {
                            updatingGeoFenceData = false;
                          });
                          widget.onChanged(true);
                        },
                        style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.green),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  0), // Set the border radius to 0 for a rectangular shape
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5)),
                        child: Text(
                          updatingGeoFenceData ? "SAVING..." : 'SAVE',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: dataController.normalTextSize.value,
                          ),
                        ),
                      ))
                    ],
                  ),
                ]),
              )));
  }
}
