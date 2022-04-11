import 'dart:async';
import 'dart:developer';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:file_typification/file_typification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:upstorage_desktop/components/blur/delete.dart';
import 'package:upstorage_desktop/components/custom_button_template.dart';
import 'package:upstorage_desktop/components/media_info.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/models/record.dart';
import 'package:upstorage_desktop/pages/files/opened_folder/opened_folder_state.dart';
import 'package:upstorage_desktop/pages/media/media_cubit.dart';
import 'package:upstorage_desktop/pages/media/media_open/media_open_view.dart';
import 'package:upstorage_desktop/pages/media/media_state.dart';
import 'package:upstorage_desktop/utilites/event_bus.dart';
import 'package:upstorage_desktop/utilites/extensions.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/utilites/state_container.dart';
import 'package:upstorage_desktop/utilites/state_info_container.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MediaPage extends StatefulWidget {
  @override
  _MediaPageState createState() => new _MediaPageState();

  MediaPage();
}

List<Widget> dirsList = [];

class _MediaPageState extends State<MediaPage> with TickerProviderStateMixin {
  bool ifGrid = true;
  S translate = getIt<S>();
  var _folderButtonSize = 140;
  double? _searchFieldWidth;
  final double _rowSpasing = 20.0;
  final double _rowPadding = 30.0;
  var _folderListScrollController = ScrollController(keepScrollOffset: false);
  var _verticalFolderListScrollController =
      ScrollController(keepScrollOffset: false);
  final TextEditingController _searchingFieldController =
      TextEditingController();
  GlobalKey propertiesWidthKey = GlobalKey();
  List<CustomPopupMenuController> _popupControllers = [];
  Timer? timerForOpenFile;
  int _startTimer = 1;
  bool _isOpen = false;
  var _indexObject = -1;
  var x;

  void _initiatingControllers(MediaState state) {
    if (_popupControllers.isEmpty) {
      state.currentFolderRecords.forEach((element) {
        _popupControllers.add(CustomPopupMenuController());
      });
    }
  }

  void _setWidthSearchFields(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    _searchFieldWidth =
        width - _rowSpasing * 3 - 30 * 2 - _rowPadding * 2 - 274 - 320;
  }

  void startTimer() {
    _isOpen = true;
    const oneSec = const Duration(seconds: 1);
    if (timerForOpenFile != null) {
      timerForOpenFile?.cancel();
      _startTimer = 1;
    }
    timerForOpenFile = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_startTimer == 0) {
          setState(() {
            timer.cancel();
            _startTimer = 1;
            _indexObject = -1;
            _isOpen = false;
          });
        } else {
          setState(() {
            _startTimer--;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _setWidthSearchFields(context);
    // _args = ModalRoute.of(context)!.settings.arguments
    //     as MediaListMoveToFolderSettings;

    return BlocProvider<MediaCubit>(
      create: (_) => MediaCubit()..init(),
      child: Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          //crossAxisAlignment:  CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 46,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 0,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Color.fromARGB(25, 23, 69, 139),
                                        blurRadius: 4,
                                        offset: Offset(1, 4))
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(13.0),
                                      child: Align(
                                        alignment: FractionalOffset.centerLeft,
                                        child: Container(
                                            width: 20,
                                            height: 20,
                                            child: SvgPicture.asset(
                                                "assets/file_page/search.svg")),
                                      ),
                                    ),
                                    BlocBuilder<MediaCubit, MediaState>(
                                        builder: (context, state) {
                                      return Container(
                                        width: _searchFieldWidth,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Center(
                                            child: TextField(
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: Theme.of(context)
                                                    .disabledColor,
                                              ),
                                              onChanged: (value) {
                                                context
                                                    .read<MediaCubit>()
                                                    .mapSortedFieldChanged(
                                                        value);
                                              },
                                              controller:
                                                  _searchingFieldController,
                                              decoration:
                                                  InputDecoration.collapsed(
                                                hintText: translate.search,
                                                hintStyle: TextStyle(
                                                  fontSize: 16.0,
                                                  color: Theme.of(context)
                                                      .disabledColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          StateInfoContainer.of(context)?.record == null
                              ? Container(
                                  child: BlocBuilder<MediaCubit, MediaState>(
                                      builder: (context, state) {
                                    return Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: 20, left: 20),
                                          child: GestureDetector(
                                            onTap: () {
                                              StateContainer.of(context)
                                                  .changePage(
                                                      ChoosedPage.settings);
                                            },
                                            child: MouseRegion(
                                              cursor: SystemMouseCursors.click,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(23.0),
                                                child: Container(
                                                    child: state.user.image),
                                              ),
                                            ),
                                          ),
                                        ),
                                        (MediaQuery.of(context).size.width >
                                                965)
                                            ? Container(
                                                constraints: BoxConstraints(
                                                    maxWidth: 120),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 5),
                                                      child: Text(
                                                        state.user?.firstName ??
                                                            '',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 17,
                                                          color: Theme.of(
                                                                  context)
                                                              .bottomAppBarColor,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      state.user?.email ?? '',
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Theme.of(context)
                                                            .bottomAppBarColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    );
                                  }),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 30,
                      ),
                      child: Container(
                        height: 224,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Color.fromARGB(25, 23, 69, 139),
                                blurRadius: 4,
                                offset: Offset(1, 4))
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 30,
                                child: Row(
                                  children: [
                                    Text(
                                      translate.folder_dir,
                                      style: TextStyle(
                                        color: Theme.of(context).focusColor,
                                        fontSize: 20,
                                        fontFamily: kNormalTextFontFamily,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 861,
                                      child: SizedBox(),
                                    ),
                                    Container(
                                      width: 30,
                                      height: 30,
                                      child: RawMaterialButton(
                                        onPressed: () {
                                          _folderListScrollController.animateTo(
                                              _folderListScrollController
                                                      .offset -
                                                  _folderButtonSize,
                                              duration:
                                                  Duration(milliseconds: 500),
                                              curve: Curves.ease);
                                        },
                                        fillColor:
                                            Theme.of(context).primaryColor,
                                        child: Icon(
                                          Icons.arrow_back_ios_rounded,
                                          color: Theme.of(context).splashColor,
                                          size: 20.0,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        child: RawMaterialButton(
                                          onPressed: () {
                                            _folderListScrollController
                                                .animateTo(
                                                    _folderListScrollController
                                                            .offset +
                                                        _folderButtonSize,
                                                    duration: Duration(
                                                        milliseconds: 500),
                                                    curve: Curves.ease);
                                          },
                                          fillColor:
                                              Theme.of(context).primaryColor,
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color:
                                                Theme.of(context).splashColor,
                                            size: 20.0,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: 25,
                                  ),
                                  child: BlocBuilder<MediaCubit, MediaState>(
                                    builder: (context, state) {
                                      //  _folderListScrollController.animateTo(
                                      //       _verticalFolderListScrollController
                                      //           .offset,
                                      //       duration: Duration(milliseconds: 500),
                                      //       curve: Curves.ease);

                                      _initiatingControllers(state);
                                      return Stack(children: [
                                        NotificationListener(
                                          child: ListView(
                                            shrinkWrap: true,
                                            physics: ClampingScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            controller:
                                                _verticalFolderListScrollController,
                                          ),
                                          onNotification: (t) {
                                            setState(() {
                                              x = _verticalFolderListScrollController
                                                  .position.pixels;
                                              print(x);
                                            });
                                            if (t is ScrollEndNotification) {}
                                            return true;
                                          },
                                        ),
                                        ListView(
                                          shrinkWrap: true,
                                          physics: ClampingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          controller:
                                              _folderListScrollController,
                                          children: [
                                            ...state.albums
                                                .map(
                                                  (album) => _folderIcon(
                                                    album,
                                                    isChoosed: album.id ==
                                                        state.currentFolder.id,
                                                    blocContext: context,
                                                  ),
                                                )
                                                .toList(),
                                          ],
                                        ),
                                      ]);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Color.fromARGB(25, 23, 69, 139),
                                  blurRadius: 4,
                                  offset: Offset(1, 4))
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 20, 30, 0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    BlocBuilder<MediaCubit, MediaState>(
                                      builder: (context, state) {
                                        return Container(
                                          child: Text(
                                            state.currentFolder.name ?? ':(',
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context).focusColor,
                                              fontFamily: kNormalTextFontFamily,
                                              fontSize: 20,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    Expanded(
                                      flex: 821,
                                      child: Container(),
                                    ),
                                    BlocBuilder<MediaCubit, MediaState>(
                                        builder: (context, state) {
                                      return IconButton(
                                        padding: EdgeInsets.zero,
                                        iconSize: 30,
                                        onPressed: () {
                                          context
                                              .read<MediaCubit>()
                                              .changeRepresentation(
                                                  FilesRepresentation.table);
                                        },
                                        icon: SvgPicture.asset(
                                            'assets/file_page/list.svg',
                                            color: state.representation ==
                                                    FilesRepresentation.table
                                                ? Theme.of(context).splashColor
                                                : Theme.of(context)
                                                    .toggleButtonsTheme
                                                    .color),
                                      );
                                    }),
                                    BlocBuilder<MediaCubit, MediaState>(
                                      builder: (context, state) {
                                        return IconButton(
                                          iconSize: 30,
                                          onPressed: () {
                                            context
                                                .read<MediaCubit>()
                                                .changeRepresentation(
                                                    FilesRepresentation.grid);
                                          },
                                          icon: SvgPicture.asset(
                                              'assets/file_page/block.svg',
                                              // width: 30,
                                              // height: 30,
                                              //colorBlendMode: BlendMode.softLight,
                                              color: state.representation ==
                                                      FilesRepresentation.grid
                                                  ? Theme.of(context)
                                                      .splashColor
                                                  : Theme.of(context)
                                                      .toggleButtonsTheme
                                                      .color),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              ifGrid
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40),
                                      child: Divider(
                                        height: 1,
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    )
                                  : Container(),
                              BlocBuilder<MediaCubit, MediaState>(
                                builder: (context, state) {
                                  eventBusMediaOpen.on().listen((event) {
                                    var element =
                                        StateInfoContainer.of(context)?.record;
                                    if (_isOpen == false) {
                                      startTimer();
                                      context
                                          .read<MediaCubit>()
                                          .fileTapped(element as Record);
                                    }
                                  });
                                  return Expanded(
                                    child: state.representation ==
                                            FilesRepresentation.grid
                                        ? state.progress == true
                                            ? _filesGrid()
                                            : _progressIndicator(context)
                                        : _filesList(context, state),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            StateInfoContainer.of(context)?.record == null
                ? Container()
                : showViewFileInfo(),
          ],
        ),
      ),
    );
  }

  // void _listener(BuildContext context, MediaState state) {
  //   if (state.status == FormzStatus.valid) {
  //     showDialog(
  //       context: context,
  //       builder: (context) {
  //         return SuccessPupup(
  //           buttonText: "translate.ok,",
  //           middleText: "translate.added_to_album,",
  //           onButtonTap: () => Navigator.of(context).popUntil(
  //             (route) {
  //               return route.settings.name == _args.nameOfRouteToBack;
  //             },
  //           ),
  //         );
  //       },
  //     );
  //   } else if (state.status == FormzStatus.submissionFailure) {
  //     if (state.errorType == ErrorType.noInternet) {
  //       showDialog(
  //         context: context,
  //         builder: (context) {
  //           return SuccessPupup(
  //             buttonText: "translate.ok",
  //             middleText: "translate.no_internet",
  //             isError: true,
  //             onButtonTap: () => Navigator.pop(context),
  //           );
  //         },
  //       );
  //     } else if (state.errorType == ErrorType.technicalError) {
  //       showDialog(
  //         context: context,
  //         builder: (context) {
  //           return SuccessPupup(
  //             buttonText: "translate.ok",
  //             middleText: "translate.technical_error",
  //             isError: true,
  //             onButtonTap: () => Navigator.pop(context),
  //           );
  //         },
  //       );
  //     }
  //   }
  // }

  Widget _progressIndicator(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.6,
      child: Center(
        child: CupertinoActivityIndicator(
          animating: true,
        ),
      ),
    );
  }

  Widget showViewFileInfo() {
    try {
      if (StateInfoContainer.of(context)?.record == null) {
        return Container();
      } else {
        // _prepareFields(context);
        return BlocBuilder<MediaCubit, MediaState>(builder: (context, state) {
          return Container(
              child: MediaInfoView(
                  key: propertiesWidthKey,
                  user: state.user,
                  record: StateInfoContainer.of(context)?.record));
        });
      }
    } catch (e) {
      return Container();
    }
  }

  Widget _folderIcon(
    Folder album, {
    required bool isChoosed,
    required BuildContext blocContext,
  }) {
    Color activeColor;
    String icon = 'album';
    if (album.id == '-1') {
      activeColor = Color(0xFF868FFF);
    } else if (album.name == translate.photos) {
      activeColor = Color(0xFF59D7AB);
      icon = 'photo';
    } else if (album.name == translate.video) {
      activeColor = Color(0xFFFF847E);
      icon = 'video';
    } else {
      activeColor = Color(0xFFFF94E1);
    }
    return Padding(
      padding: const EdgeInsets.only(right: 13),
      child: GestureDetector(
        onTap: () {
          print('folder tapped: ${album.name}');
          blocContext.read<MediaCubit>().changeFolder(album);

          final mediaAlbumId = album.id == '-1' ? null : album.id;
          StateContainer.of(context).changeChoosedMediaFolderId(mediaAlbumId);

          log('${StateContainer.of(context).choosedMediaFolderId}');
        },
        child: Container(
          width: _folderButtonSize.toDouble(),
          height: _folderButtonSize.toDouble(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 2,
              color: isChoosed
                  ? activeColor
                  : Theme.of(context).buttonTheme.colorScheme!.primary,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SvgPicture.asset(
                  'assets/file_page/${icon}_icon.svg',
                  color: activeColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
                child: Text(
                  album.name ?? ':(',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    color: Theme.of(context).disabledColor,
                    fontSize: 16,
                    fontFamily: kNormalTextFontFamily,
                    height: 1.1,
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _onTapItem(List<BaseObject> media, BaseObject selectedMedia,
      BuildContext context, Folder? openedFolder) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return MediaOpenPage(
            arguments: MediaOpenPageArgs(
                media: media,
                selectedMedia: selectedMedia,
                selectedFolder: openedFolder),
          );
        });
    // pushNewScreenWithRouteSettings(
    //   context,
    //   screen: MediaOpenPage(),
    //   withNavBar: false,
    //   settings: RouteSettings(
    //     arguments: MediaOpenPageArgs(
    //         media: media,
    //         selectedMedia: selectedMedia,
    //         selectedFolder: openedFolder),
    //   ),
    // ).then((value) {
    //   if (value == true) {
    //     context.read<MediaCubit>();
    //   }
    //   setState(() {});
    // });
  }

  Widget _filesGrid() {
    return BlocBuilder<MediaCubit, MediaState>(
      buildWhen: (previous, current) {
        var needToUpdate =
            previous.currentFolderRecords != current.currentFolderRecords;
        return needToUpdate;
      },
      builder: (blocContext, state) {
        return LayoutBuilder(builder: (context, constrains) {
          // print('min width ${constrains.smallest.width}');

          return Container(
            // padding: EdgeInsets.symmetric(horizontal: 40),
            child: GridView.builder(
              itemCount: state.currentFolderRecords.length,
              shrinkWrap: true,
              controller: ScrollController(),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: constrains.smallest.width ~/ 100,
                crossAxisSpacing: 30,
                childAspectRatio: (1.1 / 1.50),
                mainAxisSpacing: 35,
              ),
              itemBuilder: (context, index) {
                var record = state.currentFolderRecords[index];

                if (state.currentFolderRecords.length >
                    _popupControllers.length) {
                  _popupControllers = [];
                  _initiatingControllers(state);
                }

                _onPointerDown(PointerDownEvent event) {
                  if (event.kind == PointerDeviceKind.mouse &&
                      event.buttons == kSecondaryMouseButton) {
                    print("right button click");

                    _popupControllers[
                            state.currentFolderRecords.indexOf(record)]
                        .showMenu();
                  }
                }

                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      //_photoOpen(context, state.currentFolderRecords);
                      // _onTapItem(state.currentFolderRecords, record, context,
                      //     state.currentFolder);
                      if (_indexObject != index) {
                        setState(() {
                          _indexObject = index;
                        });
                        startTimer();
                        blocContext
                            .read<MediaCubit>()
                            .fileTapped(state.currentFolderRecords[index]);
                      }
                    },
                    child: Listener(
                      onPointerDown: _onPointerDown,
                      behavior: HitTestBehavior.opaque,
                      child: IgnorePointer(
                        child: CustomPopupMenu(
                            pressType: PressType.singleClick,
                            barrierColor: Colors.transparent,
                            showArrow: false,
                            enablePassEvent: false,
                            horizontalMargin: 110,
                            verticalMargin: 0,
                            controller: _popupControllers[
                                state.currentFolderRecords.indexOf(record)],
                            menuBuilder: () {
                              return MediaPopupMenuActions(
                                theme: Theme.of(context),
                                translate: translate,
                                onTap: (action) async {
                                  _popupControllers[state.currentFolderRecords
                                          .indexOf(record)]
                                      .hideMenu();
                                  if (action == MediaAction.properties) {
                                    // controller.hideMenu();
                                    StateInfoContainer.of(context)
                                        ?.setInfoRecord(record);
                                  } else {
                                    //   controller.hideMenu();
                                    var result = await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return BlurDelete();
                                      },
                                    );
                                    if (result == true) {
                                      context
                                          .read<MediaCubit>()
                                          .onActionDeleteChoosed(record);
                                    }
                                  }
                                },
                              );
                            },
                            child: MediaGridElement(
                                record: state.currentFolderRecords[index])),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        });
      },
    );
  }

  Widget _filesList(BuildContext context, MediaState state) {
    TextStyle style = TextStyle(
      color: Theme.of(context).textTheme.subtitle1?.color,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      fontFamily: kNormalTextFontFamily,
    );
    TextStyle cellTextStyle = TextStyle(
      color: Theme.of(context).textTheme.subtitle1?.color,
      fontSize: 14,
      fontFamily: kNormalTextFontFamily,
    );

    return BlocBuilder<MediaCubit, MediaState>(
      builder: (context, state) {
        return LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: ScrollController(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: DataTable(
                  columnSpacing: 25,
                  showCheckboxColumn: false,
                  columns: [
                    DataColumn(
                      label: Container(
                        width: constraints.maxWidth * 0.5,
                        child: Text(
                          translate.name,
                          style: style,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Container(
                        width: constraints.maxWidth * 0.06,
                        child: Text(
                          translate.format,
                          style: style,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Container(
                        width: constraints.maxWidth * 0.05,
                        child: Text(
                          translate.date,
                          style: style,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Container(
                        width: constraints.maxWidth * 0.06,
                        child: Text(
                          translate.size,
                          style: style,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Container(
                        width: constraints.maxWidth * 0.001,
                        child: SizedBox(
                          width: constraints.maxWidth * 0.001,
                        ),
                      ),
                    ),
                  ],
                  rows: state.currentFolderRecords.map((e) {
                    String? type = '';
                    bool isFile = false;
                    if (state.currentFolderRecords.length >
                        _popupControllers.length) {
                      _popupControllers = [];
                      _initiatingControllers(state);
                    }

                    var record = e;
                    isFile = true;
                    if (record.thumbnail != null &&
                        record.thumbnail!.isNotEmpty) {
                      type = FileAttribute()
                          .getFilesType(record.name!.toLowerCase());
                    }

                    return DataRow.byIndex(
                      index: state.currentFolderRecords.indexOf(e),
                      color:
                          MaterialStateProperty.resolveWith<Color?>((states) {
                        print(states.toList().toString());
                        if (states.contains(MaterialState.focused)) {
                          return Theme.of(context).splashColor;
                        }
                        return null;
                      }),
                      cells: [
                        DataCell(
                          GestureDetector(
                            onTap: () {
                              var index = state.currentFolderRecords.indexOf(e);
                              if (_indexObject != index) {
                                setState(() {
                                  _indexObject = index;
                                });
                                startTimer();
                                context.read<MediaCubit>().fileTapped(e);
                              }
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    type.isNotEmpty
                                        ? 'assets/file_icons/${type}_s.png'
                                        : 'assets/file_icons/unexpected_s.png',
                                    fit: BoxFit.contain,
                                    height: 24,
                                    width: 24,
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Text(
                                      e.name ?? '',
                                      style: cellTextStyle,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  // Spacer(),
                                  BlocBuilder<MediaCubit, MediaState>(
                                    builder: (context, state) {
                                      return GestureDetector(
                                        onTap: () {
                                          context
                                              .read<MediaCubit>()
                                              .setFavorite(e);
                                        },
                                        child: Image.asset(
                                          e.favorite
                                              ? 'assets/file_page/favorite.png'
                                              : 'assets/file_page/not_favorite.png',
                                          height: 18,
                                          width: 18,
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            type.isEmpty ? translate.foldr : type.toUpperCase(),
                            style: cellTextStyle,
                          ),
                        ),
                        DataCell(
                          Text(
                            DateFormat('dd.MM.yyyy').format(e.createdAt!),
                            style: cellTextStyle,
                          ),
                        ),
                        DataCell(
                          Text(
                            fileSize(e.size, translate, 1),
                            style: cellTextStyle,
                          ),
                        ),
                        DataCell(
                          Theme(
                            data: Theme.of(context).copyWith(
                              hoverColor: Colors.transparent,
                              splashColor: Colors.transparent,
                            ),
                            child: CustomPopupMenu(
                              pressType: PressType.singleClick,
                              barrierColor: Colors.transparent,
                              showArrow: false,
                              horizontalMargin: 110,
                              verticalMargin: 0,
                              controller: _popupControllers[
                                  state.currentFolderRecords.indexOf(e)],
                              menuBuilder: () {
                                return MediaPopupMenuActions(
                                    theme: Theme.of(context),
                                    translate: translate,
                                    onTap: (action) async {
                                      _popupControllers[state
                                              .currentFolderRecords
                                              .indexOf(e)]
                                          .hideMenu();
                                      if (action == MediaAction.properties) {
                                        // controller.hideMenu();
                                        StateInfoContainer.of(context)
                                            ?.setInfoRecord(e);
                                      } else {
                                        //   controller.hideMenu();
                                        var result = await showDialog<bool>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return BlurDelete();
                                          },
                                        );
                                        if (result == true) {
                                          context
                                              .read<MediaCubit>()
                                              .onActionDeleteChoosed(e);
                                        }
                                      }
                                    });
                              },
                              child: Container(
                                height: 30,
                                width: 30,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/file_page/three_dots.svg',
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}

class MediaGridElement extends StatelessWidget {
  final Record record;

  const MediaGridElement({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var imageUrl = record.thumbnail!.first.publicUrl!;
    Widget image;
    if (imageUrl.isURL()) {
      image = Image.network(
        record.thumbnail!.first.publicUrl!,
      );
    } else {
      image = Image.asset(
        'assets/file_icons/image_default.png',
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: image,
            ),
            ..._uploadProgress(record.loadPercent),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          record.name ?? ':(',
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).disabledColor,
            fontFamily: kNormalTextFontFamily,
            fontSize: 14,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  List<Widget> _uploadProgress(double? progress) {
    List<Widget> indicators = [];
    if (progress != null) {
      print('creating indicators with progress: $progress');
      indicators = [
        Visibility(
          child: CircularProgressIndicator(
            value: progress / 100,
          ),
        ),
        CupertinoActivityIndicator(),
      ];
    }

    return indicators;
  }
}

class MediaPopupMenuActions extends StatefulWidget {
  MediaPopupMenuActions(
      {required this.theme,
      required this.translate,
      required this.onTap,
      Key? key})
      : super(key: key);

  final ThemeData theme;
  final S translate;
  final Function(MediaAction) onTap;
  @override
  _MediaPopupMenuActionsState createState() => _MediaPopupMenuActionsState();
}

class _MediaPopupMenuActionsState extends State<MediaPopupMenuActions> {
  int ind = -1;
  @override
  Widget build(BuildContext context) {
    var style = TextStyle(
      fontFamily: kNormalTextFontFamily,
      fontSize: 14,
      color: Theme.of(context).disabledColor,
    );
    var mainColor = widget.theme.colorScheme.onSecondary;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: mainColor,
            spreadRadius: 3,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: IntrinsicWidth(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onTap(MediaAction.properties);
                  },
                  child: MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        ind = 0;
                      });
                    },
                    child: Container(
                      width: 190,
                      height: 40,
                      color: ind == 0 ? mainColor : null,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      margin: EdgeInsets.zero,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Image.asset(
                          //   'assets/file_page/file_options/info.png',
                          //   height: 20,
                          // ),
                          SvgPicture.asset(
                            'assets/options/info.svg',
                            height: 20,
                          ),
                          Container(
                            width: 15,
                          ),
                          Text(
                            widget.translate.info,
                            style: style,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: mainColor,
                  height: 1,
                ),
                GestureDetector(
                  onTap: () {
                    widget.onTap(MediaAction.delete);
                  },
                  child: MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        ind = 1;
                      });
                    },
                    child: Container(
                      width: 190,
                      height: 40,
                      color: ind == 1
                          ? widget.theme.indicatorColor.withOpacity(0.1)
                          : null,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Image.asset(
                          //   'assets/file_page/file_options/trash.png',
                          //   height: 20,
                          // ),
                          SvgPicture.asset(
                            'assets/options/trash.svg',
                            height: 20,
                            color: widget.theme.indicatorColor,
                          ),
                          Container(
                            width: 15,
                          ),
                          Text(
                            widget.translate.delete,
                            style: style.copyWith(
                                color: Theme.of(context).errorColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MediaListMoveToFolderSettings {
  List<BaseObject>? selectedItems;
  BaseObject? folderFrom;
  BaseObject openedFolder;
  String? nameOfRouteToBack;

  MediaListMoveToFolderSettings({
    required this.openedFolder,
    this.folderFrom,
    this.selectedItems,
    this.nameOfRouteToBack,
  });
}
