import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/core/common.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/reports/controller/reports_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class TuroTripScreen extends StatefulWidget {
  const TuroTripScreen({super.key});

  @override
  TuroTripScreenState createState() => TuroTripScreenState();
}

class TuroTripScreenState extends State<TuroTripScreen> {
  ScrollController? tableController;
  bool _sortAscending = false;
  int _sortColumnIndex = 2;
  int rowsPerPage = 20;
  int totalPage = 0;
  dynamic turoTripsData;
  int currentPage = 1;
  TextEditingController pageNumberController = TextEditingController();
  List<String> datetypeList = ['All', 'Old', 'Current', 'Future'];
  String filterDateType = 'All';
  final AuthController authController = getIt<AuthController>();
  final DataController dataController = Get.find<DataController>();

  final ReportsController reportsController = getIt<ReportsController>();
  String sortName = "start";
  String sortDirection = "desc";
  Future<void> _fetchData() async {
    if (!context.mounted) return;
    if (!context.mounted) return;
    if (authController.storageUserData == null) return;
    await reportsController.getTuroTrips({
      'page': currentPage - 1,
      'filter_date_tpye':
          filterDateType == "current" ? 'active' : filterDateType.toLowerCase(),
      'rowsPerPage': rowsPerPage,
      'sortOrder': {"name": sortName, "direction": sortDirection},
      'userId': authController.storageUserData?['id']
    });
    setState(() {
      turoTripsData = reportsController.turoTripsData.value;
      if (turoTripsData != null) {
        int pages = turoTripsData['total'] ~/ rowsPerPage;
        if (turoTripsData['total'] % rowsPerPage != 0) {
          pages++;
        }
        setState(() {
          if (pages == 0) {
            totalPage = 1;
          } else {
            if (pages == 0) {
              totalPage = 1;
            } else {
              totalPage = pages;
            }
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    pageNumberController.text = '1';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData(); // Fetch data when the screen initializes
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: dataController.appBarHeight.value,
        title: Text(
          "Turo Trips",
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
                                    "RESERVATION",
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sort(
                                  'uid',
                                  columnIndex,
                                );
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Text(
                                    "UPDATED",
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sort(
                                  'lastmodified',
                                  columnIndex,
                                );
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Text(
                                    "START",
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sort(
                                  'start',
                                  columnIndex,
                                );
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Text(
                                    "END",
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sort(
                                  'end',
                                  columnIndex,
                                );
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Text(
                                    "SUMMARY",
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sort(
                                  'summary',
                                  columnIndex,
                                );
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Text(
                                    "LOCATION",
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sort(
                                  'location',
                                  columnIndex,
                                );
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Text(
                                    "DRIVER",
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sort(
                                  'primary_driver',
                                  columnIndex,
                                );
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Text(
                                    "PHONE",
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sort(
                                  'phone',
                                  columnIndex,
                                );
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Text(
                                    "MOOVETRAX CODE",
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                ],
                              ),
                              onSort: (columnIndex, ascending) {
                                _sort(
                                  'shareUrl',
                                  columnIndex,
                                );
                              },
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Text(
                                    "Refresh",
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                ],
                              ),
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Text(
                                    "Action",
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          rows: turoTripsData != null
                              ? List<DataRow>.generate(
                                  turoTripsData['data'].length,
                                  (index) => DataRow(
                                    cells: [
                                      DataCell(GestureDetector(
                                        onTap: () async {
                                          if (await canLaunchUrl(Uri.parse(
                                              turoTripsData['data'][index]
                                                  ['description']))) {
                                            await launchUrl(
                                              Uri.parse(turoTripsData['data']
                                                  [index]['description']),
                                              mode: LaunchMode
                                                  .externalApplication,
                                            );
                                          } else {
                                            throw "Could not launch this url";
                                          }
                                        },
                                        child: Text(
                                          turoTripsData['data'][index]["uid"]
                                              .toString(),
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: dataController
                                                  .normalTextSize.value),
                                        ),
                                      )),
                                      DataCell(
                                        Text(
                                          convertUTCtoLocal(
                                              turoTripsData['data'][index]
                                                      ["lastmodified"]
                                                  .toString()),
                                          style: TextStyle(
                                              fontSize: dataController
                                                  .normalTextSize.value),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          convertUTCtoLocal(
                                              turoTripsData['data'][index]
                                                          ["start"]
                                                      ?.toString() ??
                                                  ''),
                                          style: TextStyle(
                                              fontSize: dataController
                                                  .normalTextSize.value),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          convertUTCtoLocal(
                                              turoTripsData['data'][index]
                                                      ["end"]
                                                  .toString()),
                                          style: TextStyle(
                                              fontSize: dataController
                                                  .normalTextSize.value),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          turoTripsData['data'][index]
                                                  ["summary"]
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: dataController
                                                  .normalTextSize.value),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          turoTripsData['data'][index]
                                                          ["location"]
                                                      .toString() ==
                                                  "null"
                                              ? ""
                                              : turoTripsData['data'][index]
                                                      ["location"]
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: dataController
                                                  .normalTextSize.value),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          turoTripsData['data'][index]
                                                          ["primary_driver"]
                                                      .toString() ==
                                                  "null"
                                              ? ""
                                              : turoTripsData['data'][index]
                                                      ["primary_driver"]
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: dataController
                                                  .normalTextSize.value),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          turoTripsData['data'][index]["phone"]
                                                      .toString() ==
                                                  "null"
                                              ? ""
                                              : turoTripsData['data'][index]
                                                      ["phone"]
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: dataController
                                                  .normalTextSize.value),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          turoTripsData['data'][index]
                                                          ["shareUrl"]
                                                      .toString() ==
                                                  "null"
                                              ? ""
                                              : turoTripsData['data'][index]
                                                      ["shareUrl"]
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: dataController
                                                  .normalTextSize.value),
                                        ),
                                      ),
                                      DataCell(IconButton(
                                          onPressed: () async {
                                            await reportsController
                                                .getTuroTripParseQueue(
                                                    turoTripsData['data'][index]
                                                            ["uid"]
                                                        .toString());
                                            if (reportsController
                                                    .apiStatus.value ==
                                                ApiState.failure) {
                                              Get.snackbar(
                                                  "Refresh failed",
                                                  reportsController
                                                      .errorMessage.value,
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.white,
                                                  animationDuration:
                                                      const Duration(
                                                          milliseconds: 300));
                                            }
                                            _fetchData();
                                          },
                                          icon: const Icon(
                                            Icons.refresh,
                                            color: Colors.green,
                                          ))),
                                      const DataCell(
                                        Text(
                                          'action',
                                          style: TextStyle(fontSize: 16),
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
              turoTripsData == null ? '' : '$currentPage / $totalPage',
              style: TextStyle(fontSize: dataController.appBarTitleSize.value),
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
            const SizedBox(
              width: 15,
            ),
            DropdownButton<String>(
              value: filterDateType,
              icon: Icon(Icons.arrow_drop_down,
                  size: dataController.iconSize.value),
              underline: Container(),
              elevation: 16,
              onChanged: (String? value) {
                setState(() {
                  filterDateType = value!;
                });
                _fetchData();
              },
              items:
                  datetypeList.map<DropdownMenuItem<String>>((dynamic value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                        fontSize: dataController.appBarTitleSize.value),
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
