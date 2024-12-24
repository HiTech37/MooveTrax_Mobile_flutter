import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/common/widget/default_button.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/reports/controller/reports_controller.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

class InviteWidget extends StatefulWidget {
  const InviteWidget({
    super.key,
    required this.onChanged,
  });

  final ValueChanged onChanged;

  @override
  State<InviteWidget> createState() => _InviteWidgetState();
}

class _InviteWidgetState extends State<InviteWidget> {
  late TextEditingController _emailController;
  final DataController dataController = Get.find<DataController>();

  bool? checkedKillSwitch = true;
  List<dynamic> deviceList = [];
  final AuthController authController = getIt<AuthController>();
  final ReportsController reportsController = getIt<ReportsController>();

  final MultiSelectController<dynamic> _deviceSelectController =
      MultiSelectController();
  @override
  void dispose() {
    _emailController.dispose();
    _deviceSelectController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    await authController.getUserProfile();
    final dynamic userData = authController.profileData.value;
    if (userData != null) {
      final dynamic devices = userData['devices'] ?? [];
      deviceList.addAll(devices);
    }
    _emailController = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width > 400
            ? 400
            : MediaQuery.of(context).size.width,
        height: 280,
        padding: EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 10 * dataController.currentScaleFactor.value),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _emailController,
              style: TextStyle(fontSize: dataController.normalTextSize.value),
              decoration: const InputDecoration(hintText: "Email"),
            ),
            const SizedBox(height: 10),
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
              hintStyle:
                  TextStyle(fontSize: dataController.normalTextSize.value),
              options: deviceList.map<ValueItem<dynamic>>((dynamic value) {
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
              optionTextStyle:
                  TextStyle(fontSize: dataController.normalTextSize.value),
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
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                width: 200,
                child: CheckboxListTile(
                  value: checkedKillSwitch,
                  onChanged: (bool? value) {
                    setState(() {
                      checkedKillSwitch = value!;
                    });
                  },
                  title: Text(
                    'KillSwitch',
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(child: Obx(() {
                  return DefaultButton(
                      text:
                          reportsController.apiStatus.value == ApiState.loading
                              ? "ADDING..."
                              : "ADD",
                      press: () async {
                        if (_emailController.text == "") {
                          Get.snackbar("No Email ", "Please enter email",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              animationDuration:
                                  const Duration(milliseconds: 300));
                          return;
                        } else if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                            .hasMatch(_emailController.text)) {
                          Get.snackbar(
                              "Invalid Email ", "Please enter a valid email",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              animationDuration:
                                  const Duration(milliseconds: 300));
                          return;
                        }
                        if (_deviceSelectController.selectedOptions.isEmpty) {
                          Get.snackbar(
                              "No Devices selected", "Please select devices",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              animationDuration:
                                  const Duration(milliseconds: 300));
                          return;
                        } else {
                          for (int i = 0;
                              i <
                                  _deviceSelectController
                                      .selectedOptions.length;
                              i++) {
                            await reportsController.addCoHost({
                              'email': _emailController.text,
                              'kill_switch': checkedKillSwitch,
                              'owner_user_id':
                                  authController.storageUserData?['id'],
                              'deviceIds': _deviceSelectController
                                  .selectedOptions[i].value['id']
                                  .toString()
                            });
                            if (reportsController.apiStatus.value ==
                                ApiState.failure) {
                              Get.snackbar(
                                  "Adding Failed! DeviceId: ${_deviceSelectController.selectedOptions[i].value['id']}",
                                  reportsController.errorMessage.value,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                  animationDuration:
                                      const Duration(milliseconds: 300));
                            }
                          }
                        }
                        Get.back();
                      });
                })),
                const SizedBox(
                  width: 20,
                ),
                Flexible(
                    child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            padding: WidgetStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 20 *
                                        dataController.currentScaleFactor.value,
                                    vertical: 16 *
                                        dataController
                                            .currentScaleFactor.value))),
                        child: Text(
                          'CANCEL',
                          style: TextStyle(
                              fontSize: dataController.normalTextSize.value),
                        )))
              ],
            )
          ],
        ));
  }
}
