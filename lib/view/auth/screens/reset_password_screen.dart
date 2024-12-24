import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/common/widget/default_button.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ResetPasswordScreenState createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String email = '';
  final _formKey = GlobalKey<FormState>();
  final AuthController authController = getIt<AuthController>();
  final DataController dataController = Get.find<DataController>();

  Widget entryField(String title) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15 * dataController.currentScaleFactor.value),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            style: TextStyle(fontSize: dataController.normalTextSize.value),
            onChanged: (text) => setState(() => email = text),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'Can\'t be empty';
              }
              if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$")
                  .hasMatch(text)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: dataController.bottomAppBarHeight.value,
          title: Text(
            "Reset Password",
            style: TextStyle(fontSize: dataController.appBarTitleSize.value),
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                Get.offAllNamed('/login');
              },
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: dataController.iconSize.value,
              )),
        ),
        body: SizedBox(
          height: height,
          child: Stack(
            children: <Widget>[
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: height * .15),
                          Image.asset(
                            "asset/images/logo.png",
                            height:
                                80 * dataController.currentScaleFactor.value,
                          ),
                          SizedBox(
                              height:
                                  50 * dataController.currentScaleFactor.value),
                          entryField("Email *"),
                          SizedBox(
                              height:
                                  30 * dataController.currentScaleFactor.value),
                          Obx(() {
                            return DefaultButton(
                                text: authController.apiStatus.value ==
                                        ApiState.loading
                                    ? "SENDING..."
                                    : "RESET PASSWORD",
                                press: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await authController.resetPassword({
                                      'email': email,
                                    });
                                    if (authController.apiStatus.value ==
                                        ApiState.failure) {
                                      Get.snackbar("Request Failed",
                                          authController.errorMessage.value,
                                          backgroundColor: Colors.red,
                                          colorText: Colors.white,
                                          animationDuration: const Duration(
                                              milliseconds: 300));
                                    } else {
                                      Get.snackbar("Request Success",
                                          'Your password reset link has been sent. Please check your email.',
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white,
                                          animationDuration: const Duration(
                                              milliseconds: 300));
                                    }
                                  }
                                });
                          }),
                          const SizedBox(height: 20),
                          SizedBox(height: height * .055),
                        ],
                      ),
                    ),
                  )),
            ],
          ),
        ));
  }
}
