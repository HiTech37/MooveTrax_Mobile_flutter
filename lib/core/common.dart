import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:moovetrax/core/api_config.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Duration cacheDuration = Duration(hours: 48);
Future<void> resetApp() async {
  // Clear cache
  Directory cacheDir = await getTemporaryDirectory();
  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }

  // Clear storage
  Directory appDocDir = await getApplicationDocumentsDirectory();
  if (appDocDir.existsSync()) {
    appDocDir.deleteSync(recursive: true);
  }

  // Reset SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();

  // Navigate to the login screen or any other initial screen
  // You can also use Navigator.popUntil() if you want to clear the navigation stack
  // and go back to the initial screen.
}

String randomStr(int len) {
  const chars = '0123456789abcdefghijklmnopqrstuvwxyz';
  Random rnd = Random();
  String ans = '';

  for (int i = 0; i < len; i++) {
    ans += chars[rnd.nextInt(chars.length)];
  }

  return ans;
}

int bottomMenuIndex(int index) {
  if (index == 0 || index == 1) {
    return 0;
  } else {
    return index - 1;
  }
}

String generateSharedUrlId([String deviceNickname = ""]) {
  String sharedUrl = '${randomStr(10)}${randomStr(5)}';

  if (deviceNickname.isNotEmpty) {
    deviceNickname = deviceNickname
        .trim()
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '');
    sharedUrl += '_$deviceNickname';
  }

  final utcStr = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now().toUtc());
  sharedUrl += '_$utcStr';

  return sharedUrl;
}

String convertTimestampToUTC(String timestamp) {
  if (timestamp.isEmpty) return '';
  if (timestamp == 'null') return '';

  try {
    // Convert the timestamp to an integer
    int timestampInt = int.parse(timestamp);

    // Convert timestamp to DateTime in UTC
    DateTime utcDate =
        DateTime.fromMillisecondsSinceEpoch(timestampInt * 1000, isUtc: true);

    // Format the date in UTC
    String formattedDate =
        DateFormat("MMMM dd, yyyy HH:mm:ss 'UTC'").format(utcDate);

    return formattedDate;
  } catch (e) {
    // Handle any parsing errors
    return '';
  }
}

String convertTimestampToLocal(String timestamp) {
  if (timestamp.isEmpty) return '';
  if (timestamp == 'null') return '';

  try {
    int timestampInt = int.parse(timestamp);

    DateTime utcDate =
        DateTime.fromMillisecondsSinceEpoch(timestampInt * 1000, isUtc: true);

    DateTime localDate = utcDate.toLocal();

    String formattedDate =
        DateFormat("MMMM dd, yyyy hh:mm a").format(localDate);

    return formattedDate;
  } catch (e) {
    debugPrint('Error parsing timestamp: $e');
    return '';
  }
}

String convertUTCtoLocal(String utcDateString) {
  if (utcDateString.isEmpty) return '';

  DateTime utcDate = DateTime.parse(utcDateString);

  DateTime localDate = utcDate.toLocal();
  String formattedDate = DateFormat('MMMM dd, yyyy hh:mm a').format(localDate);

  return formattedDate;
}

String generateRandomString(int length) {
  // Define the character set (lowercase letters and digits)
  const String charSet = 'abcdefghijklmnopqrstuvwxyz0123456789';

  // Create a Random object
  final Random random = Random();

  // Generate the random string
  return List.generate(length, (index) {
    return charSet[random.nextInt(charSet.length)];
  }).join('');
}

String getDirection(double angle) {
  if ((angle >= 337.5 && angle <= 360) || (angle >= 0 && angle < 22.5)) {
    return 'North';
  } else if (angle >= 22.5 && angle < 67.5) {
    return 'North-East';
  } else if (angle >= 67.5 && angle < 112.5) {
    return 'East';
  } else if (angle >= 112.5 && angle < 157.5) {
    return 'South-East';
  } else if (angle >= 157.5 && angle < 202.5) {
    return 'South';
  } else if (angle >= 202.5 && angle < 247.5) {
    return 'South-West';
  } else if (angle >= 247.5 && angle < 292.5) {
    return 'West';
  } else if (angle >= 292.5 && angle < 337.5) {
    return 'North-West';
  } else {
    return 'Unknown';
  }
}

String convertUTCtoLocal4(String utcDateString) {
  if (utcDateString == '' || utcDateString == "null") return '';
  // Parse UTC date string
  DateTime utcDate = DateTime.parse(utcDateString);

  // Convert to local timezone
  DateTime localDate = utcDate.toLocal();

  // Format the date
  String formattedDate = DateFormat("MM-dd HH:mm").format(localDate);

  return formattedDate;
}

String convertUTCtoLocal3(String utcDateString) {
  if (utcDateString == '' || utcDateString == 'null') return '';
  // Parse UTC date string
  DateTime utcDate = DateTime.parse(utcDateString);

  // Convert to local timezone
  DateTime localDate = utcDate.toLocal();

  // Format the date
  String formattedDate = DateFormat("MMMM dd, yyyy HH:mm").format(localDate);

  return formattedDate;
}

Color getColorDevice(String color) {
  Color data = Colors.black;
  switch (color) {
    case "Black":
      data = Colors.black;
      break;
    case "Blue":
      data = Colors.blue;
      break;
    case "Brown":
      data = Colors.brown;
      break;
    case "Gold":
      data = Colors.amber;
      break;
    case "Gray":
      data = Colors.grey;
      break;
    case "Green":
      data = Colors.green;
      break;
    case "Red":
      data = Colors.red;
      break;
    case "Silver":
      Colors.grey[400];
      break;
    case "White":
      data = Colors.white;
      break;
    case "Yellow":
      data = Colors.yellow;
      break;
    default:
      data = Colors.black;
  }
  return data;
}

String convertUTCtoLocal1(String utcDateString) {
  if (utcDateString == '' || utcDateString == 'null') return '';

  // Parse UTC date string
  DateTime utcDate = DateTime.parse(utcDateString);

  // Convert to local timezone
  DateTime localDate = utcDate.toLocal();

  // Format the date
  String formattedDate = DateFormat("MMMM dd, yyyy").format(localDate);

  return formattedDate;
}

String dateFormat1(String utcDateString) {
  if (utcDateString == '') return '';

  // Parse UTC date string
  DateTime utcDate = DateTime.parse(utcDateString);

  // Convert to local timezone

  // Format the date
  String formattedDate = DateFormat("MM/dd/yyyy").format(utcDate);

  return formattedDate;
}

String convertUTCtoLocal2(String utcDateString) {
  if (utcDateString == '' || utcDateString == 'null') return '';

  var date = DateFormat("yyyy-MM-dd HH:mm:ss").parse(utcDateString, true);
  var local = date.toLocal();
  return DateFormat("MM/dd/yyyy").format(local);
}

DateTime convertUTCtoLocalDate(String utcDateString) {
  if (utcDateString == '' || utcDateString == 'null') return DateTime.now();

  var date = DateFormat("yyyy-MM-dd HH:mm:ss").parse(utcDateString, true);
  var local = date.toLocal();
  return local;
}

Future<Uint8List> getBytesFromAsset(
    {required String path, required int width}) async {
  final ByteData data = await rootBundle.load(path);
  final ui.Codec codec = await ui
      .instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  final ui.FrameInfo fi = await codec.getNextFrame();
  final Uint8List bytes =
      (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
          .buffer
          .asUint8List();
  return bytes;
}

double scaleFactorDPI(BuildContext context) {
  // Get the device's DPI
  double deviceDPI = MediaQuery.of(context).devicePixelRatio;

  // Define a base DPI
  double baseDPI = 160.0; // Standard DPI for baseline scaling

  // Calculate the scale factor based on DPI
  return deviceDPI / baseDPI;
}

double scaleFactor(BuildContext context) {
  // Get the device's screen width
  double screenWidth =
      MediaQuery.of(context).size.width > MediaQuery.of(context).size.height
          ? MediaQuery.of(context).size.height
          : MediaQuery.of(context).size.width;

  // Define a base width
  double baseWidth = 340;
  double scalefactor = screenWidth / baseWidth;
  // Calculate the scale factor
  return scalefactor > 2 ? 1.5 : scalefactor;
}

Future<String> getStreetName(double lat, double lng) async {
  String apiKey = ApiConfig.googleMapAkey;
  if (lat == -1000 || lng == -1000) return '';

  // Data is either not cached or cache is expired, make API call
  final url =
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&sensor=true&key=$apiKey';

  try {
    var response = await Dio().get(url);

    if (response.statusCode == 200) {
      final json = response.data;
      if (json['status'] == 'OK') {
        final results = json['results'];
        if (results.isNotEmpty) {
          final streetName =
              "${results[0]['address_components'][0]['long_name']}, "
              "${results[0]['address_components'][1]['short_name']}, "
              "${results[0]['address_components'][2]['short_name']}";

          return streetName;
        }
      }
    }
  } catch (e) {
    return 'No Address Info';
  }

  return 'No Address Info';
}

Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
  String assetName, [
  Size size = const Size(24, 24),
  String? title,
  Color? color,
  int? acc,
]) async {
  final pictureInfo = await vg.loadPicture(SvgAssetLoader(assetName), null);
  final waveInfo =
      await vg.loadPicture(const SvgAssetLoader('asset/images/wave.svg'), null);
  double widthFactor = 3;
  double devicePixelRatio =
      ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
  int width = (size.width * devicePixelRatio * widthFactor).toInt();
  double textHeight =
      width * 0.1; // Adjust the font size relative to the circle size
  int height = (size.height * devicePixelRatio +
          textHeight * 2.2 +
          size.width * 2 * (acc ?? 0))
      .toInt();

  final scaleFactor = min(
        width / widthFactor / pictureInfo.size.width,
        (size.height * devicePixelRatio) / pictureInfo.size.height,
      ) *
      0.8;

  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);

  // Draw text above the circle
  final textPainter = TextPainter(
      text: TextSpan(
        text: title ?? '',
        style: TextStyle(
            color: Colors.black,
            fontSize: textHeight,
            fontWeight: FontWeight.w600),
      ),
      textDirection: ui.TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 2,
      ellipsis: '...');

  textPainter.layout(maxWidth: width.toDouble());

  final textOffset = Offset(
    (width - textPainter.width) / 2,
    0,
  );

  textPainter.paint(canvas, textOffset);

  double circleRadius = width * 0.5 / widthFactor;

  // Draw circle background
  Color? fillColor = color == Colors.white ? Colors.grey[700] : Colors.white;
  Paint circleBackgroundPaint = Paint()
    ..color = fillColor!
    ..style = PaintingStyle.fill;
  Paint circleBorderPaint = Paint()
    ..color = Colors.black
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1.0;

  double circleCenterY = textPainter.height +
      circleRadius +
      (height -
              textPainter.height -
              2 * circleRadius -
              size.width * 2 * (acc ?? 0)) /
          2;
  canvas.drawCircle(
      Offset(width / 2, circleCenterY), circleRadius, circleBackgroundPaint);
  canvas.drawCircle(
      Offset(width / 2, circleCenterY), circleRadius, circleBorderPaint);

  // Draw waveInfo below the circle if acc == 0
  if (acc == 1) {
    double waveWidth = size.width * 2;
    double waveHeight =
        waveWidth * (waveInfo.size.height / waveInfo.size.width);
    double waveYPosition = circleCenterY + circleRadius + textHeight / 2;

    // Draw white background with rectangle border
    Paint waveBackgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Paint waveBorderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    Rect waveRect = Rect.fromLTWH(
      (width - waveWidth) / 2,
      waveYPosition,
      waveWidth,
      waveHeight,
    );
    canvas.drawRect(waveRect, waveBackgroundPaint);
    canvas.drawRect(waveRect, waveBorderPaint);

    // Draw the wave SVG inside the rectangle
    canvas.save();
    canvas.translate(
      (width - waveWidth) / 2,
      waveYPosition,
    );
    canvas.scale(waveWidth / waveInfo.size.width);
    canvas.drawPicture(waveInfo.picture);
    canvas.restore();
  }

  // Calculate translation for centering SVG
  double dx = (width - pictureInfo.size.width * scaleFactor) / 2;
  double dy = (circleCenterY - (pictureInfo.size.height * scaleFactor) / 2);

  canvas.translate(dx, dy);

  // Apply color filter if color is provided
  if (color != null) {
    Paint paint = Paint()
      ..colorFilter = ColorFilter.mode(color, BlendMode.srcIn);
    canvas.saveLayer(null, paint);
  }

  canvas
    ..scale(scaleFactor)
    ..drawPicture(pictureInfo.picture);

  if (color != null) {
    canvas.restore();
  }

  final rasterPicture = recorder.endRecording();
  final image = await rasterPicture.toImage(width, height);
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

  return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
}

Future<bool> checkIfSimulator() async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  final iosInfo = await deviceInfoPlugin.iosInfo;
  // Check if the device is a simulator
  if (iosInfo.isPhysicalDevice) {
    return false;
  } else {
    return true;
  }
}
