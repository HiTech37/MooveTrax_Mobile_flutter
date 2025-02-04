import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

  DateTime selectedFromDate = DateTime.now().add(const Duration(days: -7));
  DateTime selectedToDate = DateTime.now();

  List<dynamic> deviceList = [
    {"id": "Devices", "name": "Devices"}
  ];
  List<dynamic> deviceIds = [];
  final AuthController authController = getIt<AuthController>();
  final DataController dataController = Get.find<DataController>();

  final ReportsController reportsController = getIt<ReportsController>();
  dynamic dropdownValue;

  Future<void> _fetchData() async {
    print("deviceList=>${deviceList.length}");
    print("deviceIds=>${deviceIds.length}");

    if (!context.mounted) return;
    await reportsController.getMileAgeList({
      'deviceIds': deviceIds,
      'page': currentPage - 1,
      'rowsPerPage': rowsPerPage,
      'sortOrder': {},
      'date_from': DateFormat('yyyy-MM-dd').format(selectedFromDate),
      'date_to': DateFormat('yyyy-MM-dd').format(selectedToDate),
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
        // }r
        // if (pages == 0) {
        //   totalPage = 1;
        // } else {
        //   totalPage = pages;
        // }
      }
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
        _fetchData();
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
        _fetchData();
      });
    }
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
      dropdownValue = null; // No device selected initially
      for (var el in devices) {
        deviceList.add(el); // Add devices to the list
      }
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text('From',
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value)),
                const SizedBox(width: 8),
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
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text('To',
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value)),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => selectToDate(context),
                  child: Padding(
                    padding: EdgeInsets.all(
                        5 * dataController.currentScaleFactor.value),
                    child: Text(
                      DateFormat('yyyy-MM-dd')
                          .format(selectedToDate)
                          .toString(),
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: dataController.normalTextSize.value),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minWidth: MediaQuery.of(context).size.width),
                    child: DataTable(
                      sortAscending: _sortAscending,
                      sortColumnIndex: _sortColumnIndex,
                      columns: [
                        DataColumn(
                          label: Text("Date (GMT-0)",
                              style: TextStyle(
                                  fontSize:
                                      dataController.normalTextSize.value)),
                          onSort: (columnIndex, ascending) {
                            _sort<String>(
                                (data) => data['date'].toString(), columnIndex);
                          },
                        ),
                        DataColumn(
                          label: Text("Distance",
                              style: TextStyle(
                                  fontSize:
                                      dataController.normalTextSize.value)),
                          onSort: (columnIndex, ascending) {
                            _sort<String>(
                                (data) => data['mileage_real'].toString(),
                                columnIndex);
                          },
                        ),
                      ],
                      rows: dailyMileAgeData != null
                          ? List<DataRow>.generate(
                              dailyMileAgeData['data'].length,
                              (index) => DataRow(
                                cells: [
                                  DataCell(Text(
                                    convertUTCtoLocal(dailyMileAgeData['data']
                                            [index]["date"]
                                        .toString()),
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  )),
                                  DataCell(Text(
                                    dailyMileAgeData['data'][index]["mileage"]
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  )),
                                ],
                              ),
                            )
                          : [],
                    ),
                  ),
                ),
              ),
            ),
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
          vertical: 5 * dataController.currentScaleFactor.value,
        ),
        height: dataController.bottomAppBarHeight.value,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Spacer(),
            DropdownButton<dynamic>(
              value: deviceIds.isEmpty ? null : deviceList[0],
              hint: Text(
                "Select Devices", // Default hint text
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
              icon: Icon(
                Icons.arrow_drop_down,
                size: dataController.iconSize.value,
              ),
              underline: Container(),
              elevation: 16,
              onChanged: (dynamic value) {
                setState(() {
                  if (value['id'] != "Devices") {
                    if (deviceIds.contains(value['id'])) {
                      deviceIds.remove(value['id']);
                    } else {
                      deviceIds.add(value['id']);
                    }
                  }
                });
                _fetchData();
              },
              items: deviceList.map<DropdownMenuItem<dynamic>>((dynamic value) {
                bool isSelected = deviceIds.contains(value['id']);
                return DropdownMenuItem<dynamic>(
                  value: value,
                  child: Row(
                    children: [
                      if (isSelected)
                        Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 20 * dataController.currentScaleFactor.value,
                        )
                      else
                        SizedBox(
                            width:
                                30 * dataController.currentScaleFactor.value),
                      Text(
                        value['name']! == "Devices"
                            ? "Select Device"
                            : value['name'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: dataController.normalTextSize.value,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
