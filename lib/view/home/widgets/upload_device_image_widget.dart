import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart' as gt;
import 'package:image_picker/image_picker.dart';
import 'package:moovetrax/common/widget/default_button.dart';
import 'package:moovetrax/core/api_config.dart';
import 'package:moovetrax/di.dart';
import 'package:moovetrax/viewmodel/auth/controller/auth_controller.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';
import 'package:moovetrax/viewmodel/device/controller/device_controller.dart';

class UploadDeviceImageWidget extends StatefulWidget {
  final dynamic device;

  const UploadDeviceImageWidget({super.key, required this.device});

  @override
  UploadDeviceImageWidgetState createState() => UploadDeviceImageWidgetState();
}

class UploadDeviceImageWidgetState extends State<UploadDeviceImageWidget> {
  final DataController dataController = gt.Get.find<DataController>();
  bool uploadingImage = false;
  final DeviceController deviceController = getIt<DeviceController>();
  final AuthController authController = getIt<AuthController>();
  File? pickedImageFile;

  _pickImageGallery() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          pickedImageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  _pickImageCamera() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          pickedImageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7 > 400
          ? 400
          : MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.6,
      padding: EdgeInsets.all(15 * dataController.currentScaleFactor.value),
      child: Column(
        children: [
          Text(
            'Upload device image',
            style: TextStyle(fontSize: dataController.titleTextSize.value),
          ),
          SizedBox(
            height: 20 * dataController.currentScaleFactor.value,
          ),
          Container(
            width: 100 * dataController.currentScaleFactor.value,
            height: 100 * dataController.currentScaleFactor.value,
            padding:
                EdgeInsets.all(15 * dataController.currentScaleFactor.value),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(
                  300 * dataController.currentScaleFactor.value)),
              color: Colors.grey[500],
            ),
            child: pickedImageFile != null
                ? Image.file(
                    pickedImageFile!,
                    fit: BoxFit.contain,
                  )
                : widget.device['image'] != "" || widget.device['image'] != null
                    ? Image.network(
                        ApiConfig.siteUrl + widget.device['image'],
                        fit: BoxFit.cover,
                      )
                    : SvgPicture.asset(
                        "asset/images/${widget.device['category'] ?? 'Default'}.svg",
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                      ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  onPressed: () {
                    _pickImageCamera();
                  },
                  icon: Icon(Icons.photo_camera,
                      size: dataController.iconSize.value)),
              IconButton(
                  onPressed: () {
                    _pickImageGallery();
                  },
                  icon: Icon(
                    Icons.photo,
                    size: dataController.iconSize.value,
                  )),
            ],
          ),
          SizedBox(
            height: 20 * dataController.currentScaleFactor.value,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: DefaultButton(
                  text: uploadingImage ? "SUBMITTING..." : "SUBMIT",
                  press: () async {
                    if (pickedImageFile == null) return;
                    setState(() {
                      uploadingImage = true;
                    });

                    FormData formData = FormData.fromMap({
                      "user_id": authController.storageUserData?['id'],
                      "device_id": widget.device['id'],
                      "upload_file": await MultipartFile.fromFile(
                          pickedImageFile!.path,
                          filename: pickedImageFile!.path.split('/').last),
                    });
                    await deviceController.uploadDeviceImage(formData);
                    setState(() {
                      uploadingImage = false;
                    });
                    gt.Get.back();
                  },
                ),
              ),
              SizedBox(
                width: 10 * dataController.currentScaleFactor.value,
              ),
              Expanded(
                  child: SizedBox(
                      height: 50 * dataController.currentScaleFactor.value,
                      child: OutlinedButton(
                          onPressed: () {
                            gt.Get.back();
                          },
                          style: ButtonStyle(
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              padding: WidgetStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal:
                                          16 *
                                              dataController
                                                  .currentScaleFactor.value,
                                      vertical: 10 *
                                          dataController
                                              .currentScaleFactor.value))),
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                                fontSize: dataController.normalTextSize.value),
                          ))))
            ],
          )
        ],
      ),
    );
  }
}
