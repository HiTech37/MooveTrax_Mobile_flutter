import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:intl/intl.dart';
import 'package:get/get.dart' as gt;
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/common/widget/default_button.dart';
import 'package:moovetrax/common/widget/youtube_player.dart';
import 'package:moovetrax/core/api_config.dart';
import 'package:moovetrax/core/common.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/view/share/widgets/edit_share_text_dialog.dart';
import 'package:moovetrax/view/share/widgets/image_picker.dart';
import 'package:moovetrax/view/shared_links/widget/turo_setup_widget.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

enum CarApproveOption { always, manual, aiApprove }

enum UnkillOPtion { firstUnlockByRenter, selfieInsideCar }

class ShareScreen extends StatefulWidget {
  const ShareScreen({super.key});

  @override
  ShareScreenState createState() => ShareScreenState();
}

class ShareScreenState extends State<ShareScreen> {
  List<dynamic> deviceList = [];
  List<dynamic> turoTripList = [];
  Map<String, dynamic> deviceValue = {};
  String howToUploadRequirementsVideo = "Wiks5TRTzBA";
  String? selectedTimeZone;
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay selectedFromTime = TimeOfDay.now();
  TimeOfDay selectedToTime = TimeOfDay.now();
  List<String> timezoneList = [];
  String autoSendTollEmail = '';
  bool generating = false;
  bool autoLock = false;
  bool sendTollReportDaily = false;
  bool autoSendToll = false;
  bool shareSettingsEnabled = false;
  bool carLocationAvailableTime = false;
  String allotPerday = '';
  bool unlockWorkTime = false;
  bool unkillAfter = false;
  bool alertGuest = false;
  bool pictureLicense = false;
  bool selfieLicense = false;
  bool unlockSelfieLicense = false;
  UnkillOPtion unkillOption = UnkillOPtion.firstUnlockByRenter;
  bool autoKillSwitch = false;
  String shareMinutesBefore = '';
  String shareMinutesAfter = '';
  CarApproveOption carLocationApproveOptionValue = CarApproveOption.always;
  CarApproveOption unlockCarApproveOptionValue = CarApproveOption.always;
  CarApproveOption unkillApproveOptionValue = CarApproveOption.always;
  final DataController dataController = gt.Get.find<DataController>();
  final DeviceController deviceController = getIt<DeviceController>();
  Map<String, dynamic> shareSetting = {};
  dynamic selectedDeviceSharePageData;
  final AuthController authController = getIt<AuthController>();

  TextEditingController allotEditController = TextEditingController(text: '');
  TextEditingController alertGuestEditController =
      TextEditingController(text: '');
  TextEditingController alertGuestAutoSendMessageEditController =
      TextEditingController(text: '');
  TextEditingController canUploadEditController =
      TextEditingController(text: '');
  TextEditingController generatedUrlEditController =
      TextEditingController(text: '');
  TextEditingController shareBeforeEditController =
      TextEditingController(text: '');
  TextEditingController shareAfterEditController =
      TextEditingController(text: '');
  TextEditingController aiAvailablePercentEditController =
      TextEditingController(text: '');
  TextEditingController unlockAiPercientEditController =
      TextEditingController(text: '');

  TextEditingController unKillAiPercientEditController =
      TextEditingController(text: '');
  TextEditingController approveEmailEditController =
      TextEditingController(text: '');

  TextEditingController autoSendTollEditController =
      TextEditingController(text: '');
  TextEditingController carLocationAutoSendMessageEditController =
      TextEditingController(text: '');
  TextEditingController unlockAutoSendMessageEditController =
      TextEditingController(text: '');
  TextEditingController unkillAutoSendMessageEditController =
      TextEditingController(text: '');

  List<dynamic> availList = [];
  List<dynamic> unlockList = [];
  List<dynamic> unkillList = [];
  List<String> unlockAvailableList = [];
  List<String> unkillAfterList = [];
  List<String> locationAvailableList = [];
  String availAutoSendPicturePath = "";
  String unlockAutoSendPicturePath = "";
  String unkillAutoSendPicturePath = "";
  File? availAutoSendPicture;
  File? unlockAutoSendPicture;
  File? unkillAutoSendPicture;

  List<TextEditingController> locationEditControllers = [];
  List<TextEditingController> unlockEditControllers = [];
  List<TextEditingController> unkillEditControllers = [];
  @override
  void initState() {
    super.initState();
    initData();
  }

  void initializeLocationEditControllers() {
    setState(() {
      // Generate the list with possible nulls, then filter and cast
      locationEditControllers = List.generate(
          locationAvailableList.length,
          (index) => TextEditingController(
              text: locationAvailableList[
                  index])); // Convert the iterable back to a list
    });
  }

  void initializeUnlockEditControllers() {
    setState(() {
      // Generate the list with possible nulls, then filter and cast
      unlockEditControllers = List.generate(
          unlockAvailableList.length,
          (index) => TextEditingController(
              text: unlockAvailableList[
                  index])); // Convert the iterable back to a list
    });
  }

  void initializeUnkillEditControllers() {
    setState(() {
      // Generate the list with possible nulls, then filter and cast
      unkillEditControllers = List.generate(
          unkillAfterList.length,
          (index) => TextEditingController(
              text: unkillAfterList[
                  index])); // Convert the iterable back to a list
    });
  }

  void addNewItemToUnkillEditControllers(String newItem) {
    setState(() {
      unkillEditControllers.add(TextEditingController(text: newItem));
    });
  }

  void removeUnkillEditController(int index) {
    setState(() {
      unkillEditControllers[index]
          .dispose(); // Dispose the controller for the removed item
      unkillEditControllers.removeAt(index);
    });
  }

  void addNewItemToLocationEditControllers(String newItem) {
    setState(() {
      locationEditControllers.add(TextEditingController(text: newItem));
    });
  }

  void removeLocationEditController(int index) {
    setState(() {
      locationEditControllers[index]
          .dispose(); // Dispose the controller for the removed item
      locationEditControllers.removeAt(index);
    });
  }

  void addNewItemToUnlockEditControllers(String newItem) {
    setState(() {
      unlockEditControllers.add(TextEditingController(text: newItem));
    });
  }

  CarApproveOption getCarApproveOptionFromString(String value) {
    switch (value) {
      case 'always':
        return CarApproveOption.always;
      case 'manual':
        return CarApproveOption.manual;
      case 'ai':
        return CarApproveOption.aiApprove;
      default:
        return CarApproveOption.always;
    }
  }

  String getValueFromCarApproveOption(CarApproveOption value) {
    switch (value) {
      case CarApproveOption.always:
        return 'always';
      case CarApproveOption.manual:
        return 'manual';
      case CarApproveOption.aiApprove:
        return 'ai';
    }
  }

  void removeUnlockEditController(int index) {
    setState(() {
      unlockEditControllers[index]
          .dispose(); // Dispose the controller for the removed item
      unlockEditControllers.removeAt(index);
    });
  }

  @override
  void dispose() {
    allotEditController.dispose();
    shareBeforeEditController.dispose();
    shareAfterEditController.dispose();
    autoSendTollEditController.dispose();
    alertGuestEditController.dispose();
    canUploadEditController.dispose();
    aiAvailablePercentEditController.dispose();
    unKillAiPercientEditController.dispose();
    alertGuestAutoSendMessageEditController.dispose();
    unlockAiPercientEditController.dispose();
    approveEmailEditController.dispose();
    carLocationAutoSendMessageEditController.dispose();
    unlockAutoSendMessageEditController.dispose();
    unkillAutoSendMessageEditController.dispose();
    super.dispose();
  }

  void initData() async {
    if (!mounted) return;

    List<String> gmtOffsets = [];

    tz.initializeTimeZones();
    List<String> timeZones = tz.timeZoneDatabase.locations.keys.toList();

    for (String timeZoneName in timeZones) {
      // Load the time zone from the database
      final location = tz.getLocation(timeZoneName);

      // Get the current time in that time zone
      final now = tz.TZDateTime.now(location);

      // Get the offset from UTC (in minutes)
      final offset = now.timeZoneOffset;

      // Convert the offset to hours and minutes (e.g., GMT+X or GMT-X)
      final sign = offset.isNegative ? '-' : '+';
      final hours = offset.inHours.abs();
      final minutes = offset.inMinutes.abs() % 60;

      // Format the GMT string
      String gmtString = 'GMT$sign$hours:${minutes.toString().padLeft(2, '0')}';

      // Print the result
      gmtOffsets.add(gmtString);
    }
    gmtOffsets = gmtOffsets.toSet().toList();
    gmtOffsets.sort((a, b) {
      // Extract the numeric offset from 'GMT+X' or 'GMT-X'
      int offsetA = int.parse(a.replaceAll(RegExp(r'[^+-\d]'), ''));
      int offsetB = int.parse(b.replaceAll(RegExp(r'[^+-\d]'), ''));

      // Compare the numeric offsets
      return offsetA.compareTo(offsetB);
    });

    setState(() {
      timezoneList = gmtOffsets;
    });

    final localLocation = tz.getLocation('US/Eastern');

    // Get the current time in that time zone
    final now = tz.TZDateTime.now(localLocation);

    // Get the offset from UTC (in minutes)
    final offset = now.timeZoneOffset;

    // Convert the offset to hours and minutes (e.g., GMT+X or GMT-X)
    final sign = offset.isNegative ? '-' : '+';
    final hours = offset.inHours.abs();
    final minutes = offset.inMinutes.abs() % 60;

    // Format the GMT string
    selectedTimeZone = 'GMT$sign$hours:${minutes.toString().padLeft(2, '0')}';

    await deviceController.getMainPageData();
    if (deviceController.apiStatus.value == ApiState.failure) {
      Get.snackbar("Failed", deviceController.errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          animationDuration: const Duration(milliseconds: 300));
      setState(() {
        deviceList =[ ];
      });
      return;
    }

    if (deviceController.mainPageData.value != null) {
      setState(() {
        deviceList = deviceController.mainPageData.value;
      });
      if (!mounted) return;
      List<dynamic> matchedItems = deviceList
          .where((item) =>
              item['id'].toString() == dataController.currentDeviceId.value)
          .toList();

      setState(() {
        if (matchedItems.isEmpty) {
          deviceValue = deviceList.first;
        } else {
          deviceValue = matchedItems.first;
        }
      });
    } else {
      setState(() {
        deviceList = [];
      });
    }
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
      setState(() {
        for (TextEditingController controller in locationEditControllers) {
          controller.dispose();
        }
        for (TextEditingController controller in unlockEditControllers) {
          controller.dispose();
        }
        for (TextEditingController controller in unkillEditControllers) {
          controller.dispose();
        }
        locationAvailableList.clear();
        unlockAvailableList.clear();
        unkillAfterList.clear();
        selectedDeviceSharePageData =
            deviceController.selectedDeviceSharePageData.value;
        setTuroTripList(selectedDeviceSharePageData['turoTripList']);
        if (selectedDeviceSharePageData['device']['share_settings'] == null) {
          shareSetting = {};
        } else {
          shareSetting = jsonDecode(
              selectedDeviceSharePageData['device']['share_settings']);
        }
        shareSettingsEnabled = shareSetting['share_setting_enabled'] ?? false;
        availList = shareSetting['avail'] ?? [];

        if (shareSetting['unkill_by'] != null) {
          unkillOption = shareSetting['unkill_by'] == 'renter'
              ? UnkillOPtion.firstUnlockByRenter
              : UnkillOPtion.selfieInsideCar;
        }
        unlockList = shareSetting['unlock'] ?? [];
        carLocationAvailableTime = shareSetting['avail_car'] ?? false;
        unkillList = shareSetting['unkill'] ?? [];
        for (dynamic value in availList) {
          if (value.toString().toLowerCase() == "picture of license") {
            pictureLicense = true;
          } else if (value.toString().toLowerCase() == "selfie with license") {
            selfieLicense = true;
          } else {
            locationAvailableList.add(value.toString());
          }
        }
        for (dynamic value in unkillList) {
          unkillAfterList.add(value.toString());
        }
        for (dynamic value in unlockList) {
          if (value != "Selfie With Car License Plate") {
            unlockAvailableList.add(value.toString());
          } else {
            unlockSelfieLicense = true;
          }
        }
        alertGuest = shareSetting['alert_guest'] ?? false;

        // selectedTimeZone = shareSetting['timezone'];
        unlockWorkTime = shareSetting['unlock_car'] ?? false;
        autoKillSwitch = shareSetting['auto_kill_switch'] ?? false;
        approveEmailEditController.text =
            shareSetting['manual_approve_email'] ?? '';
        alertGuestEditController.text =
            shareSetting['alert_guest_minutes_before'].toString();
        unkillAfter = shareSetting['unkill_car'] ?? false;
        aiAvailablePercentEditController.text =
            (shareSetting['avail_ai_percent'] ?? '').toString();
        alertGuestAutoSendMessageEditController.text =
            shareSetting['alert_guest_auto_send_message'] ?? '';
        unlockAiPercientEditController.text =
            (shareSetting['unlock_ai_percent'] ?? '').toString();
        unKillAiPercientEditController.text =
            (shareSetting['unkill_ai_percent'] ?? '').toString();
        canUploadEditController.text =
            shareSetting['avail_upload_minutes_before'].toString();
        carLocationApproveOptionValue = getCarApproveOptionFromString(
            shareSetting['avail_approve_type'] ?? '');
        unlockCarApproveOptionValue = getCarApproveOptionFromString(
            shareSetting['unlock_approve_type'] ?? '');
        unkillApproveOptionValue = getCarApproveOptionFromString(
            shareSetting['unkill_approve_type'] ?? '');
        carLocationAutoSendMessageEditController.text =
            shareSetting['avail_auto_send_message'] ?? '';
        unlockAutoSendMessageEditController.text =
            shareSetting['unlock_auto_send_message'] ?? '';
        unkillAutoSendMessageEditController.text =
            shareSetting['unkill_auto_send_message'] ?? '';
        allotPerday = shareSetting['allot_per_day'] ?? '';
        shareMinutesBefore =
            (shareSetting['share_minutes_before'] ?? '').toString();
        shareMinutesAfter =
            (shareSetting['share_minutes_after'] ?? '').toString();
        allotEditController.text = allotPerday;
        shareBeforeEditController.text = shareMinutesBefore;
        shareAfterEditController.text = shareMinutesAfter;
        autoLock = shareSetting['auto_lock'] == "true" ? true : false;
        autoSendToll = shareSetting['auto_send_toll'] == "true" ? true : false;
        autoSendTollEditController.text =
            shareSetting['auto_send_toll_email'] ?? '';
        autoSendTollEmail = shareSetting['auto_send_toll_email'] ?? '';
        availAutoSendPicturePath =
            shareSetting['avail_auto_send_picture_preview'] ?? '';
        unlockAutoSendPicturePath =
            shareSetting['unlock_auto_send_picture_preview'] ?? '';
        unkillAutoSendPicturePath =
            shareSetting['unkill_auto_send_picture_preview'] ?? '';
        initializeLocationEditControllers();
        initializeUnkillEditControllers();
        initializeUnlockEditControllers();
      });
    }
  }

  int getDifferencewithTwotimestamp(int startDate, int endDate) {
    DateTime dateTime1 = DateTime.fromMillisecondsSinceEpoch(startDate * 1000);
    DateTime dateTime2 = DateTime.fromMillisecondsSinceEpoch(endDate * 1000);
    Duration difference = dateTime2.difference(dateTime1);

    return difference.inHours;
  }

  void setTuroTripList(List<dynamic> turoTripData) {
    if (turoTripData.isNotEmpty) {
      setState(() {
        turoTripList = []; // Clear the list before adding new items
        for (var element in turoTripData) {
          final String summary = element['summary'] ?? '';
          final List<String> summaryArr = summary.split('-');
          final String summaryStr = summaryArr[0].trim();
          final List<String> summaryWordArr = summaryStr.split(' ');
          final String summaryFirstWord = summaryWordArr.first;
          final String summaryLastWord = summaryWordArr.last;
          final int? startTimestamp = element['start_timestamp'];
          final int? endTimestamp = element['end_timestamp'];
          final String? tzId = element['tzid'];

          String startTime = "";
          String endTime = "";

          if (element['uid'] == null || element['uid'] == "") {
            startTime = getFormattedTime(element['start'], true);
            endTime = getFormattedTime(element['end'], true);
          } else {
            startTime = startTimestamp != null
                ? convertUnixTimestampToTimezone(
                    startTimestamp, "yyyy-MM-dd HH:mm", tzId)
                : "";
            endTime = endTimestamp != null
                ? convertUnixTimestampToTimezone(
                    endTimestamp, "yyyy-MM-dd HH:mm", tzId)
                : "";
          }
          int currentTimeStamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
          int differ =
              getDifferencewithTwotimestamp(currentTimeStamp, startTimestamp!);
          if (differ > -24) {
            final String label =
                "$summaryFirstWord - $summaryLastWord $startTime - $endTime";
            turoTripList.add({
              "id": element['id'],
              "label": label,
              "startTime": startTime,
              "endTime": endTime,
            });
          }
        }
        turoTripList.sort((a, b) => a["startTime"].compareTo(b["startTime"]));
      });
    }
  }

  String convertUnixTimestampToTimezone(
      int unixtimestamp, String format, String? ianaTimezone) {
    try {
      tz.initializeTimeZones();
      final tz.Location location =
          ianaTimezone != null && ianaTimezone.isNotEmpty
              ? tz.getLocation(ianaTimezone)
              : tz.UTC;

      final tz.TZDateTime dateTime = tz.TZDateTime.fromMillisecondsSinceEpoch(
          location, unixtimestamp * 1000);
      return DateFormat(format).format(dateTime);
    } catch (e) {
      return "";
    }
  }

  String getFormattedTime(String? dateStr, [bool isOnlyStr = false]) {
    try {
      if (dateStr == null) return "";
      final DateTime date = DateTime.parse(dateStr);

      // Format the date string
      final String formattedDate =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
      if (isOnlyStr) {
        return formattedDate;
      }
      return formattedDate; // Keeping it simple; no additional library like moment
    } catch (e) {
      print("getFormattedTime error: $e");
      return "";
    }
  }

  void updateDeviceData(String deviceID) async {
    await deviceController.getSelectedShareDevicePageData(deviceID);
    if (deviceController.apiStatus.value == ApiState.success) {
      setState(() {
        selectedDeviceSharePageData =
            deviceController.selectedDeviceSharePageData.value;
        setTuroTripList(selectedDeviceSharePageData['turoTripList']);
        shareSetting =
            selectedDeviceSharePageData['device']['share_settings'] != null
                ? jsonDecode(
                    selectedDeviceSharePageData['device']['share_settings'])
                : {};
        // selectedTimeZone = shareSetting['timezone'];
        allotPerday = shareSetting['allot_per_day'] ?? '';
        shareMinutesBefore =
            (shareSetting['share_minutes_before'] ?? '').toString();
        shareMinutesAfter =
            (shareSetting['share_minutes_after'] ?? '').toString();

        allotEditController.text = allotPerday;
        shareBeforeEditController.text = shareMinutesBefore;
        shareAfterEditController.text = shareMinutesAfter;
        autoLock = (shareSetting['auto_lock'] ?? '') == "true" ? true : false;
        autoSendToll =
            (shareSetting['auto_send_toll'] ?? '') == "true" ? true : false;
        autoSendTollEditController.text =
            shareSetting['auto_send_toll_email'] ?? '';
        autoSendTollEmail = shareSetting['auto_send_toll_email'] ?? '';
      });
    }
  }

  void generateSettings() async {
    DateTime selectedFromDateTime = DateTime(
      selectedFromDate.year,
      selectedFromDate.month,
      selectedFromDate.day,
      selectedFromTime.hour,
      selectedFromTime.minute,
    );
    DateTime selectedToDateTime = DateTime(
      selectedToDate.year,
      selectedToDate.month,
      selectedToDate.day,
      selectedToTime.hour,
      selectedToTime.minute,
    );

    // Convert to UTC
    DateTime selectedFromUtc = selectedFromDateTime.toUtc();
    DateTime selectedToUtc = selectedToDateTime.toUtc();

    List<String> list1 = [];
    if (pictureLicense) {
      list1.add('Picture Of License');
    }
    if (selfieLicense) list1.add('Selfie With License');
    for (TextEditingController controller in locationEditControllers) {
      list1.add(controller.text);
    }

    List<String> list2 = [];
    if (unlockSelfieLicense) list2.add('Selfie With Car License Plate');
    for (TextEditingController controller in unlockEditControllers) {
      list2.add(controller.text);
    }

    List<String> list3 = [];
    for (TextEditingController controller in unkillEditControllers) {
      list3.add(controller.text);
    }

    shareSetting['unkill_by'] =
        unkillOption == UnkillOPtion.firstUnlockByRenter ? "renter" : "picture";
    shareSetting['unlock'] = list2;
    shareSetting['avail'] = list1;
    shareSetting['unkill'] = list3;
    shareSetting['share_setting_enabled'] = shareSettingsEnabled;
    shareSetting['alert_guest'] = alertGuest;
    shareSetting['timezone'] = selectedTimeZone;
    shareSetting['unlock_car'] = unlockWorkTime;
    shareSetting['auto_kill_switch'] = autoKillSwitch;
    shareSetting['manual_approve_email'] = approveEmailEditController.text;
    shareSetting['alert_guest_minutes_before'] = alertGuestEditController.text;
    shareSetting['unkill_car'] = unkillAfter;
    shareSetting['avail_ai_percent'] =
        double.parse(aiAvailablePercentEditController.text);
    shareSetting['alert_guest_auto_send_message'] =
        alertGuestAutoSendMessageEditController.text;
    shareSetting['unlock_ai_percent'] =
        double.parse(unlockAiPercientEditController.text);
    shareSetting['unkill_ai_percent'] =
        double.parse(unKillAiPercientEditController.text);
    shareSetting['avail_upload_minutes_before'] =
        double.parse(canUploadEditController.text);
    shareSetting['avail_approve_type'] =
        getValueFromCarApproveOption(carLocationApproveOptionValue);
    shareSetting['unlock_approve_type'] =
        getValueFromCarApproveOption(unlockCarApproveOptionValue);
    shareSetting['unkill_approve_type'] =
        getValueFromCarApproveOption(unkillApproveOptionValue);
    shareSetting['avail_auto_send_message'] =
        carLocationAutoSendMessageEditController.text;
    shareSetting['unlock_auto_send_message'] =
        unlockAutoSendMessageEditController.text;
    shareSetting['unkill_auto_send_message'] =
        unkillAutoSendMessageEditController.text;
    shareSetting['allot_per_day'] = allotEditController.text;
    shareSetting['share_minutes_before'] =
        double.parse(shareBeforeEditController.text);
    shareSetting['share_minutes_after'] =
        double.parse(shareAfterEditController.text);
    shareSetting['auto_send_toll_email'] = autoSendTollEditController.text;
    shareSetting['auto_send_toll'] = autoSendToll ? "true" : "false";
    shareSetting['auto_lock'] = autoLock ? "true" : "false";
    FormData formData = FormData.fromMap({
      "user_id": authController.storageUserData?['id'],
      "deviceId": deviceValue['id'],
      "from": selectedFromUtc,
      "to": selectedToUtc,
      "shareSetting": jsonEncode(shareSetting),
      "device_id": deviceValue['id'],
      "share_minutes_before": int.parse(shareMinutesBefore),
      "share_minutes_after": int.parse(shareMinutesAfter),
      "allot_miles": double.parse(allotPerday),
      "allot_per_day": double.parse(allotPerday),
      "auto_lock": autoLock,
      "auto_send_toll": autoSendToll,
      "auto_send_toll_email": autoSendTollEmail,
      "daily_lsend_toll": sendTollReportDaily,
      "timezone": selectedTimeZone!,
      "shareUrl": generateSharedUrlId(deviceValue['name']),
      "avail_auto_send_picture": availAutoSendPicture != null
          ? await MultipartFile.fromFile(availAutoSendPicture!.path,
              filename: availAutoSendPicture!.path.split('/').last)
          : availAutoSendPicturePath,
      "unlock_auto_send_picture": unlockAutoSendPicture != null
          ? await MultipartFile.fromFile(unlockAutoSendPicture!.path,
              filename: unlockAutoSendPicture!.path.split('/').last)
          : unlockAutoSendPicturePath,
      "unkill_auto_send_picture": unkillAutoSendPicture != null
          ? await MultipartFile.fromFile(unkillAutoSendPicture!.path,
              filename: unkillAutoSendPicture!.path.split('/').last)
          : unkillAutoSendPicturePath,
    });

    setState(() {
      generating = true;
    });

    await deviceController.updateShareSetting(formData);

    setState(() {
      generatedUrlEditController.text =
          ApiConfig.shareSettingUrl + deviceController.sharedUrl.value;
    });

    if (deviceController.apiStatus.value == ApiState.failure) {
      gt.Get.snackbar("Generating Failed", deviceController.errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          animationDuration: const Duration(milliseconds: 300));
    }

    setState(() {
      generating = false;
    });

    Clipboard.setData(ClipboardData(
        text: shareSetting['sharedTextTemplate']
            .toString()
            .replaceAll('[domain][url]', generatedUrlEditController.text)));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to Clipboard!')),
    );
    initData();
  }

  Future<void> selectFromDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedFromDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedFromDate) {
      setState(() {
        selectedFromDate = pickedDate;
      });
    }
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

  void carLocationAgreeAiApprove() {
    if (carLocationApproveOptionValue != CarApproveOption.aiApprove) {
      gt.Get.defaultDialog(
        radius: 5,
        title: 'MooveTrax',
        middleText:
            'AI matching is done by computer and can be very wrong, AI can not tell the difference between a person holding a picture and just a picture of a picture. Do you want the proceed?',
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                carLocationApproveOptionValue = CarApproveOption.aiApprove;
              });
              gt.Get.back();
            },
            child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'AGREE',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.green),
                )),
          ),
          InkWell(
            onTap: () {
              gt.Get.back();
            },
            child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'DECLINE',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                )),
          ),
        ],
      );
    } else {
      setState(() {
        carLocationApproveOptionValue = CarApproveOption.aiApprove;
      });
    }
  }

  void unkillAgreeAiApprove() {
    if (unkillApproveOptionValue != CarApproveOption.aiApprove) {
      gt.Get.defaultDialog(
        radius: 5,
        title: 'MooveTrax',
        middleText:
            'AI matching is done by computer and can be very wrong, AI can not tell the difference between a person holding a picture and just a picture of a picture. Do you want the proceed?',
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                unkillApproveOptionValue = CarApproveOption.aiApprove;
              });
              gt.Get.back();
            },
            child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'AGREE',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.green),
                )),
          ),
          InkWell(
            onTap: () {
              gt.Get.back();
            },
            child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'DECLINE',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                )),
          ),
        ],
      );
    } else {
      setState(() {
        unkillApproveOptionValue = CarApproveOption.aiApprove;
      });
    }
  }

  void unlockAgreeAiApprove() {
    if (unlockCarApproveOptionValue != CarApproveOption.aiApprove) {
      gt.Get.defaultDialog(
        radius: 5,
        title: 'MooveTrax',
        middleText:
            'AI matching is done by computer and can be very wrong, AI can not tell the difference between a person holding a picture and just a picture of a picture. Do you want the proceed?',
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                unlockCarApproveOptionValue = CarApproveOption.aiApprove;
              });
              gt.Get.back();
            },
            child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'AGREE',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.green),
                )),
          ),
          InkWell(
            onTap: () {
              gt.Get.back();
            },
            child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'DECLINE',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                )),
          ),
        ],
      );
    } else {
      setState(() {
        unlockCarApproveOptionValue = CarApproveOption.aiApprove;
      });
    }
  }

  Future<void> selectFromTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedFromTime,
    );
    if (pickedTime != null && pickedTime != selectedFromTime) {
      setState(() {
        selectedFromTime = pickedTime;
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

  Widget uploadRequirementsDetailsField() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                      width: 40 * dataController.currentScaleFactor.value,
                      height: 40 * dataController.currentScaleFactor.value,
                      child: Checkbox(
                          value: alertGuest,
                          onChanged: (value) {
                            setState(() {
                              alertGuest = !alertGuest;
                            });
                          })),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          alertGuest = !alertGuest;
                        });
                      },
                      child: Text("Alert guest",
                          style: TextStyle(
                              fontSize: dataController.normalTextSize.value))),
                  SizedBox(
                    width: 10 * dataController.currentScaleFactor.value,
                  ),
                  Expanded(
                    child: TextField(
                      controller: alertGuestEditController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter
                            .digitsOnly, // Allow only digits (0-9)
                      ],
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                      decoration: InputDecoration(
                          label: const Text('Minutes Before Start of Trip'),
                          labelStyle: TextStyle(
                              fontSize: dataController.normalTextSize.value)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Auto send Message',
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                  ),
                  SizedBox(width: 10 * dataController.currentScaleFactor.value),
                  TextField(
                    controller: alertGuestAutoSendMessageEditController,
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                  )
                ],
              )
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                      width: 40 * dataController.currentScaleFactor.value,
                      height: 40 * dataController.currentScaleFactor.value,
                      child: Checkbox(
                          value: carLocationAvailableTime,
                          onChanged: (value) {
                            setState(() {
                              carLocationAvailableTime = value!;
                            });
                          })),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          carLocationAvailableTime = !carLocationAvailableTime;
                        });
                      },
                      child: Text(
                        "Car location becomes available after",
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      )),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Can Upload',
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                  ),
                  SizedBox(
                    width: 10 * dataController.currentScaleFactor.value,
                  ),
                  Flexible(
                      child: TextField(
                    controller: canUploadEditController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter
                          .digitsOnly, // Allow only digits (0-9)
                    ],
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                    decoration: InputDecoration(
                        label: const Text('Minutes Before Trip'),
                        labelStyle: TextStyle(
                            fontSize: dataController.normalTextSize.value)),
                  )),
                ],
              ),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              Row(
                children: [
                  SizedBox(
                      width: 40 * dataController.currentScaleFactor.value,
                      height: 40 * dataController.currentScaleFactor.value,
                      child: Checkbox(
                          value: pictureLicense & carLocationAvailableTime,
                          onChanged: carLocationAvailableTime == false
                              ? null
                              : (value) {
                                  setState(() {
                                    pictureLicense = !pictureLicense;
                                  });
                                })),
                  SizedBox(
                    width: 10 * dataController.currentScaleFactor.value,
                  ),
                  Expanded(
                      child: TextField(
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                    enabled: false,
                    decoration: InputDecoration(
                        hintText: "Picture Of License",
                        hintStyle: TextStyle(
                            fontSize: dataController.normalTextSize.value)),
                  )),
                ],
              ),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              Row(
                children: [
                  SizedBox(
                      width: 40 * dataController.currentScaleFactor.value,
                      height: 40 * dataController.currentScaleFactor.value,
                      child: Checkbox(
                          value: selfieLicense & carLocationAvailableTime,
                          onChanged: carLocationAvailableTime
                              ? (value) {
                                  setState(() {
                                    selfieLicense = !selfieLicense;
                                  });
                                }
                              : null)),
                  SizedBox(
                    width: 10 * dataController.currentScaleFactor.value,
                  ),
                  Expanded(
                      child: TextField(
                    enabled: false,
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                    decoration: InputDecoration(
                        hintText: "Selfie with License",
                        hintStyle: TextStyle(
                            fontSize: dataController.normalTextSize.value)),
                  )),
                ],
              ),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              if (carLocationAvailableTime)
                ListView.builder(
                  itemCount: locationAvailableList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: TextField(
                        controller: locationEditControllers[index],
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                        onChanged: (value) {
                          setState(() {
                            locationAvailableList[index] = value;
                          });
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.close,
                          size: dataController.iconSize.value,
                        ),
                        onPressed: () {
                          setState(() {
                            locationAvailableList.removeAt(index);
                            removeLocationEditController(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              if (carLocationAvailableTime)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                        width: 120 * dataController.currentScaleFactor.value,
                        child: DefaultButton(
                            text: 'ADD NEW',
                            press: () {
                              setState(() {
                                locationAvailableList.add('');
                                addNewItemToLocationEditControllers('');
                              });
                            })),
                  ],
                ),
              Row(children: [
                SizedBox(
                    width: 40 * dataController.currentScaleFactor.value,
                    height: 40 * dataController.currentScaleFactor.value,
                    child: Radio<CarApproveOption>(
                      value: CarApproveOption.always,
                      groupValue: carLocationApproveOptionValue,
                      onChanged: (CarApproveOption? value) {
                        setState(() {
                          carLocationApproveOptionValue = value!;
                        });
                      },
                    )),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        carLocationApproveOptionValue = CarApproveOption.always;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20 * dataController.currentScaleFactor.value),
                      child: Text(
                        'Always Approve',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                    ))
              ]),
              Row(children: [
                SizedBox(
                    width: 40 * dataController.currentScaleFactor.value,
                    height: 40 * dataController.currentScaleFactor.value,
                    child: Radio<CarApproveOption>(
                      value: CarApproveOption.manual,
                      groupValue: carLocationApproveOptionValue,
                      onChanged: (CarApproveOption? value) {
                        setState(() {
                          carLocationApproveOptionValue = value!;
                        });
                      },
                    )),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        carLocationApproveOptionValue = CarApproveOption.manual;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20 * dataController.currentScaleFactor.value),
                      child: Text(
                        'Manual Approve',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                    ))
              ]),
              Row(children: [
                SizedBox(
                    width: 40 * dataController.currentScaleFactor.value,
                    height: 40 * dataController.currentScaleFactor.value,
                    child: Radio<CarApproveOption>(
                      value: CarApproveOption.aiApprove,
                      groupValue: carLocationApproveOptionValue,
                      onChanged: (CarApproveOption? value) {
                        carLocationAgreeAiApprove();
                      },
                    )),
                GestureDetector(
                    onTap: () {
                      carLocationAgreeAiApprove();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20 * dataController.currentScaleFactor.value),
                      child: Text(
                        'AI Approve',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                    )),
                SizedBox(
                  width: 10 * dataController.currentScaleFactor.value,
                ),
                SizedBox(
                    width: 80 * dataController.currentScaleFactor.value,
                    child: TextField(
                      controller: aiAvailablePercentEditController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    )),
                SizedBox(
                  width: 10 * dataController.currentScaleFactor.value,
                ),
                Text(
                  '%',
                  style:
                      TextStyle(fontSize: dataController.normalTextSize.value),
                )
              ]),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              Row(
                children: [
                  Text(
                    'Approve Email',
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                  ),
                  SizedBox(
                    width: 10 * dataController.currentScaleFactor.value,
                  ),
                  Expanded(
                    child: TextField(
                      controller: approveEmailEditController,
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              Row(
                children: [
                  Text(
                    'Auto send Message',
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                  ),
                  SizedBox(
                    width: 10 * dataController.currentScaleFactor.value,
                  ),
                  Expanded(
                    child: TextField(
                      controller: carLocationAutoSendMessageEditController,
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              Row(
                children: [
                  Text(
                    'Auto send Picture',
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                  ),
                  const Spacer(),
                  SizedBox(
                      width: 120 * dataController.currentScaleFactor.value,
                      child: Column(
                        children: [
                          // Check if unlockAutoSendPicturePath is not an empty string
                          if (availAutoSendPicturePath.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8.0), // Optional: add padding
                              child: availAutoSendPicturePath.startsWith('http')
                                  ? Image.network(
                                      availAutoSendPicturePath,
                                      width: 120 *
                                          dataController
                                              .currentScaleFactor.value,
                                      height: 120 *
                                          dataController
                                              .currentScaleFactor.value,
                                      fit: BoxFit.cover, // Adjust the fit style
                                    )
                                  : Image.file(
                                      File(availAutoSendPicturePath),
                                      width: 120 *
                                          dataController
                                              .currentScaleFactor.value,
                                      height: 120 *
                                          dataController
                                              .currentScaleFactor.value,
                                      fit: BoxFit.cover, // Adjust the fit style
                                    ),
                            ),
                          ImagePickerComponent(
                            onImagePicked: (File image) {
                              setState(() {
                                availAutoSendPicturePath = image.path;
                                availAutoSendPicture = image;
                              });
                            },
                          ),
                        ],
                      ))
                ],
              )
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                      width: 40 * dataController.currentScaleFactor.value,
                      height: 40 * dataController.currentScaleFactor.value,
                      child: Checkbox(
                          value: unlockWorkTime,
                          onChanged: (value) {
                            setState(() {
                              unlockWorkTime = value!;
                            });
                          })),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          unlockWorkTime = !unlockWorkTime;
                        });
                      },
                      child: Text("Unlock will work after",
                          style: TextStyle(
                              fontSize: dataController.normalTextSize.value))),
                ],
              ),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              Row(
                children: [
                  SizedBox(
                      width: 40 * dataController.currentScaleFactor.value,
                      height: 40 * dataController.currentScaleFactor.value,
                      child: Checkbox(
                          value: unlockSelfieLicense & unlockWorkTime,
                          onChanged: unlockWorkTime
                              ? (value) {
                                  setState(() {
                                    unlockSelfieLicense = !unlockSelfieLicense;
                                  });
                                }
                              : null)),
                  SizedBox(
                    width: 10 * dataController.currentScaleFactor.value,
                  ),
                  const Expanded(
                      child: TextField(
                    enabled: false,
                    decoration: InputDecoration(
                        hintText: "Selfie With Car License Plate"),
                  )),
                ],
              ),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              if (unlockWorkTime)
                ListView.builder(
                  itemCount: unlockAvailableList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: TextField(
                        decoration: InputDecoration(
                            hintText: unlockAvailableList[index]),
                        controller: unlockEditControllers[index],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          setState(() {
                            unlockAvailableList.removeAt(index);
                            removeUnlockEditController(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              if (unlockWorkTime)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                        width: 120,
                        child: DefaultButton(
                            text: 'ADD NEW',
                            press: () {
                              setState(() {
                                unlockAvailableList.add('');
                                addNewItemToUnlockEditControllers('');
                              });
                            })),
                  ],
                ),
              Row(children: [
                SizedBox(
                    width: 40 * dataController.currentScaleFactor.value,
                    height: 40 * dataController.currentScaleFactor.value,
                    child: Radio<CarApproveOption>(
                      value: CarApproveOption.always,
                      groupValue: unlockCarApproveOptionValue,
                      onChanged: (CarApproveOption? value) {
                        setState(() {
                          unlockCarApproveOptionValue = value!;
                        });
                      },
                    )),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        unlockCarApproveOptionValue = CarApproveOption.always;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20 * dataController.currentScaleFactor.value),
                      child: Text(
                        'Always Approve',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                    ))
              ]),
              Row(children: [
                SizedBox(
                    width: 40 * dataController.currentScaleFactor.value,
                    height: 40 * dataController.currentScaleFactor.value,
                    child: Radio<CarApproveOption>(
                      value: CarApproveOption.manual,
                      groupValue: unlockCarApproveOptionValue,
                      onChanged: (CarApproveOption? value) {
                        setState(() {
                          unlockCarApproveOptionValue = value!;
                        });
                      },
                    )),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        unlockCarApproveOptionValue = CarApproveOption.manual;
                      });
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20 * dataController.currentScaleFactor.value),
                      child: Text(
                        'Manual Approve',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                    ))
              ]),
              Row(children: [
                SizedBox(
                    width: 40 * dataController.currentScaleFactor.value,
                    height: 40 * dataController.currentScaleFactor.value,
                    child: Radio<CarApproveOption>(
                      value: CarApproveOption.aiApprove,
                      groupValue: unlockCarApproveOptionValue,
                      onChanged: (CarApproveOption? value) {
                        unlockAgreeAiApprove();
                      },
                    )),
                GestureDetector(
                    onTap: () {
                      unlockAgreeAiApprove();
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 20 * dataController.currentScaleFactor.value),
                      child: Text(
                        'AI Approve',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                    )),
                SizedBox(
                  width: 10 * dataController.currentScaleFactor.value,
                ),
                SizedBox(
                    width: 80 * dataController.currentScaleFactor.value,
                    child: TextField(
                      controller: unlockAiPercientEditController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    )),
                SizedBox(
                  width: 10 * dataController.currentScaleFactor.value,
                ),
                Text(
                  '%',
                  style:
                      TextStyle(fontSize: dataController.normalTextSize.value),
                )
              ]),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              Row(
                children: [
                  Text(
                    'Auto send Message',
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                  ),
                  SizedBox(
                    width: 10 * dataController.currentScaleFactor.value,
                  ),
                  Expanded(
                    child: TextField(
                      controller: unlockAutoSendMessageEditController,
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20 * dataController.currentScaleFactor.value,
              ),
              Row(
                children: [
                  Text(
                    'Auto send Picture',
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                  ),
                  const Spacer(),
                  SizedBox(
                      width: 120 * dataController.currentScaleFactor.value,
                      child: Column(
                        children: [
                          // Check if unlockAutoSendPicturePath is not an empty string
                          if (unlockAutoSendPicturePath.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8.0), // Optional: add padding
                              child: unlockAutoSendPicturePath
                                      .startsWith('http')
                                  ? Image.network(
                                      unlockAutoSendPicturePath,
                                      width: 120 *
                                          dataController
                                              .currentScaleFactor.value,
                                      height: 120 *
                                          dataController
                                              .currentScaleFactor.value,
                                      fit: BoxFit.cover, // Adjust the fit style
                                    )
                                  : Image.file(
                                      File(unlockAutoSendPicturePath),
                                      width: 120 *
                                          dataController
                                              .currentScaleFactor.value,
                                      height: 120 *
                                          dataController
                                              .currentScaleFactor.value,
                                      fit: BoxFit.cover, // Adjust the fit style
                                    ),
                            ),
                          ImagePickerComponent(
                            onImagePicked: (File image) {
                              setState(() {
                                unlockAutoSendPicture = image;
                                unlockAutoSendPicturePath = image.path;
                              });
                            },
                          ),
                        ],
                      )),
                ],
              )
            ],
          ),
        ),
        Row(
          children: [
            SizedBox(
                width: 40 * dataController.currentScaleFactor.value,
                height: 40 * dataController.currentScaleFactor.value,
                child: Checkbox(
                    value: autoKillSwitch,
                    onChanged: (value) {
                      setState(() {
                        autoKillSwitch = !autoKillSwitch;
                      });
                    })),
            GestureDetector(
                onTap: () {
                  setState(() {
                    autoKillSwitch = !autoKillSwitch;
                  });
                },
                child: Text("Auto killswitch",
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value))),
          ],
        ),
        if (autoKillSwitch)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Colors.grey,
                width: 1,
              ),
            ),
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Row(
                //   children: [
                //     SizedBox(
                //         width: 40 * dataController.currentScaleFactor.value,
                //         height: 40 * dataController.currentScaleFactor.value,
                //         child: Checkbox(
                //             value: unkillAfter,
                //             onChanged: (value) {
                //               setState(() {
                //                 unkillAfter = value!;
                //               });
                //             })),
                //     GestureDetector(
                //         onTap: () {
                //           setState(() {
                //             unkillAfter = !unkillAfter;
                //           });
                //         },
                //         child: Text("Car will unkill after",
                //             style: TextStyle(
                //                 fontSize:
                //                     dataController.normalTextSize.value))),
                //   ],
                // ),
                // SizedBox(
                //   height: 20 * dataController.currentScaleFactor.value,
                // ),
                Row(
                  children: [
                    SizedBox(
                        width: 40 * dataController.currentScaleFactor.value,
                        height: 40 * dataController.currentScaleFactor.value,
                        child: Radio<UnkillOPtion>(
                            value: UnkillOPtion.firstUnlockByRenter,
                            groupValue: unkillOption,
                            onChanged: unkillAfter
                                ? (UnkillOPtion? value) {
                                    setState(() {
                                      unkillOption = value!;
                                    });
                                  }
                                : null)),
                    SizedBox(
                      width: 10 * dataController.currentScaleFactor.value,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          unkillOption = UnkillOPtion.firstUnlockByRenter;
                        });
                      },
                      child: const Text("First Unlock By Renter"),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20 * dataController.currentScaleFactor.value,
                ),
                Row(
                  children: [
                    SizedBox(
                        width: 40 * dataController.currentScaleFactor.value,
                        height: 40 * dataController.currentScaleFactor.value,
                        child: Radio<UnkillOPtion>(
                            value: UnkillOPtion.selfieInsideCar,
                            groupValue: unkillOption,
                            onChanged: unkillAfter
                                ? (UnkillOPtion? value) {
                                    setState(() {
                                      unkillOption = value!;
                                    });
                                  }
                                : null)),
                    SizedBox(
                      width: 10 * dataController.currentScaleFactor.value,
                    ),
                    const Expanded(
                        child: TextField(
                      enabled: false,
                      decoration:
                          InputDecoration(hintText: "Selfie Inside Car"),
                    )),
                  ],
                ),
                SizedBox(
                  height: 20 * dataController.currentScaleFactor.value,
                ),
                if (unkillAfter)
                  ListView.builder(
                    itemCount: unkillAfterList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: TextField(
                          decoration:
                              InputDecoration(hintText: unkillAfterList[index]),
                          controller: unkillEditControllers[index],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              unkillAfterList.removeAt(index);
                              removeUnkillEditController(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                //   if (unkillAfter)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                        width: 120,
                        child: DefaultButton(
                            text: 'ADD NEW',
                            press: () {
                              setState(() {
                                unkillAfterList.add('');
                                addNewItemToUnkillEditControllers('');
                              });
                            })),
                  ],
                ),
                Row(children: [
                  SizedBox(
                      width: 40 * dataController.currentScaleFactor.value,
                      height: 40 * dataController.currentScaleFactor.value,
                      child: Radio<CarApproveOption>(
                        value: CarApproveOption.always,
                        groupValue: unkillApproveOptionValue,
                        onChanged: (CarApproveOption? value) {
                          setState(() {
                            unkillApproveOptionValue = value!;
                          });
                        },
                      )),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          unkillApproveOptionValue = CarApproveOption.always;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 20 * dataController.currentScaleFactor.value),
                        child: Text(
                          'Always Approve',
                          style: TextStyle(
                              fontSize: dataController.normalTextSize.value),
                        ),
                      ))
                ]),
                Row(children: [
                  SizedBox(
                      width: 40 * dataController.currentScaleFactor.value,
                      height: 40 * dataController.currentScaleFactor.value,
                      child: Radio<CarApproveOption>(
                        value: CarApproveOption.manual,
                        groupValue: unkillApproveOptionValue,
                        onChanged: (CarApproveOption? value) {
                          setState(() {
                            unkillApproveOptionValue = value!;
                          });
                        },
                      )),
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          unkillApproveOptionValue = CarApproveOption.manual;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 20 * dataController.currentScaleFactor.value),
                        child: Text(
                          'Manual Approve',
                          style: TextStyle(
                              fontSize: dataController.normalTextSize.value),
                        ),
                      ))
                ]),
                Row(children: [
                  SizedBox(
                      width: 40 * dataController.currentScaleFactor.value,
                      height: 40 * dataController.currentScaleFactor.value,
                      child: Radio<CarApproveOption>(
                        value: CarApproveOption.aiApprove,
                        groupValue: unkillApproveOptionValue,
                        onChanged: (CarApproveOption? value) {
                          unkillAgreeAiApprove();
                        },
                      )),
                  GestureDetector(
                      onTap: () {
                        unkillAgreeAiApprove();
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 20 * dataController.currentScaleFactor.value),
                        child: Text(
                          'AI Approve',
                          style: TextStyle(
                              fontSize: dataController.normalTextSize.value),
                        ),
                      )),
                  SizedBox(
                    width: 10 * dataController.currentScaleFactor.value,
                  ),
                  SizedBox(
                      width: 80 * dataController.currentScaleFactor.value,
                      child: TextField(
                        controller: unKillAiPercientEditController,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      )),
                  SizedBox(
                    width: 10 * dataController.currentScaleFactor.value,
                  ),
                  Text(
                    '%',
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                  )
                ]),
                SizedBox(
                  height: 20 * dataController.currentScaleFactor.value,
                ),
                Row(
                  children: [
                    Text(
                      'Auto send Message',
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                    SizedBox(
                      width: 10 * dataController.currentScaleFactor.value,
                    ),
                    Expanded(
                      child: TextField(
                        controller: unkillAutoSendMessageEditController,
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 20 * dataController.currentScaleFactor.value,
                ),
                Row(
                  children: [
                    Text(
                      'Auto send Picture',
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                    const Spacer(),
                    SizedBox(
                        width: 120 * dataController.currentScaleFactor.value,
                        child: Column(
                          children: [
                            // Check if unlockAutoSendPicturePath is not an empty string
                            if (unkillAutoSendPicturePath.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8.0), // Optional: add padding
                                child:
                                    unkillAutoSendPicturePath.startsWith('http')
                                        ? Image.network(
                                            unkillAutoSendPicturePath,
                                            width: 120 *
                                                dataController
                                                    .currentScaleFactor.value,
                                            height: 120 *
                                                dataController
                                                    .currentScaleFactor.value,
                                            fit: BoxFit
                                                .cover, // Adjust the fit style
                                          )
                                        : Image.file(
                                            File(unkillAutoSendPicturePath),
                                            width: 120 *
                                                dataController
                                                    .currentScaleFactor.value,
                                            height: 120 *
                                                dataController
                                                    .currentScaleFactor.value,
                                            fit: BoxFit
                                                .cover, // Adjust the fit style
                                          ),
                              ),
                            ImagePickerComponent(
                              onImagePicked: (File image) {
                                setState(() {
                                  unkillAutoSendPicture = image;
                                  unkillAutoSendPicturePath = image.path;
                                });
                              },
                            ),
                          ],
                        ))
                  ],
                )
              ],
            ),
          ),
      ],
    );
  }

  void agreeWithUploadRequirements() {
    if (shareSettingsEnabled == false) {
      gt.Get.defaultDialog(
        radius: 5,
        title: 'MooveTrax',
        middleText: 'MooveTrax will use AI to extract data from the picture.',
        actions: [
          InkWell(
            onTap: () {
              setState(() {
                shareSettingsEnabled = true;
              });
              gt.Get.back();
            },
            child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'AGREE',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.green),
                )),
          ),
          InkWell(
            onTap: () {
              setState(() {
                shareSettingsEnabled = false;
              });
              gt.Get.back();
            },
            child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'DECLINE',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                )),
          ),
        ],
      );
    } else {
      setState(() {
        shareSettingsEnabled = false;
      });
    }
  }

  Widget uploadRequirementsField() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: MediaQuery.of(context).size.width < 400
          ? Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Row(
                children: [
                  SizedBox(
                      width: 40 * dataController.currentScaleFactor.value,
                      height: 40 * dataController.currentScaleFactor.value,
                      child: Checkbox(
                          value: shareSettingsEnabled,
                          onChanged: (value) {
                            agreeWithUploadRequirements();
                          })),
                  InkWell(
                      onTap: () {
                        agreeWithUploadRequirements();
                      },
                      child: Text(
                        "With Upload Requirements",
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      )),
                  SizedBox(width: 5 * dataController.currentScaleFactor.value),
                  Tooltip(
                      showDuration: const Duration(seconds: 5),
                      message:
                          "Renter will be forced to upload some pictures in order to access the car",
                      triggerMode: TooltipTriggerMode.tap,
                      child: Icon(
                        Icons.info,
                        size: dataController.iconSize.value,
                      )),
                ],
              ),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return YouTubePlayerDialog(
                            videoId: howToUploadRequirementsVideo);
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    'Video',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: dataController.normalTextSize.value),
                  ),
                ),
              )
            ])
          : Row(
              children: [
                SizedBox(
                    width: 40 * dataController.currentScaleFactor.value,
                    height: 40 * dataController.currentScaleFactor.value,
                    child: Checkbox(
                        value: shareSettingsEnabled,
                        onChanged: (value) {
                          agreeWithUploadRequirements();
                        })),
                InkWell(
                    onTap: () {
                      agreeWithUploadRequirements();
                    },
                    child: Text(
                      "With Upload Requirements",
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    )),
                SizedBox(width: 5 * dataController.currentScaleFactor.value),
                Tooltip(
                    showDuration: const Duration(seconds: 5),
                    message:
                        "Renter will be forced to upload some pictures in order to access the car",
                    triggerMode: TooltipTriggerMode.tap,
                    child: Icon(
                      Icons.info,
                      size: dataController.iconSize.value,
                    )),
                SizedBox(width: 5 * dataController.currentScaleFactor.value),
                InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return YouTubePlayerDialog(
                              videoId: howToUploadRequirementsVideo);
                        });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'Video',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: dataController.normalTextSize.value),
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Widget deviceField() {
    return DropdownMenu<dynamic>(
      expandedInsets: const EdgeInsets.all(0),
      initialSelection: deviceValue,
      textStyle: TextStyle(fontSize: dataController.normalTextSize.value),
      onSelected: (dynamic value) {
        setState(() {
          deviceValue = value;
          updateDeviceData(deviceValue['id'].toString());
        });
      },
      dropdownMenuEntries:
          deviceList.map<DropdownMenuEntry<dynamic>>((dynamic value) {
        return DropdownMenuEntry<dynamic>(
            value: value,
            label: value['name'],
            style: ButtonStyle(
                textStyle: WidgetStateProperty.all(
                    TextStyle(fontSize: dataController.normalTextSize.value))));
      }).toList(),
    );
  }

  Widget turoTripField() {
    return DropdownMenu<dynamic>(
      expandedInsets: const EdgeInsets.all(0),
      initialSelection: deviceValue,
      textStyle: TextStyle(fontSize: dataController.normalTextSize.value),
      onSelected: (dynamic value) {
        setState(() {
          DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
          selectedFromDate = dateFormat.parse(value['startTime']);

          selectedFromTime = TimeOfDay(
              hour: selectedFromDate.hour, minute: selectedFromDate.minute);

          selectedToDate = dateFormat.parse(value['endTime']);
          selectedToTime = TimeOfDay(
              hour: selectedToDate.hour, minute: selectedToDate.minute);
        });
      },
      dropdownMenuEntries:
          turoTripList.map<DropdownMenuEntry<dynamic>>((dynamic value) {
        return DropdownMenuEntry<dynamic>(
            value: value,
            label: value['label'],
            style: ButtonStyle(
                textStyle: WidgetStateProperty.all(
                    TextStyle(fontSize: dataController.normalTextSize.value))));
      }).toList(),
    );
  }

  Widget timeZoneField() {
    return DropdownButton<String>(
      isExpanded: true,
      value: selectedTimeZone,
      hint: Text(
        'Select a time zone',
        style: TextStyle(fontSize: dataController.normalTextSize.value),
      ),
      items: timezoneList.map((String timeZone) {
        return DropdownMenuItem<String>(
          value: timeZone,
          child: Text(
            timeZone,
            style: TextStyle(fontSize: dataController.normalTextSize.value),
          ),
        );
      }).toList(),
      onChanged: (String? value) {
        setState(() {
          selectedTimeZone = value;
        });
      },
    );
  }

  Widget autoSendTollField() {
    return Row(
      children: [
        SizedBox(
            width: 40 * dataController.currentScaleFactor.value,
            height: 40 * dataController.currentScaleFactor.value,
            child: Checkbox(
                value: autoSendToll,
                onChanged: (value) {
                  setState(() {
                    autoSendToll = value!;
                  });
                })),
        GestureDetector(
            onTap: () {
              setState(() {
                autoSendToll = !autoSendToll;
              });
            },
            child: Text("Auto send toll",
                style:
                    TextStyle(fontSize: dataController.normalTextSize.value))),
        SizedBox(
          width: 20 * dataController.currentScaleFactor.value,
        ),
        Expanded(
            child: TextField(
          controller: autoSendTollEditController,
          onChanged: (value) {
            setState(() {
              autoSendTollEmail = value;
            });
          },
          style: TextStyle(fontSize: dataController.normalTextSize.value),
        ))
      ],
    );
  }

  Widget turoAndAllotField() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            gt.Get.dialog(Dialog(
                insetPadding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10.0), // Set the border radius
                ),
                child: TuroSetupWidget(onChanged: (value) {})));
          },
          child: Padding(
              padding:
                  EdgeInsets.all(5 * dataController.currentScaleFactor.value),
              child: Text(
                'Turo Setup',
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: dataController.normalTextSize.value),
              )),
        ),
        SizedBox(width: 5 * dataController.currentScaleFactor.value),
        Text(
          'Allot',
          style: TextStyle(fontSize: dataController.normalTextSize.value),
        ),
        SizedBox(width: 5 * dataController.currentScaleFactor.value),
        SizedBox(
            width: 80 * dataController.currentScaleFactor.value,
            child: TextField(
              controller: allotEditController,
              style: TextStyle(fontSize: dataController.normalTextSize.value),
              onChanged: (value) {
                setState(() {
                  allotPerday = value;
                });
              },
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 12 * dataController.currentScaleFactor.value,
                      horizontal: 8 * dataController.currentScaleFactor.value)),
            )),
        SizedBox(width: 5 * dataController.currentScaleFactor.value),
        Text(
          'Miles',
          style: TextStyle(fontSize: dataController.normalTextSize.value),
        ),
        SizedBox(width: 10 * dataController.currentScaleFactor.value),
        Tooltip(
            showDuration: const Duration(seconds: 5),
            message: "How many miles is included is included in this trip",
            triggerMode: TooltipTriggerMode.tap,
            child: Icon(
              Icons.info,
              size: dataController.iconSize.value,
            ))
      ],
    );
  }

  Widget fromSelectField() {
    return Row(children: [
      Flexible(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('    From',
              style: TextStyle(fontSize: dataController.normalTextSize.value)),
          Row(children: [
            InkWell(
              onTap: () => selectFromDate(context),
              child: Padding(
                  padding: EdgeInsets.all(
                      5 * dataController.currentScaleFactor.value),
                  child: Text(
                    DateFormat('yyyy-MM-dd')
                        .format(selectedFromDate)
                        .toString(),
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: dataController.normalTextSize.value),
                  )),
            ),
            InkWell(
              onTap: () => selectFromTime(context),
              child: Padding(
                  padding: EdgeInsets.all(
                      5 * dataController.currentScaleFactor.value),
                  child: Text(
                    selectedFromTime.format(context),
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: dataController.normalTextSize.value),
                  )),
            ),
          ])
        ],
      )),
      SizedBox(
          width: 120 * dataController.currentScaleFactor.value,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Minutes Before',
              style: TextStyle(fontSize: dataController.normalTextSize.value),
            ),
            TextField(
              controller: shareBeforeEditController,
              style: TextStyle(fontSize: dataController.normalTextSize.value),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  shareMinutesBefore = value;
                });
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 12 * dataController.currentScaleFactor.value,
                      horizontal: 8 * dataController.currentScaleFactor.value)),
            )
          ])),
    ]);
  }

  Widget toSelectField() {
    return Row(children: [
      Flexible(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('    To',
              style: TextStyle(fontSize: dataController.normalTextSize.value)),
          Row(children: [
            InkWell(
              onTap: () => selectToDate(context),
              child: Padding(
                  padding: EdgeInsets.all(
                      5 * dataController.currentScaleFactor.value),
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(selectedToDate).toString(),
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
          ])
        ],
      )),
      SizedBox(
          width: 120 * dataController.currentScaleFactor.value,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'Minutes After',
              style: TextStyle(fontSize: dataController.normalTextSize.value),
            ),
            TextField(
              controller: shareAfterEditController,
              style: TextStyle(fontSize: dataController.normalTextSize.value),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  shareMinutesAfter = value;
                });
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                      vertical: 12 * dataController.currentScaleFactor.value,
                      horizontal: 8 * dataController.currentScaleFactor.value)),
            )
          ])),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: dataController.appBarHeight.value,
          title: Text(
            "Share Link",
            style: TextStyle(fontSize: dataController.appBarTitleSize.value),
          ),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
              onPressed: () {
                gt.Get.back();
              },
              icon: Icon(Icons.arrow_back_ios_new,
                  size: dataController.iconSize.value)),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(
                    10 * dataController.currentScaleFactor.value),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Devices',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      deviceField(),
                      SizedBox(
                        height: 20 * dataController.currentScaleFactor.value,
                      ),
                      Text(
                        'Select Turo Trip',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      turoTripField(),
                      SizedBox(
                        height: 20 * dataController.currentScaleFactor.value,
                      ),
                      turoAndAllotField(),
                      SizedBox(
                        height: 10 * dataController.currentScaleFactor.value,
                      ),
                      Text(
                        'Timezone',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      timeZoneField(),
                      SizedBox(
                        height: 20 * dataController.currentScaleFactor.value,
                      ),
                      fromSelectField(),
                      SizedBox(
                        height: 20 * dataController.currentScaleFactor.value,
                      ),
                      toSelectField(),
                      Row(
                        children: [
                          SizedBox(
                              width:
                                  40 * dataController.currentScaleFactor.value,
                              height:
                                  40 * dataController.currentScaleFactor.value,
                              child: Checkbox(
                                  value: autoLock,
                                  onChanged: (value) {
                                    setState(() {
                                      autoLock = value!;
                                    });
                                  })),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  autoLock = !autoLock;
                                });
                              },
                              child: Text("Auto Lock",
                                  style: TextStyle(
                                      fontSize: dataController
                                          .normalTextSize.value))),
                          SizedBox(
                              width:
                                  10 * dataController.currentScaleFactor.value),
                          Tooltip(
                              showDuration: const Duration(seconds: 5),
                              message: "Lock will be sent at the end of trip.",
                              triggerMode: TooltipTriggerMode.tap,
                              child: Icon(
                                Icons.info,
                                size: dataController.iconSize.value,
                              ))
                        ],
                      ),
                      SizedBox(
                        height: 10 * dataController.currentScaleFactor.value,
                      ),
                      uploadRequirementsField(),
                      SizedBox(
                        height: 10 * dataController.currentScaleFactor.value,
                      ),
                      if (shareSettingsEnabled)
                        uploadRequirementsDetailsField(),
                      if (shareSettingsEnabled)
                        SizedBox(
                          height: 10 * dataController.currentScaleFactor.value,
                        ),
                      autoSendTollField(),
                      SizedBox(
                        height: 10 * dataController.currentScaleFactor.value,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  autoLock = !autoLock;
                                });
                              },
                              child: Text("Send Toll Report Daily",
                                  style: TextStyle(
                                      fontSize: dataController
                                          .normalTextSize.value))),
                          SizedBox(
                              width:
                                  10 * dataController.currentScaleFactor.value),
                          SizedBox(
                              width:
                                  40 * dataController.currentScaleFactor.value,
                              height:
                                  40 * dataController.currentScaleFactor.value,
                              child: Checkbox(
                                  value: sendTollReportDaily,
                                  onChanged: (value) {
                                    setState(() {
                                      sendTollReportDaily = value!;
                                    });
                                  })),
                        ],
                      ),
                      SizedBox(
                        height: 20 * dataController.currentScaleFactor.value,
                      ),
                      Row(children: [
                        Expanded(
                            child: OutlinedButton(
                          onPressed: () {
                            generateSettings();
                          },
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    0), // Set the border radius to 0 for a rectangular shape
                              ),
                              side: const BorderSide(color: Colors.green),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5 *
                                      dataController.currentScaleFactor.value,
                                  vertical: 15 *
                                      dataController.currentScaleFactor.value)),
                          child: Text(
                            generating ? "GENERATING..." : 'GENERATE',
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value,
                                color: Colors.green),
                          ),
                        )),
                        SizedBox(
                          width: 10 * dataController.currentScaleFactor.value,
                        ),
                        Expanded(
                            child: TextField(
                          controller: generatedUrlEditController,
                          style: TextStyle(
                              fontSize: dataController.normalTextSize.value),
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12 *
                                      dataController.currentScaleFactor.value,
                                  horizontal: 8 *
                                      dataController.currentScaleFactor.value),
                              labelText: 'Generated Url',
                              labelStyle: TextStyle(
                                  fontSize:
                                      dataController.normalTextSize.value)),
                        )),
                        IconButton(
                            onPressed: () {
                              Get.dialog(Dialog(
                                  insetPadding: const EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: EditShareTextWidget(
                                      deviceId:
                                          selectedDeviceSharePageData['device']
                                              ['id'],
                                      shareText:
                                          shareSetting['sharedTextTemplate'] ??
                                              '',
                                      onChanged: (value) {
                                        setState(() {
                                          shareSetting['sharedTextTemplate'] =
                                              value;
                                          Get.back();
                                        });
                                      })));
                            },
                            icon: Icon(
                              Icons.edit,
                              size: dataController.iconSize.value,
                            )),
                        IconButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                  text: shareSetting['sharedTextTemplate']
                                      .toString()
                                      .replaceAll('[domain][url]',
                                          generatedUrlEditController.text)));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Copied to Clipboard!')),
                              );
                            },
                            icon: Icon(
                              Icons.copy,
                              size: dataController.iconSize.value,
                            ))
                      ])
                    ]))));
  }
}
