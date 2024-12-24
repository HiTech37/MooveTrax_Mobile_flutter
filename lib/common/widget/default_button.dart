import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    super.key,
    required this.text,
    required this.press,
  });
  final String text;
  final VoidCallback press;
  @override
  Widget build(BuildContext context) {
    final DataController dataController = Get.find<DataController>();

    return SizedBox(
        height: 50 * dataController.currentScaleFactor.value,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: press,
          style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                  horizontal: 16 * dataController.currentScaleFactor.value,
                  vertical: 10 * dataController.currentScaleFactor.value))),
          child: Text(
            text,
            style: TextStyle(
              fontSize: dataController.normalTextSize.value,
              fontWeight: FontWeight.w500,
            ),
          ),
        ));
  }
}
