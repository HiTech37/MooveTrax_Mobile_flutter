import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/core/common.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/reports/controller/reports_controller.dart';

class CommandsScreen extends StatefulWidget {
  const CommandsScreen({super.key});

  @override
  EventsScreenState createState() => EventsScreenState();
}

class EventsScreenState extends State<CommandsScreen> {
  ScrollController? tableController;
  bool _sortAscending = true;
  int _sortColumnIndex = 0;
  int rowsPerPage = 20;
  int totalPage = 0;
  dynamic commandsData;
  int currentPage = 1;
  TextEditingController pageNumberController = TextEditingController();
  List<dynamic> deviceList = [
    {"id": "All", "name": "All"}
  ];
  dynamic dropdownValue;
  final ReportsController reportsController = getIt<ReportsController>();
  final AuthController authController = getIt<AuthController>();
  String sortName = "createdAt";
  String sortDirection = "desc";
  final DataController dataController = Get.find<DataController>();

  Future<void> _fetchData() async {
    if (!context.mounted) return;
    if (authController.storageUserData == null) return;
    await reportsController.getCommands({
      'deviceId': dropdownValue['id'],
      'page': currentPage - 1,
      'rowsPerPage': rowsPerPage,
      'sortOrder': {'name': sortName, 'direction': sortDirection},
      'userId': authController.storageUserData?['id']
    });
    setState(() {
      commandsData = reportsController.commandsData.value;
      if (commandsData != null) {
        int pages = commandsData['total'] ~/ rowsPerPage;
        if (commandsData['total'] % rowsPerPage != 0) {
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
    getUserNameList();
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

  Future<void> getUserNameList() async {
    await reportsController.getUserNameList();
    _fetchData();
  }

  String getDeviceName(String deviceId) {
    String deviceName = deviceId;
    for (int i = 0; i < deviceList.length; i++) {
      if (deviceList[i]['id'].toString() == deviceId) {
        deviceName = deviceList[i]['name'].toString();
      }
    }
    return deviceName;
  }

  String findUserName(String userID) {
    if (reportsController.userNameList.value == null) return '';
    if (userID == '0') {
      return 'system';
    }
    if (userID == '-1') {
      return 'Installer';
    }
    if (reportsController.userNameList.value.length == 0) {
      return '';
    } else {
      for (int i = 0; i < reportsController.userNameList.value.length; i++) {
        if (reportsController.userNameList.value[i]['id'].toString() ==
            userID) {
          return reportsController.userNameList.value[i]['name'];
        }
      }
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: dataController.appBarHeight.value,
        title: Text(
          "Commands",
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
            items:
                <String>['Events', 'Daily Mileage', 'Home'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              if (value == 'Events') {
                Get.toNamed('/reports/events');
              }
              if (value == 'Daily Mileage') {
                Get.toNamed('/reports/daily-mileage');
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
                                  Text("USER",
                                      style: TextStyle(
                                          fontSize: dataController
                                              .normalTextSize.value)),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sort(
                                  'userId',
                                  columnIndex,
                                );
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Text("DEVICE",
                                      style: TextStyle(
                                          fontSize: dataController
                                              .normalTextSize.value)),
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
                                  Text("COMMAND",
                                      style: TextStyle(
                                          fontSize: dataController
                                              .normalTextSize.value)),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sort(
                                  'commandType',
                                  columnIndex,
                                );
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Text("VALUE",
                                      style: TextStyle(
                                          fontSize: dataController
                                              .normalTextSize.value)),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sort(
                                  'count',
                                  columnIndex,
                                );
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Text("WHEN",
                                      style: TextStyle(
                                          fontSize: dataController
                                              .normalTextSize.value)),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sort(
                                  'createdAt',
                                  columnIndex,
                                );
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Text("STATUS",
                                      style: TextStyle(
                                          fontSize: dataController
                                              .normalTextSize.value)),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sort(
                                  'status',
                                  columnIndex,
                                );
                              },
                            ),
                          ],
                          rows: commandsData != null
                              ? List<DataRow>.generate(
                                  commandsData['data'].length,
                                  (index) => DataRow(
                                    cells: [
                                      DataCell(
                                        Text(
                                          findUserName(commandsData['data']
                                                  [index]["userId"]
                                              .toString()),
                                          style: TextStyle(
                                              fontSize: dataController
                                                  .normalTextSize.value),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          getDeviceName(commandsData['data']
                                                  [index]["deviceId"]
                                              .toString()),
                                          style: TextStyle(
                                              fontSize: dataController
                                                  .normalTextSize.value),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          commandsData['data'][index]
                                                  ["commandType"]
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: dataController
                                                  .normalTextSize.value),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          commandsData['data'][index]["count"]
                                                          .toString() ==
                                                      'null' ||
                                                  commandsData['data'][index]
                                                              ["count"]
                                                          .toString() ==
                                                      '0'
                                              ? ''
                                              : commandsData['data'][index]
                                                      ["count"]
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: dataController
                                                  .normalTextSize.value),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          convertUTCtoLocal(commandsData['data']
                                                  [index]["createdAt"]
                                              .toString()),
                                          style: TextStyle(
                                              fontSize: dataController
                                                  .normalTextSize.value),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          commandsData['data'][index]["status"]
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
                  color: const Color.fromARGB(36, 158, 158, 158),
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
                child: Icon(Icons.navigate_before,
                    size: dataController.iconSize.value),
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
                commandsData == null ? '' : '$currentPage / $totalPage',
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
              InkWell(
                child: Icon(Icons.navigate_next,
                    size: dataController.iconSize.value),
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
              SizedBox(
                width: 10 * dataController.currentScaleFactor.value,
              ),
              SizedBox(
                width: 60 * dataController.currentScaleFactor.value,
                height: 40 * dataController.currentScaleFactor.value,
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
                width: 10 * dataController.currentScaleFactor.value,
              ),
              DropdownButton<dynamic>(
                value: dropdownValue,
                icon: Icon(
                  Icons.arrow_drop_down,
                  size: dataController.iconSize.value,
                ),
                underline: Container(),
                onChanged: (dynamic value) {
                  setState(() {
                    dropdownValue = value;
                  });
                  _fetchData();
                },
                items:
                    deviceList.map<DropdownMenuItem<dynamic>>((dynamic value) {
                  return DropdownMenuItem<dynamic>(
                    value: value,
                    child: SizedBox(
                        width: 120 * dataController.currentScaleFactor.value,
                        child: Text(
                          value['name']!.toString(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: dataController.normalTextSize.value),
                        )),
                  );
                }).toList(),
              ),
            ],
          )),
    );
  }
}
