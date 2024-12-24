import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';

class DefaultBottomNavigationBar extends StatefulWidget {
  const DefaultBottomNavigationBar({
    super.key,
  });
  @override
  DefaultBottomNavigationBarState createState() =>
      DefaultBottomNavigationBarState();
}

class DefaultBottomNavigationBarState
    extends State<DefaultBottomNavigationBar> {
  final AuthController authController = getIt<AuthController>();

  @override
  Widget build(BuildContext context) {
    DataController controller = Get.put(DataController());
    return Obx(() => BottomNavigationBar(
          unselectedLabelStyle:
              TextStyle(fontSize: controller.normalTextSize.value),
          selectedLabelStyle:
              TextStyle(fontSize: controller.normalTextSize.value),
          currentIndex: controller.currentIndex.value,
          onTap: (index) async {
            switch (index) {
              case 0:
                if (authController.storageUserData == null) {
                  Get.offAllNamed('/login');
                } else {
                  controller.changeTabIndex(0);
                  controller.setGeoFenceEditing(false);
                }
                break;
              case 1:
                if (authController.storageUserData == null) {
                  Get.offAllNamed('/login');
                } else {
                  controller.changeTabIndex(0);
                  controller.setGeoFenceEditing(false);
                  controller.setShowPlayPositionsHistory(true);
                }
                break;
              case 2:
                if (authController.storageUserData == null) {
                  Get.offAllNamed('/login');
                } else {
                  controller.changeTabIndex(2);
                }
                break;
              case 3:
                if (authController.storageUserData == null) {
                  Get.offAllNamed('/login');
                } else {
                  controller.changeTabIndex(3);
                }
                break;
              case 4:
                await authController.logOut();
                if (authController.apiStatus.value == ApiState.success) {
                  Get.offAllNamed('/login');
                } else {
                  Get.snackbar(
                      "Logout Failled", authController.errorMessage.value,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      animationDuration: const Duration(milliseconds: 300));
                }

                break;

              default:
                if (authController.storageUserData == null) {
                  Get.offAllNamed('/login');
                } else {
                  Get.toNamed('/home');
                }
                break;
            }
          },
          items: [
            BottomNavigationBarItem(
              icon:
                  Icon(Icons.location_history, size: controller.iconSize.value),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_outline,
                  size: controller.iconSize.value),
              label: 'Playback',
            ),
            BottomNavigationBarItem(
              icon:
                  Icon(Icons.document_scanner, size: controller.iconSize.value),
              label: 'Reports',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings, size: controller.iconSize.value),
              label: 'Settings',
            ),
            BottomNavigationBarItem(
              icon:
                  Icon(Icons.logout_outlined, size: controller.iconSize.value),
              label: 'Logout',
            ),
          ],
        ));
  }
}
