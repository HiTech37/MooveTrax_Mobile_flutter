import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerComponent extends StatefulWidget {
  final Function(File)
      onImagePicked; // Callback to send selected image to parent widget

  const ImagePickerComponent({super.key, required this.onImagePicked});

  @override
  ImagePickerComponentState createState() => ImagePickerComponentState();
}

class ImagePickerComponentState extends State<ImagePickerComponent> {
  File? selectedImage; // Holds the selected image
  final ImagePicker _picker = ImagePicker();

  // Method to pick an image from the camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      setState(() {
        selectedImage = imageFile;
      });
      widget.onImagePicked(
          imageFile); // Send the selected image to the parent widget
    }
  }

  // Method to show a dialog with options to choose camera or gallery
  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _pickImage(ImageSource.gallery); // Pick from gallery
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.of(context).pop(); // Close the dialog
                  _pickImage(ImageSource.camera); // Pick from camera
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showImageSourceDialog(context),
      child: const Text('CHOOSE FILE'),
    );
  }
}
