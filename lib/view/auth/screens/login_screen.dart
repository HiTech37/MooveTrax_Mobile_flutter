import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/common/widget/default_button.dart';
import 'package:moovetrax/core/api_config.dart';
import 'package:moovetrax/core/app_style.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String mToken = '';
  final AuthController authController = getIt<AuthController>();
  TextEditingController gpsIdEditController = TextEditingController(text: '');
  final DataController dataController = Get.find<DataController>();
  @override
  void dispose() {
    gpsIdEditController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mToken = token!;
        gpsIdEditController.text = token;
      });
    });
  }

  Widget emailField() {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 10 * dataController.currentScaleFactor.value),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // TextField(
          //     readOnly: true,
          //     controller: gpsIdEditController,
          //     style: TextStyle(fontSize: dataController.normalTextSize.value),
          //     decoration: InputDecoration(
          //       labelText: 'PUSH TOKEN',
          //       labelStyle:
          //           TextStyle(fontSize: dataController.normalTextSize.value),
          //     )),
          Text(
            "Email *",
            style: TextStyle(
                fontSize: 15 * dataController.currentScaleFactor.value),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            autofillHints: const [AutofillHints.email],
            onChanged: (text) => setState(() => email = text),
            style: TextStyle(fontSize: dataController.normalTextSize.value),
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

  Widget passwordField() {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 10 * dataController.currentScaleFactor.value),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Password *",
            style: TextStyle(
                fontSize: 15 * dataController.currentScaleFactor.value),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            obscureText: true,
            autofillHints: const [AutofillHints.password],
            style: TextStyle(fontSize: dataController.normalTextSize.value),
            onChanged: (text) => setState(() => password = text),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'Can\'t be empty';
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
        body: SizedBox(
      height: height,
      child: Stack(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .15),
                      Image.asset(
                        "asset/images/logo.png",
                        height: 80 * dataController.currentScaleFactor.value,
                      ),
                      SizedBox(
                          height: 50 * dataController.currentScaleFactor.value),
                      AutofillGroup(
                          child: Column(
                        children: [
                          emailField(),
                          passwordField(),
                        ],
                      )),
                      SizedBox(
                          height: 30 * dataController.currentScaleFactor.value),
                      Obx(() {
                        return DefaultButton(
                          text:
                              authController.apiStatus.value == ApiState.loading
                                  ? "LOGGING IN..."
                                  : "LOGIN",
                          press: () async {
                            if (_formKey.currentState!.validate()) {
                              dataController.changeTabIndex(0);
                              await authController.login({
                                'email': email,
                                'password': password,
                                'push_token': mToken
                              });
                              if (authController.apiStatus.value ==
                                  ApiState.failure) {
                                Get.snackbar("Login Failed",
                                    authController.errorMessage.value,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    animationDuration:
                                        const Duration(milliseconds: 300));
                              } else if (authController.storageUserData !=
                                  null) {
                                dataController.changeTabIndex(0);
                                Get.offAllNamed('/home');
                              }
                            }
                          },
                        );
                      }),
                      SizedBox(
                          height: 20 * dataController.currentScaleFactor.value),
                      InkWell(
                          onTap: () {
                            Get.toNamed('/reset-password');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            alignment: Alignment.center,
                            child: Text('RESET PASSWORD',
                                style: TextStyle(
                                    fontSize: 16 *
                                        dataController.currentScaleFactor.value,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? darkThemeColorList['linkTextColor']
                                        : lightThemeColorList[
                                            'linkTextColor'])),
                          )),
                      SizedBox(
                        height: 10 * dataController.currentScaleFactor.value,
                      ),
                      InkWell(
                          onTap: () {
                            Get.toNamed('/installer-login');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            alignment: Alignment.center,
                            child: Text('INSTALLER LOGIN',
                                style: TextStyle(
                                    fontSize: 16 *
                                        dataController.currentScaleFactor.value,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? darkThemeColorList['linkTextColor']
                                        : lightThemeColorList[
                                            'linkTextColor'])),
                          )),
                      SizedBox(
                        height: 10 * dataController.currentScaleFactor.value,
                      ),
                      InkWell(
                          onTap: () async {
                            if (await canLaunchUrl(
                                Uri.parse(ApiConfig.oemSignUpUrl))) {
                              await launchUrl(
                                Uri.parse(ApiConfig.oemSignUpUrl),
                                mode: LaunchMode.externalApplication,
                              );
                            } else {
                              throw "Could not launch this url";
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            alignment: Alignment.center,
                            child: Text('OEM SIGNUP',
                                style: TextStyle(
                                    fontSize: 16 *
                                        dataController.currentScaleFactor.value,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? darkThemeColorList['linkTextColor']
                                        : lightThemeColorList[
                                            'linkTextColor'])),
                          )),
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
