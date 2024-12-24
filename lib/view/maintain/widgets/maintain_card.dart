import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moovetrax/core/common.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';

class MaintainCardWidget extends StatefulWidget {
  final dynamic data;

  const MaintainCardWidget({
    super.key,
    required this.data,
    required this.onChanged,
    required this.deleteClicked,
  });
  final ValueChanged onChanged;
  final ValueChanged deleteClicked;

  @override
  State<MaintainCardWidget> createState() => MaintainCardWidgetState();
}

class MaintainCardWidgetState extends State<MaintainCardWidget> {
  DateTime selectedNextDate = DateTime.now();
  final DataController dataController = Get.find<DataController>();

  TextEditingController selectedNextMilesController =
      TextEditingController(text: '');
  TextEditingController noteEditController = TextEditingController(text: '');
  final ExpansionTileController _expansionTileController =
      ExpansionTileController();

  @override
  void initState() {
    super.initState();
    initData();
  }

  @override
  void dispose() {
    selectedNextMilesController.dispose();
    noteEditController.dispose();

    super.dispose();
  }

  void initData() {
    if (!mounted) return;
    setState(
      () {
        selectedNextDate = convertUTCtoLocalDate(widget.data['log_list']
            [widget.data['log_list'].length - 1]['date']);
      },
    );
    selectedNextMilesController.text = widget.data['log_list']
            [widget.data['log_list'].length - 1]['miles']
        .toString();
    noteEditController.text = widget.data['note'];
  }

  String calculateDaysInterval(String day1, String day2) {
    if (day1 == '' || day2 == '') return '-';
    DateTime utcDate1 = DateTime.parse(day1);
    DateTime utcDate2 = DateTime.parse(day2);
    Duration difference = utcDate2.difference(utcDate1);
    return (difference.inHours / 24).ceil().toString();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedNextDate,
      firstDate: DateTime(2015),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedNextDate) {
      setState(() {
        selectedNextDate = pickedDate;

        widget.data['log_list'][widget.data['log_list'].length - 1]['date'] =
            DateFormat("yyyy-MM-dd HH:mm:ss")
                .format(selectedNextDate.toUtc())
                .toString();
        widget.onChanged(widget.data);
      });
    }
  }

  String calculateMilesInterval(dynamic day1, dynamic day2) {
    if (day1 == '' || day2 == '') return '-';
    return (day1 - day2).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(
            bottom: 20 * dataController.currentScaleFactor.value),
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.all(
                Radius.circular(10 * dataController.currentScaleFactor.value))),
        padding: EdgeInsets.symmetric(
            vertical: 10 * dataController.currentScaleFactor.value,
            horizontal: 10 * dataController.currentScaleFactor.value),
        child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              controller: _expansionTileController,
              title: Text(
                widget.data['name'],
                style: TextStyle(
                    fontSize: dataController.titleTextSize.value,
                    fontWeight: FontWeight.w500),
              ),
              tilePadding: const EdgeInsets.all(0),
              children: <Widget>[
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        'Previous Services',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            'Date',
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value),
                          ),
                          Text(
                            'Miles',
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Flexible(
                              child: Container(
                                  width: double.infinity,
                                  height: 50 *
                                      dataController.currentScaleFactor.value,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueGrey),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    widget.data['log_list'].length > 2
                                        ? convertUTCtoLocal2(widget
                                                .data['log_list'][
                                            widget.data['log_list'].length -
                                                2]['date'])
                                        : '',
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ))),
                          SizedBox(
                            width: 10 * dataController.currentScaleFactor.value,
                          ),
                          Flexible(
                              child: Container(
                                  width: double.infinity,
                                  height: 50 *
                                      dataController.currentScaleFactor.value,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueGrey),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    widget.data['log_list'].length > 2
                                        ? widget.data['log_list'][
                                                widget.data['log_list'].length -
                                                    2]['miles']
                                            .toString()
                                        : '',
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ))),
                        ],
                      ),
                      SizedBox(
                        height: 10 * dataController.currentScaleFactor.value,
                      ),
                      Row(
                        children: [
                          Flexible(
                              child: Container(
                                  width: double.infinity,
                                  height: 50 *
                                      dataController.currentScaleFactor.value,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueGrey),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    widget.data['log_list'].length > 1
                                        ? convertUTCtoLocal2(widget
                                                .data['log_list'][
                                            widget.data['log_list'].length -
                                                1]['date'])
                                        : '',
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ))),
                          SizedBox(
                            width: 10 * dataController.currentScaleFactor.value,
                          ),
                          Flexible(
                              child: Container(
                                  width: double.infinity,
                                  height: 50 *
                                      dataController.currentScaleFactor.value,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueGrey),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    widget.data['log_list'].length > 1
                                        ? widget.data['log_list'][
                                                widget.data['log_list'].length -
                                                    1]['miles']
                                            .toString()
                                        : '',
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ))),
                        ],
                      ),
                      SizedBox(
                        height: 20 * dataController.currentScaleFactor.value,
                      ),
                      Text(
                        'Interval',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      SizedBox(
                        height: 10 * dataController.currentScaleFactor.value,
                      ),
                      Row(
                        children: [
                          Flexible(
                              child: Container(
                                  width: double.infinity,
                                  height: 50 *
                                      dataController.currentScaleFactor.value,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueGrey),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    widget.data['log_list'].length > 2
                                        ? calculateDaysInterval(
                                            widget.data['log_list'][
                                                widget.data['log_list'].length -
                                                    2]['date'],
                                            widget.data['log_list'][
                                                widget.data['log_list'].length -
                                                    1]['date'])
                                        : '',
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ))),
                          SizedBox(
                            width: 10 * dataController.currentScaleFactor.value,
                          ),
                          Flexible(
                              child: Container(
                                  width: double.infinity,
                                  height: 50 *
                                      dataController.currentScaleFactor.value,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueGrey),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    widget.data['log_list'].length > 2
                                        ? calculateMilesInterval(
                                            widget.data['log_list'][
                                                widget.data['log_list'].length -
                                                    1]['miles'],
                                            widget.data['log_list'][
                                                widget.data['log_list'].length -
                                                    2]['miles'])
                                        : '-',
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ))),
                        ],
                      ),
                      SizedBox(
                        height: 20 * dataController.currentScaleFactor.value,
                      ),
                      Text(
                        'Next Service',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      SizedBox(
                        height: 10 * dataController.currentScaleFactor.value,
                      ),
                      Row(
                        children: [
                          Flexible(
                            child: InkWell(
                                onTap: () => selectDate(context),
                                child: Container(
                                  width: double.infinity,
                                  height: 50 *
                                      dataController.currentScaleFactor.value,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueGrey),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        DateFormat('MM/dd/yyyy')
                                            .format(selectedNextDate)
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: dataController
                                                .normalTextSize.value),
                                      )),
                                )),
                          ),
                          SizedBox(
                            width: 10 * dataController.currentScaleFactor.value,
                          ),
                          Flexible(
                              child: SizedBox(
                            height:
                                50 * dataController.currentScaleFactor.value,
                            child: TextField(
                              controller: selectedNextMilesController,
                              enabled: true,
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 12 *
                                          dataController
                                              .currentScaleFactor.value,
                                      horizontal: 8 *
                                          dataController
                                              .currentScaleFactor.value)),
                              style: TextStyle(
                                  fontSize:
                                      dataController.normalTextSize.value),
                              onChanged: (value) {
                                widget.data['log_list']
                                        [widget.data['log_list'].length - 1]
                                    ['miles'] = double.parse(value);
                                widget.onChanged(widget.data);
                              },
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*$')),
                              ],
                            ),
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 20 * dataController.currentScaleFactor.value,
                      ),
                      Text(
                        'Interval',
                        style: TextStyle(
                            fontSize: dataController.normalTextSize.value),
                      ),
                      SizedBox(
                        height: 10 * dataController.currentScaleFactor.value,
                      ),
                      Row(
                        children: [
                          Flexible(
                              child: Container(
                                  width: double.infinity,
                                  height: 50 *
                                      dataController.currentScaleFactor.value,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueGrey),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    widget.data['log_list'].length > 1
                                        ? calculateDaysInterval(
                                            widget.data['log_list'][
                                                widget.data['log_list'].length -
                                                    2]['date'],
                                            widget.data['log_list'][
                                                widget.data['log_list'].length -
                                                    1]['date'])
                                        : '-',
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ))),
                          SizedBox(
                            width: 10 * dataController.currentScaleFactor.value,
                          ),
                          Flexible(
                              child: Container(
                                  width: double.infinity,
                                  height: 50 *
                                      dataController.currentScaleFactor.value,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueGrey),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(
                                    widget.data['log_list'].length > 1
                                        ? calculateMilesInterval(
                                            int.parse(
                                                selectedNextMilesController
                                                    .text),
                                            widget.data['log_list'][
                                                widget.data['log_list'].length -
                                                    2]['miles'],
                                          )
                                        : '-',
                                    style: TextStyle(
                                        fontSize: dataController
                                            .normalTextSize.value),
                                  ))),
                        ],
                      ),
                      SizedBox(
                        height: 10 * dataController.currentScaleFactor.value,
                      ),
                      Row(children: [
                        Flexible(
                            child: SizedBox(
                                height: 50 *
                                    dataController.currentScaleFactor.value,
                                child: TextField(
                                  style: TextStyle(
                                      fontSize:
                                          dataController.normalTextSize.value),
                                  onChanged: (value) {
                                    widget.data['note'] = value;
                                    widget.onChanged(widget.data);
                                  },
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 12 *
                                              dataController
                                                  .currentScaleFactor.value,
                                          horizontal: 8 *
                                              dataController
                                                  .currentScaleFactor.value)),
                                  controller: noteEditController,
                                ))),
                        SizedBox(
                          width: 10 * dataController.currentScaleFactor.value,
                        ),
                        Expanded(
                            child: SizedBox(
                                height: 50 *
                                    dataController.currentScaleFactor.value,
                                child: OutlinedButton(
                                  onPressed: () {
                                    _expansionTileController.collapse();
                                    widget.deleteClicked(true);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          0), // Set the border radius to 0 for a rectangular shape
                                    ),
                                    side: const BorderSide(color: Colors.red),
                                  ),
                                  child: Text(
                                    'DELETE',
                                    style: TextStyle(
                                        fontSize:
                                            dataController.normalTextSize.value,
                                        color: Colors.red),
                                  ),
                                ))),
                      ]),
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                )
              ],
            )));
  }
}
