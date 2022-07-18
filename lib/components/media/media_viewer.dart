import 'dart:io';

import 'package:cpp_native/models/record.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:storageup/pages/media/media_open/media_open_bloc.dart';
import 'package:storageup/pages/media/media_open/media_open_event.dart';
import 'package:storageup/pages/media/media_open/media_open_state.dart';
import 'package:storageup/pages/media/media_open/media_open_view.dart';
import 'package:storageup/utilities/extensions.dart';

class MediaViewer extends StatefulWidget {
  const MediaViewer({Key? key}) : super(key: key);

  @override
  State<MediaViewer> createState() => _MediaViewerState();
}

class _MediaViewerState extends State<MediaViewer> {
  final ItemPositionsListener _mainListPositionsListener =
      ItemPositionsListener.create();
  final ItemScrollController _mainListScrollController = ItemScrollController();
  ScrollDirection _direction = ScrollDirection.forward;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          _imageView(context),
          FractionallySizedBox(
            heightFactor: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        if (_mainListPositionsListener
                            .itemPositions.value.isEmpty) {
                          print("MainListPositionsListener is empty");
                          return;
                        }

                        print(_mainListPositionsListener.itemPositions.value);
                        var pos = _mainListPositionsListener
                            .itemPositions.value.first.index;

                        _mainListScrollController.scrollTo(
                            index: pos - 1,
                            duration: Duration(milliseconds: 200));
                        context
                            .read<MediaOpenBloc>()
                            .add(MediaOpenChangeChoosedMedia(index: pos - 1));
                      },
                      child: SvgPicture.asset('assets/options/arrow_left.svg'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        if (_mainListPositionsListener
                            .itemPositions.value.isEmpty) {
                          print("MainListPositionsListener is empty");
                          return;
                        }

                        print(_mainListPositionsListener.itemPositions.value);
                        var pos = _mainListPositionsListener
                            .itemPositions.value.first.index;

                        _mainListScrollController.scrollTo(
                            index: pos + 1,
                            duration: Duration(milliseconds: 200));
                        context
                            .read<MediaOpenBloc>()
                            .add(MediaOpenChangeChoosedMedia(index: pos + 1));
                      },
                      child: SvgPicture.asset('assets/options/arrow_right.svg'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageView(BuildContext context) {
    return BlocBuilder<MediaOpenBloc, MediaOpenState>(
        builder: ((context, state) {
      if ((state.choosedMedia as Record).loadPercent == 100) {
        print('loaded');
      }

      return state.isInitialized
          ? ScrollConfiguration(
              behavior: NoColorOverscrollBehavior(),
              child: NotificationListener(
                child: ScrollablePositionedList.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.mediaFromFolder.length,
                  itemScrollController: _mainListScrollController,
                  initialScrollIndex: state.mediaFromFolder.indexWhere(
                      (element) => element.id == state.choosedMedia.id),
                  itemPositionsListener: _mainListPositionsListener,
                  physics: PageScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: BlocBuilder<MediaOpenBloc, MediaOpenState>(
                          builder: (context, state) {
                            var media = state.mediaFromFolder[index] as Record;

                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                _buildMedia(media),
                                (media.path != null &&
                                            media.path?.isNotEmpty == true) ||
                                        (media.loadPercent != null)
                                    ? Container()
                                    : Center(
                                        child: CircularProgressIndicator(
                                          value: media.loadPercent,
                                        ),
                                      ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
                onNotification: (notification) {
                  if (notification is UserScrollNotification) {
                    _direction = notification.direction;
                  }
                  if (notification is ScrollEndNotification) {
                    print(notification.runtimeType);

                    var pos = _mainListPositionsListener
                        .itemPositions.value.first.index;
                    var pos2 = _mainListPositionsListener
                        .itemPositions.value.last.index;
                    // var path = (state.mediaFromFolder[pos] as Record).path;
                    // print('pos: $pos, pos2:$pos2');
                    // var positions =
                    //     _mainListPositionsListener.itemPositions.value;

                    // var min = positions
                    //     .where((element) => element.itemTrailingEdge > 0)
                    //     .reduce((min, pos) =>
                    //         pos.itemTrailingEdge < min.itemTrailingEdge
                    //             ? pos
                    //             : min)
                    //     .index;

                    // var max = positions
                    //     .where((element) => element.itemLeadingEdge < 1)
                    //     .reduce((max, pos) =>
                    //         pos.itemTrailingEdge > max.itemTrailingEdge
                    //             ? pos
                    //             : max)
                    //     .index;

                    // print('min = $min');
                    // print('max = $max');
                    // var tmp = min == max;
                    // print(min == max);

                    // print('dragDetails: ${notification.dragDetails}');
                    // print('dept: ${notification.depth}');

                    // if (path == null || path.isEmpty) {
                    //   context.read<MediaOpenBloc>().add(MediaOpenDownload(
                    //       mediaId: state.mediaFromFolder[pos].id));
                    // }
                  }
                  return true;
                },
              ),
            )
          : Container(
              width: double.infinity,
            );
    }));
  }

  Widget _buildMedia(Record media) {
    Widget element;

    var mediaPath = media.path;

    var isExisting = File(mediaPath ?? '').existsSync();
    var isVideo = media.mimeType?.contains('video') ?? false;

    var mediaMiniatureAdress = '';
    if (media.thumbnail != null && media.thumbnail!.isNotEmpty) {
      mediaMiniatureAdress = media.thumbnail!.first.publicUrl ?? '';
    }

    if (mediaPath != null && mediaPath.isNotEmpty && isExisting) {
      if (isVideo) {
        String? mediaFile = media.path;

        if (mediaFile is String) {
          if (Platform.isIOS) {
            mediaFile = Uri.encodeFull(mediaFile);
          }
        }

        element = Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          child: Text('Video is not supported yet'),
        );
      } else {
        element = Image.file(
          File(mediaPath),
          fit: BoxFit.contain,
          width: MediaQuery.of(context).size.width,
        );
      }
    } else if (mediaMiniatureAdress.isEmpty) {
      element = Image.asset(
        isVideo ? 'assets/file_icons/video.png' : 'assets/file_icons/image.png',
        fit: BoxFit.contain,
        width: MediaQuery.of(context).size.width,
      );
    } else {
      element = Image.network(
        mediaMiniatureAdress,
        fit: BoxFit.contain,
        width: MediaQuery.of(context).size.width,
      );
    }

    return element;
  }
}
