import 'dart:async';
import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';

class FullScreenVideoPlayerWidget extends StatefulWidget {
  final Player player;
  final String videoPath;
  final bool isPlaying;

  const FullScreenVideoPlayerWidget({
    super.key,
    required this.player,
    required this.videoPath,
    required this.isPlaying,
  });

  @override
  State<FullScreenVideoPlayerWidget> createState() =>
      _FullScreenVideoPlayerWidgetState();
}

class _FullScreenVideoPlayerWidgetState
    extends State<FullScreenVideoPlayerWidget> {
  late Player player;
  StreamSubscription<PositionState>? positionsSub;

  @override
  void initState() {
    super.initState();

    if (Platform.isWindows) {
      player = Player(
          id: widget.videoPath.hashCode + 1,
          registerTexture: !Platform.isWindows);
      player.open(Media.file(File(widget.videoPath)), autoStart: false);
      print(widget.player.position.position);
      player.play();
      player.seek(widget.player.position.position ?? Duration(seconds: 0));
    } else {
      player = widget.player;
    }
  }

  @override
  void dispose() {
    positionsSub?.cancel();
    if (Platform.isWindows) {
      player.dispose();
    }
    super.dispose();
  }

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
                  Navigator.pop(
                    context,
                    FullScreenVideoClosedArgs(
                      position: player.position.position,
                      isPlaying: player.playback.isPlaying,
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class FullScreenVideoClosedArgs {
  final Duration? position;
  final bool isPlaying;

  FullScreenVideoClosedArgs({
    required this.position,
    required this.isPlaying,
  });
}
