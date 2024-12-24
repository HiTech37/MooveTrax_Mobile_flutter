import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moovetrax/viewmodel/data_controller.dart';

class VideoToImageScreen extends StatefulWidget {
  const VideoToImageScreen({super.key});

  @override
  VideoToImageScreenState createState() => VideoToImageScreenState();
}

class VideoToImageScreenState extends State<VideoToImageScreen> {
  final DataController dataController = Get.find<DataController>();
  final ImagePicker picker = ImagePicker();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future pickVideo() async {
    // XFile? videoFile = await picker.pickVideo(source: ImageSource.camera);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: dataController.appBarHeight.value,
        title: Text(
          "Image Extract",
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
      body: IconButton(
          onPressed: () {
            pickVideo();
          },
          icon: const Icon(Icons.camera_alt)),
      resizeToAvoidBottomInset: true,
    );
  }
}
