import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/core/common.dart';
import 'package:moovetrax/data/api/payment/payment_api.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';

class EscrowWidget extends StatefulWidget {
  const EscrowWidget({super.key});

  @override
  EscrowWidgetState createState() => EscrowWidgetState();
}

class EscrowWidgetState extends State<EscrowWidget> {
  final AuthController authController = getIt<AuthController>();
  late TextEditingController _amountController;
  bool movingAllCarsToEscrow = false;
  bool cancelingSubscription = false;

  String balance = "0.0";
  String startedDate = "";
  String billedDate = "";
  bool isSubscribed = false;
  List<dynamic> escrowLogData = [];
  final DataController dataController = Get.find<DataController>();
  final PaymentApi paymentApi = GetIt.instance<PaymentApi>();

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(text: '');
    initData();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> initData() async {
    if (!mounted) return;
    await authController.getUserProfile();
    await authController.getUserEscrowCarBalance();
    await authController.getEscrowLogs();
    if (authController.userEscrowCarBalance.value != null) {
      setState(() {
        startedDate = convertUTCtoLocal1(
            authController.userEscrowCarBalance.value['user']['createdAt']);
        if (authController.userEscrowCarBalance.value['user']['last_billed'] ==
            null) {
          billedDate = '';
        } else {
          startedDate = convertUTCtoLocal1(
              authController.userEscrowCarBalance.value['user']['last_billed']);
        }
      });
    }
    if (authController.profileData.value != null) {
      setState(
        () {
          balance =
              authController.profileData.value['escrow_balance'].toString();
        },
      );
      _amountController.text =
          authController.profileData.value['monthly_cost'].toString();
    }

    if (authController.escrowLogs.value['suscription_detail'] != null &&
        authController.escrowLogs.value['suscription_detail']['status'] !=
            "CANCELLED") {
      setState(() {
        isSubscribed = true;
      });
    } else {
      setState(() {
        isSubscribed = false;
      });
    }
    if (authController.escrowLogs.value != null) {
      setState(() {
        escrowLogData = authController.escrowLogs.value['log_list'];
      });
    }
  }

  Widget escrowLogCard(dynamic logData) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Theme(
              data:
                  Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                childrenPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                title: Text(
                  logData['amount'],
                  style: TextStyle(
                      fontSize: dataController.titleTextSize.value,
                      fontWeight: FontWeight.w500),
                ),
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Added By:',
                        style: TextStyle(
                          fontSize: dataController.normalTextSize.value,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          logData['from_name'],
                          style: TextStyle(
                            fontSize: dataController.normalTextSize.value,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'User:',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      Text(
                        logData['to_name'],
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Balance:',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      Text(
                        logData['to_balance'],
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'When:',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      Text(
                        convertUTCtoLocal(logData['createdAt']),
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Note:',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      Text(
                        logData['note'],
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20 * dataController.currentScaleFactor.value),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Balance: $balance',
              style: TextStyle(
                  fontSize: 20 * dataController.currentScaleFactor.value,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              controller: _amountController,
              onChanged: (value) {},
              style: TextStyle(
                fontSize: dataController.titleTextSize.value,
              ),
              decoration: InputDecoration(
                  hintText: "",
                  label: Text(
                    'Amount',
                    style:
                        TextStyle(fontSize: dataController.titleTextSize.value),
                  )),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Start: $startedDate',
              style: TextStyle(
                  fontSize: dataController.titleTextSize.value,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(
              height: 20,
            ),
            // Text(
            //   'Billed on: $billedDate',
            //   style: TextStyle(
            //       fontSize: dataController.titleTextSize.value,
            //       fontWeight: FontWeight.w700),
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            Text(
              'Escrow Logs',
              style: TextStyle(
                fontSize: dataController.titleTextSize.value,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (escrowLogData.isNotEmpty)
              SizedBox(
                  height: 300 * dataController.currentScaleFactor.value,
                  child: ListView.builder(
                    itemCount: escrowLogData.length,
                    itemBuilder: (context, index) {
                      return escrowLogCard(escrowLogData[index]);
                    },
                  )),
            if (escrowLogData.isNotEmpty)
              const SizedBox(
                height: 20,
              ),
            isSubscribed == false
                ? GestureDetector(
                    onTap: () async {
                      try {
                        double price = double.parse(_amountController.text);
                        await paymentApi.updatePlanPrice({
                          'itemId': authController.storageUserData?['id'],
                          'itemType': 'escrow',
                          "monthly_cost": price
                        });

                        Get.toNamed('/account-subscription');
                      } catch (error) {
                        if (kDebugMode) {
                          print(error);
                        }
                      }
                    },
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                58 * dataController.currentScaleFactor.value,
                            vertical:
                                9 * dataController.currentScaleFactor.value),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(25),
                            ),
                            color: Colors.amber[600]),
                        height: 34 * dataController.currentScaleFactor.value,
                        child: Image.asset(
                          "asset/images/paypal-logo.png",
                        )))
                : ElevatedButton(
                    onPressed: () async {
                      dynamic confirmCancel = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                              'Confirm Cancellation',
                              style: TextStyle(
                                fontSize: dataController.titleTextSize.value,
                              ),
                            ),
                            content: Text(
                              'Are you sure you want to cancel your subscription?',
                              style: TextStyle(
                                fontSize: dataController.normalTextSize.value,
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Get.back(result: false);
                                },
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize:
                                        dataController.normalTextSize.value,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.back(result: true);
                                },
                                child: Text(
                                  'OK',
                                  style: TextStyle(
                                    fontSize:
                                        dataController.normalTextSize.value,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                      if (confirmCancel == null) return;

                      if (confirmCancel) {
                        setState(() {
                          cancelingSubscription = true;
                        });
                        try {
                          await paymentApi.cancelSubscription({
                            'subscription_id': authController
                                .profileData.value['subscription_id'],
                            "itemType": 'escrow'
                          });
                          setState(() {
                            cancelingSubscription = false;
                          });
                          initData();
                        } catch (error) {
                          setState(() {
                            cancelingSubscription = false;
                          });
                          // Handle the error appropriately, e.g., show a message to the user
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: 8 * dataController.currentScaleFactor.value,
                        horizontal:
                            24 * dataController.currentScaleFactor.value,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: const Color.fromARGB(255, 245, 174, 20),
                    ),
                    child: Text(
                      cancelingSubscription
                          ? "Canceling..."
                          : 'Cancel Subscription',
                      style: TextStyle(
                        fontSize: dataController.normalTextSize.value,
                        color: const Color.fromARGB(255, 53, 52, 95),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
                onTap: () async {
                  setState(() {
                    movingAllCarsToEscrow = true;
                  });
                  await authController.setDevicesBillingSource();
                  setState(() {
                    movingAllCarsToEscrow = false;
                  });
                  if (authController.apiStatus.value == ApiState.success) {
                    Get.snackbar(
                      "",
                      "",
                      colorText: Colors.white,
                      backgroundColor: Colors.green,
                      animationDuration: const Duration(milliseconds: 300),
                      titleText: Text(
                        "All Cars moved to Escrow",
                        style: TextStyle(
                          fontSize:
                              18 * dataController.currentScaleFactor.value,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  if (authController.apiStatus.value == ApiState.failure) {
                    Get.snackbar("Failed", authController.errorMessage.value,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        animationDuration: const Duration(milliseconds: 300));
                  }
                },
                child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal:
                            30 * dataController.currentScaleFactor.value,
                        vertical: 10 * dataController.currentScaleFactor.value),
                    decoration: const BoxDecoration(
                        border: Border.fromBorderSide(
                            BorderSide(color: Colors.grey)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                        color: Colors.transparent),
                    height: 40 * dataController.currentScaleFactor.value,
                    child: Text(
                      movingAllCarsToEscrow
                          ? 'Processing...'
                          : 'All Cars to Escrow',
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ))),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    ));
  }
}
