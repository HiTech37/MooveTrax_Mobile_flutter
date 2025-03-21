import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/common/controller/base_controller.dart';
import 'package:moovetrax/common/widget/default_button.dart';
import 'package:moovetrax/core/api_config.dart';
import 'package:moovetrax/core/common.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/view/shared_links/widget/invite_widget.dart';
import 'package:moovetrax/view/shared_links/widget/share_links_item_edit_widget.dart';
// import 'package:moovetrax/view/shared_links/widget/turo_setup_widget.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/reports/controller/reports_controller.dart';

class SharedLinksScreen extends StatefulWidget {
  const SharedLinksScreen({super.key});

  @override
  SharedLinksScreenState createState() => SharedLinksScreenState();
}

class SharedLinksScreenState extends State<SharedLinksScreen> {
  ScrollController? tableController;
  bool _sortSharedLinksAscending = true;
  int _sortSharedLinksColumnIndex = 0;
  bool _sortCoHostAscending = true;
  int _sortCoHostColumnIndex = 0;
  int sharedLinksRowsPerPage = 20;
  int sharedLinksTotalPage = 0;
  int coHostRowsPerPage = 20;
  int coHostTotalPage = 0;
  String sharedLinksSearchKey = "";
  String coHostSearchKey = "";
  dynamic sharedLinksData;
  dynamic coHostData;
  int currentSharedLinksPage = 1;
  int currentCoHostPage = 1;

  TextEditingController pageNumberController = TextEditingController();
  TextEditingController sharedLinksSearchKeyController =
      TextEditingController();
  TextEditingController coHostSearchKeyController = TextEditingController();
  List<String> searchTypeList = [
    'All',
    'Expired',
    'Active',
    'Future',
    'Co-Host'
  ];
  String searchType = 'All';
  String sharedLinksSortName = "id";
  String sharedLinksSortDirection = "asc";
  String coHostLinksSortName = "id";
  String coHostLinksSortDirection = "asc";
  final ReportsController reportsController = getIt<ReportsController>();
  final AuthController authController = getIt<AuthController>();
  final DataController dataController = Get.find<DataController>();

  Future<void> _fetchData() async {
    if (!context.mounted) return;
    if (searchType == "Co-Host") {
      await reportsController.getCoHosts({
        'page': currentCoHostPage - 1,
        'searchType': searchType.toLowerCase(),
        "search": coHostSearchKey,
        'rowsPerPage': coHostRowsPerPage,
        'sortOrder': {
          'name': coHostLinksSortName,
          'direction': coHostLinksSortDirection
        },
        'userId': authController.storageUserData?['id']
      });
      setState(() {
        coHostData = reportsController.coHostData.value;
        if (coHostData != null) {
          int pages = coHostData['total'] ~/ coHostRowsPerPage;
          if (coHostData['total'] % coHostRowsPerPage != 0) {
            pages++;
          }
          if (pages == 0) {
            coHostTotalPage = 1;
          } else {
            if (pages == 0) {
              coHostTotalPage = 1;
            } else {
              coHostTotalPage = pages;
            }
          }
        }
      });
    } else {
      await reportsController.getSharedLinks({
        'page': currentSharedLinksPage - 1,
        'searchType': searchType.toLowerCase(),
        'rowsPerPage': sharedLinksRowsPerPage,
        "search": sharedLinksSearchKey,
        'sortOrder': {
          'name': sharedLinksSortName,
          'direction': sharedLinksSortDirection
        },
        'userId': authController.storageUserData?['id']
      });
      setState(() {
        sharedLinksData = reportsController.sharedLinksData.value;
        if (sharedLinksData != null) {
          int pages = sharedLinksData['total'] ~/ sharedLinksRowsPerPage;
          if (sharedLinksData['total'] % sharedLinksRowsPerPage != 0) {
            pages++;
          }
          if (pages == 0) {
            sharedLinksTotalPage = 1;
          } else {
            if (pages == 0) {
              sharedLinksTotalPage = 1;
            } else {
              sharedLinksTotalPage = pages;
            }
          }
        }
      });
    }
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

  void _sortSharedLinks(String sortField, int columnIndex) {
    if (_sortSharedLinksColumnIndex == columnIndex) {
      // If the same column is clicked again, toggle the sort order
      _sortSharedLinksAscending = !_sortSharedLinksAscending;
    } else {
      // Otherwise, sort in ascending order
      _sortSharedLinksAscending = true;
    }

    setState(() {
      _sortSharedLinksColumnIndex = columnIndex;
    });
    _fetchData();
  }

  void _sortCoHost(String sortField, int columnIndex) {
    if (_sortCoHostColumnIndex == columnIndex) {
      // If the same column is clicked again, toggle the sort order
      _sortCoHostAscending = !_sortCoHostAscending;
    } else {
      // Otherwise, sort in ascending order
      _sortCoHostAscending = true;
    }

    setState(() {
      _sortCoHostColumnIndex = columnIndex;
    });
    _fetchData();
  }

  Widget coHostDataTable() {
    return DataTable(
      sortAscending: _sortCoHostAscending,
      sortColumnIndex: _sortCoHostColumnIndex,
      columns: [
        DataColumn(
          label: Row(
            children: [
              Text(
                "EMAIL",
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
            ],
          ),
          onSort: (columnIndex, ascending) {
            _sortCoHost(
              'email',
              columnIndex,
            );
          },
        ),
        DataColumn(
          label: Row(
            children: [
              Text(
                "DEVICE NAME",
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
            ],
          ),
          onSort: (columnIndex, ascending) {
            _sortSharedLinks(
              'device_name',
              columnIndex,
            );
          },
        ),
        DataColumn(
          label: Row(
            children: [
              Text(
                "DEVICE ID",
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
            ],
          ),
          onSort: (columnIndex, ascending) {
            _sortSharedLinks(
              'uniqueId',
              columnIndex,
            );
          },
        ),
        DataColumn(
          label: Row(
            children: [
              Text(
                "DATE",
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
            ],
          ),
          onSort: (columnIndex, ascending) {
            _sortSharedLinks(
              'createdAt',
              columnIndex,
            );
          },
        ),
        DataColumn(
          label: Row(
            children: [
              Text(
                "ACTION",
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
            ],
          ),
        ),
      ],
      rows: coHostData != null
          ? List<DataRow>.generate(
              coHostData['data'].length,
              (index) => DataRow(
                cells: [
                  DataCell(
                    Text(
                      coHostData['data'][index]["email"].toString(),
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                  ),
                  DataCell(
                    Text(
                      coHostData['data'][index]["device_name"].toString(),
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                  ),
                  DataCell(
                    Text(
                      coHostData['data'][index]["uniqueId"]?.toString() ?? '',
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                  ),
                  DataCell(
                    Text(
                      coHostData['data'][index]["createdAt"].toString(),
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                  ),
                  DataCell(
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                insetPadding: const EdgeInsets.all(10),
                                title: const Text('Are you sure to delete?'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('CANCEL'),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text('YES'),
                                    onPressed: () async {
                                      await reportsController.deleteCoHost({
                                        "id": coHostData['data'][index]['id']
                                      });
                                      if (reportsController.apiStatus.value ==
                                          ApiState.failure) {
                                        Get.snackbar("Deleting Failed",
                                            authController.errorMessage.value,
                                            backgroundColor: Colors.red,
                                            colorText: Colors.white,
                                            animationDuration: const Duration(
                                                milliseconds: 300));
                                      }
                                      _fetchData();

                                      Get.back();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.delete)),
                  ),
                ],
              ),
            )
          : [],
    );
  }

  Widget shareLinksDataTable() {
    return DataTable(
      sortAscending: _sortSharedLinksAscending,
      sortColumnIndex: _sortSharedLinksColumnIndex,
      columnSpacing: 10,
      columns: [
        const DataColumn(
          label: SizedBox(
            width: 10,
          ),
        ),
        DataColumn(
          label: Row(
            children: [
              Text(
                "USER",
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
            ],
          ),
          onSort: (columnIndex, ascending) {
            _sortSharedLinks(
              'user_email',
              columnIndex,
            );
          },
        ),
        DataColumn(
          label: Row(
            children: [
              Text(
                "DEVICE",
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
            ],
          ),
          onSort: (columnIndex, ascending) {
            _sortSharedLinks(
              'deviceId',
              columnIndex,
            );
          },
        ),
        DataColumn(
          label: Row(
            children: [
              Text(
                "FROM",
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
            ],
          ),
          onSort: (columnIndex, ascending) {
            _sortSharedLinks(
              'from',
              columnIndex,
            );
          },
        ),
        DataColumn(
          label: Row(
            children: [
              Text(
                "TO",
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
            ],
          ),
          onSort: (columnIndex, ascending) {
            _sortSharedLinks(
              'to',
              columnIndex,
            );
          },
        ),
        DataColumn(
          label: Row(
            children: [
              Text(
                "ALLOT",
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
            ],
          ),
          onSort: (columnIndex, ascending) {
            _sortSharedLinks(
              'allot_miles',
              columnIndex,
            );
          },
        ),
        DataColumn(
          label: Row(
            children: [
              Text(
                "DRIVEN",
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
            ],
          ),
          onSort: (columnIndex, ascending) {
            _sortSharedLinks(
              'link_distance',
              columnIndex,
            );
          },
        ),
        DataColumn(
          label: Row(
            children: [
              Text(
                "LINK",
                style: TextStyle(fontSize: dataController.normalTextSize.value),
              ),
            ],
          ),
          onSort: (columnIndex, ascending) {
            _sortSharedLinks(
              'shareUrl',
              columnIndex,
            );
          },
        ),
      ],
      rows: sharedLinksData != null
          ? List<DataRow>.generate(
              sharedLinksData['data'].length,
              (index) => DataRow(
                cells: [
                  DataCell(Container(
                      width: 30,
                      alignment: Alignment.center,
                      child: InkWell(
                        child: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (String result) async {
                            switch (result) {
                              case "Edit":
                                Get.dialog(Dialog(
                                    insetPadding: const EdgeInsets.all(10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ShareItemLinkEdit(
                                        sharedLinksData['data'][index])));
                                break;
                              case "Remove":
                                bool? confirmDelete = await Get.dialog<bool>(
                                  AlertDialog(
                                    title: Text(
                                      'Remove Item?',
                                      style: TextStyle(
                                          fontSize: dataController
                                              .titleTextSize.value),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                              fontSize: dataController
                                                  .normalTextSize.value),
                                        ),
                                        onPressed: () {
                                          Get.back(result: false);
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Remove',
                                          style: TextStyle(
                                              fontSize: dataController
                                                  .normalTextSize.value),
                                        ),
                                        onPressed: () {
                                          Get.back(result: true);
                                        },
                                      ),
                                    ],
                                  ),
                                );

                                // If user confirmed the deletion, proceed with the delete operation
                                if (confirmDelete == true) {
                                  await reportsController.deleteSharedLinks(
                                      sharedLinksData['data'][index]['id']
                                          .toString());
                                  _fetchData();
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
                                            fontSize: dataController
                                                .normalTextSize.value)),
                                  ],
                                )),
                            PopupMenuItem<String>(
                                value: 'Remove',
                                child: Row(
                                  children: [
                                    Text('Remove',
                                        style: TextStyle(
                                            fontSize: dataController
                                                .normalTextSize.value)),
                                  ],
                                )),
                          ],
                        ),
                        onTap: () {},
                      ))),
                  DataCell(Text(
                    sharedLinksData['data'][index]["user_email"].toString(),
                    style: TextStyle(
                        fontSize: dataController.normalTextSize.value),
                  )),
                  DataCell(
                    Text(
                      sharedLinksData['data'][index]["device_name"].toString(),
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                  ),
                  DataCell(
                    Text(
                      convertUTCtoLocal(
                          sharedLinksData['data'][index]["from"]?.toString() ??
                              ''),
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                  ),
                  DataCell(
                    Text(
                      convertUTCtoLocal(
                          sharedLinksData['data'][index]["to"].toString()),
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                  ),
                  DataCell(
                    Text(
                      sharedLinksData['data'][index]["allot_miles"]
                                  .toString() ==
                              'null'
                          ? "0"
                          : sharedLinksData['data'][index]["allot_miles"]
                              .toString(),
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                  ),
                  DataCell(
                    Text(
                      (double.parse(sharedLinksData['data'][index]
                                  ["end_odometer"]) -
                              double.parse(sharedLinksData['data'][index]
                                  ["start_odometer"]))
                          .round()
                          .toStringAsFixed(0),
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                  ),
                  DataCell(
                    Text(
                      '${ApiConfig.siteUrl}temporary/${sharedLinksData['data'][index]["shareUrl"]}',
                      style: TextStyle(
                          fontSize: dataController.normalTextSize.value),
                    ),
                  ),
                ],
              ),
            )
          : [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: dataController.appBarHeight.value,
        title: Text(
          "Shared Links",
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
          InkWell(
              onTap: () {
                sharedLinksSearchKeyController.text = sharedLinksSearchKey;
                coHostSearchKeyController.text = coHostSearchKey;
                Get.dialog(Dialog(
                    insetPadding: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Set the border radius
                    ),
                    child: SizedBox(
                        height: 220,
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Search',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: const Icon(Icons.close))
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                searchType == "Co-Host"
                                    ? TextField(
                                        controller: coHostSearchKeyController,
                                        decoration: const InputDecoration(
                                            hintText: "Search..."),
                                        onChanged: (value) {
                                          setState(() {
                                            coHostSearchKey = value;
                                          });
                                        },
                                      )
                                    : TextField(
                                        controller:
                                            sharedLinksSearchKeyController,
                                        decoration: const InputDecoration(
                                            hintText: "Search..."),
                                        onChanged: (value) {
                                          setState(() {
                                            sharedLinksSearchKey = value;
                                          });
                                        },
                                      ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width: 140,
                                  child: DefaultButton(
                                    text: "SEARCH",
                                    press: () {
                                      _fetchData();
                                      Get.back();
                                    },
                                  ),
                                ),
                              ],
                            )))));
              },
              child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    Icons.search,
                    size: dataController.iconSize.value,
                  ))),
          const SizedBox(
            width: 10,
          )
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
                        child: searchType == 'Co-Host'
                            ? coHostDataTable()
                            : shareLinksDataTable()))),
          ),
          Obx(() => reportsController.apiStatus.value == ApiState.loading
              ? Container(
                  color: Colors.grey,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : const SizedBox()),
        ],
      ),
      resizeToAvoidBottomInset: true,
      bottomSheet: searchType == "Co-Host"
          ? BottomAppBar(
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
                      if (reportsController.apiStatus.value ==
                          ApiState.loading) {
                        return;
                      }
                      if (currentCoHostPage == 1) return;
                      setState(() {
                        currentCoHostPage = currentCoHostPage - 1;
                        pageNumberController.text =
                            currentCoHostPage.toString();
                      });
                      _fetchData();
                    },
                  ),
                  Text(
                    sharedLinksData == null
                        ? ''
                        : '$currentCoHostPage / $coHostTotalPage',
                    style: TextStyle(
                        fontSize: dataController.appBarTitleSize.value),
                  ),
                  InkWell(
                    child: Icon(Icons.navigate_next,
                        size: dataController.iconSize.value),
                    onTap: () {
                      if (reportsController.apiStatus.value ==
                          ApiState.loading) {
                        return;
                      }
                      if (currentCoHostPage == coHostTotalPage) return;
                      setState(() {
                        currentCoHostPage = currentCoHostPage + 1;
                        pageNumberController.text =
                            currentCoHostPage.toString();
                      });
                      _fetchData();
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: pageNumberController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                          fontSize: dataController.appBarTitleSize.value),
                      decoration: const InputDecoration(
                          hintText: 'Enter page number',
                          contentPadding: EdgeInsets.all(0)),
                      onSubmitted: (value) {
                        setState(() {
                          if (int.parse(value) > coHostTotalPage) {
                            setState(() {
                              currentCoHostPage = coHostTotalPage;
                              pageNumberController.text =
                                  currentCoHostPage.toString();
                            });
                          } else if (int.parse(value) < 1) {
                            setState(() {
                              currentCoHostPage = 1;
                              pageNumberController.text =
                                  currentCoHostPage.toString();
                            });
                          } else {
                            setState(() {
                              currentCoHostPage = int.parse(value);
                              pageNumberController.text =
                                  currentCoHostPage.toString();
                            });
                          }
                          _fetchData();
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  DropdownButton<String>(
                    value: searchType,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                    ),
                    underline: Container(),
                    elevation: 16,
                    onChanged: (String? value) {
                      setState(() {
                        searchType = value!;
                        coHostSearchKey = '';
                      });
                      _fetchData();
                    },
                    items: searchTypeList
                        .map<DropdownMenuItem<String>>((dynamic value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              value,
                              style: TextStyle(
                                  fontSize:
                                      dataController.appBarTitleSize.value),
                            )),
                      );
                    }).toList(),
                  ),
                ],
              ),
            )
          : BottomAppBar(
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
                      if (reportsController.apiStatus.value ==
                          ApiState.loading) {
                        return;
                      }
                      if (currentSharedLinksPage == 1) return;
                      setState(() {
                        currentSharedLinksPage = currentSharedLinksPage - 1;
                        pageNumberController.text =
                            currentSharedLinksPage.toString();
                      });
                      _fetchData();
                    },
                  ),
                  Text(
                    sharedLinksData == null
                        ? ''
                        : '$currentSharedLinksPage / $sharedLinksTotalPage',
                    style: TextStyle(
                        fontSize: dataController.appBarTitleSize.value),
                  ),
                  InkWell(
                    child: Icon(Icons.navigate_next,
                        size: dataController.iconSize.value),
                    onTap: () {
                      if (reportsController.apiStatus.value ==
                          ApiState.loading) {
                        return;
                      }
                      if (currentSharedLinksPage == sharedLinksTotalPage) {
                        return;
                      }
                      setState(() {
                        currentSharedLinksPage = currentSharedLinksPage + 1;
                        pageNumberController.text =
                            currentSharedLinksPage.toString();
                      });
                      _fetchData();
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: pageNumberController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      textAlignVertical: TextAlignVertical.center,
                      style: TextStyle(
                          fontSize: dataController.appBarTitleSize.value),
                      decoration: const InputDecoration(
                          hintText: 'Enter page number',
                          contentPadding: EdgeInsets.all(0)),
                      onSubmitted: (value) {
                        setState(() {
                          if (int.parse(value) > sharedLinksTotalPage) {
                            setState(() {
                              currentSharedLinksPage = sharedLinksTotalPage;
                              pageNumberController.text =
                                  currentSharedLinksPage.toString();
                            });
                          } else if (int.parse(value) < 1) {
                            setState(() {
                              currentSharedLinksPage = 1;
                              pageNumberController.text =
                                  currentSharedLinksPage.toString();
                            });
                          } else {
                            setState(() {
                              currentSharedLinksPage = int.parse(value);
                              pageNumberController.text =
                                  currentSharedLinksPage.toString();
                            });
                          }
                          _fetchData();
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  DropdownButton<String>(
                    value: searchType,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                    ),
                    underline: Container(),
                    elevation: 16,
                    onChanged: (String? value) {
                      setState(() {
                        searchType = value!;
                        sharedLinksSearchKey = '';
                      });
                      _fetchData();
                    },
                    items: searchTypeList
                        .map<DropdownMenuItem<String>>((dynamic value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(value,
                                style: TextStyle(
                                    fontSize:
                                        dataController.appBarTitleSize.value))),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
      floatingActionButton: Padding(
          padding: EdgeInsets.only(
              bottom: 60 * dataController.currentScaleFactor.value),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // FloatingActionButton(
              //   mini: dataController.currentScaleFactor.value < 1,
              //   onPressed: () {
              //     Get.dialog(Dialog(
              //         insetPadding: const EdgeInsets.all(10),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(
              //               10.0), // Set the border radius
              //         ),
              //         child: TuroSetupWidget(onChanged: (value) {})));
              //   },
              //   child: const Icon(
              //     Icons.settings_input_component,
              //     color: Colors.white,
              //   ),
              // ),
              // SizedBox(
              //     height: 16 *
              //         dataController.currentScaleFactor
              //             .value), // Adjust the height as needed
              if (searchType == "Co-Host")
                FloatingActionButton(
                  mini: dataController.currentScaleFactor.value < 1,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          insetPadding: EdgeInsets.all(
                              10 * dataController.currentScaleFactor.value),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          content: InviteWidget(
                            onChanged: (value) {},
                          ),
                        );
                      },
                    ).then((value) {
                      _fetchData();
                    });
                  },
                  child: const Icon(Icons.add_box, color: Colors.white),
                )
            ],
          )),
    );
  }
}
