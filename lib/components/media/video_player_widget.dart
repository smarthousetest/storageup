import 'dart:async';
import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:storageup/components/media/full_screen_video_player_widget.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({Key? key, required this.videoPath})
      : super(key: key);

  final String videoPath;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late final Player player;
  StreamSubscription<PlaybackState>? playbackSubscription;

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
    playbackSubscription?.cancel();

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

    return Stack(
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
                if (Platform.isMacOS) {
                  return;
                }

                if (Platform.isWindows) {
                  player.pause();
                }

                showDialog(
                    context: context,
                    builder: (context) {
                      return FullScreenVideoPlayerWidget(
                        player: player,
                        videoPath: widget.videoPath,
                        isPlaying: player.playback.isPlaying,
                      );
                    }).then((value) {
                  if (Platform.isWindows) {
                    if (value is FullScreenVideoClosedArgs) {
                      var position = value.position;
                      if (position is Duration) {
                        if (value.isPlaying) {
                          player.play();
                          player.seek(position);
                        } else {
                          player.play();
                          player.seek(position);
                          player.pause();
                        }
                      }
                    }
                  }
                });
              },
            ),
          );
        })
      ],
    );
  }
}
