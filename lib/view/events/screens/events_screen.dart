import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/core/common.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/reports/controller/reports_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  EventsScreenState createState() => EventsScreenState();
}

class EventsScreenState extends State<EventsScreen> {
  ScrollController? tableController;
  bool _sortAscending = false;
  int _sortColumnIndex = 3;
  int rowsPerPage = 20;
  int totalPage = 0;
  dynamic eventsData;
  int currentPage = 1;
  TextEditingController pageNumberController = TextEditingController();
  List<dynamic> deviceList = [
    {"id": "All", "name": "All"}
  ];
  dynamic dropdownValue;
  final AuthController authController = getIt<AuthController>();
  String sortName = "deviceTime";
  String sortDirection = "desc";

  final ReportsController reportsController = getIt<ReportsController>();
  final DataController dataController = Get.find<DataController>();

  Future<void> _fetchData() async {
    if (!context.mounted) return;
    if (authController.storageUserData == null) return;
    await reportsController.getEvents({
      'deviceId': dropdownValue['id'],
      'page': currentPage - 1,
      'rowsPerPage': rowsPerPage,
      'sortOrder': {'name': sortName, 'direction': sortDirection},
      'userId': authController.storageUserData?['id']
    });
    setState(() {
      eventsData = reportsController.eventsData.value;
      if (eventsData != null) {
        int pages = eventsData['total'] ~/ rowsPerPage;
        if (eventsData['total'] % rowsPerPage != 0) {
          pages++;
        }
        if (pages == 0) {
          totalPage = 1;
        } else {
          totalPage = pages;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    pageNumberController.text = '1';
    await authController.getUserProfile();
    final dynamic userData = authController.profileData.value;
    if (userData != null) {
      final dynamic devices = userData['devices'] ?? [];

      deviceList.addAll(devices);
      dropdownValue = deviceList[0];
    }
    _fetchData(); // Fetch data when the screen initializes
  }

  @override
  void dispose() {
    pageNumberController.dispose();
    super.dispose();
  }

  void _sort(String sortField, int columnIndex) {
    if (_sortColumnIndex == columnIndex) {
      // If the same column is clicked again, toggle the sort order
      _sortAscending = !_sortAscending;
    } else {
      // Otherwise, sort in ascending order
      _sortAscending = true;
    }
    setState(() {
      sortName = sortField;
      if (_sortAscending) {
        sortDirection = "asc";
      } else {
        sortDirection = "desc";
      }
    });
    setState(() {
      _sortColumnIndex = columnIndex;
    });
    _fetchData();
  }

  String getWarningData(dynamic event) {
    if (event['warning_data'] == null) return '';
    Map<String, dynamic> jsonMap = json.decode(event['warning_data']);
    if (event['warning'] == 'Low_Battery') {
      return "Low Battery: ${jsonMap['mt2v_dc_volt']}";
    }
    if (event['warning'] == 'Odometer') {
      return "Miles: ${jsonMap['mileage']}";
    }

    if (event['warning'] == 'Geofence') {
      return "Geofence: ${jsonMap['fence_name']}";
    }
    if (event['warning'] == 'Severe_Weather') {
      return " ${jsonMap['headline']}";
    }
    if (event['warning'] == 'Unlocked_by_Bluetooth') {
      return "Unlocked via Bluetooth";
    }
    if (event['warning'] == 'Locked_by_Bluetooth') {
      return "Locked via Bluetooth";
    }
    if (event['warning'] == 'ACC_ON') {
      return "ACC ON";
    }
    if (event['warning'] == 'ACC_OFF') {
      return "ACC OFF";
    }
    return event['warning'];
  }

  String findDeviceName(String id) {
    for (int i = 0; i < deviceList.length; i++) {
      if (deviceList[i]['id'].toString() == id) {
        return deviceList[i]['name'];
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: dataController.appBarHeight.value,
        title: Text(
          "Events",
          style: TextStyle(fontSize: dataController.appBarTitleSize.value),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: dataController.iconSize.value,
          ),
        ),
        actions: [
          DropdownButton<String>(
            padding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 5 * dataController.currentScaleFactor.value),
            items: <String>['Daily Mileage', 'Commands', 'Home']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              if (value == 'Daily Mileage') {
                Get.toNamed('/reports/daily-mileage');
              }
              if (value == 'Commands') {
                Get.toNamed('/reports/commands');
              }
              if (value == 'Home') {
                Get.toNamed('/home');
                dataController.changeTabIndex(0);
              }
            },
            icon: Icon(
              Icons.menu,
              size: dataController.iconSize.value,
              color: Colors.white,
            ),
            underline: const SizedBox(), // Removes the underline
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: MediaQuery.of(context).size.width,
                        ),
                        child: DataTable(
                          sortAscending: _sortAscending,
                          sortColumnIndex: _sortColumnIndex,
                          columns: [
                            DataColumn(
                              label: Row(
                                children: [
                                  Text(
                                    "DEVICE",
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sort(
                                  'deviceId',
                                  columnIndex,
                                );
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Text(
                                    "EVENT",
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sort(
                                  'warning',
                                  columnIndex,
                                );
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Text(
                                    "BATTERY(V)",
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sort(
                                  'mt2v_dc_volt',
                                  columnIndex,
                                );
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Text(
                                    "WHEN",
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sort(
                                  'deviceTime',
                                  columnIndex,
                                );
                              },
                            ),
                          ],
                          rows: eventsData != null
                              ? List<DataRow>.generate(
                                  eventsData['data'].length,
                                  (index) => DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          findDeviceName(eventsData['data']
                                                  [index]["deviceId"]
                                              .toString()),
                                          style: TextStyle(
                                              fontSize: dataController
                                                  .normalTextSize.value),
                                        ),
                                      ),
                                      DataCell(
                                        eventsData['data'][index]['warning'] ==
                                                'Geofence'
                                            ? GestureDetector(
                                                onTap: () async {
                                                  Map<String, dynamic> jsonMap =
                                                      json.decode(
                                                          eventsData['data']
                                                                  [index]
                                                              ['warning_data']);
                                                  if (await canLaunchUrl(
                                                      Uri.parse(jsonMap[
                                                          'googleMapUrl']))) {
                                                    await launchUrl(
                                                      Uri.parse(jsonMap[
                                                          'googleMapUrl']),
                                                      mode: LaunchMode
                                                          .externalApplication,
                                                    );
                                                  } else {
                                                    throw "Could not launch this url";
                                                  }
                                                },
                                                child: Text(
                                                  getWarningData(
                                                      eventsData['data']
                                                          [index]),
                                                  style: const TextStyle(
                                                      color: Colors.blue),
                                                ),
                                              )
                                            : Text(
                                                getWarningData(
                                                    eventsData['data'][index]),
                                                style: TextStyle(
                                                    fontSize: dataController
                                                        .normalTextSize.value),
                                              ),
                                      ),
                                      DataCell(
                                        Text(
                                          eventsData['data'][index]
                                                      ["mt2v_dc_volt"] !=
                                                  null
                                              ? '${eventsData['data'][index]["mt2v_dc_volt"]} V'
                                              : '',
                                          style: TextStyle(
                                              fontSize: dataController
                                                  .normalTextSize.value),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          convertUTCtoLocal(eventsData['data']
                                                  [index]["deviceTime"]
                                              .toString()),
                                          style: TextStyle(
                                              fontSize: dataController
                                                  .normalTextSize.value),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : [],
                        )))),
          ),
          Obx(() => reportsController.apiStatus.value == ApiState.loading
              ? Container(
                  color: Colors.grey.withAlpha(25),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : const SizedBox()),
        ],
      ),
      resizeToAvoidBottomInset: true,
      bottomSheet: BottomAppBar(
        padding: EdgeInsets.symmetric(
            horizontal: 10 * dataController.currentScaleFactor.value,
            vertical: 10 * dataController.currentScaleFactor.value),
        height: dataController.bottomAppBarHeight.value,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              child: Icon(
                Icons.navigate_before,
                size: dataController.iconSize.value,
              ),
              onTap: () {
                if (reportsController.apiStatus.value == ApiState.loading) {
                  return;
                }
                if (currentPage == 1) return;
                setState(() {
                  currentPage = currentPage - 1;
                  pageNumberController.text = currentPage.toString();
                });
                _fetchData();
              },
            ),
            Text(
              eventsData == null ? '' : '$currentPage / $totalPage',
              style: TextStyle(fontSize: dataController.normalTextSize.value),
            ),
            InkWell(
              child: Icon(
                Icons.navigate_next,
                size: dataController.iconSize.value,
              ),
              onTap: () {
                if (reportsController.apiStatus.value == ApiState.loading) {
                  return;
                }
                if (currentPage == totalPage) return;
                setState(() {
                  currentPage = currentPage + 1;
                  pageNumberController.text = currentPage.toString();
                });
                _fetchData();
              },
            ),
            Expanded(
              child: TextField(
                controller: pageNumberController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: dataController.appBarTitleSize.value),
                decoration: const InputDecoration(
                    hintText: 'Enter page number',
                    contentPadding: EdgeInsets.all(0)),
                onSubmitted: (value) {
                  setState(() {
                    if (int.parse(value) > totalPage) {
                      setState(() {
                        currentPage = totalPage;
                        pageNumberController.text = currentPage.toString();
                      });
                    } else if (int.parse(value) < 1) {
                      setState(() {
                        currentPage = 1;
                        pageNumberController.text = currentPage.toString();
                      });
                    } else {
                      setState(() {
                        currentPage = int.parse(value);
                        pageNumberController.text = currentPage.toString();
                      });
                    }
                    _fetchData();
                  });
                },
              ),
            ),
            SizedBox(
              width: 15 * dataController.currentScaleFactor.value,
            ),
            DropdownButton<dynamic>(
              value: dropdownValue,
              icon: Icon(Icons.arrow_drop_down,
                  size: dataController.iconSize.value),
              underline: Container(),
              elevation: 16,
              onChanged: (dynamic value) {
                setState(() {
                  dropdownValue = value;
                });
                _fetchData();
              },
              items: deviceList.map<DropdownMenuItem<dynamic>>((dynamic value) {
                return DropdownMenuItem<dynamic>(
                    value: value,
                    child: SizedBox(
                      width: 120 * dataController.currentScaleFactor.value,
                      child: Text(value['name']!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: dataController.normalTextSize.value)),
                    ));
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
