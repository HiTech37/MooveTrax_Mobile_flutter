import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/core/common.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/reports/controller/reports_controller.dart';

class DailyMileAgeScreen extends StatefulWidget {
  const DailyMileAgeScreen({super.key});

  @override
  EventsScreenState createState() => EventsScreenState();
}

class EventsScreenState extends State<DailyMileAgeScreen> {
  ScrollController? tableController;
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  int rowsPerPage = 20;
  int totalPage = 0;
  dynamic dailyMileAgeData;
  int currentPage = 1;
  TextEditingController pageNumberController = TextEditingController();
  List<dynamic> deviceList = [
    {"id": "All", "name": "All"}
  ];
  final AuthController authController = getIt<AuthController>();
  final DataController dataController = Get.find<DataController>();

  final ReportsController reportsController = getIt<ReportsController>();
  dynamic dropdownValue;

  Future<void> _fetchData() async {
    if (!context.mounted) return;
    await reportsController.getMileAgeList({
      'deviceId': dropdownValue['id'],
      'page': currentPage - 1,
      'rowsPerPage': rowsPerPage,
      'sortOrder': {},
    });
    setState(() {
      dailyMileAgeData = reportsController.mileAgeData.value;
      if (dailyMileAgeData != null) {
        // Get the current date
        final DateTime now = DateTime.now();
        // Calculate the date 30 days ago
        final DateTime thirtyDaysAgo = now.subtract(const Duration(days: 30));

        // Filter the data to only include the last 30 days
        final List filteredData = dailyMileAgeData['data'].where((item) {
          DateTime itemDate = DateTime.parse(item['date']);
          return itemDate.isAfter(thirtyDaysAgo);
        }).toList();
        setState(() {
          dailyMileAgeData['data'] = filteredData;
        });

        // Calculate the total pages
        // int pages = dailyMileAgeData['data'].length ~/ rowsPerPage;
        // if (dailyMileAgeData['data'].length % rowsPerPage != 0) {
        //   pages++;
        // }
        // if (pages == 0) {
        //   totalPage = 1;
        // } else {
        //   totalPage = pages;
        // }
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

  void _sort<T>(
      Comparable<T> Function(Map<String, dynamic>) getField, int columnIndex) {
    if (_sortColumnIndex == columnIndex) {
      // If the same column is clicked again, toggle the sort order
      _sortAscending = !_sortAscending;
    } else {
      // Otherwise, sort in ascending order
      _sortAscending = true;
    }

    dailyMileAgeData['data'].sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return _sortAscending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    setState(() {
      _sortColumnIndex = columnIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: dataController.appBarHeight.value,
        title: Text(
          "Daily Mileage",
          style: TextStyle(fontSize: dataController.appBarTitleSize.value),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new,
              size: dataController.iconSize.value),
        ),
        actions: [
          DropdownButton<String>(
            padding: EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 5 * dataController.currentScaleFactor.value),
            items: <String>['Events', 'Commands', 'Home'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              if (value == 'Events') {
                Get.toNamed('/reports/events');
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
                                    "Date ( GMT-0 )",
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sort<String>(
                                  (data) => data['date'].toString(),
                                  columnIndex,
                                );
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Text(
                                    "Distance",
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sort<String>(
                                  (data) => data['mileage_real'].toString(),
                                  columnIndex,
                                );
                              },
                            ),
                          ],
                          rows: dailyMileAgeData != null
                              ? List<DataRow>.generate(
                                  dailyMileAgeData['data'].length,
                                  (index) => DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          convertUTCtoLocal(
                                              dailyMileAgeData['data'][index]
                                                      ["date"]
                                                  .toString()),
                                          style: TextStyle(
                                              fontSize: dataController
                                                  .normalTextSize.value),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          dailyMileAgeData['data'][index]
                                                  ["mileage"]
                                              .toString(),
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
            vertical: 5 * dataController.currentScaleFactor.value),
        height: dataController.bottomAppBarHeight.value,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // InkWell(
            //   child: Icon(
            //     Icons.navigate_before,
            //     size: dataController.iconSize.value,
            //   ),
            //   onTap: () {
            //     if (reportsController.apiStatus.value == ApiState.loading) {
            //       return;
            //     }
            //     if (currentPage == 1) return;
            //     setState(() {
            //       currentPage = currentPage - 1;
            //       pageNumberController.text = currentPage.toString();
            //     });
            //     _fetchData();
            //   },
            // ),
            // Text(
            //   dailyMileAgeData == null ? '' : '$currentPage / $totalPage',
            //   style: TextStyle(fontSize: dataController.normalTextSize.value),
            // ),
            // InkWell(
            //   child: Icon(
            //     Icons.navigate_next,
            //     size: dataController.iconSize.value,
            //   ),
            //   onTap: () {
            //     if (reportsController.apiStatus.value == ApiState.loading) {
            //       return;
            //     }
            //     if (currentPage == totalPage) return;
            //     setState(() {
            //       currentPage = currentPage + 1;
            //       pageNumberController.text = currentPage.toString();
            //     });
            //     _fetchData();
            //   },
            // ),
            // Expanded(
            //   child: TextField(
            //     controller: pageNumberController,
            //     keyboardType: TextInputType.number,
            //     textAlign: TextAlign.center,
            //     style:
            //         TextStyle(fontSize: dataController.appBarTitleSize.value),
            //     decoration: const InputDecoration(
            //         hintText: 'Enter page number',
            //         contentPadding: EdgeInsets.all(0)),
            //     onSubmitted: (value) {
            //       setState(() {
            //         if (int.parse(value) > totalPage) {
            //           setState(() {
            //             currentPage = totalPage;
            //             pageNumberController.text = currentPage.toString();
            //           });
            //         } else if (int.parse(value) < 1) {
            //           setState(() {
            //             currentPage = 1;
            //             pageNumberController.text = currentPage.toString();
            //           });
            //         } else {
            //           setState(() {
            //             currentPage = int.parse(value);
            //             pageNumberController.text = currentPage.toString();
            //           });
            //         }
            //         _fetchData();
            //       });
            //     },
            //   ),
            // ),
            // SizedBox(
            //   width: 15 * dataController.currentScaleFactor.value,
            // ),
            const Spacer(),
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
