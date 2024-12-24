import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/widget/bottom_navigation_bar.dart';
import 'package:moovetrax/core/common.dart';
import 'package:moovetrax/view/home/screens/map_screen.dart';
import 'package:moovetrax/view/home/screens/reports_screen.dart';
import 'package:moovetrax/view/home/screens/settings_screen.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final DataController controller = Get.put(DataController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Obx(() => IndexedStack(
              index: bottomMenuIndex(controller.currentIndex.value),
              children: const [
                MapScreen(),
                ReportsScreen(),
                SettingsScreen(),
              ],
            )),
        bottomNavigationBar: Obx(() => SizedBox(
            child: controller.showPlayPositionsHistory.value
                ? null
                : const DefaultBottomNavigationBar())));
  }
}
