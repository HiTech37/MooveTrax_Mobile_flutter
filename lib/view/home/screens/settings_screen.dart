import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  final DataController dataController = Get.find<DataController>();
  final DeviceController deviceController = getIt<DeviceController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: dataController.appBarHeight.value,
        title: Text(
          "Settings",
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
                    Icon(Icons.person, size: dataController.iconSize.value),
                title: Text(
                  'Account',
                  style: TextStyle(
                    fontSize: dataController.titleTextSize.value,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Get.toNamed('/settings/account');
                },
              )),
              Card(
                  child: ListTile(
                leading: Icon(Icons.map, size: dataController.iconSize.value),
                title: Text(
                  'Geofences',
                  style: TextStyle(
                    fontSize: dataController.titleTextSize.value,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  dataController.setGeoFenceEditing(true);
                  dataController.changeTabIndex(0);
                },
              )),
              Card(
                  child: ListTile(
                leading: Icon(Icons.link, size: dataController.iconSize.value),
                title: Text(
                  'Share Links',
                  style: TextStyle(
                    fontSize: dataController.titleTextSize.value,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Get.toNamed('/settings/shared-links');
                },
              )),
              Card(
                  child: ListTile(
                leading:
                    Icon(Icons.car_rental, size: dataController.iconSize.value),
                title: Text(
                  'Turo Trips',
                  style: TextStyle(
                    fontSize: dataController.titleTextSize.value,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Get.toNamed('/settings/turo-trips');
                },
              )),
              Card(
                  child: ListTile(
                leading: Theme.of(context).brightness == Brightness.dark
                    ? Icon(Icons.dark_mode, size: dataController.iconSize.value)
                    : Icon(Icons.light_mode,
                        size: dataController.iconSize.value),
                title: Text(
                  Theme.of(context).brightness == Brightness.dark
                      ? 'Dark Mode'
                      : 'Light Mode',
                  style: TextStyle(
                    fontSize: dataController.titleTextSize.value,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  if (Theme.of(context).brightness == Brightness.dark) {
                    Get.changeThemeMode(ThemeMode.light);
                  } else {
                    Get.changeThemeMode(ThemeMode.dark);
                  }
                  // Add navigation logic for Account settings
                },
              )),
            ],
          )),
    );
  }
}
