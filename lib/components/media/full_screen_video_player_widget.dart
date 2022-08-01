import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';

class FullScreenVideoPlayerWidget extends StatelessWidget {
  final Player player;

  const FullScreenVideoPlayerWidget({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Platform.isWindows
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
                ),
          LayoutBuilder(builder: (context, size) {
            return Container(
              height: size.maxHeight - 80,
              child: GestureDetector(
                onTap: () {
                  print('Video player click');
                  player.playOrPause();
                },
                onDoubleTap: () {
                  Navigator.pop(context);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
