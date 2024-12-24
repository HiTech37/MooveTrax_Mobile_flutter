import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/core/common.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/view/pl/widgets/expense_bottom_sheet.dart';
import 'package:moovetrax/view/pl/widgets/income_bottom_sheet.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';

class PLScreen extends StatefulWidget {
  const PLScreen({super.key});

  @override
  PLScreenState createState() => PLScreenState();
}

class PLScreenState extends State<PLScreen> {
  final DeviceController deviceController = getIt<DeviceController>();
  final DataController dataController = Get.find<DataController>();

  dynamic deviceData;
  dynamic devicePLData;

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void showAddExpenseBottomSheetModal(context) {
    showModalBottomSheet(
      constraints: const BoxConstraints(maxWidth: double.infinity),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: const AddExpenseBottomSheet());
      },
    ).then((value) => initData());
  }

  void showAddIncomeBottomsheetModal(context) {
    showModalBottomSheet(
      constraints: const BoxConstraints(maxWidth: double.infinity),
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: const AddIncomeBottomSheet());
      },
    ).then((value) => {initData()});
  }

  void initData() async {
    if (!mounted) return;
    await deviceController
        .getPlData({"deviceId": dataController.currentDeviceId.value});
    if (deviceController.apiStatus.value == ApiState.success) {
      if (!mounted) return;
      setState(() {
        deviceData = deviceController.selectedDevicePlData.value['device'];
        devicePLData = deviceController.selectedDevicePlData.value['plData'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          toolbarHeight: dataController.appBarHeight.value,
          title: Text(
            deviceData != null ? "P&L-${deviceData['name']}" : "P&L",
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
          bottom: TabBar(
            padding: const EdgeInsets.all(0),
            labelPadding: const EdgeInsets.all(0),
            labelColor: Colors.white,
            labelStyle:
                TextStyle(fontSize: dataController.normalTextSize.value),
            unselectedLabelColor: Colors.white54,
            tabs: const [
              Tab(
                text: 'Income',
              ),
              Tab(text: 'Expense'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // First tab content
            devicePLData != null && devicePLData['incomeList'].length != 0
                ? SingleChildScrollView(
                    child: Column(
                    children: List.generate(devicePLData['incomeList'].length,
                        (index) {
                      final incomeData = devicePLData['incomeList'][index];
                      return Container(
                          margin: EdgeInsets.all(
                              10 * dataController.currentScaleFactor.value),
                          padding: EdgeInsets.all(
                              5 * dataController.currentScaleFactor.value),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Date',
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                  Text(
                                    'Trip',
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                      child: Container(
                                          width: double.infinity,
                                          height: 50 *
                                              dataController
                                                  .currentScaleFactor.value,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.blueGrey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text(
                                            dateFormat1(incomeData['plDate']),
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value),
                                          ))),
                                  SizedBox(
                                    width: 10 *
                                        dataController.currentScaleFactor.value,
                                  ),
                                  Flexible(
                                      child: Container(
                                          width: double.infinity,
                                          height: 50 *
                                              dataController
                                                  .currentScaleFactor.value,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.blueGrey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text(
                                            incomeData['tripId'],
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value),
                                          ))),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Amount',
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                  Text(
                                    'Notes',
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                      child: Container(
                                          width: double.infinity,
                                          height: 50 *
                                              dataController
                                                  .currentScaleFactor.value,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.blueGrey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text(
                                            incomeData['amount'],
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value),
                                          ))),
                                  SizedBox(
                                    width: 10 *
                                        dataController.currentScaleFactor.value,
                                  ),
                                  Flexible(
                                      child: Container(
                                          width: double.infinity,
                                          height: 50 *
                                              dataController
                                                  .currentScaleFactor.value,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.blueGrey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text(
                                            incomeData['note'] ?? '',
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value),
                                          ))),
                                ],
                              ),
                            ],
                          ));
                    }),
                  ))
                : Center(
                    child: Text(
                      "No Data",
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                  ),
            // Second tab content
            devicePLData != null && devicePLData['expenseList'].length != 0
                ? SingleChildScrollView(
                    child: Column(
                    children: List.generate(devicePLData['expenseList'].length,
                        (index) {
                      final expenseData = devicePLData['expenseList'][index];
                      return Container(
                          margin: EdgeInsets.all(
                              10 * dataController.currentScaleFactor.value),
                          padding: EdgeInsets.all(
                              5 * dataController.currentScaleFactor.value),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5)),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Date',
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                  Text(
                                    'Trip',
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                      child: Container(
                                          width: double.infinity,
                                          height: 50 *
                                              dataController
                                                  .currentScaleFactor.value,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.blueGrey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text(
                                            dateFormat1(expenseData['plDate']),
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value),
                                          ))),
                                  SizedBox(
                                    width: 10 *
                                        dataController.currentScaleFactor.value,
                                  ),
                                  Flexible(
                                      child: Container(
                                          width: double.infinity,
                                          height: 50 *
                                              dataController
                                                  .currentScaleFactor.value,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.blueGrey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text(
                                            expenseData['tripId'],
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value),
                                          ))),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Amount',
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                  Text(
                                    'Notes',
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Flexible(
                                      child: Container(
                                          width: double.infinity,
                                          height: 50 *
                                              dataController
                                                  .currentScaleFactor.value,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.blueGrey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text(
                                            expenseData['amount'],
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value),
                                          ))),
                                  SizedBox(
                                    width: 10 *
                                        dataController.currentScaleFactor.value,
                                  ),
                                  Flexible(
                                      child: Container(
                                          width: double.infinity,
                                          height: 50 *
                                              dataController
                                                  .currentScaleFactor.value,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.blueGrey),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Text(
                                            expenseData['note'] ?? '',
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value),
                                          ))),
                                ],
                              ),
                            ],
                          ));
                    }),
                  ))
                : Center(
                    child: Text(
                      "No Data",
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
