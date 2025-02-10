import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/common/widget/bottom_sheet_switch.dart';
import 'package:moovetrax/common/widget/default_button.dart';
import 'package:moovetrax/common/widget/youtube_player.dart';
import 'package:moovetrax/core/api_config.dart';
import 'package:moovetrax/core/common.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/view/home/screens/place.dart';
import 'package:moovetrax/view/home/widgets/credit_balance_widget.dart';
import 'package:moovetrax/view/home/widgets/device_setting_widget.dart';
import 'package:moovetrax/view/home/widgets/geofence_edit_widget.dart';
import 'package:moovetrax/view/home/widgets/upload_device_image_widget.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> mapController = Completer();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DeviceController deviceController = getIt<DeviceController>();
  bool drawingPolygonEnabled = false;
  final AuthController authController = getIt<AuthController>();
  bool showReplay = false;
  final DataController dataController = Get.find<DataController>();
  List<dynamic> deviceList = [];
  List<dynamic> geoFenceDataList = [];
  List<dynamic> recoverDeviceList = [];
  bool cameraMoving = false;
  bool loadingHistory = false;
  bool isWebsocketOpened = true;
  MapType currentMapType = MapType.normal;
  int totalDevices = 0;
  int onlineDevices = 0;
  Set<Polygon> polygonsList = <Polygon>{};
  Set<Polyline> polyLines = <Polyline>{};
  String currentSearchValue = '';

  String howToVideoId = "OCz1Oqc8UDc";

  Set<Polygon> polygons = {};
  dynamic selectedDevice;
  bool playingHistory = false;
  bool isDrawingPolygon = true;
  List<LatLng> polygonPoints = [];
  LatLng _center = const LatLng(28.521563, -82.677433);
  File? pickedImageFile;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  bool mapCreated = false;
  List<Place> items = [];
  bool deviceSortDirection = false;
  String deviceSortField = "";
  bool installSortDirection = false;
  bool nameSortDirection = false;
  bool balanceSortDirection = false;
  bool onlineSortDirection = false;
  dynamic playMarkerIconData;
  bool lockSortDirection = false;
  bool killSortDirection = false;
  bool geoFenceDataInitialized = false;
  bool makeSortDirection = false;
  bool modelSortDirection = false;
  bool colorSortDirection = false;
  bool vinSortDirection = false;
  bool milesSortDirection = false;
  bool categorySortDirection = false;
  String currentSortField = "Installation";
  String historyResultText = "";
  DateTime selectedFromDate = DateTime.now();
  DateTime selectedToDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay selectedFromTime = TimeOfDay.now();
  TimeOfDay selectedToTime = TimeOfDay.now();
  WebSocketChannel? _channel;
  bool drawerOpened = false;

  List<String> playSpeedList = <String>['1X', '5X', '10X'];
  List<String> periodList = <String>[
    'Today',
    'Last Hour',
    'Last 5 Hours',
    'Yesterday',
    "This Week",
    "Previous Week",
    "This Month",
    "Previous Month",
    "Custom"
  ];
  dynamic selectedDeviceToPlay;
  double currentPlayPosition = 0;
  List<dynamic> playHistoryData = [];
  String periodValue = 'Today';
  String playSpeed = '1X';
  int updateDevicesValue = 0;
  int updateMapValue = 0;
  bool updatingDevicesFromSocket = false;
  bool autoPlayValue = true;
  late ClusterManager _manager;
  bool drawerOpend = false;
  Set<Marker> markers = {};

  Timer? _timer;
  Timer? _socketTimer;

  Color getColor(double value) {
    if (value <= 0) {
      return Colors.green;
    } else if (value < 15) {
      return Colors.grey;
    } else {
      return Colors.red;
    }
  }

  void startPlayTimer() {
    int duration = playSpeed == "1X"
        ? 1000
        : playSpeed == "5X"
            ? 200
            : 100;
    var oneSec = Duration(milliseconds: duration);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (playingHistory == false) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {});

          if (currentPlayPosition.round() == (playHistoryData.length - 1)) {
            setState(() {
              playingHistory = false;
            });
            return;
          }
          currentPlayPosition++;
          markers.add(Marker(
            draggable: true,
            markerId: MarkerId(selectedDeviceToPlay['id'].toString()),
            position: LatLng(
                playHistoryData[currentPlayPosition.round()]['latitude'],
                playHistoryData[currentPlayPosition.round()]['longitude']),
            icon: playMarkerIconData,
          ));
        }
      },
    );
  }

  void zoomToFitOnePosition(List<LatLng> positions, double zoomLevel) async {
    if (positions.isEmpty) return;

    final GoogleMapController controller = await mapController.future;

    if (positions.length == 1) {
      // For a single position, manually set a zoom level for a closer view
      var position = positions[0];

      controller.animateCamera(
        CameraUpdate.newLatLngZoom(position, zoomLevel),
      );
    } else {
      LatLngBounds bounds;

      var southwestLat =
          positions.map((m) => m.latitude).reduce((a, b) => a < b ? a : b);
      var southwestLng =
          positions.map((m) => m.longitude).reduce((a, b) => a < b ? a : b);
      var northeastLat =
          positions.map((m) => m.latitude).reduce((a, b) => a > b ? a : b);
      var northeastLng =
          positions.map((m) => m.longitude).reduce((a, b) => a > b ? a : b);
      bounds = LatLngBounds(
        southwest: LatLng(southwestLat, southwestLng),
        northeast: LatLng(northeastLat, northeastLng),
      );

      // Define a zoom level factor for multiple positions.
      const zoomFactor =
          1; // Adjusts the zoom to be halfway between fully zoomed out and the bounds
      final double currentPadding =
          50 * dataController.currentScaleFactor.value;
      final double adjustedPadding = currentPadding * zoomFactor;

      controller.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, adjustedPadding),
      );
    }
  }

  void onMapTypeButtonPressed() {
    // Toggle between map types
    setState(() {
      currentMapType =
          currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  moveCameraPostion() async {
    if (selectedDevice == null) return;
    setState(() {
      _center = LatLng(double.parse(selectedDevice['latitude'].toString()),
          double.parse(selectedDevice['longitude'].toString()));
    });
    final GoogleMapController controller = await mapController.future;
    final CameraPosition eiffelTowerPosition =
        CameraPosition(target: _center, zoom: 16);
    controller
        .animateCamera(CameraUpdate.newCameraPosition(eiffelTowerPosition));
  }

  Future<void> showPositionsHistory() async {
    if (!mounted) return;
    String fromDate = '';
    String toDate = '';
    final now = DateTime.now();

    switch (periodValue) {
      case "Today":
        fromDate = intl.DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ")
            .format(DateTime(now.year, now.month, now.day, 0, 0, 0).toUtc());
        toDate = intl.DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(
            DateTime(now.year, now.month, now.day, 23, 59, 59, 999).toUtc());
        break;

      case "Last Hour":
        fromDate = intl.DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ")
            .format(now.subtract(const Duration(hours: 1)).toUtc());
        toDate =
            intl.DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(now.toUtc());
        break;

      case "Last 5 Hours":
        fromDate = intl.DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ")
            .format(now.subtract(const Duration(hours: 5)).toUtc());
        toDate =
            intl.DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(now.toUtc());
        break;

      case "Yesterday":
        final yesterday = now.subtract(const Duration(days: 1));
        fromDate = intl.DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(
            DateTime(yesterday.year, yesterday.month, yesterday.day, 0, 0, 0)
                .toUtc());
        toDate = intl.DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime(
                yesterday.year, yesterday.month, yesterday.day, 23, 59, 59, 999)
            .toUtc());
        break;

      case "This Week":
        final weekStart = now.subtract(Duration(days: now.weekday % 7));
        fromDate = intl.DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(
            DateTime(weekStart.year, weekStart.month, weekStart.day, 0, 0, 0)
                .toUtc());
        toDate =
            intl.DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(now.toUtc());
        break;

      case "Previous Week":
        final now = DateTime.now(); // Assuming you have the current date-time
        final int daysSinceLastSunday =
            now.weekday % 7; // `0` if today is Sunday, `6` if today is Saturday
        final prevWeekStart = now.subtract(
            Duration(days: daysSinceLastSunday + 7)); // Move to last Sunday
        final prevWeekEnd =
            prevWeekStart.add(const Duration(days: 6)); // Previous Saturday

        fromDate = intl.DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime(
                prevWeekStart.year,
                prevWeekStart.month,
                prevWeekStart.day,
                0,
                0,
                0)
            .toUtc());

        toDate = intl.DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime(
                prevWeekEnd.year,
                prevWeekEnd.month,
                prevWeekEnd.day,
                23,
                59,
                59,
                999)
            .toUtc());
        break;

      case "This Month":
        fromDate = intl.DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ")
            .format(DateTime(now.year, now.month, 1, 0, 0, 0).toUtc());
        toDate =
            intl.DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(now.toUtc());
        break;

      case "Previous Month":
        final prevMonth = DateTime(now.year, now.month - 1, 1);
        fromDate = intl.DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(
            DateTime(prevMonth.year, prevMonth.month, 1, 0, 0, 0).toUtc());
        final lastDayPrevMonth = DateTime(now.year, now.month, 0);
        toDate = intl.DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format(DateTime(
                lastDayPrevMonth.year,
                lastDayPrevMonth.month,
                lastDayPrevMonth.day,
                23,
                59,
                59,
                999)
            .toUtc());
        break;
      case "Custom":
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
        fromDate = intl.DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ")
            .format(selectedFromDateTime.toUtc());

        toDate = intl.DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ")
            .format(selectedToDateTime.toUtc());
        break;

      default:
        // Handle any other cases or invalid input
        debugPrint("Invalid period value");
    }

    if (selectedDeviceToPlay == null) return;
    setState(() {
      loadingHistory = true;
    });
    await deviceController.getPositionsHistory(
        selectedDeviceToPlay['id'].toString(), '${fromDate}Z', '${toDate}Z');

    setState(() {
      loadingHistory = false;
    });
    if (deviceController.apiStatus.value == ApiState.failure) {
      Get.snackbar("Failed", deviceController.errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          animationDuration: const Duration(milliseconds: 300));

      return;
    }
    setState(() {
      markers.clear();
      items.clear();
      _manager.setItems(items);
      polyLines.clear();
    });
    List<dynamic> responseList =
        deviceController.positionsHistoryData.value ?? [];

    if (deviceController.apiStatus.value == ApiState.success) {
      if (responseList.isEmpty) {
        historyResultText = "No playback data found";
        Get.snackbar("Replay", historyResultText,
            backgroundColor: Colors.blue,
            colorText: Colors.white,
            animationDuration: const Duration(milliseconds: 300));
        return;
      } else {
        setState(() {
          currentPlayPosition = 0;
          playHistoryData = responseList;
        });
        List<LatLng> coordinates = [];
        for (var item in responseList) {
          coordinates.add(LatLng(item['latitude'], item['longitude']));
        }

        final markerIconData = await bitmapDescriptorFromSvgAsset(
            'asset/images/${selectedDeviceToPlay['category']}.svg',
            Size(30 * dataController.currentScaleFactor.value,
                30 * dataController.currentScaleFactor.value),
            selectedDeviceToPlay['name'],
            getColorDevice(selectedDeviceToPlay['color']));

        playMarkerIconData = markerIconData;

        markers.add(Marker(
          draggable: true,
          markerId: MarkerId(selectedDeviceToPlay['id'].toString()),
          position: LatLng(
              responseList[currentPlayPosition.round()]['latitude'],
              responseList[currentPlayPosition.round()]['longitude']),
          icon: playMarkerIconData,
        ));

        polyLines.add(Polyline(
          polylineId: const PolylineId('playhistory'),
          points: coordinates,
          color: Colors.black,
          width: 3,
        ));

        playingHistory = true;
        currentPlayPosition = 0;
        playingHistory = autoPlayValue;
        setState(() {});

        List<LatLng> positions = [];
        positions.add(
          LatLng(double.parse(responseList[0]['latitude'].toString()),
              double.parse(responseList[0]['longitude'].toString())),
        );

        zoomToFitOnePosition(positions, 17);

        if (autoPlayValue) {
          startPlayTimer();
        }
      }
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController.complete(controller);
    setState(() {
      mapCreated = true;
    });
    _manager.setMapId(controller.mapId);
  }

  void addCustomIcon() async {
    final Uint8List selected =
        await getBytesFromAsset(width: 160, path: "asset/images/Coupe.svg");
    final selectedIconMarker = BitmapDescriptor.fromBytes(selected);
    setState(() {
      markerIcon = selectedIconMarker;
    });
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

  Widget fromSelectField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('    From',
            style: TextStyle(fontSize: dataController.normalTextSize.value)),
        Row(children: [
          InkWell(
            onTap: () => selectFromDate(context),
            child: Padding(
                padding:
                    EdgeInsets.all(5 * dataController.currentScaleFactor.value),
                child: Text(
                  intl.DateFormat('yyyy-MM-dd')
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
                padding:
                    EdgeInsets.all(5 * dataController.currentScaleFactor.value),
                child: Text(
                  selectedFromTime.format(context),
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: dataController.normalTextSize.value),
                )),
          ),
        ])
      ],
    );
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

  Widget toSelectField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('    To',
          style: TextStyle(fontSize: dataController.normalTextSize.value)),
      Row(children: [
        InkWell(
          onTap: () => selectToDate(context),
          child: Padding(
              padding:
                  EdgeInsets.all(5 * dataController.currentScaleFactor.value),
              child: Text(
                intl.DateFormat('yyyy-MM-dd').format(selectedToDate).toString(),
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: dataController.normalTextSize.value),
              )),
        ),
        InkWell(
          onTap: () => selectToTime(context),
          child: Padding(
              padding:
                  EdgeInsets.all(5 * dataController.currentScaleFactor.value),
              child: Text(
                selectedToTime.format(context),
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: dataController.normalTextSize.value),
              )),
        ),
      ])
    ]);
  }

  @override
  void initState() {
    super.initState();

    _manager = _initClusterManager();
    initData();
    _initializeListeners();

    if (_socketTimer != null && _socketTimer!.isActive) {
      return; // Timer is already running, no need to create a new one
    }
    _initializeWebSocket();
    _initializeTimers();
  }

  void _initializeWebSocket() {
    _channel = WebSocketChannel.connect(
      Uri.parse(ApiConfig.webSocketUrl),
    );
    setState(() {
      isWebsocketOpened = true;
    });

    _channel?.stream.listen(
      (data) {
        updateDevicesFromSocket(data);
      },
      onError: (error) {
        _reconnectWebSocket();
      },
      onDone: () {
        isWebsocketOpened = false;
        _reconnectWebSocket();
      },
    );
  }

  void _initializeTimers() {
    if (!mounted) return;

    if (authController.storageUserData == null) return;
    _socketTimer?.cancel();
    _socketTimer = Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      if (authController.storageUserData != null) {
        final Map<String, dynamic> data = {
          "type": "GET_DEVICE_POSITION_DATA",
          "tokenData": {
            "m_token": authController.storageUserData!['token'] ?? '',
            "shareUri": ""
          }
        };
        final String jsonData = jsonEncode(data);
        if (isWebsocketOpened) {
          _channel?.sink.add(jsonData);
        }
      } else {
        _channel?.sink.close();
      }
    });
  }

  void _initializeListeners() {
    ever(dataController.updateMap, (_) {
      if (updateMapValue != dataController.updateMap.value) {
        initData();
      }
    });

    ever(dataController.updateDevice, (_) {
      if (updateDevicesValue != dataController.updateDevice.value) {
        updateDevices();
      }
    });

    ever(dataController.showPlayPositionsHistory, (_) {
      if (mounted) {
        setState(() {
          showReplay = dataController.showPlayPositionsHistory.value;
          if (deviceList.isNotEmpty) {
            selectedDeviceToPlay = deviceList.firstWhere(
              (device) =>
                  device['id'].toString() ==
                  dataController.currentDeviceId.value,
              orElse: () => deviceList.first,
            );
          }
        });
      }
    });

    ever(dataController.geoGeoFenceEditingEnabled, (_) {
      if (!geoFenceDataInitialized &&
          dataController.geoGeoFenceEditingEnabled.value) {
        initGeoFenceData();
      } else {
        _resetGeoFenceData();
      }
    });
  }

  void _resetGeoFenceData() {
    if (!mounted) return;

    setState(() {
      geoFenceDataInitialized = false;
      polygonsList.clear();
    });

    dataController.setGeoFenceEditing(false);
  }

  void _reconnectWebSocket() {
    Future.delayed(const Duration(seconds: 10), () {
      if (mounted) {
        _initializeWebSocket();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _socketTimer?.cancel();
    _channel?.sink.close();
    super.dispose();
  }

  Future<void> updateDevicesFromSocket(String data) async {
    if (dataController.showPlayPositionsHistory.value) {
      return;
    }
    setState(() {
      updatingDevicesFromSocket = true;
    });
    if (cameraMoving) {
      return;
    }
    dynamic jsonData = jsonDecode(data);
    List<Place> newItems = [];

    deviceList = jsonData['devices'];
    recoverDeviceList = jsonData['devices'];
    totalDevices = deviceList.length;
    onlineDevices = 0;
    if (deviceList.isNotEmpty) {
      selectedDevice = deviceList[0];
      if (dataController.currentDeviceId.value != '') {
        for (int i = 0; i < deviceList.length; i++) {
          if (deviceList[i]['id'] == dataController.currentDeviceId.value) {
            selectedDeviceToPlay = deviceList[i];
          }
        }
      } else {
        selectedDeviceToPlay = deviceList.first;
      }
      int index = 0;

      for (final device in deviceList) {
        if (device['status'] == 'online') {
          onlineDevices++;
        }
        if (checkDeviceLastConnection(device)) {
          final item = Place(
              name: device['name'],
              deviceId: device['id'].toString(),
              index: index,
              category: device['category'] ?? 'Default',
              color: device['color'] ?? 'Balck',
              latLng: LatLng(double.parse(device['latitude'].toString()),
                  double.parse(device['longitude'].toString())));
          index++;
          newItems.add(item);
        }
      }
    }
    _manager.setItems(newItems);
    updatingDevicesFromSocket = false;
    if (deviceSortField != "") {
      sortVehicles(deviceSortField, deviceSortDirection);
    }
    setState(() {});
  }

  Future<void> updateCurrentDeviceMarker(String deviceId) async {
    for (dynamic device in deviceList) {
      if (device['id'].toString() == deviceId) {
        for (int i = 0; i < items.length; i++) {
          if (items[i].deviceId == deviceId) {
            Place updateItem = items[i].updateLocation(LatLng(
                double.parse(device['latitude'].toString()),
                double.parse(device['longitude'].toString())));
            items[i] = updateItem; // Replace the item with updateItem
            _manager.setItems(items);
            final GoogleMapController controller = await mapController.future;
            controller.animateCamera(
              CameraUpdate.newLatLngZoom(
                  LatLng(double.parse(device['latitude'].toString()),
                      double.parse(device['longitude'].toString())),
                  17.0),
            );
            return;
          }
        }
      }
    }
    for (int i = 0; i < items.length; i++) {
      if (items[i].deviceId == deviceId) {
        items.removeAt(i);
        _manager.setItems(items);
        return;
      }
    }
  }

  Future<void> initGeoFenceData() async {
    if (dataController.geoGeoFenceEditingEnabled.value == true) {
      await deviceController.getGeoFenceList();
      if (deviceController.apiStatus.value == ApiState.failure) {
        Get.snackbar("Failed", deviceController.errorMessage.value,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            animationDuration: const Duration(milliseconds: 300));

        return;
      }
      geoFenceDataList = deviceController.geoFenceData.value;
      geoFenceDataInitialized = true;
      // Clear existing polygons
      polygonsList.clear();

      // Iterate through the data and create polygons
      for (var item in geoFenceDataList) {
        List<LatLng> coordinates = [];
        var coordinateList = json.decode(item['coordinates']);
        for (var point in coordinateList) {
          coordinates.add(LatLng(point[1], point[0]));
        }

        polygonsList.add(Polygon(
          polygonId: PolygonId(item['id'].toString()),
          points: coordinates,
          fillColor: Colors.blue.withAlpha(75),
          strokeColor: Colors.blue,
          strokeWidth: 3,
        ));
      }

      // Update the state to rebuild the map with new polygons
      setState(() {});
    }
  }

  void deletePolygonById(String polygonId) {
    List<Polygon> matchingPolygons = polygonsList
        .where((polygon) => polygon.polygonId.value == polygonId)
        .toList();

    if (matchingPolygons.isNotEmpty) {
      setState(() {
        polygonsList.remove(matchingPolygons.first);
      });
    } else {}
  }

  ClusterManager _initClusterManager() {
    return ClusterManager<Place>(items, _updateMarkers,
        markerBuilder: _markerBuilder, stopClusteringZoom: 16);
  }

  Future<Marker> Function(dynamic) get _markerBuilder => (cluster) async {
        Cluster<Place> cluseterData = cluster;
        return Marker(
          markerId: MarkerId(cluseterData.getId()),
          position: cluseterData.location,
          onTap: () {
            if (cluseterData.isMultiple) return;
            updateCurrentDeviceMarker(cluseterData.items.first.deviceId);
            dataController
                .updateCurrentDeviceId(cluseterData.items.first.deviceId);
            setState(() {
              selectedDevice = deviceList[cluseterData.items.first.index];
              selectedDeviceToPlay = deviceList[cluseterData.items.first.index];
            });

            if (double.parse(deviceList[cluseterData.items.first.index]
                        ['credit']
                    .toString()) >=
                double.parse(deviceList[cluseterData.items.first.index]
                        ['monthly_cost']
                    .toString())) {
              Get.dialog(Dialog(
                  insetPadding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: CreditBalanceWidget(onChanged: (vale) {})));
            } else {
              Get.dialog(Dialog(
                  insetPadding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: DeviceSettingWidget(onChanged: (vale) {})));
            }
          },
          icon: await _getMarkerBitmap(
              cluseterData.isMultiple,
              cluster.isMultiple ? cluster.count.toString() : "",
              cluster.items.first),
        );
      };
  void _updateMarkers(Set<Marker> markerItems) {
    if (!mounted) return;
    setState(() {
      markers = markerItems;
    });
  }

  Future<BitmapDescriptor> _getMarkerBitmap(
      bool isMultiple, String text, Place data) async {
    if (isMultiple) {
      final PictureRecorder pictureRecorder = PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      final Paint paint1 = Paint()..color = Colors.blue;
      final Paint paint2 = Paint()..color = Colors.white;

      int size = (180 / dataController.currentScaleFactor.value).round();

      canvas.drawCircle(Offset(size / 2, size / 2), size / 2.0, paint1);
      canvas.drawCircle(Offset(size / 2, size / 2), size / 2.2, paint2);
      canvas.drawCircle(Offset(size / 2, size / 2), size / 2.8, paint1);

      TextPainter painter = TextPainter(textDirection: TextDirection.ltr);
      painter.text = TextSpan(
        text: text,
        style: TextStyle(
            fontSize: size / 3,
            color: Colors.white,
            fontWeight: FontWeight.normal),
      );
      painter.layout();
      painter.paint(
        canvas,
        Offset(size / 2 - painter.width / 2, size / 2 - painter.height / 2),
      );

      final img = await pictureRecorder.endRecording().toImage(size, size);
      final data =
          await img.toByteData(format: ImageByteFormat.png) as ByteData;

      return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
    } else {
      final markerIconData = await bitmapDescriptorFromSvgAsset(
          'asset/images/${data.category}.svg',
          Size(35 * dataController.currentScaleFactor.value,
              35 * dataController.currentScaleFactor.value),
          data.name,
          getColorDevice(data.color),
          data.acc);
      return markerIconData;
    }
  }

  void sortVehicles(String sortBy, bool ascending) {
    if (deviceList.isEmpty) {
      return;
    }
    deviceList.sort((a, b) {
      int comparison = 0;
      switch (sortBy) {
        case 'Alphabetically':
          comparison = a['name']
              .toString()
              .toLowerCase()
              .compareTo(b['name'].toString().toLowerCase());
          break;
        case 'Balance':
          comparison =
              double.parse(a['credit']).compareTo(double.parse(b['credit']));
          break;
        case 'Online':
          comparison = a['status'].toString().compareTo(b['status'].toString());
          break;
        case 'Lock Status':
          comparison = a['lock_status']
              .toString()
              .compareTo(b['lock_status'].toString());
          break;
        case 'Kill Status':
          comparison = a['kill_status']
              .toString()
              .compareTo(b['kill_status'].toString());
          break;
        case 'Make':
          comparison = a['make'].toString().compareTo(b['make'].toString());
          break;
        case 'Model':
          comparison = a['model'].toString().compareTo(b['model'].toString());
          break;
        case 'Color':
          comparison = a['color'].toString().compareTo(b['color'].toString());
          break;
        case 'Category':
          comparison =
              a['category'].toString().compareTo(b['category'].toString());
          break;
        case 'Miles':
          comparison = double.parse(a['odometer'])
              .compareTo(double.parse(b['odometer']));
          break;
        case 'Installation':
          comparison = DateTime.parse(a['createdAt'])
              .compareTo(DateTime.parse(b['createdAt']));
          break;
        case 'Vin':
          comparison = a['vin'].toString().compareTo(b['vin'].toString());
          break;

        default:
          comparison = 0;
      }
      return ascending ? comparison : -comparison;
    });
  }

  bool checkDeviceLastConnection(dynamic device) {
    if (device['lastConnect'] != null) {
      if (device == null) return false;
      if (device['status'] == 'online') return true;
      // Step 1: Parse the UTC time string to a DateTime object
      DateTime parsedUtcTime = DateTime.parse(device['lastConnect']).toUtc();

      // Step 2: Get the current UTC time
      DateTime currentUtcTime = DateTime.now().toUtc();

      // Step 3: Calculate the time difference
      Duration difference = currentUtcTime.difference(parsedUtcTime);

      // Step 4: Check if the difference is less than 12 hours (12 * 60 minutes * 60 seconds)
      return difference.inHours < 12;
    } else {
      return false;
    }
  }

  Future<void> initData() async {
    if (!mounted) return;
    setState(() {
      updateMapValue = dataController.updateMap.value;
    });
    await deviceController.getMainPageData();
    if (deviceController.apiStatus.value == ApiState.failure) {
      Get.snackbar("Failed", deviceController.errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          animationDuration: const Duration(milliseconds: 300));

      return;
    }
    final box = GetStorage();
    final sortKey = box.read('deviceSortKey');
    final sortDirection = box.read('sortDirection');
    if (!mounted) return;
    if (deviceController.mainPageData.value != null) {
      List<LatLng> positions = [];

      setState(() {
        deviceList = deviceController.mainPageData.value;
        recoverDeviceList = deviceController.mainPageData.value;
        totalDevices = deviceList.length;
        if (deviceList.isNotEmpty) {
          selectedDevice = deviceList[0];
          if (dataController.currentDeviceId.value != '') {
            for (int i = 0; i < deviceList.length; i++) {
              if (deviceList[i]['id'] == dataController.currentDeviceId.value) {
                selectedDeviceToPlay = deviceList[i];
              }
            }
          } else {
            selectedDeviceToPlay = deviceList.first;
          }
          markers.clear();
          items.clear();
          int index = 0;
          onlineDevices = 0;

          for (final device in deviceList) {
            if (device['status'] == 'online') {
              onlineDevices++;
            }
            if (checkDeviceLastConnection(device)) {
              final item = Place(
                  name: device['name'],
                  deviceId: device['id'].toString(),
                  index: index,
                  category: device['category'] ?? 'Default',
                  color: device['color'] ?? 'Black',
                  latLng: LatLng(double.parse(device['latitude'].toString()),
                      double.parse(device['longitude'].toString())));
              index++;
              items.add(item);
              positions.add(LatLng(double.parse(device['latitude'].toString()),
                  double.parse(device['longitude'].toString())));
            }
          }
        }
      });
      _manager.setItems(items);
      zoomToFitOnePosition(positions, 15);
    }
    if (sortKey == null || sortDirection == null) return;
    setState(() {
      currentSortField = sortKey;
      bool sortFlag = sortDirection == 'true' ? true : false;
      switch (sortKey) {
        case "Installation":
          installSortDirection = sortFlag;
          sortVehicles(sortKey, installSortDirection);
          break;
        case "Alphabetically":
          nameSortDirection = sortFlag;
          sortVehicles(sortKey, nameSortDirection);
          break;
        case "Balance":
          balanceSortDirection = sortFlag;
          sortVehicles(sortKey, balanceSortDirection);

          break;
        case "Online":
          onlineSortDirection = sortFlag;
          sortVehicles(sortKey, onlineSortDirection);

          break;
        case "Lock Status":
          lockSortDirection = sortFlag;
          sortVehicles(sortKey, lockSortDirection);

          break;
        case "Kill Status":
          killSortDirection = sortFlag;
          sortVehicles(sortKey, killSortDirection);

          break;
        case "Make":
          makeSortDirection = sortFlag;
          sortVehicles(sortKey, makeSortDirection);

          break;
        case "Model":
          modelSortDirection = sortFlag;
          sortVehicles(sortKey, modelSortDirection);

          break;
        case "Color":
          colorSortDirection = sortFlag;
          sortVehicles(sortKey, colorSortDirection);

          break;
        case "Category":
          categorySortDirection = sortFlag;
          sortVehicles(sortKey, categorySortDirection);

          break;
        case "Miles":
          milesSortDirection = sortFlag;
          sortVehicles(sortKey, milesSortDirection);

          break;
        case "Vin":
          vinSortDirection = sortFlag;
          sortVehicles(sortKey, vinSortDirection);

          break;
      }
    });
  }

  Future<void> updateDevices() async {
    if (!mounted) return;
    setState(() {
      updateDevicesValue = dataController.updateDevice.value;
    });
    await deviceController.getMainPageData();
    if (deviceController.apiStatus.value == ApiState.failure) {
      Get.snackbar("Failed", deviceController.errorMessage.value,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          animationDuration: const Duration(milliseconds: 300));

      return;
    }
    if (deviceController.mainPageData.value != null) {
      List<LatLng> positions = [];

      setState(() {
        deviceList = [];

        recoverDeviceList = deviceController.mainPageData.value;
        totalDevices = deviceList.length;
        onlineDevices = 0;
        if (recoverDeviceList.isNotEmpty) {
          selectedDevice = recoverDeviceList[0];
          if (dataController.currentDeviceId.value != '') {
            for (int i = 0; i < recoverDeviceList.length; i++) {
              if (recoverDeviceList[i]['id'] ==
                  dataController.currentDeviceId.value) {
                selectedDeviceToPlay = recoverDeviceList[i];
              }
            }
          } else {
            selectedDeviceToPlay = recoverDeviceList.first;
          }
          markers.clear();
          items.clear();
          int index = 0;

          for (final device in recoverDeviceList) {
            if (device['status'] == 'online') {
              onlineDevices++;
            }
            if (checkDeviceLastConnection(device)) {
              final item = Place(
                  name: device['name'],
                  deviceId: device['id'].toString(),
                  index: index,
                  category: device['category'] ?? 'Default',
                  color: device['color'] ?? 'Balck',
                  latLng: LatLng(double.parse(device['latitude'].toString()),
                      double.parse(device['longitude'].toString())));
              index++;
              items.add(item);
              positions.add(LatLng(double.parse(device['latitude'].toString()),
                  double.parse(device['longitude'].toString())));
            }

            if (device['name']
                .toString()
                .toLowerCase()
                .contains(currentSearchValue.toLowerCase())) {
              deviceList.add(device);
            } else if (device['vin']
                .toString()
                .toLowerCase()
                .contains(currentSearchValue.toLowerCase())) {
              deviceList.add(device);
            } else if (device['iccid']
                .toString()
                .toLowerCase()
                .contains(currentSearchValue.toLowerCase())) {
              deviceList.add(device);
            } else if (device['id']
                .toString()
                .toLowerCase()
                .contains(currentSearchValue.toLowerCase())) {
              deviceList.add(device);
            }
          }
        }
      });
      _manager.setItems(items);
    }
  }

  void onMapTapped(LatLng latLng) {
    if (!dataController.geoGeoFenceEditingEnabled.value ||
        !drawingPolygonEnabled) {
      return;
    }
    setState(() {
      polygonPoints.add(latLng);
      _createPolygon();
    });
  }

  Widget playHistoryWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 20 * dataController.currentScaleFactor.value,
          ),
          DropdownMenu<dynamic>(
            textStyle: TextStyle(fontSize: dataController.normalTextSize.value),
            expandedInsets: const EdgeInsets.all(0),
            initialSelection: selectedDeviceToPlay,
            onSelected: (dynamic value) {
              setState(() {
                selectedDeviceToPlay = value;
              });
            },
            dropdownMenuEntries:
                deviceList.map<DropdownMenuEntry<dynamic>>((dynamic value) {
              return DropdownMenuEntry<dynamic>(
                  value: value, label: value['name']);
            }).toList(),
          ),
          SizedBox(
            height: 20 * dataController.currentScaleFactor.value,
          ),
          Text(
            'Period',
            style: TextStyle(fontSize: dataController.normalTextSize.value),
          ),
          SizedBox(
            height: 10 * dataController.currentScaleFactor.value,
          ),
          DropdownMenu<String>(
            textStyle: TextStyle(fontSize: dataController.normalTextSize.value),
            expandedInsets: const EdgeInsets.all(0),
            initialSelection: periodValue,
            onSelected: (String? value) {
              setState(() {
                periodValue = value!;
              });
            },
            dropdownMenuEntries:
                periodList.map<DropdownMenuEntry<String>>((String value) {
              return DropdownMenuEntry<String>(value: value, label: value);
            }).toList(),
          ),
          if (periodValue == periodList.last)
            Column(
              children: [
                SizedBox(
                  height: 20 * dataController.currentScaleFactor.value,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [fromSelectField(), toSelectField()],
                )
              ],
            ),
          SizedBox(
            height: 20 * dataController.currentScaleFactor.value,
          ),
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Playback Speed',
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                  ),
                  SizedBox(
                    height: 10 * dataController.currentScaleFactor.value,
                  ),
                  DropdownMenu<String>(
                    expandedInsets: const EdgeInsets.all(0),
                    initialSelection: playSpeed,
                    textStyle: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                    onSelected: (String? value) {
                      setState(() {
                        playSpeed = value!;
                      });
                    },
                    dropdownMenuEntries: playSpeedList
                        .map<DropdownMenuEntry<String>>((String value) {
                      return DropdownMenuEntry<String>(
                          value: value, label: value);
                    }).toList(),
                  )
                ],
              )),
              SizedBox(width: 20 * dataController.currentScaleFactor.value),
              SizedBox(
                  width: 120 * dataController.currentScaleFactor.value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Auto Play',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      BottomSheetSwitch(
                        switchValue: autoPlayValue,
                        valueChanged: (value) {
                          setState(() {
                            autoPlayValue = value;
                          });
                        },
                      ),
                    ],
                  ))
            ],
          ),
          SizedBox(
            height: 20 * dataController.currentScaleFactor.value,
          ),
          DefaultButton(
              text: loadingHistory ? "LOADING..." : "SHOW",
              press: () {
                showPositionsHistory();
              }),
        ],
      ),
    );
  }

  Widget playControlsWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedDeviceToPlay['name'].toString(),
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
              IconButton(
                  onPressed: () async {
                    List<List<dynamic>> rows = [
                      ["deviceTime", "longitude", "latitude"]
                    ];

                    for (var entry in playHistoryData) {
                      rows.add([
                        entry["deviceTime"],
                        entry["longitude"],
                        entry["latitude"]
                      ]);
                    }

                    String csv = const ListToCsvConverter().convert(rows);
                    final directory = await getApplicationDocumentsDirectory();
                    String timestamp =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    final pathOfTheFileToWrite =
                        '${directory.path}/data_$timestamp.csv';

                    // Create file and write CSV data
                    File file = File(pathOfTheFileToWrite);
                    try {
                      await file.writeAsString(csv);
                      Get.snackbar("Download",
                          "History data downloaded at $pathOfTheFileToWrite",
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          animationDuration: const Duration(milliseconds: 300));
                    } catch (error) {
                      if (kDebugMode) {
                        print(error);
                      }
                    }
                  },
                  icon: const Icon(Icons.download))
            ],
          ),
          Slider(
              value: currentPlayPosition,
              max: (polyLines.first.points.length - 1).toDouble(),
              divisions: polyLines.first.points.length > 100
                  ? 100
                  : polyLines.first.points.length,
              label: currentPlayPosition.round().toString(),
              onChanged: (double value) {
                setState(() {
                  currentPlayPosition = value;
                  markers.add(Marker(
                    draggable: true,
                    markerId: MarkerId(selectedDeviceToPlay['id'].toString()),
                    position: LatLng(
                        playHistoryData[currentPlayPosition.round()]
                            ['latitude'],
                        playHistoryData[currentPlayPosition.round()]
                            ['longitude']),
                    icon: playMarkerIconData,
                  ));
                });
              }),
          Row(
            children: [
              Text(
                '0',
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
              const Spacer(),
              Text(
                currentPlayPosition.round().toString(),
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
              const Spacer(),
              Text(
                polyLines.first.points.length.toString(),
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              )
            ],
          ),
          Row(
            children: [
              Text(
                'Playback: $playSpeed',
                style: TextStyle(fontSize: dataController.smallTextSize.value),
              ),
              const Spacer(),
              Text(
                convertUTCtoLocal(
                    playHistoryData[currentPlayPosition.round()]['deviceTime']),
                style: TextStyle(fontSize: dataController.smallTextSize.value),
              )
            ],
          ),
          Row(
            children: [
              Text(
                '${playHistoryData[currentPlayPosition.round()]['speed']}mi/h',
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
              const Spacer(),
              Text(
                '${(playHistoryData[currentPlayPosition.round()]['signal'] / 31 * 100).round()}%',
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
              const Spacer(),
              Text(
                '${(playHistoryData[currentPlayPosition.round()]['mt2v_dc_volt'] ?? '').toString()}V',
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
            ],
          ),
          Row(
            children: [
              const Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.fast_rewind_sharp,
                    size: 24 * dataController.currentScaleFactor.value,
                  )),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    setState(() {
                      playingHistory = !playingHistory;

                      if (playingHistory) {
                        startPlayTimer();
                      }
                    });
                  },
                  icon: playingHistory == false
                      ? Icon(Icons.play_arrow,
                          size: 24 * dataController.currentScaleFactor.value)
                      : Icon(Icons.stop,
                          size: 24 * dataController.currentScaleFactor.value)),
              const Spacer(),
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.fast_forward_sharp,
                      size: 24 * dataController.currentScaleFactor.value)),
              const Spacer(),
            ],
          )
        ],
      ),
    );
  }

  Future<void> onCreateGeoFence(LatLng latLng) async {
    if (!dataController.geoGeoFenceEditingEnabled.value ||
        !drawingPolygonEnabled) {
      return;
    }
    if (polygonPoints.length < 3) return;

    String area = "POLYGON ((";
    List<List<double>> coordinates = [];
    for (int i = 0; i < polygonPoints.length; i++) {
      area += "${polygonPoints[i].latitude} ";
      area += '${polygonPoints[i].longitude}, ';
      coordinates.add([polygonPoints[i].longitude, polygonPoints[i].latitude]);
    }
    area += "))";

    Get.dialog(Dialog(
        insetPadding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: GeoFenceEditWidget(
            onChanged: (value) async {
              if (value) {
                await initGeoFenceData();
                polygonPoints.clear();
                polygonsList.removeWhere(
                    (polygon) => polygon.polygonId.value == "polygon_1");

                Get.back();
              }
            },
            actionType: 'create',
            geofenceArea: area,
            geofenceCoordinates: coordinates)));
  }

  void _createPolygon() {
    polygonsList.add(
      Polygon(
        polygonId: const PolygonId('polygon_1'),
        points: polygonPoints,
        strokeColor: Colors.green,
        strokeWidth: 2,
        fillColor: Colors.green.withAlpha(40),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: showReplay
          ? AppBar(
              leading: IconButton(
                padding: const EdgeInsets.all(2),
                icon:
                    Icon(Icons.arrow_back, size: dataController.iconSize.value),
                onPressed: () async {
                  dataController.setShowPlayPositionsHistory(false);

                  historyResultText = "";
                  playingHistory = false;
                  polyLines.clear();
                  await updateDevices();
                },
              ),
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Replay'),
                ],
              ),
              actions: [
                if (polyLines.isNotEmpty)
                  IconButton(
                      onPressed: () {
                        polyLines.clear();
                        playingHistory = false;
                        historyResultText = "";

                        setState(() {});
                      },
                      icon: const Icon(Icons.settings))
              ],
            )
          : null,
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 20,
            ),
            mapType: currentMapType,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            onCameraMove: (CameraPosition position) {
              _manager.onCameraMove(position);
              setState(() {
                cameraMoving = true;
              });
            },
            onCameraIdle: () {
              setState(() {
                cameraMoving = false;
              });
              if (!updatingDevicesFromSocket) {
                _manager.updateMap();
              }
            },
            polygons: polygonsList,
            polylines: polyLines,
            markers: markers,
            onTap: onMapTapped,
            onLongPress: onCreateGeoFence,
          ),
          Obx(() => dataController.showPlayPositionsHistory.value
              ? MediaQuery.of(context).size.height > 500
                  ? Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                          padding: EdgeInsets.all(
                              10 * dataController.currentScaleFactor.value),
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color.fromARGB(192, 0, 0, 0)
                                  : Colors.white),
                          child: polyLines.isEmpty
                              ? playHistoryWidget(context)
                              : playControlsWidget(context)),
                    )
                  : Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                          padding: EdgeInsets.all(
                              10 * dataController.currentScaleFactor.value),
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color.fromARGB(192, 0, 0, 0)
                                  : Colors.white),
                          height: 200 * dataController.currentScaleFactor.value,
                          child: polyLines.isEmpty
                              ? playHistoryWidget(context)
                              : playControlsWidget(context)),
                    )
              : Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: AppBar(
                      backgroundColor:
                          Colors.transparent, // Making app bar transparent
                      elevation: 0,
                      toolbarHeight: dataController.appBarHeight.value,
                      leadingWidth: dataController.appBarHeight.value,
                      leading: Container(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black54
                            : Colors.green,
                        child: IconButton(
                          // Customizing leading widget to have a green hamburger button
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 35 * dataController.currentScaleFactor.value,
                          ),
                          onPressed: () {
                            setState(() {
                              drawerOpend = true;
                            });
                            _scaffoldKey.currentState?.openDrawer();
                          },
                        ),
                      )))),
        ],
      ),
      drawer: SizedBox(
          width: (MediaQuery.of(context).size.width - 30) > 400
              ? 400
              : (MediaQuery.of(context).size.width - 20),
          child: Obx(() => dataController.geoGeoFenceEditingEnabled.value
              ? Drawer(
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical:
                              30 * dataController.currentScaleFactor.value,
                          horizontal:
                              10 * dataController.currentScaleFactor.value),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                IconButton(
                                  padding: const EdgeInsets.all(2),
                                  icon: Icon(Icons.arrow_back,
                                      size: dataController.iconSize.value),
                                  onPressed: () {
                                    dataController.setGeoFenceEditing(false);
                                    setState(() {
                                      geoFenceDataInitialized = false;
                                      polygonsList.clear();
                                    });
                                    Get.back();
                                  },
                                ),
                                Expanded(
                                    child: Text(
                                  'Geofences',
                                  style: TextStyle(
                                      fontSize:
                                          dataController.normalTextSize.value),
                                ))
                              ],
                            ),
                            trailing: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return YouTubePlayerDialog(
                                          videoId: howToVideoId);
                                    });
                              },
                              child: Text(
                                'How To Video',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize:
                                        dataController.normalTextSize.value),
                              ),
                            ),
                          ),
                          if (geoFenceDataList.isNotEmpty)
                            Expanded(
                                child: SingleChildScrollView(
                              child: Column(
                                children: geoFenceDataList.map((geoFenceData) {
                                  return Column(children: [
                                    ListTile(
                                      title: Row(children: [
                                        Expanded(
                                            child: Text(geoFenceData['name'])),
                                        PopupMenuButton<String>(
                                          icon: const Icon(Icons.more_vert),
                                          onSelected: (String result) async {
                                            switch (result) {
                                              case "Edit":
                                                Get.back();

                                                dataController.setGeoFenceId(
                                                    geoFenceData['id']
                                                        .toString());

                                                Get.dialog(Dialog(
                                                    insetPadding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                    ),
                                                    child: GeoFenceEditWidget(
                                                      onChanged: (value) {
                                                        if (value) {
                                                          initGeoFenceData();
                                                          Get.back();
                                                        }
                                                      },
                                                      geofenceArea: '',
                                                      geofenceCoordinates: const [],
                                                      actionType: 'edit',
                                                    )));
                                                break;
                                              case "Remove":
                                                bool? confirmDelete =
                                                    await Get.dialog<bool>(
                                                  AlertDialog(
                                                    title: Text(
                                                      'Confirm Deletion',
                                                      style: TextStyle(
                                                          fontSize:
                                                              dataController
                                                                  .titleTextSize
                                                                  .value),
                                                    ),
                                                    content: Text(
                                                      'Are you sure you want to delete this geofence?',
                                                      style: TextStyle(
                                                          fontSize:
                                                              dataController
                                                                  .normalTextSize
                                                                  .value),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        child: Text(
                                                          'Cancel',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  dataController
                                                                      .normalTextSize
                                                                      .value),
                                                        ),
                                                        onPressed: () {
                                                          Get.back(
                                                              result: false);
                                                        },
                                                      ),
                                                      TextButton(
                                                        child: Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                              fontSize:
                                                                  dataController
                                                                      .normalTextSize
                                                                      .value),
                                                        ),
                                                        onPressed: () {
                                                          Get.back(
                                                              result: true);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                );

                                                // If user confirmed the deletion, proceed with the delete operation
                                                if (confirmDelete == true) {
                                                  await deviceController
                                                      .deleteGeoFenceById(
                                                          geoFenceData['id']
                                                              .toString());
                                                  if (deviceController
                                                          .apiStatus.value ==
                                                      ApiState.success) {
                                                    deletePolygonById(
                                                        geoFenceData['id']
                                                            .toString());
                                                    await initGeoFenceData();
                                                    Get.back();
                                                  }
                                                }
                                                break;
                                            }
                                          },
                                          itemBuilder: (BuildContext context) =>
                                              <PopupMenuEntry<String>>[
                                            PopupMenuItem<String>(
                                                value: 'Edit',
                                                child: Row(
                                                  children: [
                                                    Text('Edit',
                                                        style: TextStyle(
                                                            fontSize:
                                                                dataController
                                                                    .normalTextSize
                                                                    .value)),
                                                  ],
                                                )),
                                            PopupMenuItem<String>(
                                                value: 'Remove',
                                                child: Row(
                                                  children: [
                                                    Text('Remove',
                                                        style: TextStyle(
                                                            fontSize:
                                                                dataController
                                                                    .normalTextSize
                                                                    .value)),
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ]),
                                      onTap: () {},
                                    ),
                                    const Divider()
                                  ]);
                                }).toList(),
                              ),
                            )),
                          const Divider(),
                        ],
                      )))
              : Drawer(
                  child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 30 * dataController.currentScaleFactor.value,
                      horizontal: 5 * dataController.currentScaleFactor.value),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                                child: TextFormField(
                              onChanged: (value) {
                                if (value == "") {
                                  setState(() {
                                    deviceList = recoverDeviceList;
                                    currentSearchValue = value;
                                  });
                                  return;
                                }
                                setState(() {
                                  deviceList = [];

                                  for (dynamic device in recoverDeviceList) {
                                    if (device['name']
                                        .toString()
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                      deviceList.add(device);
                                    } else if (device['vin']
                                        .toString()
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                      deviceList.add(device);
                                    } else if (device['iccid']
                                        .toString()
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                      deviceList.add(device);
                                    } else if (device['id']
                                        .toString()
                                        .toLowerCase()
                                        .contains(value.toLowerCase())) {
                                      deviceList.add(device);
                                    }
                                  }
                                });
                              },
                              style: TextStyle(
                                  fontSize:
                                      dataController.normalTextSize.value),
                              decoration: InputDecoration(
                                  hintText: '$onlineDevices/$totalDevices'),
                            )),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.sort),
                              onSelected: (String result) async {
                                currentSortField = result;

                                await authController.saveSortKey(result);

                                bool sortDirection;

                                // Update sort direction and sort vehicles based on the selected field
                                switch (result) {
                                  case "Installation":
                                    installSortDirection =
                                        !installSortDirection;
                                    sortDirection = installSortDirection;
                                    break;
                                  case "Alphabetically":
                                    nameSortDirection = !nameSortDirection;
                                    sortDirection = nameSortDirection;
                                    break;
                                  case "Balance":
                                    balanceSortDirection =
                                        !balanceSortDirection;
                                    sortDirection = balanceSortDirection;
                                    break;
                                  case "Online":
                                    onlineSortDirection = !onlineSortDirection;
                                    sortDirection = onlineSortDirection;
                                    break;
                                  case "Lock Status":
                                    lockSortDirection = !lockSortDirection;
                                    sortDirection = lockSortDirection;
                                    break;
                                  case "Kill Status":
                                    killSortDirection = !killSortDirection;
                                    sortDirection = killSortDirection;
                                    break;
                                  case "Make":
                                    makeSortDirection = !makeSortDirection;
                                    sortDirection = makeSortDirection;
                                    break;
                                  case "Model":
                                    modelSortDirection = !modelSortDirection;
                                    sortDirection = modelSortDirection;
                                    break;
                                  case "Color":
                                    colorSortDirection = !colorSortDirection;
                                    sortDirection = colorSortDirection;
                                    break;
                                  case "Category":
                                    categorySortDirection =
                                        !categorySortDirection;
                                    sortDirection = categorySortDirection;
                                    break;
                                  case "Miles":
                                    milesSortDirection = !milesSortDirection;
                                    sortDirection = milesSortDirection;
                                    break;
                                  case "Vin":
                                    vinSortDirection = !vinSortDirection;
                                    sortDirection = vinSortDirection;
                                    break;
                                  default:
                                    sortDirection = false; // Default value
                                }

                                // Update the state
                                setState(() {
                                  deviceSortField = result;
                                  deviceSortDirection = sortDirection;
                                  sortVehicles(result, sortDirection);
                                });

                                // Save the sort direction asynchronously
                                await authController.saveSortDirection(
                                    sortDirection.toString());
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                    value: 'Installation',
                                    child: Row(
                                      children: [
                                        Text('Installation',
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value)),
                                        if (currentSortField == 'Installation')
                                          const Spacer(),
                                        if (currentSortField == 'Installation')
                                          const Icon(Icons.check),
                                        if (currentSortField == 'Installation')
                                          const Spacer(),
                                        if (currentSortField == 'Installation')
                                          installSortDirection == true
                                              ? const Icon(
                                                  Icons.arrow_downward_rounded)
                                              : const Icon(
                                                  Icons.arrow_upward_rounded)
                                      ],
                                    )),
                                PopupMenuItem<String>(
                                    value: 'Alphabetically',
                                    child: Row(
                                      children: [
                                        Text('Alphabetically',
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value)),
                                        if (currentSortField ==
                                            'Alphabetically')
                                          const Spacer(),
                                        if (currentSortField ==
                                            'Alphabetically')
                                          const Icon(Icons.check),
                                        if (currentSortField ==
                                            'Alphabetically')
                                          const Spacer(),
                                        if (currentSortField ==
                                            'Alphabetically')
                                          nameSortDirection == true
                                              ? const Icon(
                                                  Icons.arrow_downward_rounded)
                                              : const Icon(
                                                  Icons.arrow_upward_rounded)
                                      ],
                                    )),
                                PopupMenuItem<String>(
                                    value: 'Balance',
                                    child: Row(
                                      children: [
                                        Text('Balance',
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value)),
                                        if (currentSortField == 'Balance')
                                          const Spacer(),
                                        if (currentSortField == 'Balance')
                                          const Icon(Icons.check),
                                        if (currentSortField == 'Balance')
                                          const Spacer(),
                                        if (currentSortField == 'Balance')
                                          balanceSortDirection == true
                                              ? const Icon(
                                                  Icons.arrow_downward_rounded)
                                              : const Icon(
                                                  Icons.arrow_upward_rounded)
                                      ],
                                    )),
                                PopupMenuItem<String>(
                                    value: 'Online',
                                    child: Row(
                                      children: [
                                        Text('Online',
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value)),
                                        if (currentSortField == 'Online')
                                          const Spacer(),
                                        if (currentSortField == 'Online')
                                          const Icon(Icons.check),
                                        if (currentSortField == 'Online')
                                          const Spacer(),
                                        if (currentSortField == 'Online')
                                          onlineSortDirection == true
                                              ? const Icon(
                                                  Icons.arrow_downward_rounded)
                                              : const Icon(
                                                  Icons.arrow_upward_rounded)
                                      ],
                                    )),
                                PopupMenuItem<String>(
                                    value: 'Lock Status',
                                    child: Row(
                                      children: [
                                        Text('Lock Status',
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value)),
                                        if (currentSortField == 'Lock Status')
                                          const Spacer(),
                                        if (currentSortField == 'Lock Status')
                                          const Icon(Icons.check),
                                        if (currentSortField == 'Lock Status')
                                          const Spacer(),
                                        if (currentSortField == 'Lock Status')
                                          lockSortDirection == true
                                              ? const Icon(
                                                  Icons.arrow_downward_rounded)
                                              : const Icon(
                                                  Icons.arrow_upward_rounded)
                                      ],
                                    )),
                                PopupMenuItem<String>(
                                    value: 'Kill Status',
                                    child: Row(
                                      children: [
                                        Text('Kill Status',
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value)),
                                        if (currentSortField == 'Kill Status')
                                          const Spacer(),
                                        if (currentSortField == 'Kill Status')
                                          const Icon(Icons.check),
                                        if (currentSortField == 'Kill Status')
                                          const Spacer(),
                                        if (currentSortField == 'Kill Status')
                                          killSortDirection == true
                                              ? const Icon(
                                                  Icons.arrow_downward_rounded)
                                              : const Icon(
                                                  Icons.arrow_upward_rounded)
                                      ],
                                    )),
                                PopupMenuItem<String>(
                                    value: 'Make',
                                    child: Row(
                                      children: [
                                        Text('Make',
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value)),
                                        if (currentSortField == 'Make')
                                          const Spacer(),
                                        if (currentSortField == 'Make')
                                          const Icon(Icons.check),
                                        if (currentSortField == 'Make')
                                          const Spacer(),
                                        if (currentSortField == 'Make')
                                          makeSortDirection == true
                                              ? const Icon(
                                                  Icons.arrow_downward_rounded)
                                              : const Icon(
                                                  Icons.arrow_upward_rounded)
                                      ],
                                    )),
                                PopupMenuItem<String>(
                                    value: 'Model',
                                    child: Row(
                                      children: [
                                        Text('Model',
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value)),
                                        if (currentSortField == 'Model')
                                          const Spacer(),
                                        if (currentSortField == 'Model')
                                          const Icon(Icons.check),
                                        if (currentSortField == 'Model')
                                          const Spacer(),
                                        if (currentSortField == 'Model')
                                          modelSortDirection == true
                                              ? const Icon(
                                                  Icons.arrow_downward_rounded)
                                              : const Icon(
                                                  Icons.arrow_upward_rounded)
                                      ],
                                    )),
                                PopupMenuItem<String>(
                                    value: 'Color',
                                    child: Row(
                                      children: [
                                        Text('Color',
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value)),
                                        if (currentSortField == 'Color')
                                          const Spacer(),
                                        if (currentSortField == 'Color')
                                          const Icon(Icons.check),
                                        if (currentSortField == 'Color')
                                          const Spacer(),
                                        if (currentSortField == 'Color')
                                          colorSortDirection == true
                                              ? const Icon(
                                                  Icons.arrow_downward_rounded)
                                              : const Icon(
                                                  Icons.arrow_upward_rounded)
                                      ],
                                    )),
                                PopupMenuItem<String>(
                                    value: 'Category',
                                    child: Row(
                                      children: [
                                        Text('Category',
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value)),
                                        if (currentSortField == 'Category')
                                          const Spacer(),
                                        if (currentSortField == 'Category')
                                          const Icon(Icons.check),
                                        if (currentSortField == 'Category')
                                          const Spacer(),
                                        if (currentSortField == 'Category')
                                          categorySortDirection == true
                                              ? const Icon(
                                                  Icons.arrow_downward_rounded)
                                              : const Icon(
                                                  Icons.arrow_upward_rounded)
                                      ],
                                    )),
                                PopupMenuItem<String>(
                                    value: 'Miles',
                                    child: Row(
                                      children: [
                                        Text('Miles',
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value)),
                                        if (currentSortField == 'Miles')
                                          const Spacer(),
                                        if (currentSortField == 'Miles')
                                          const Icon(Icons.check),
                                        if (currentSortField == 'Miles')
                                          const Spacer(),
                                        if (currentSortField == 'Miles')
                                          milesSortDirection == true
                                              ? const Icon(
                                                  Icons.arrow_downward_rounded)
                                              : const Icon(
                                                  Icons.arrow_upward_rounded)
                                      ],
                                    )),
                                PopupMenuItem<String>(
                                    value: 'Vin',
                                    child: Row(
                                      children: [
                                        Text('Vin',
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value)),
                                        if (currentSortField == 'Vin')
                                          const Spacer(),
                                        if (currentSortField == 'Vin')
                                          const Icon(Icons.check),
                                        if (currentSortField == 'Vin')
                                          const Spacer(),
                                        if (currentSortField == 'Vin')
                                          vinSortDirection == true
                                              ? const Icon(
                                                  Icons.arrow_downward_rounded)
                                              : const Icon(
                                                  Icons.arrow_upward_rounded)
                                      ],
                                    )),
                              ],
                            ),
                            IconButton(
                              padding: const EdgeInsets.all(2),
                              icon: Icon(Icons.add,
                                  size: dataController.iconSize.value),
                              onPressed: () {
                                Get.back();
                                Get.toNamed('/device-manage');
                              },
                            ),
                          ],
                        ),
                      ),
                      if (deviceList.isNotEmpty) const Divider(),
                      if (deviceList.isNotEmpty)
                        Expanded(
                            child: SingleChildScrollView(
                          child: Column(
                            children: deviceList.map((device) {
                              return ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5 *
                                        dataController.currentScaleFactor.value,
                                    horizontal: 5 *
                                        dataController
                                            .currentScaleFactor.value),
                                title: Row(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            pickedImageFile = null;
                                          });
                                          Get.dialog(Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                              ),
                                              child: UploadDeviceImageWidget(
                                                device: device,
                                              ))).then((value) => initData());
                                        },
                                        child: Container(
                                            padding: EdgeInsets.all(8 *
                                                dataController
                                                    .currentScaleFactor.value),
                                            width: 50 *
                                                dataController
                                                    .currentScaleFactor.value,
                                            height: 50 *
                                                dataController
                                                    .currentScaleFactor.value,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(30 *
                                                        dataController
                                                            .currentScaleFactor
                                                            .value)),
                                                color: Colors.grey[500]),
                                            child: device['image'] != "" &&
                                                    device['image'] != null
                                                ? Image.network(
                                                    ApiConfig.siteUrl +
                                                        device['image'],
                                                  )
                                                : SvgPicture.asset(
                                                    "asset/images/"
                                                    "${device['category'] ?? 'Default'}.svg",
                                                    width: 10,
                                                    height: 10,
                                                    colorFilter: const ColorFilter.mode(
                                                        Colors.white,
                                                        BlendMode.srcIn)))),
                                    SizedBox(
                                      width: 5 *
                                          dataController
                                              .currentScaleFactor.value,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(device['name'],
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .titleTextSize.value)),
                                        Row(children: [
                                          Text(
                                            device['status'] != "online"
                                                ? "${device['status']} ${convertUTCtoLocal4(device['lastConnect'].toString())}"
                                                : device['status'],
                                            style: TextStyle(
                                                fontSize: dataController
                                                    .normalTextSize.value,
                                                color:
                                                    device['status'] == "online"
                                                        ? Colors.green
                                                        : Colors.orange[700]),
                                          ),
                                          const Spacer(),
                                          OutlinedButton(
                                            style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 5 *
                                                    dataController
                                                        .currentScaleFactor
                                                        .value,
                                                vertical: 2 *
                                                    dataController
                                                        .currentScaleFactor
                                                        .value,
                                              ),
                                            ),
                                            child: Text(
                                              device['credit'],
                                              style: TextStyle(
                                                color: getColor(double.parse(
                                                    device['credit']
                                                        .toString())),
                                                fontSize: dataController
                                                    .normalTextSize.value,
                                              ),
                                            ),
                                            onPressed: () {
                                              Get.back();
                                              setState(() {
                                                selectedDevice = device;
                                              });
                                              dataController
                                                  .updateCurrentDeviceId(
                                                      selectedDevice['id']
                                                          .toString());

                                              Get.dialog(Dialog(
                                                  insetPadding:
                                                      const EdgeInsets.all(10),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  child: CreditBalanceWidget(
                                                      onChanged: (vale) {})));
                                            },
                                          )
                                        ])
                                      ],
                                    )),
                                  ],
                                ),
                                onTap: () async {
                                  Get.back();
                                  setState(() {
                                    selectedDevice = device;
                                  });
                                  dynamic updatedDevice = device;
                                  await deviceController.getMainPageData();
                                  if (deviceController.apiStatus.value ==
                                      ApiState.failure) {
                                    Get.snackbar("Failed",
                                        deviceController.errorMessage.value,
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                        animationDuration:
                                            const Duration(milliseconds: 300));

                                    return;
                                  }
                                  if (deviceController.mainPageData.value !=
                                      null) {
                                    for (int i = 0;
                                        i <
                                            deviceController
                                                .mainPageData.value.length;
                                        i++) {
                                      if (deviceController.mainPageData.value[i]
                                              ['id'] ==
                                          device['id']) {
                                        updatedDevice = deviceController
                                            .mainPageData.value[i];
                                      }
                                    }
                                  }
                                  updateCurrentDeviceMarker(
                                      updatedDevice['id'].toString());
                                  dataController.updateCurrentDeviceId(
                                      updatedDevice['id'].toString());

                                  setState(() {
                                    selectedDeviceToPlay = updatedDevice;
                                  });

                                  if (double.parse(
                                          updatedDevice['credit'].toString()) >=
                                      double.parse(updatedDevice['monthly_cost']
                                              .toString()) *
                                          2) {
                                    Get.dialog(Dialog(
                                        insetPadding: const EdgeInsets.all(10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: CreditBalanceWidget(
                                            onChanged: (value) {})));
                                  } else {
                                    Get.dialog(Dialog(
                                        insetPadding: const EdgeInsets.all(10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: DeviceSettingWidget(
                                            onChanged: (value) {})));
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        )),
                      const Divider(),
                    ],
                  ),
                )))),
      floatingActionButton: Obx(() => dataController
              .geoGeoFenceEditingEnabled.value
          ? Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 40 * dataController.currentScaleFactor.value,
                  horizontal: 0),
              child: SizedBox(
                  height: 90 * dataController.currentScaleFactor.value,
                  child: Column(
                    children: [
                      InkWell(
                          onTap: () {
                            setState(() {
                              drawingPolygonEnabled = !drawingPolygonEnabled;
                            });
                            if (!drawingPolygonEnabled) {
                              polygonPoints.clear();
                              polygonsList.removeWhere((polygon) =>
                                  polygon.polygonId.value == "polygon_1");
                            }
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    5 * dataController.currentScaleFactor.value,
                                vertical: 5 *
                                    dataController.currentScaleFactor.value),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(160, 255, 255, 255)),
                            child: Icon(
                              Icons.polyline_outlined,
                              color: drawingPolygonEnabled
                                  ? Colors.blue
                                  : Colors.black,
                            ),
                          )),
                      InkWell(
                          onTap: () {
                            if (polygonPoints.isNotEmpty) {
                              polygonPoints.removeLast();
                            }
                            setState(() {});
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    5 * dataController.currentScaleFactor.value,
                                vertical: 5 *
                                    dataController.currentScaleFactor.value),
                            decoration: const BoxDecoration(
                                color: Color.fromARGB(160, 255, 255, 255)),
                            child: const Icon(
                              Icons.delete_outline,
                            ),
                          )),
                    ],
                  )))
          : dataController.showPlayPositionsHistory.value
              ? const SizedBox()
              : Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 40 * dataController.currentScaleFactor.value,
                      vertical: 0),
                  child: SizedBox(
                      width: 50,
                      height: 120,
                      child: Column(children: [
                        FloatingActionButton(
                          mini: dataController.currentScaleFactor < 1,
                          onPressed: () {
                            initData();
                          },
                          shape: const CircleBorder(),
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          child: const Icon(
                            Icons.refresh,
                          ),
                        ),
                        FloatingActionButton(
                          mini: dataController.currentScaleFactor < 1,
                          onPressed: () {
                            onMapTypeButtonPressed();
                          },
                          shape: const CircleBorder(),
                          backgroundColor:
                              const Color.fromARGB(255, 226, 138, 5),
                          foregroundColor: Colors.white,
                          child: currentMapType == MapType.normal
                              ? const Icon(
                                  Icons.satellite_alt_outlined,
                                )
                              : const Icon(
                                  Icons.image,
                                ),
                        )
                      ])),
                )),
    );
  }
}
