import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/models/base_object.dart';
import 'package:storageup/models/record.dart';
import 'package:storageup/pages/media/media_open/media_open_bloc.dart';
import 'package:storageup/pages/media/media_open/media_open_event.dart';
import 'package:storageup/pages/media/media_open/media_open_state.dart';
import 'package:storageup/utilities/injection.dart';

class Positions {
  int last;
  int current;

  Positions({this.last = 0, this.current = 0});
}

class MediaOpenPage extends StatefulWidget {
  MediaOpenPage({
    Key? key,
    required this.arguments,
  }) : super(key: key);
  final MediaOpenPageArgs arguments;

  @override
  _MediaOpenPageState createState() => _MediaOpenPageState();
}

class _MediaOpenPageState extends State<MediaOpenPage> {
  late ItemPositionsListener _mainListPositionsListener;
  late ItemScrollController _mainListScrollController;
  bool _isControllersInit = false;

  void _initControllers(BuildContext context) {
    if (!_isControllersInit) {
      _isControllersInit = true;
      _mainListScrollController = ItemScrollController();

      _mainListPositionsListener = ItemPositionsListener.create();
    }
  }

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MediaOpenBloc>()..add(MediaOpenPageOpened(choosedFolder: widget.arguments.selectedFolder, choosedMedia: widget.arguments.selectedMedia)),
      child: Material(
        color: Colors.transparent,
        child: Stack(children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
              ),
              child: Container(
                color: Colors.black.withAlpha(85),
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.arguments.selectedMedia.name ?? '',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontFamily: kNormalTextFontFamily,
                            ),
                          )),
                      Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 61.0),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: SvgPicture.asset('assets/options/close.svg')),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                mainSection(context),
                Container(
                  height: 125,
                )
              ],
            ),
          )
        ]),
      ),
    );
  }

  mainSection(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30.0),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  //TODO do realisation of this function
                },
                child: SvgPicture.asset('assets/options/arrow_left.svg'),
              ),
            ),
          ),
          Spacer(),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 140,
              child: _imageView(context),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 30.0),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  //TODO do realisation of this function
                },
                child: SvgPicture.asset('assets/options/arrow_right.svg'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ScrollDirection _direction = ScrollDirection.forward;

  _imageView(BuildContext context) {
    return BlocBuilder<MediaOpenBloc, MediaOpenState>(buildWhen: (previous, current) {
      var isChoosedFilePathChanged = (previous.choosedMedia as Record).path != (current.choosedMedia as Record).path;

      var isInited = previous.isInitialized != current.isInitialized;

      var isAnyOfFilesChanged = current.mediaFromFolder != previous.mediaFromFolder;
      return isChoosedFilePathChanged || isInited || isAnyOfFilesChanged;
    }, builder: ((context, state) {
      _initControllers(context);
      return state.isInitialized
          ? ScrollConfiguration(
              behavior: NoColorOverscrollBehavior(),
              child: NotificationListener(
                child: ScrollablePositionedList.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: state.mediaFromFolder.length,
                  itemScrollController: _mainListScrollController,
                  initialScrollIndex: state.mediaFromFolder.indexWhere((element) => element.id == state.choosedMedia.id),
                  itemPositionsListener: _mainListPositionsListener,
                  physics: PageScrollPhysics(),
                  itemBuilder: (context, index) {
                    var media = state.mediaFromFolder[index] as Record;
                    var mediaLocalPath = media.path;
                    var isExisting = File(media.path ?? '').existsSync();
                    var mediaMiniatureAdress = '';
                    if (media.thumbnail != null && media.thumbnail!.isNotEmpty) {
                      mediaMiniatureAdress = media.thumbnail!.first.publicUrl ?? '';
                    }

                    return Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          mediaLocalPath != null && mediaLocalPath.isNotEmpty && isExisting
                              ? Image.file(
                                  File(media.path!),
                                  fit: BoxFit.contain,
                                  width: MediaQuery.of(context).size.width - 2,
                                )
                              : mediaMiniatureAdress.isEmpty
                                  ? Image.asset(
                                      'assets/test_image2.png',
                                      fit: BoxFit.contain,
                                      width: MediaQuery.of(context).size.width - 2,
                                    )
                                  : Image.network(
                                      mediaMiniatureAdress,
                                      fit: BoxFit.contain,
                                      width: MediaQuery.of(context).size.width - 2,
                                    ),
                          media.path != null && media.path?.isNotEmpty == true
                              ? Container()
                              : Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ],
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

                    var pos = _mainListPositionsListener.itemPositions.value.first.index;
                    var pos2 = _mainListPositionsListener.itemPositions.value.last.index;
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
                    if (_direction == ScrollDirection.forward)
                      context.read<MediaOpenBloc>().add(MediaOpenChangeChoosedMedia(index: pos));
                    else if (_direction == ScrollDirection.reverse) context.read<MediaOpenBloc>().add(MediaOpenChangeChoosedMedia(index: pos2));
                    // if (path == null || path.isEmpty) {
                    //   context.read<MediaOpenBloc>().add(MediaOpenDownload(
                    //       mediaId: state.mediaFromFolder[pos].id));
                    // }
                  }
                  return true;
                },
              ),
            )
          : Container();
    }));
  }
}

class MediaOpenPageArgs {
  List<BaseObject> media;
  BaseObject selectedMedia;
  BaseObject? selectedFolder;

  MediaOpenPageArgs({
    required this.media,
    required this.selectedMedia,
    this.selectedFolder,
  });
}

class NoColorOverscrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
