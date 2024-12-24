import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/core/common.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/reports/controller/reports_controller.dart';

class ShareItemLinkEdit extends StatefulWidget {
  final dynamic shareItemData;

  const ShareItemLinkEdit(this.shareItemData, {super.key});

  @override
  ShareItemLinkEditState createState() => ShareItemLinkEditState();
}

class ShareItemLinkEditState extends State<ShareItemLinkEdit> {
  late DateTime selectedToDate;
  late TimeOfDay selectedToTime;
  final ReportsController reportsController = getIt<ReportsController>();

  final DataController dataController = Get.find<DataController>();
  bool updatingShareLink = false;

  @override
  void initState() {
    super.initState();
    DateTime utcDateTime = DateTime.parse(widget.shareItemData['to']).toUtc();
    DateTime localDateTime = utcDateTime.toLocal();
    selectedToDate = localDateTime;
    selectedToTime =
        TimeOfDay(hour: selectedToDate.hour, minute: selectedToDate.minute);
  }

  Future<void> selectToDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedToDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedToDate) {
      setState(() {
        selectedToDate = pickedDate;
      });
    }
  }

  Future<void> selectToTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedToTime,
    );
    if (pickedTime != null && pickedTime != selectedToTime) {
      setState(() {
        selectedToTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width > 400
            ? 400
            : MediaQuery.of(context).size.width,
        height: 260 * dataController.currentScaleFactor.value,
        padding: EdgeInsets.symmetric(
            horizontal: 20 * dataController.currentScaleFactor.value,
            vertical: 10 * dataController.currentScaleFactor.value),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Edit Link',
            style: TextStyle(fontSize: dataController.titleTextSize.value),
          ),
          SizedBox(
            height: 20 * dataController.currentScaleFactor.value,
          ),
          Text(
            "From",
            style: TextStyle(fontSize: dataController.smallTextSize.value),
          ),
          Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: 10 * dataController.currentScaleFactor.value),
              child: Text(
                  convertUTCtoLocal(
                      widget.shareItemData["from"]?.toString() ?? ''),
                  style: TextStyle(
                      fontSize: dataController.normalTextSize.value))),
          SizedBox(
            height: 20 * dataController.currentScaleFactor.value,
          ),
          Text(
            "To",
            style: TextStyle(fontSize: dataController.smallTextSize.value),
          ),
          Row(children: [
            InkWell(
              onTap: () => selectToDate(context),
              child: Padding(
                  padding: EdgeInsets.all(
                      5 * dataController.currentScaleFactor.value),
                  child: Text(
                    DateFormat('MMMM dd, yyyy')
                        .format(selectedToDate)
                        .toString(),
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: dataController.normalTextSize.value),
                  )),
            ),
            InkWell(
              onTap: () => selectToTime(context),
              child: Padding(
                  padding: EdgeInsets.all(
                      5 * dataController.currentScaleFactor.value),
                  child: Text(
                    selectedToTime.format(context),
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: dataController.normalTextSize.value),
                  )),
            ),
          ]),
          SizedBox(
            height: 20 * dataController.currentScaleFactor.value,
          ),
          Row(
            children: [
              Expanded(
                  child: OutlinedButton(
                onPressed: () async {
                  Get.back();
                },
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          0), // Set the border radius to 0 for a rectangular shape
                    ),
                    side: const BorderSide(
                        color: Color.fromARGB(255, 108, 93, 245)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5)),
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                      fontSize: dataController.normalTextSize.value,
                      color: const Color.fromARGB(255, 108, 93, 245)),
                ),
              )),
              SizedBox(
                width: 20 * dataController.currentScaleFactor.value,
              ),
              Expanded(
                  child: OutlinedButton(
                onPressed: () async {
                  DateTime selectedToDateTime = DateTime(
                    selectedToDate.year,
                    selectedToDate.month,
                    selectedToDate.day,
                    selectedToTime.hour,
                    selectedToTime.minute,
                  );
                  String selectedToTimestamp =
                      DateFormat("yyyy-MM-ddTHH:mm:ss'Z'")
                          .format(selectedToDateTime.toUtc());
                  widget.shareItemData['to'] = selectedToTimestamp;
                  setState(() {
                    updatingShareLink = true;
                  });
                  await reportsController.updateSharedLinks(
                      widget.shareItemData['id'].toString(),
                      widget.shareItemData);
                  setState(() {
                    updatingShareLink = false;
                  });
                  if (reportsController.apiStatus.value == ApiState.success) {
                    Get.back();
                  } else {
                    Get.snackbar(
                        "Updating Failed", reportsController.errorMessage.value,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        animationDuration: const Duration(milliseconds: 300));
                  }
                },
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.green),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          0), // Set the border radius to 0 for a rectangular shape
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5)),
                child: Text(
                  updatingShareLink ? "SAVING..." : 'SAVE',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: dataController.normalTextSize.value,
                  ),
                ),
              ))
            ],
          ),
        ]));
  }
}
