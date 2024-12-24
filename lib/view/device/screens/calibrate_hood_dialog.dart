import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/di.dart';

import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';

class CalibrateHoodDialog extends StatefulWidget {
  const CalibrateHoodDialog({
    super.key,
    required this.onChanged,
  });

  final ValueChanged onChanged;

  @override
  State<CalibrateHoodDialog> createState() => _CalibrateHoodDialogState();
}

class _CalibrateHoodDialogState extends State<CalibrateHoodDialog> {
  final DataController dataController = Get.find<DataController>();
  final DeviceController deviceController = getIt<DeviceController>();
  String calibrateDoorVolt = '';
  @override
  void initState() {
    super.initState();
    initdata();
  }

  void initdata() async {
    if (!mounted) return;
    await deviceController
        .getSelectedDeviceData(dataController.currentDeviceId.value);
    if (deviceController.apiStatus.value == ApiState.success) {
      setState(() {
        calibrateDoorVolt =
            deviceController.selectedDeviceData.value['mt2v_hood_volt'] ??
                '0.0';
        calibrateDoorVolt = '${calibrateDoorVolt}V';
      });
    } else {
      Get.snackbar("Failed", deviceController.errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          animationDuration: const Duration(milliseconds: 300));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
        height: 200 * dataController.currentScaleFactor.value,
        padding: EdgeInsets.symmetric(
            horizontal: 15 * dataController.currentScaleFactor.value,
            vertical: 20 * dataController.currentScaleFactor.value),
        child: SizedBox(
            height: 500,
            child: Column(
              children: [
                Text(
                  'MooveTrax',
                  style: TextStyle(
                      fontSize: dataController.appBarTitleSize.value,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10 * dataController.currentScaleFactor.value,
                ),
                Text(
                  'Has the Hood been open for 5 or more minutes?',
                  style:
                      TextStyle(fontSize: dataController.normalTextSize.value),
                ),
                SizedBox(
                  height: 10 * dataController.currentScaleFactor.value,
                ),
                Text(
                  calibrateDoorVolt,
                  style: TextStyle(
                      fontSize: dataController.appBarTitleSize.value,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () async {
                        await deviceController.setDeviceVoltage({
                          'device_id': dataController.currentDeviceId.value,
                          'type': 'hood_voltage'
                        });
                        if (deviceController.apiStatus.value ==
                            ApiState.success) {
                          Get.snackbar(
                              "MooveTrax", "Hood Pin has been calibrated",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                              animationDuration:
                                  const Duration(milliseconds: 300));
                        }
                      },
                      child: const Text("YES"),
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
