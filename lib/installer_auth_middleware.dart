import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';

class InstallerAuthMiddleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final AuthController authController = getIt<AuthController>();

    // Replace with your own logic
    bool isLoggedIn = false; // Assume this is fetched from some auth service
    if (authController.installerKey != null &&
        authController.installerKey != '') {
      isLoggedIn = true;
    }
    if (!isLoggedIn && route != '/login') {
      return const RouteSettings(name: '/login');
    }
    return null; // No redirect
  }
}
