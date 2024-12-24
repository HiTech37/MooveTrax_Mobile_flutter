import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/common/widget/default_button.dart';
import 'package:moovetrax/core/api_config.dart';
import 'package:moovetrax/core/common.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class InstallerSignUpScreen extends StatefulWidget {
  const InstallerSignUpScreen({super.key});

  @override
  InstallerSignUpScreenState createState() => InstallerSignUpScreenState();
}

enum CountryCode { usa, other }

enum MobileUse { yes, no }

class InstallerSignUpScreenState extends State<InstallerSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String phone = '';
  String company = '';
  String zipCode = '';
  String costInstall = '';
  String radiusService = '50';
  CountryCode countryCode = CountryCode.usa;
  MobileUse mobileUse = MobileUse.yes;
  final AuthController authController = getIt<AuthController>();
  final DataController dataController = Get.find<DataController>();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget companyField() {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 10 * dataController.currentScaleFactor.value),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Company Name *",
            style: TextStyle(
                fontSize: 15 * dataController.currentScaleFactor.value),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            onChanged: (text) => setState(() => company = text),
            style: TextStyle(fontSize: dataController.normalTextSize.value),
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

  Widget emailField() {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 10 * dataController.currentScaleFactor.value),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Email *",
            style: TextStyle(
                fontSize: 15 * dataController.currentScaleFactor.value),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
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

  Widget phoneField() {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 10 * dataController.currentScaleFactor.value),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Phone *",
            style: TextStyle(
                fontSize: 15 * dataController.currentScaleFactor.value),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            keyboardType: TextInputType.phone,
            onChanged: (text) => setState(() => phone = text),
            style: TextStyle(fontSize: dataController.normalTextSize.value),
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

  Widget zipCodeField() {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 10 * dataController.currentScaleFactor.value),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Zip code *",
            style: TextStyle(
                fontSize: 15 * dataController.currentScaleFactor.value),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            onChanged: (text) => setState(() => zipCode = text),
            style: TextStyle(fontSize: dataController.normalTextSize.value),
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
                      SizedBox(height: height * .1),
                      Image.asset(
                        "asset/images/logo.png",
                        height: 80 * dataController.currentScaleFactor.value,
                      ),
                      SizedBox(
                          height: 30 * dataController.currentScaleFactor.value),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Installer Signup',
                            style: TextStyle(
                                fontSize: 20 *
                                    dataController.currentScaleFactor.value,
                                fontWeight: FontWeight.w600),
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (await canLaunchUrl(
                                  Uri.parse(ApiConfig.schematicsUrl))) {
                                await launchUrl(
                                  Uri.parse(ApiConfig.schematicsUrl),
                                  mode: LaunchMode.externalApplication,
                                );
                              } else {
                                throw "Could not launch this url";
                              }
                            },
                            child: Text(
                              'Schematics',
                              style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 16 *
                                      dataController.currentScaleFactor.value),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                          height: 10 * dataController.currentScaleFactor.value),
                      emailField(),
                      phoneField(),
                      companyField(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: RadioListTile<CountryCode>(
                              title: const Text('USA'),
                              value: CountryCode.usa,
                              groupValue: countryCode,
                              onChanged: (CountryCode? value) {
                                setState(() {
                                  countryCode = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<CountryCode>(
                              title: const Text('Other'),
                              value: CountryCode.other,
                              groupValue: countryCode,
                              onChanged: (CountryCode? value) {
                                setState(() {
                                  countryCode = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      zipCodeField(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                              child: Text(
                            'Mobile',
                            style: TextStyle(
                                fontSize: 15 *
                                    dataController.currentScaleFactor.value),
                          )),
                          Expanded(
                            child: RadioListTile<MobileUse>(
                              title: const Text('Yes'),
                              value: MobileUse.yes,
                              groupValue: mobileUse,
                              onChanged: (MobileUse? value) {
                                setState(() {
                                  mobileUse = value!;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile<MobileUse>(
                              title: const Text('No'),
                              value: MobileUse.no,
                              groupValue: mobileUse,
                              onChanged: (MobileUse? value) {
                                setState(() {
                                  mobileUse = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      if (mobileUse == MobileUse.yes)
                        SizedBox(
                          height: 20 * dataController.currentScaleFactor.value,
                        ),
                      if (mobileUse == MobileUse.yes)
                        Row(
                          children: [
                            Text(
                              'Radius Serviced',
                              style: TextStyle(
                                  fontSize: 15 *
                                      dataController.currentScaleFactor.value),
                            ),
                            SizedBox(
                              width:
                                  20 * dataController.currentScaleFactor.value,
                            ),
                            Expanded(
                                child: TextFormField(
                              keyboardType: TextInputType.number,
                              onChanged: (text) =>
                                  setState(() => radiusService = text),
                              style: TextStyle(
                                  fontSize:
                                      dataController.normalTextSize.value),
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return 'Can\'t be empty';
                                }

                                return null;
                              },
                            )),
                            SizedBox(
                              width:
                                  20 * dataController.currentScaleFactor.value,
                            ),
                            Text(
                              'Miles',
                              style: TextStyle(
                                  fontSize: 15 *
                                      dataController.currentScaleFactor.value),
                            )
                          ],
                        ),
                      SizedBox(
                          height: 20 * dataController.currentScaleFactor.value),
                      Row(
                        children: [
                          Text(
                            'Cost to install Moovetrax in a`\n2020 Camry Turn key?',
                            style: TextStyle(
                                fontSize: 15 *
                                    dataController.currentScaleFactor.value),
                          ),
                          SizedBox(
                            width: 20 * dataController.currentScaleFactor.value,
                          ),
                          Expanded(
                              child: TextFormField(
                            keyboardType: TextInputType.number,
                            onChanged: (text) =>
                                setState(() => costInstall = text),
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value),
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Can\'t be empty';
                              }

                              return null;
                            },
                          )),
                        ],
                      ),
                      SizedBox(
                          height: 30 * dataController.currentScaleFactor.value),
                      Obx(() {
                        return DefaultButton(
                          text:
                              authController.apiStatus.value == ApiState.loading
                                  ? "Publishing..."
                                  : "Publish",
                          press: () async {
                            if (_formKey.currentState!.validate()) {
                              await authController.installerSignUp({
                                'company_name': company,
                                "country": countryCode == CountryCode.usa
                                    ? "usa"
                                    : 'Other',
                                "email": email,
                                "install_cost": costInstall,
                                "mobile_installer":
                                    mobileUse == MobileUse.yes ? "1" : "0",
                                "phone": phone,
                                "radius_serviced": radiusService,
                                "session": "installer-${randomStr(9)}",
                                "zip_code": zipCode
                              });
                              if (authController.apiStatus.value ==
                                  ApiState.failure) {
                                Get.snackbar("SignUp Failed",
                                    authController.errorMessage.value,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    animationDuration:
                                        const Duration(milliseconds: 300));
                              } else if (authController
                                      .installerSignUpResult.value ==
                                  false) {
                                Get.snackbar("SignUp Failed",
                                    "Input Data seems to be wrong.",
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                    animationDuration:
                                        const Duration(milliseconds: 300));
                              } else {
                                Get.snackbar("SignUp Success!", "Thank you!",
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                    animationDuration:
                                        const Duration(milliseconds: 300));
                              }
                            }
                          },
                        );
                      }),
                      SizedBox(
                          height: 20 * dataController.currentScaleFactor.value),
                    ],
                  ),
                ),
              )),
        ],
      ),
    ));
  }
}
