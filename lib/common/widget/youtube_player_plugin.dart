import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerDialog extends StatefulWidget {
  final String videoId;

  const YouTubePlayerDialog({super.key, required this.videoId});

  @override
  YouTubePlayerDialogState createState() => YouTubePlayerDialogState();
}

class YouTubePlayerDialogState extends State<YouTubePlayerDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(5),
      shape: Border.all(color: Colors.green),
      backgroundColor: Colors.black,
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: YoutubePlayer(
                controller: YoutubePlayerController(
                  initialVideoId:
                      widget.videoId, // Provide the YouTube video ID here
                  flags: const YoutubePlayerFlags(
                    autoPlay: true,
                    mute: false,
                  ),
                ),
                showVideoProgressIndicator: true,
              ),
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
