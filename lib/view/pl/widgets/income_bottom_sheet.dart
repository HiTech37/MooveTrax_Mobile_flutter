// play_bottomsheet.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moovetrax/common/widget/default_button.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';

class AddIncomeBottomSheet extends StatefulWidget {
  const AddIncomeBottomSheet({super.key});

  @override
  AddIncomeBottomSheetState createState() => AddIncomeBottomSheetState();
}

class AddIncomeBottomSheetState extends State<AddIncomeBottomSheet> {
  final DataController dataController = Get.find<DataController>();
  final DeviceController deviceController = getIt<DeviceController>();
  String note = "";
  String tripId = "";
  String amount = "";
  String plDate = "";
  bool savingPlData = false;

  DateTime selectedDate = DateTime.now();

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void saveExpenseData() async {
    setState(() {
      savingPlData = true;
    });
    if (amount == '') {
      Get.snackbar("Valdiation Error", "Amount is empty",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          animationDuration: const Duration(milliseconds: 300));
    }
    await deviceController.addPlItem({
      'type': 'income',
      'deviceId': dataController.currentDeviceId.value,
      'plDate': DateFormat('yyyy-MM-dd').format(selectedDate).toString(),
      'amount': amount,
      'tripId': tripId
    });
    setState(() {
      savingPlData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height / 2,
        padding: EdgeInsets.all(10 * dataController.currentScaleFactor.value),
        child: SingleChildScrollView(
            child: Column(
          children: [
            SizedBox(
              height: 20 * dataController.currentScaleFactor.value,
            ),
            SizedBox(
              height: 50 * dataController.currentScaleFactor.value,
              child: InkWell(
                  onTap: () => selectDate(context),
                  child: Container(
                    width: double.infinity,
                    height: 50 * dataController.currentScaleFactor.value,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey),
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          DateFormat('MM/dd/yyyy')
                              .format(selectedDate)
                              .toString(),
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: dataController.normalTextSize.value),
                        )),
                  )),
            ),
            SizedBox(
              height: 10 * dataController.currentScaleFactor.value,
            ),
            SizedBox(
                height: 50 * dataController.currentScaleFactor.value,
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      tripId = value;
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical:
                              12 * dataController.currentScaleFactor.value,
                          horizontal:
                              8 * dataController.currentScaleFactor.value),
                      label: Text(
                        'Trip',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      labelStyle: TextStyle(
                          fontSize: dataController.normalTextSize.value)),
                )),
            SizedBox(
              height: 10 * dataController.currentScaleFactor.value,
            ),
            SizedBox(
                height: 50 * dataController.currentScaleFactor.value,
                child: TextField(
                  onChanged: (value) {
                    amount = value;
                  },
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical:
                              12 * dataController.currentScaleFactor.value,
                          horizontal:
                              8 * dataController.currentScaleFactor.value),
                      label: Text(
                        'Amount',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      labelStyle: TextStyle(
                          fontSize: dataController.normalTextSize.value)),
                )),
            SizedBox(
              height: 10 * dataController.currentScaleFactor.value,
            ),
            SizedBox(
                height: 50 * dataController.currentScaleFactor.value,
                child: TextField(
                  onChanged: (value) {
                    note = value;
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          vertical:
                              12 * dataController.currentScaleFactor.value,
                          horizontal:
                              8 * dataController.currentScaleFactor.value),
                      label: Text(
                        'Notes',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      labelStyle: TextStyle(
                          fontSize: dataController.normalTextSize.value)),
                )),
            SizedBox(
              height: 10 * dataController.currentScaleFactor.value,
            ),
            DefaultButton(
                text: savingPlData ? "ADDING" : "ADD",
                press: () {
                  saveExpenseData();
                })
          ],
        )));
  }
}
