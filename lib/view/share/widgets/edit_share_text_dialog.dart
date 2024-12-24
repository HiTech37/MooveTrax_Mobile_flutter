import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/di.dart';

import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';

class EditShareTextWidget extends StatefulWidget {
  const EditShareTextWidget(
      {super.key,
      required this.onChanged,
      required this.shareText,
      required this.deviceId});

  final ValueChanged onChanged;
  final int deviceId;
  final String shareText;

  @override
  State<EditShareTextWidget> createState() => _EditShareTextWidgetState();
}

class _EditShareTextWidgetState extends State<EditShareTextWidget> {
  final DataController dataController = Get.find<DataController>();
  final DeviceController deviceController = getIt<DeviceController>();
  bool updatingSharedText = false;
  final String defaultText =
      'You can use the following link to: \nLocate. \nHonk The Horn. \nUnlock.\n\nThis link will become active right before your trip starts \n\n[domain][url]';

  TextEditingController editShareTextController =
      TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    initdata();
  }

  void initdata() {
    if (!mounted) return;
    setState(() {
      editShareTextController.text =
          widget.shareText == '' ? defaultText : widget.shareText;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void initData() async {
    if (!mounted) return;
  }

  @override
  void dispose() {
    super.dispose();
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
        child: SizedBox(
            height: 500,
            child: Column(
              children: [
                Text(
                  'Edit Shared text',
                  style:
                      TextStyle(fontSize: dataController.appBarTitleSize.value),
                ),
                TextFormField(
                  controller: editShareTextController,
                  maxLines: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        editShareTextController.text = defaultText;
                        setState(() {});
                      },
                      child: const Text("RESET"),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          updatingSharedText = true;
                        });
                        await deviceController.updateSharedTextTemplate({
                          'device_id': widget.deviceId,
                          'sharedTextTemplate': editShareTextController.text
                        });
                        setState(() {
                          updatingSharedText = false;
                        });
                        if (deviceController.apiStatus.value ==
                            ApiState.success) {
                          widget.onChanged(editShareTextController.text);
                        }
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
                      child: Text(updatingSharedText ? "SAVING..." : "SAVE"),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text("CANCEL"),
                    ),
                  ],
                )
              ],
            )));
  }
}
