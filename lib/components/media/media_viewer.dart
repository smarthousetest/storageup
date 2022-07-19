import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cpp_native/models/base_object.dart';
import 'package:cpp_native/models/record.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:storageup/components/media/video_player_widget.dart';
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
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Expanded(child: _imageView(context)),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: _previewList(),
            )
          ],
        ),
      ),
    );
  }

  Widget _controlElements(BuildContext context) {
    return BlocBuilder<MediaOpenBloc, MediaOpenState>(
      builder: (context, state) {
        return FractionallySizedBox(
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
                      int pos = _mainListPositionsListener
                          .itemPositions.value.first.index;
                      int newPosition = pos - 1;
                      if (newPosition < 0 &&
                          newPosition >= state.mediaFromFolder.length)
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
        );
      },
    );
  }

  Widget _imageView(BuildContext context) {
    return BlocBuilder<MediaOpenBloc, MediaOpenState>(
        builder: ((context, state) {
      if ((state.choosedMedia as Record).loadPercent == 100) {
        print('loaded');
      }

      return state.isInitialized
          ? Stack(
              children: [
                ScrollConfiguration(
                  behavior: NoColorOverscrollBehavior(),
                  child: ScrollablePositionedList.builder(
                    shrinkWrap: false,
                    scrollDirection: Axis.horizontal,
                    itemCount: state.mediaFromFolder.length,
                    itemScrollController: _mainListScrollController,
                    initialScrollIndex: state.mediaFromFolder.indexWhere(
                        (element) => element.id == state.choosedMedia.id),
                    itemPositionsListener: _mainListPositionsListener,
                    physics: PageScrollPhysics(),
                    itemBuilder: (context, index) {
                      var media = state.mediaFromFolder[index] as Record;

                      String? mediaPath = media.path;
                      var isExisting = File(mediaPath ?? '').existsSync();

                      print(
                          'Building item $index exists $isExisting path $mediaPath');
                      // return Container(
                      //   alignment: Alignment.center,
                      //   width: MediaQuery.of(context).size.width,
                      //   child: Text('Item ${}'),
                      // )

                      if (!isExisting) {
                        return Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          child:
                              Text('Building item $index exists $isExisting'),
                        );
                      }

                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            _buildMedia(media, mediaPath, isExisting),
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
                        ),
                      );
                    },
                  ),
                ),
                _controlElements(context),
              ],
            )
          : Container(
              width: double.infinity,
            );
    }));
  }

  ItemPositionsListener _previewListItemPositionsListener =
      ItemPositionsListener.create();
  ItemScrollController _previewListScrollController = ItemScrollController();

  Widget _previewList() {
    return BlocBuilder<MediaOpenBloc, MediaOpenState>(
      builder: (context, state) {
        if (!state.isInitialized) {
          return Container(
            height: 64,
          );
        }

        return Container(
          height: 64,
          child: ScrollablePositionedList.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: state.mediaFromFolder.length,
              itemPositionsListener: _previewListItemPositionsListener,
              itemScrollController: _previewListScrollController,
              initialScrollIndex: state.mediaFromFolder
                  .indexWhere((element) => element.id == state.choosedMedia.id),
              itemBuilder: (context, index) {
                if (index < 0) {
                  return SizedBox();
                }

                var media = state.mediaFromFolder[index] as Record;

                var mediaMiniatureAdress = '';
                if (media.thumbnail != null && media.thumbnail!.isNotEmpty) {
                  mediaMiniatureAdress = media.thumbnail!.first.publicUrl ?? '';
                }

                final isVideo = media.mimeType?.contains('video') ?? false;

                return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: GestureDetector(
                      onTap: () {
                        context.read<MediaOpenBloc>().add(
                              MediaOpenChangeChoosedMedia(index: index),
                            );
                        _mainListScrollController.scrollTo(
                          index: index,
                          duration: Duration(milliseconds: 200),
                        );
                      },
                      child: mediaMiniatureAdress.isEmpty
                          ? Image.asset(
                              isVideo
                                  ? 'assets/file_icons/video.png'
                                  : 'assets/file_icons/image.png',
                              fit: BoxFit.fitHeight,
                              // width: MediaQuery.of(context).size.width - 2,
                            )
                          : CachedNetworkImage(
                              imageUrl: mediaMiniatureAdress,
                              fit: BoxFit.contain,
                              errorWidget: (context, obj, st) =>
                                  _getImagePlaceholder(isVideo),
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) {
                                return Center(
                                  child: Container(
                                    color: Colors.black38,
                                  ),
                                );
                              },
                            )
                      // Image.asset(
                      //   'assets/test_image2.png',
                      //   //state.mediaFromFolder[index].imagePreview,
                      //   fit: BoxFit.fitHeight,
                      // ),
                      ),
                );
                // } else
                //   return SizedBox(
                //     width: MediaQuery.of(context).size.width / 5,
                //     child: Container(),
                //   );
              }),
        );
      },
    );
  }

  Widget _getImagePlaceholder(bool isVideo) {
    return Image.asset(
      isVideo ? 'assets/file_icons/video.png' : 'assets/file_icons/image.png',
      fit: BoxFit.cover,
    );
  }

  Widget _buildMedia(Record media, String? mediaPath, bool isExisting) {
    Widget element;

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
          child: VideoPlayerWidget(
            videoPath: mediaPath,
          ),
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
