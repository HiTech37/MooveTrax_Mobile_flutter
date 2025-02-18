import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/common/widget/youtube_player.dart';
import 'package:moovetrax/core/common.dart';
import 'package:moovetrax/data/api/payment/payment_api.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/view/account/widget/escrow_widget.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';

enum PaymentOption { paypal, escrow }

class CreditBalanceWidget extends StatefulWidget {
  const CreditBalanceWidget({
    super.key,
    required this.onChanged,
  });

  final ValueChanged onChanged;

  @override
  State<CreditBalanceWidget> createState() => _CreditBalanceWidgetState();
}

class _CreditBalanceWidgetState extends State<CreditBalanceWidget>
    with WidgetsBindingObserver {
  final DataController dataController = Get.find<DataController>();
  final DeviceController deviceController = getIt<DeviceController>();
  final AuthController authController = getIt<AuthController>();
  String howToVideoId = "iD6_zjMX4pw";
  PaymentOption? deviceOptionValue = PaymentOption.paypal;
  bool cancelingSubscription = false;
  bool isSubscribed = false;

  dynamic selectedDeviceChargeData;
  List<dynamic> selectedDeviceCreditLogs = [];
  final PaymentApi paymentApi = GetIt.instance<PaymentApi>();
  String escrowBalance = '';

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void initData() async {
    if (!mounted) return;
    await deviceController
        .checkChargeRequired(dataController.currentDeviceId.value);

    if (deviceController.apiStatus.value == ApiState.success) {
      if (!mounted) return;
      setState(() {
        selectedDeviceChargeData =
            deviceController.selectedDeviceChargeData.value;
      });
    }
    await deviceController.getCreditLogs(dataController.currentDeviceId.value);
    if (deviceController.apiStatus.value == ApiState.success) {
      if (!mounted) return;
      setState(() {
        selectedDeviceCreditLogs =
            deviceController.selectedDeviceCreditLogs.value['log_list'] ?? [];
        deviceOptionValue = deviceController.selectedDeviceChargeData
                    .value['device']['billing_source'] ==
                'escrow'
            ? PaymentOption.escrow
            : PaymentOption.paypal;
      });
    }
    if (deviceController.selectedDeviceCreditLogs.value['suscription_detail'] !=
            null &&
        deviceController.selectedDeviceCreditLogs.value['suscription_detail']
                ['status'] !=
            "CANCELLED") {
      setState(() {
        isSubscribed = true;
      });
    } else {
      setState(() {
        isSubscribed = false;
      });
    }
    await authController.getUserEscrowCarBalance();
    if (authController.apiStatus.value == ApiState.success) {
      if (!mounted) return;
      setState(() {
        escrowBalance = authController
            .userEscrowCarBalance.value['user']['escrow_balance']
            .toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width > 400
          ? 400 * dataController.currentScaleFactor.value
          : MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(
        horizontal: 15 * dataController.currentScaleFactor.value,
        vertical: 20 * dataController.currentScaleFactor.value,
      ),
      child: selectedDeviceChargeData == null
          ? const SizedBox(
              height: 500,
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Balance: ${selectedDeviceChargeData['device']['credit']}',
                        style: TextStyle(
                          fontSize: dataController.appBarTitleSize.value,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return YouTubePlayerDialog(
                                videoId: howToVideoId,
                              );
                            },
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Text(
                            "Video",
                            style: TextStyle(
                              color: Colors.blue[600],
                              fontSize: dataController.normalTextSize.value,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10 * dataController.currentScaleFactor.value,
                  ),
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          SizedBox(
                            width: 30 * dataController.currentScaleFactor.value,
                            height:
                                30 * dataController.currentScaleFactor.value,
                            child: Radio<PaymentOption>(
                              value: PaymentOption.paypal,
                              groupValue: deviceOptionValue,
                              onChanged: (PaymentOption? value) async {
                                setState(() {
                                  deviceOptionValue = value;
                                });
                                if (value == PaymentOption.paypal) {
                                  try {
                                    await deviceController.setBillingSource({
                                      'billing_source': "paypal",
                                      "device_id":
                                          dataController.currentDeviceId.value
                                    });
                                  } catch (error) {
                                    if (kDebugMode) {
                                      print(error);
                                    }
                                  }
                                }
                              },
                            ),
                          ),
                          isSubscribed == false
                              ? ElevatedButton(
                                  onPressed: () async {
                                    setState(() {
                                      deviceOptionValue = PaymentOption.paypal;
                                    });
                                    await deviceController.setBillingSource({
                                      'billing_source': "paypal",
                                      "device_id":
                                          dataController.currentDeviceId.value
                                    });
                                    Get.back();
                                    dataController.setCurrentPaymentItemId(
                                        dataController.currentDeviceId.value);
                                    Get.toNamed('/device-subscription');
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8 *
                                              dataController
                                                  .currentScaleFactor.value,
                                          horizontal: 24 *
                                              dataController
                                                  .currentScaleFactor.value),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      backgroundColor: const Color.fromARGB(
                                          255, 245, 174, 20)),
                                  child: Image.asset(
                                    'asset/images/paypal-logo.png', // Path to your PayPal logo asset
                                    height: 18 *
                                        dataController.currentScaleFactor
                                            .value, // Set the desired height of the logo
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () async {
                                    dynamic confirmCancel = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Confirm Cancellation',
                                            style: TextStyle(
                                              fontSize: dataController
                                                  .titleTextSize.value,
                                            ),
                                          ),
                                          content: Text(
                                            'Are you sure you want to cancel your subscription?',
                                            style: TextStyle(
                                              fontSize: dataController
                                                  .normalTextSize.value,
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
                                                  fontSize: dataController
                                                      .normalTextSize.value,
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
                                                  fontSize: dataController
                                                      .normalTextSize.value,
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
                                          'subscription_id':
                                              selectedDeviceChargeData['device']
                                                  ['subscription_id'],
                                          "itemType": 'credit'
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
                                      vertical: 8 *
                                          dataController
                                              .currentScaleFactor.value,
                                      horizontal: 24 *
                                          dataController
                                              .currentScaleFactor.value,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor:
                                        const Color.fromARGB(255, 245, 174, 20),
                                  ),
                                  child: Text(
                                    cancelingSubscription
                                        ? "Canceling..."
                                        : 'Cancel Subscription',
                                    style: TextStyle(
                                      fontSize:
                                          dataController.normalTextSize.value,
                                      color:
                                          const Color.fromARGB(255, 53, 52, 95),
                                    ),
                                  ),
                                ),
                          SizedBox(
                            width: 30 * dataController.currentScaleFactor.value,
                            height:
                                30 * dataController.currentScaleFactor.value,
                            child: Radio<PaymentOption>(
                              value: PaymentOption.escrow,
                              groupValue: deviceOptionValue,
                              onChanged: (PaymentOption? value) async {
                                setState(() {
                                  deviceOptionValue = value;
                                });
                                if (value == PaymentOption.escrow) {
                                  try {
                                    await deviceController.setBillingSource({
                                      'billing_source': "escrow",
                                      "device_id":
                                          dataController.currentDeviceId.value
                                    });
                                    if (deviceController.apiStatus.value ==
                                        ApiState.failure) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Failed',
                                              style: TextStyle(
                                                  fontSize: dataController
                                                      .titleTextSize.value),
                                            ),
                                            content: Text(
                                              '${deviceController.errorMessage.value}\n\nPlease top up your escrow balance on the account screen.',
                                              style: TextStyle(
                                                  fontSize: dataController
                                                      .normalTextSize.value),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                  Get.back();
                                                  Get.toNamed(
                                                      '/settings/account');
                                                },
                                                child: Text(
                                                  'OK',
                                                  style: TextStyle(
                                                      fontSize: dataController
                                                          .normalTextSize
                                                          .value),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      initData();
                                      dataController.updateDevices();
                                    }
                                  } catch (error) {
                                    if (kDebugMode) {
                                      print(error);
                                    }
                                  }
                                }
                              },
                            ),
                          ),
                          GestureDetector(
                              onTap: () async {
                                setState(() {
                                  deviceOptionValue = PaymentOption.escrow;
                                });
                                try {
                                  await deviceController.setBillingSource({
                                    'billing_source': "escrow",
                                    "device_id":
                                        dataController.currentDeviceId.value
                                  });
                                  if (deviceController.apiStatus.value ==
                                      ApiState.failure) {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Failed',
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .titleTextSize.value),
                                          ),
                                          content: Text(
                                            '${deviceController.errorMessage.value}\n\nPlease top up your escrow balance on the account screen.',
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Get.back();
                                                Get.back();
                                                Get.toNamed(
                                                    '/settings/account');
                                              },
                                              child: Text(
                                                'OK',
                                                style: TextStyle(
                                                    fontSize: dataController
                                                        .normalTextSize.value),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    initData();
                                    dataController.updateDevices();
                                  }
                                } catch (error) {
                                  if (kDebugMode) {
                                    print(error);
                                  }
                                }
                              },
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Pay from\n Escrow (',
                                      style: TextStyle(
                                        fontSize:
                                            dataController.normalTextSize.value,
                                        color: Colors
                                            .black, // Adjust color as needed
                                      ),
                                    ),
                                    WidgetSpan(
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.dialog(Dialog(
                                              insetPadding:
                                                  const EdgeInsets.all(10),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(
                                                    10.0), // Set the border radius
                                              ),
                                              child: const EscrowWidget()));
                                        },
                                        child: Text(
                                          escrowBalance,
                                          style: TextStyle(
                                            fontSize: dataController
                                                .normalTextSize.value,
                                            color: Colors
                                                .blue, // Indicate it's clickable
                                            decoration: TextDecoration
                                                .underline, // Optional for UX
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    TextSpan(
                                      text: ')',
                                      style: TextStyle(
                                        fontSize:
                                            dataController.normalTextSize.value,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      )),
                  SizedBox(
                    height: 10 * dataController.currentScaleFactor.value,
                  ),
                  Text(
                    'Start: ${convertUTCtoLocal1(selectedDeviceChargeData['device']['createdAt'])}',
                    style: TextStyle(
                      fontSize: dataController.normalTextSize.value,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Billed On: ${selectedDeviceChargeData['device']['billed_date']}',
                    style: TextStyle(
                      fontSize: dataController.normalTextSize.value,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10 * dataController.currentScaleFactor.value,
                  ),
                  Text(
                    'Credit Logs',
                    style: TextStyle(
                      fontSize: dataController.normalTextSize.value,
                    ),
                  ),
                  SizedBox(
                    height: 10 * dataController.currentScaleFactor.value,
                  ),
                  SizedBox(
                    height: 300 * dataController.currentScaleFactor.value,
                    child: ListView.builder(
                      itemCount: selectedDeviceCreditLogs.length,
                      itemBuilder: (context, index) {
                        final log = selectedDeviceCreditLogs[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(8),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Amount: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                      TextSpan(
                                        text: '${log['amount'] ?? 'N/A'}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Added by: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                      TextSpan(
                                        text: '${log['from_name'] ?? 'N/A'}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Note: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                      TextSpan(
                                        text: '${log['note'] ?? 'N/A'}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Device Name: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                      TextSpan(
                                        text: '${log['to_name'] ?? 'N/A'}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Serial Number: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                      TextSpan(
                                        text:
                                            '${log['device_serial_number'] ?? 'N/A'}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'Balance: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                      TextSpan(
                                        text: log['to_balance'].toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      const TextSpan(
                                        text: 'When: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                      TextSpan(
                                        text: convertTimestampToLocal(
                                            log['add_timestamp'].toString()),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10 * dataController.currentScaleFactor.value,
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            Get.back();
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                          ),
                          child: Text(
                            'CLOSE',
                            style: TextStyle(
                              fontSize: dataController.normalTextSize.value,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
