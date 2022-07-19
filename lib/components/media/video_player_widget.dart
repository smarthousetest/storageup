import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

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
    player = Player(id: widget.videoPath.hashCode, registerTexture: false);
    player.open(Media.file(File(widget.videoPath)));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NativeVideo(
      fit: BoxFit.contain,
      player: player,
      scale: 1.0,
      showControls: true,
    );
  }
}
