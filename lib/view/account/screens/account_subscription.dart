import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:moovetrax/core/api_config.dart';
import 'package:moovetrax/core/common.dart';
import 'package:moovetrax/data/api/payment/payment_api.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class AccountPaypalSubscriptionScreen extends StatefulWidget {
  const AccountPaypalSubscriptionScreen({super.key});

  @override
  AccountPaypalSubscriptionScreenState createState() =>
      AccountPaypalSubscriptionScreenState();
}

class AccountPaypalSubscriptionScreenState
    extends State<AccountPaypalSubscriptionScreen> {
  late final WebViewController webViewController;
  final PaymentApi paymentApi = GetIt.instance<PaymentApi>();
  String subscriptionPlanID = '';
  bool paymentSucceed = false;
  dynamic subscriptionDetails;
  final AuthController authController = getIt<AuthController>();

  // A method that returns the HTML string with the planId inserted

  @override
  void initState() {
    super.initState();

    // WebView setup
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('Error occurred on page: ${error.response?.statusCode}');
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {},
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          onAprroveSubscription(jsonDecode(message.message));
        },
      );

    if (kIsWeb || !Platform.isMacOS) {
      controller.setBackgroundColor(const Color(0x80000000));
    }

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    webViewController = controller;
    createSubscriptionFlow();
  }

  Future<void> onAprroveSubscription(dynamic data) async {
    try {
      await paymentApi.subscriptionComplete({
        "userId": authController.storageUserData?['id'],
        "plan_id": subscriptionPlanID,
        'itemId': authController.storageUserData?['id'],
        'itemType': 'escrow',
        'subscriptionID': data['id'],
        "orderID": data['orderID']
      });
      setState(() {
        paymentSucceed = true;
        subscriptionDetails = data;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  Future<void> createSubscriptionFlow() async {
    if (authController.storageUserData == null) return;

    try {
      String planId = await paymentApi.createPlan({
        'itemId': authController.storageUserData?['id'],
        'itemType': 'escrow'
      });
      setState(() {
        subscriptionPlanID = planId;
      });
      // Step 4: Load the WebView with the dynamically created HTML
      String dynamicHtml = "${ApiConfig.paypalSubscriptionUrl}?planId=$planId";
      webViewController.loadRequest(Uri.parse(dynamicHtml));
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
    }
  }

  // A widget to display subscription details
  Widget _subscriptionDetails() {
    return Column(
      children: [
        _detailRow('Subscription ID:', subscriptionDetails['id']),
        const SizedBox(height: 10),
        _detailRow('Subscription Date:',
            convertUTCtoLocal(subscriptionDetails['create_time'])),
      ],
    );
  }

  // Helper widget for displaying individual details
  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("PayPal Subscription")),
        body: paymentSucceed == false
            ? WebViewWidget(controller: webViewController)
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 100,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Subscription Successful!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Thank you for subscribing!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _subscriptionDetails(),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        // Add action to redirect user (e.g., back to homepage)
                        Get.toNamed('/settings/account');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Back'),
                    ),
                  ],
                ),
              ));
  }
}
