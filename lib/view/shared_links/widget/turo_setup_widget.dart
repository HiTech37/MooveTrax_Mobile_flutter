import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/common/widget/default_button.dart';
import 'package:moovetrax/common/widget/youtube_player.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/reports/controller/reports_controller.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class EmailItem {
  String email;
  String url;

  EmailItem({required this.email, required this.url});
}

class TuroSetupWidget extends StatefulWidget {
  final String selectedDeviceId;
  const TuroSetupWidget({
    super.key,
    required this.selectedDeviceId,
    required this.onChanged,
  });

  final ValueChanged onChanged;

  @override
  State<TuroSetupWidget> createState() => _TuroSetupWidgetState();
}

class _TuroSetupWidgetState extends State<TuroSetupWidget> {
  List<EmailItem> turoCallList = [];
  final ReportsController reportsController = getIt<ReportsController>();
  String howToVideoId = "ISVv_ZYMkaQ";
  final DataController dataController = Get.find<DataController>();
  final DeviceController deviceController = getIt<DeviceController>();

  bool submitting = false;
  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
    await deviceController
        .getSelectedShareDevicePageData(dataController.currentDeviceId.value);
    if (deviceController.apiStatus.value == ApiState.failure) {
      Get.snackbar("Failed", deviceController.errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          animationDuration: const Duration(milliseconds: 300));
      return;
    } else {
      if (!mounted) return;
      var selectedDeviceSharePageData =
          deviceController.selectedDeviceSharePageData.value;
      var turoList = selectedDeviceSharePageData['turoCalList'];
      setState(() {
        turoList.forEach((item) {
          turoCallList
              .add(EmailItem(email: item['turo_email'], url: item['url']));
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width > 400
          ? 400
          : MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Turo Setup',
              style: TextStyle(
                  fontSize: dataController.titleTextSize.value,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20 * dataController.currentScaleFactor.value),
            Row(
              children: [
                SizedBox(
                    width: 130 * dataController.currentScaleFactor.value,
                    child: DefaultButton(
                      text: "+ ADD NEW",
                      press: () {
                        setState(() {
                          turoCallList.add(EmailItem(email: '', url: ''));
                        });
                      },
                    )),
                const SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return YouTubePlayerDialog(videoId: howToVideoId);
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      "How To Video",
                      style: TextStyle(
                          color: Colors.blue[600],
                          fontSize: dataController.normalTextSize.value),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20 * dataController.currentScaleFactor.value),
            GestureDetector(
              onTap: () async {
                const url =
                    'https://www.youtube.com/results?search_query=auto+forward+emails';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: Text(
                'If Turo removed your url, Please auto forward your Turo emails to trip@turo.moovetrax.com',
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
            ),
            SizedBox(height: 20 * dataController.currentScaleFactor.value),
            SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  for (var i = 0; i < turoCallList.length; i++)
                    EmailWidget(
                      emailItem: turoCallList[i],
                      onDelete: () {
                        setState(() {
                          turoCallList.removeAt(i);
                        });
                      },
                      onChanged: (email, url) {
                        setState(() {
                          turoCallList[i].email = email;
                          turoCallList[i].url = url;
                        });
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: DefaultButton(
                    text: submitting ? "SUBMITTING..." : "SUBMIT",
                    press: () async {
                      if (turoCallList.isEmpty) {
                        Get.snackbar(
                            "No Selected Data", "Please add at least one data",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            animationDuration:
                                const Duration(milliseconds: 300));
                        return;
                      }

                      if (widget.selectedDeviceId == "") {
                        Get.snackbar(
                            "Invalid Device", "Please select a device.",
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            animationDuration:
                                const Duration(milliseconds: 300));
                        return;
                      }

                      var turoEmailList = [];
                      for (int i = 0; i < turoCallList.length; i++) {
                        turoEmailList.add({
                          "turo_email": turoCallList[i].email,
                          "url": turoCallList[i].url
                        });
                      }
                      setState(() {
                        submitting = true;
                      });
                      await reportsController.saveTuroCallLinks({
                        "deviceId": widget.selectedDeviceId,
                        "turo_cal": turoEmailList
                      });
                      setState(() {
                        submitting = false;
                      });
                      if (reportsController.apiStatus.value ==
                          ApiState.failure) {
                        Get.snackbar(
                            "Failed! ", reportsController.errorMessage.value,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            animationDuration:
                                const Duration(milliseconds: 300));
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 10 * dataController.currentScaleFactor.value,
                ),
                Flexible(
                    child: OutlinedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            padding: WidgetStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 40 *
                                        dataController.currentScaleFactor.value,
                                    vertical: 15 *
                                        dataController
                                            .currentScaleFactor.value))),
                        child: Text(
                          'CANCEL',
                          style: TextStyle(
                              fontSize: dataController.normalTextSize.value),
                        )))
              ],
            )
          ],
        ),
      ),
    );
  }
}

class EmailWidget extends StatefulWidget {
  final EmailItem emailItem;
  final VoidCallback onDelete;
  final Function(String, String) onChanged;

  const EmailWidget({
    super.key,
    required this.emailItem,
    required this.onDelete,
    required this.onChanged,
  });

  @override
  EmailWidgetState createState() => EmailWidgetState();
}

class EmailWidgetState extends State<EmailWidget> {
  late TextEditingController _emailController;
  late TextEditingController _urlController;
  final DataController dataController = Get.find<DataController>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.emailItem.email);
    _urlController = TextEditingController(text: widget.emailItem.url);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          margin: const EdgeInsets.only(top: 25, right: 5),
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  _onEmailChanged(value);
                },
                controller: _emailController,
                style: TextStyle(fontSize: dataController.normalTextSize.value),
                decoration: const InputDecoration(hintText: "Turo Email"),
              ),
              const SizedBox(height: 10),
              TextField(
                  controller: _urlController,
                  style:
                      TextStyle(fontSize: dataController.normalTextSize.value),
                  onChanged: (value) {
                    _onUrlChanged(value);
                  },
                  decoration:
                      const InputDecoration(hintText: "Turo Calendar URL")),
            ],
          ),
        ),
        Positioned(
          top: 15,
          right: 0,
          child: InkWell(
            onTap: widget.onDelete,
            child: Container(
              width: 25 * dataController.currentScaleFactor.value,
              height: 25 * dataController.currentScaleFactor.value,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(189, 0, 0, 1),
                borderRadius: BorderRadius.all(Radius.circular(13)),
              ),
              child: Icon(Icons.close,
                  color: Colors.white, size: dataController.iconSize.value),
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  void _onEmailChanged(String email) {
    widget.onChanged(email, _urlController.text);
  }

  void _onUrlChanged(String url) {
    widget.onChanged(_emailController.text, url);
  }
}
