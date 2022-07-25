import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({Key? key, required this.videoPath})
      : super(key: key);

  final String videoPath;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final Player player;

  @override
  void initState() {
    super.initState();

    if (Platform.isMacOS) {
      return;
    }

    player = Player(
        id: widget.videoPath.hashCode, registerTexture: !Platform.isWindows);
    player.open(Media.file(File(widget.videoPath)));
  }

  @override
  void dispose() {
    if (!Platform.isMacOS) {
      player.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isMacOS) {
      return ElevatedButton(
          onPressed: () {
            OpenFile.open(widget.videoPath);
          },
          child: Text(
            'MacOS video player is currently not supported. Click here to open in system video player',
          ));
    }

    return Platform.isWindows
        ? NativeVideo(
            fit: BoxFit.contain,
            player: player,
            scale: 1.0,
            showControls: true,
          )
        : Video(
            fit: BoxFit.contain,
            player: player,
            scale: 1.0,
            showControls: true,
          );
  }
}
