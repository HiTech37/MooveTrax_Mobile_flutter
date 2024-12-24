// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/common/widget/default_button.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/view/account/widget/escrow_widget.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  AccountScreenState createState() => AccountScreenState();
}

class AccountScreenState extends State<AccountScreen> {
  String email = '';
  String name = '';
  String phone = '';
  bool updatingProfile = false;
  bool resettingPassword = false;
  final AuthController authController = getIt<AuthController>();
  TextEditingController nameEditController = TextEditingController();
  TextEditingController emailEditController = TextEditingController();
  TextEditingController phoneEditController = TextEditingController();
  final DataController dataController = Get.find<DataController>();
  String mToken = '';

  final _formKey = GlobalKey<FormState>();
  String? approvalUrl;
  Widget emailField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Email",
            style: TextStyle(fontSize: dataController.normalTextSize.value),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: emailEditController,
            enabled: false,
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

  Widget nameField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Name",
            style: TextStyle(fontSize: dataController.normalTextSize.value),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: nameEditController,
            style: TextStyle(fontSize: dataController.normalTextSize.value),
            onChanged: (text) => setState(() => name = text),
          )
        ],
      ),
    );
  }

  Widget phoneField() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Phone",
            style: TextStyle(fontSize: dataController.normalTextSize.value),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: phoneEditController,
            style: TextStyle(fontSize: dataController.normalTextSize.value),
            onChanged: (text) => setState(() => phone = text),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    emailEditController.dispose();
    nameEditController.dispose();
    phoneEditController.dispose();
    super.dispose();
  }

  Future<void> initData() async {
    if (!mounted) return;
    await authController.getUserProfile();
    if (authController.profileData.value != null) {
      setState(
        () {
          name = authController.profileData.value['name'] ?? '';
          email = authController.profileData.value['email'] ?? '';
          phone = authController.profileData.value['phone'] ?? '';
        },
      );
    }
    nameEditController.text = name;
    emailEditController.text = email;
    phoneEditController.text = phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: dataController.appBarHeight.value,
        title: Text(
          "Account",
          style: TextStyle(fontSize: dataController.appBarTitleSize.value),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              dataController.changeTabIndex(3);
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: dataController.iconSize.value,
            )),
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey, // Set your desired border color here
                  width: 1.0, // Set the border width
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Escrow Balance',
                    style: TextStyle(
                      fontSize: 20 * dataController.currentScaleFactor.value,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  authController.profileData.value == null
                      ? Text(
                          '\$0.00',
                          style: TextStyle(
                            fontSize:
                                30 * dataController.currentScaleFactor.value,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        )
                      : Text(
                          '\$${authController.profileData.value['escrow_balance']}',
                          style: TextStyle(
                            fontSize:
                                30 * dataController.currentScaleFactor.value,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      Get.dialog(Dialog(
                          insetPadding: const EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Set the border radius
                          ),
                          child: const EscrowWidget()));
                      // await FirebaseMessaging.instance.getToken().then((token) {
                      //   setState(() {
                      //     mToken = token!;
                      //   });
                      // });
                      // await authController.updatePushToken({
                      //   'push_token': mToken,
                      //   'userID': authController.storageUserData?['id']
                      // });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(
                          horizontal:
                              50 * dataController.currentScaleFactor.value,
                          vertical:
                              5 * dataController.currentScaleFactor.value),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Text(
                      'UPDATE',
                      style: TextStyle(
                          fontSize:
                              20 * dataController.currentScaleFactor.value,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey, // Set your desired border color here
                    width: 1.0, // Set the border width
                  ),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      nameField(),
                      emailField(),
                      phoneField(),
                      const SizedBox(height: 10),
                      DefaultButton(
                          text: authController.apiStatus.value ==
                                      ApiState.loading &&
                                  updatingProfile
                              ? "SAVING..."
                              : "SAVE CHANGES",
                          press: () async {
                            if (authController.profileData.value != null) {
                              if (_formKey.currentState!.validate()) {
                                dynamic data = authController.profileData.value;
                                data['eamil'] = email;
                                data['name'] = name;
                                data['phone'] = phone;
                                setState(() {
                                  updatingProfile = true;
                                });
                                await authController.updateUserProfile(data);
                                setState(() {
                                  updatingProfile = false;
                                });
                                if (authController.apiStatus.value ==
                                    ApiState.failure) {
                                  Get.snackbar("Updating Failed",
                                      authController.errorMessage.value,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      animationDuration:
                                          const Duration(milliseconds: 300));
                                } else {
                                  Get.snackbar("Profile Update",
                                      "Your profile has been successfully updated.",
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                      animationDuration:
                                          const Duration(milliseconds: 300));
                                }
                              }
                            }
                          }),
                      const SizedBox(height: 10),
                    ],
                  ),
                )),
            const SizedBox(
              height: 15,
            ),
            DefaultButton(
                text: resettingPassword ? "SENDING..." : "RESET PASSWORD",
                press: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      resettingPassword = true;
                    });
                    await authController.resetPassword({
                      'email': email,
                    });
                    setState(() {
                      resettingPassword = false;
                    });
                    if (authController.apiStatus.value == ApiState.failure) {
                      Get.snackbar(
                          "Request Failed", authController.errorMessage.value,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          animationDuration: const Duration(milliseconds: 300));
                    } else {
                      Get.snackbar("Request Success",
                          'Your password reset link has been sent. Please check your email.',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          animationDuration: const Duration(milliseconds: 300));
                    }
                  }
                }),
          ],
        ),
      )),
    );
  }
}
