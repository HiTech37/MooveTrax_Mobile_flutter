import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class YouTubePlayerDialog extends StatelessWidget {
  final String videoId;

  const YouTubePlayerDialog({super.key, required this.videoId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.black,
      child: SizedBox(
        width: 300,
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Open Video in YouTube',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final url = 'https://www.youtube.com/watch?v=$videoId';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: const Text('Open YouTube'),
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
