import 'package:flutter/material.dart';

class BottomSheetSwitch extends StatefulWidget {
  const BottomSheetSwitch(
      {super.key, required this.switchValue, required this.valueChanged});

  final bool switchValue;
  final ValueChanged valueChanged;

  @override
  BottomSheetSwitchState createState() => BottomSheetSwitchState();
}

class BottomSheetSwitchState extends State<BottomSheetSwitch> {
  late bool switchValue;

  @override
  void initState() {
    super.initState();

    switchValue = widget.switchValue;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: switchValue,
      onChanged: (bool value) {
        setState(() {
          switchValue = value;
          widget.valueChanged(value);
        });
      },
    );
  }
}
