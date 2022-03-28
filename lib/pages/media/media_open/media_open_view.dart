import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/models/record.dart';
import 'package:upstorage_desktop/pages/media/media_open/media_open_event.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

import 'media_open_bloc.dart';
import 'media_open_state.dart';

class Positions {
  int last;
  int current;

  Positions({this.last = 0, this.current = 0});
}

class MediaOpenPage extends StatefulWidget {
  MediaOpenPage({Key? key}) : super(key: key);

  static String route = 'MediaOpenPageRoute';

  @override
  _MediaOpenPageState createState() => _MediaOpenPageState();
}

class _MediaOpenPageState extends State<MediaOpenPage> {
  BoxShadow _shadow(BuildContext context) => BoxShadow(
        color: Theme.of(context).shadowColor,
        blurRadius: 4,
        offset: Offset.fromDirection(2, 5),
      );
  late ItemScrollController _mainListScrollController;
  late ItemPositionsListener _mainListPositionsListener;
  late ItemScrollController _bottomListScrollController;
  late ItemPositionsListener _bottomListPositionsListener;
  late Function(BuildContext) listener = _listener;
  bool _isControllersInit = false;
  late Positions pos;
  final S translate = getIt<S>();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var _args = ModalRoute.of(context)!.settings.arguments as MediaOpenPageArgs;

    return BlocProvider(
      create: (context) => getIt<MediaOpenBloc>()
        ..add(MediaOpenPageOpened(
          choosedFolder: _args.selectedFolder,
          choosedMedia: _args.selectedMedia,
        )),
      child: BlocListener<MediaOpenBloc, MediaOpenState>(
        listener: _blocListener,
        child: Scaffold(
          body: Container(
            color: theme.primaryColor,
            child: SafeArea(
              child: Column(
                children: [
                  _toolbar(
                    context,
                    theme,
                  ),
                  _mainSection(context, theme),
                  _bottomView(context, theme),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _initControllers(BuildContext context) {
    if (!_isControllersInit) {
      _isControllersInit = true;
      _mainListScrollController = ItemScrollController();

      _mainListPositionsListener = ItemPositionsListener.create();
      // _mainListPositionsListener.itemPositions.addListener(() {
      //   var positions = _mainListPositionsListener.itemPositions.value;

      //   var min = positions
      //       .where((element) => element.itemTrailingEdge > 0)
      //       .reduce((min, pos) =>
      //           pos.itemTrailingEdge < min.itemTrailingEdge ? pos : min)
      //       .index;

      //   var max = positions
      //       .where((element) => element.itemLeadingEdge < 1)
      //       .reduce((max, pos) =>
      //           pos.itemTrailingEdge > max.itemTrailingEdge ? pos : max)
      //       .index;

      //   print('min = $min');
      //   print('max = $max');
      //   print(min == max);
      // });
      // _mainListPositionsListener.itemPositions.addListener(() {
      //   listener(context);
      // });

      _bottomListPositionsListener = ItemPositionsListener.create();
      _bottomListScrollController = ItemScrollController();
    }
  }

  void _listener(BuildContext context) {
    var positions = _mainListPositionsListener.itemPositions.value;
    if (positions.length == 1 || positions.first.index > positions.last.index) {
      _bottomListScrollController.scrollTo(
        index: positions.first.index + 1,
        duration: Duration(milliseconds: 100),
      );
      if (positions.first.index >= 0) {
        context.read<MediaOpenBloc>().add(
              MediaOpenChangeChoosedMedia(index: positions.first.index),
            );
      }
    }
  }

  Widget _toolbar(
    BuildContext context,
    ThemeData theme,
  ) {
    return Container(
      height: kToolbarHeight,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20.0),
        ),
        boxShadow: [
          _shadow(context),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          _leftToolbarItem(theme),
          BlocBuilder<MediaOpenBloc, MediaOpenState>(
            builder: (context, state) {
              _initControllers(context);
              return Expanded(
                child: Center(
                  child: Text(
                    state.choosedMedia.name ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: theme.textTheme.headline4?.color,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              );
            },
          ),
          _rightToolbarItem(
            theme,
          ),
        ],
      ),
    );
  }

  Widget _leftToolbarItem(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: IconButton(
        onPressed: () {
          Navigator.pop(context, true);
        },
        icon: SvgPicture.asset('assets/arrow_back.svg'),
      ),
    );
  }

  Widget _rightToolbarItem(ThemeData theme) {
    return Container(
      padding: EdgeInsets.only(right: 10.0),
      child: BlocBuilder<MediaOpenBloc, MediaOpenState>(
        builder: (context, state) {
          var selected = state.choosedMedia;
          return Padding(
            padding: const EdgeInsets.only(
              right: 10,
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  context
                      .read<MediaOpenBloc>()
                      .add(MediaOpenChangeFavoriteState(media: selected));
                });
              },
              child: SvgPicture.asset(state.choosedMedia.favorite
                  ? 'assets/media_page/ic_heart_filled.svg'
                  : 'assets/media_page/ic_heart.svg'),
            ),
          );
        },
      ),
    );
  }

  Widget _bottomView(BuildContext context, ThemeData theme) {
    return BlocBuilder<MediaOpenBloc, MediaOpenState>(
      builder: (context, state) {
        return Container(
          color: theme.primaryColor,
          height: 135.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              state.isInitialized
                  ? Expanded(
                      child: _previewList(state),
                    )
                  : Expanded(child: Container()),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _getActionRowItems(context, theme, state),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ScrollablePositionedList _previewList(MediaOpenState state) {
    return ScrollablePositionedList.builder(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: state.mediaFromFolder.length, //+ 2,
      itemPositionsListener: _bottomListPositionsListener,
      itemScrollController: _bottomListScrollController,
      initialScrollIndex: state.mediaFromFolder
          .indexWhere((element) => element.id == state.choosedMedia.id),
      itemBuilder: (context, index) {
        // if (index != 0 && index < state.mediaFromFolder.length) {
        var media = state.mediaFromFolder[index] as Record;

        var mediaMiniatureAdress = '';
        if (media.thumbnail != null && media.thumbnail!.isNotEmpty) {
          mediaMiniatureAdress = media.thumbnail!.first.publicUrl ?? '';
        }

        return Padding(
          padding: const EdgeInsets.all(1.0),
          child: GestureDetector(
            onTap: () {
              _mainListScrollController.scrollTo(
                index: index,
                duration: Duration(milliseconds: 200),
              );
            },
            child: mediaMiniatureAdress.isEmpty
                ? Image.asset(
                    'assets/test_image2.png',
                    fit: BoxFit.fitHeight,
                    // width: MediaQuery.of(context).size.width - 2,
                  )
                : Image.network(
                    mediaMiniatureAdress,
                    fit: BoxFit.fitHeight,
                    // width: MediaQuery.of(context).size.width - 2,
                  ),
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
      },
    );
  }

  List<Widget> _getActionRowItems(
      BuildContext context, ThemeData theme, MediaOpenState state) {
    List<Widget> items = [
      // IconButton(
      //   onPressed: () {},
      //   icon: SvgPicture.asset(
      //     'assets/file_context_menu/share.svg',
      //     color: theme.textTheme.headline5?.color,
      //     height: 25.0,
      //   ),
      // ),
      // IconButton(
      //   onPressed: () {},
      //   icon: SvgPicture.asset(
      //     'assets/file_context_menu/download.svg',
      //     color: theme.textTheme.headline5?.color,
      //     height: 25.0,
      //   ),
      // ),
      // IconButton(
      //   onPressed: () {
      //     _mainListPositionsListener.itemPositions.removeListener(() {
      //       listener(context);
      //     });
      //     pushNewScreenWithRouteSettings(
      //       context,
      //       screen: MediaPage(),
      //       withNavBar: true,
      //       settings: RouteSettings(
      //         name: MediaPage.moveToFolderArgs,
      //         arguments: MediaPageMoveToFolderSettings(
      //           folderFrom: state.openedFolder,
      //           selectedMedia: [state.choosedMedia],
      //           nameOfRouteToBack: MediaOpenPage.route,
      //         ),
      //       ),
      //     );
      //   },
      //   icon: SvgPicture.asset(
      //     'assets/media_page/move_to_folder.svg',
      //     color: theme.textTheme.headline5?.color,
      //     height: 25.0,
      //   ),
      // ),
      IconButton(
        onPressed: () {
          setState(() {
            context.read<MediaOpenBloc>().add(
                  MediaOpenDelete(mediaId: state.choosedMedia.id),
                );
          });
        },
        icon: SvgPicture.asset(
          'assets/file_context_menu/delete.svg',
          color: theme.textTheme.headline5?.color,
          height: 25.0,
        ),
      ),
    ];

    return items;
  }

  ScrollDirection _direction = ScrollDirection.forward;

  Widget _mainSection(BuildContext context, ThemeData theme) {
    return BlocBuilder<MediaOpenBloc, MediaOpenState>(
      buildWhen: (previous, current) {
        var isChoosedFilePathChanged = (previous.choosedMedia as Record).path !=
            (current.choosedMedia as Record).path;

        var isInited = previous.isInitialized != current.isInitialized;

        var isAnyOfFilesChanged =
            current.mediaFromFolder != previous.mediaFromFolder;
        return isChoosedFilePathChanged || isInited || isAnyOfFilesChanged;
      },
      builder: (context, state) {
        // _index = state.mediaFromFolder
        //     .indexWhere((element) => element.id == state.choosedMedia.id);

        return state.isInitialized
            ? Expanded(
                child: ScrollConfiguration(
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
                        var media = state.mediaFromFolder[index] as Record;
                        var mediaLocalPath = media.path;
                        var isExisting = File(media.path ?? '').existsSync();
                        var mediaMiniatureAdress = '';
                        if (media.thumbnail != null &&
                            media.thumbnail!.isNotEmpty) {
                          mediaMiniatureAdress =
                              media.thumbnail!.first.publicUrl ?? '';
                        }

                        return Padding(
                          padding: const EdgeInsets.all(1.0),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              mediaLocalPath != null &&
                                      mediaLocalPath.isNotEmpty &&
                                      isExisting
                                  ? Image.file(
                                      File(media.path!),
                                      fit: BoxFit.contain,
                                      width:
                                          MediaQuery.of(context).size.width - 2,
                                    )
                                  : mediaMiniatureAdress.isEmpty
                                      ? Image.asset(
                                          'assets/test_image2.png',
                                          fit: BoxFit.contain,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              2,
                                        )
                                      : Image.network(
                                          mediaMiniatureAdress,
                                          fit: BoxFit.contain,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              2,
                                        ),
                              media.path != null &&
                                      media.path?.isNotEmpty == true
                                  ? Container()
                                  : Center(child: CircularProgressIndicator()),
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
                        if (_direction == ScrollDirection.forward)
                          context
                              .read<MediaOpenBloc>()
                              .add(MediaOpenChangeChoosedMedia(index: pos));
                        else if (_direction == ScrollDirection.reverse)
                          context
                              .read<MediaOpenBloc>()
                              .add(MediaOpenChangeChoosedMedia(index: pos2));
                        // if (path == null || path.isEmpty) {
                        //   context.read<MediaOpenBloc>().add(MediaOpenDownload(
                        //       mediaId: state.mediaFromFolder[pos].id));
                        // }
                      }
                      return true;
                    },
                  ),
                ),
              )
            : Expanded(child: Container());
      },
    );
  }

  void _blocListener(BuildContext context, MediaOpenState state) async {
    // if (state.status == FormzStatus.submissionFailure) {
    //   if (state.errorType != null) {
    //     await showDialog(
    //       context: context,
    //       builder: (context) {
    //         return SuccessPupup(
    //           buttonText: translate.ok,
    //           middleText: getErrorText(translate, state.errorType!),
    //           isError: true,
    //           onButtonTap: () => Navigator.pop(context),
    //         );
    //       },
    //     );
    //   }
    // }
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
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
