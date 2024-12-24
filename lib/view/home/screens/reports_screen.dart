import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  ReportsScreenState createState() => ReportsScreenState();
}

class ReportsScreenState extends State<ReportsScreen> {
  final DataController dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: dataController.appBarHeight.value,
        title: Text(
          "Reports",
          style: TextStyle(fontSize: dataController.appBarTitleSize.value),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: ListView(
            children: [
              Card(
                  child: ListTile(
                leading:
                    Icon(Icons.view_week, size: dataController.iconSize.value),
                title: Text(
                  'Commands',
                  style: TextStyle(
                    fontSize: dataController.titleTextSize.value,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Get.toNamed('/reports/commands');
                },
              )),
              Card(
                  child: ListTile(
                leading: Icon(Icons.notifications_active,
                    size: dataController.iconSize.value),
                title: Text(
                  'Events',
                  style: TextStyle(
                    fontSize: dataController.titleTextSize.value,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Get.toNamed('/reports/events');
                },
              )),
              Card(
                  child: ListTile(
                leading:
                    Icon(Icons.av_timer, size: dataController.iconSize.value),
                title: Text(
                  'Daily Mileage',
                  style: TextStyle(
                    fontSize: dataController.titleTextSize.value,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Get.toNamed('/reports/daily-mileage');
                },
              )),
            ],
          )),
    );
  }
}
