import 'dart:async';
import 'dart:developer';
import 'package:cpp_native/models/base_object.dart';
import 'package:cpp_native/models/folder.dart';
import 'package:cpp_native/models/record.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:file_typification/file_typification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:storageup/components/blur/create_album.dart';
import 'package:storageup/components/blur/custom_error_popup.dart';
import 'package:storageup/components/blur/delete.dart';
import 'package:storageup/components/blur/rename.dart';

import 'package:storageup/components/context_menu.dart';
import 'package:storageup/components/context_menu_lib.dart';

import 'package:storageup/components/properties.dart';
import 'package:storageup/components/user_info.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/models/user.dart';
import 'package:storageup/pages/files/models/sorting_element.dart';
import 'package:storageup/pages/files/opened_folder/opened_folder_state.dart';
import 'package:storageup/pages/media/media_cubit.dart';
import 'package:storageup/pages/media/media_open/media_open_view.dart';
import 'package:storageup/pages/media/media_state.dart';
import 'package:storageup/utilities/extensions.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/state_containers/state_container.dart';

class MediaPage extends StatefulWidget {
  @override
  _MediaPageState createState() => new _MediaPageState();

  MediaPage();
}

List<Widget> dirsList = [];

class _MediaPageState extends State<MediaPage> with TickerProviderStateMixin {
  bool youSeePopUp = false;
  bool ifGrid = true;
  S translate = getIt<S>();
  var _folderButtonSize = 140;
  double? _searchFieldWidth;
  final double _rowSpasing = 20.0;
  final double _rowPadding = 30.0;
  var _folderListScrollController = ScrollController(keepScrollOffset: false);
  final TextEditingController _searchingFieldController =
      TextEditingController();
  GlobalKey propertiesWidthKey = GlobalKey();
  List<CustomPopupMenuController> _popupControllers = [];
  Timer? timerForOpenFile;
  int _startTimer = 1;
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
      create: (_) => MediaCubit(
        stateContainer: StateContainer.of(context),
      )..init(),
      child: BlocListener<MediaCubit, MediaState>(
        listener: (context, state) async {
          if (StateContainer.of(context).isPopUpShowing == false) {
            if (state.status == FormzStatus.submissionFailure) {
              StateContainer.of(context).changeIsPopUpShowing(true);
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BlurCustomErrorPopUp(
                    middleText: translate.internal_server_error,
                  );
                },
              );
              StateContainer.of(context).changeIsPopUpShowing(false);
            } else if (state.status == FormzStatus.submissionCanceled) {
              StateContainer.of(context).changeIsPopUpShowing(true);
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BlurCustomErrorPopUp(
                      middleText: translate.no_internet);
                },
              );
              StateContainer.of(context).changeIsPopUpShowing(false);
            }
          }
        },
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
                                      offset: Offset(1, 4),
                                    )
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
                                              "assets/file_page/search.svg"),
                                        ),
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
                          Container(
                            child: BlocBuilder<MediaCubit, MediaState>(
                                builder: (context, state) {
                              return state.valueNotifier != null
                                  ? ValueListenableBuilder<User?>(
                                      valueListenable: state.valueNotifier!,
                                      builder: (context, value, _) {
                                        return UserInfo(
                                          user: value,
                                          isExtended: MediaQuery.of(context)
                                                  .size
                                                  .width >
                                              966,
                                          padding: EdgeInsets.only(
                                              right: 20, left: 20),
                                          textInfoConstraints: BoxConstraints(
                                              maxWidth: 95, minWidth: 50),
                                        );
                                      })
                                  : Container();
                            }),
                          ),
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
                                      translate.albums,
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
                                            _folderListScrollController.offset -
                                                _folderButtonSize -
                                                14,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.ease,
                                          );
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
                                                        _folderButtonSize +
                                                        14,
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
                                      return Scrollbar(
                                        //thumbVisibility: true,
                                        scrollbarOrientation:
                                            ScrollbarOrientation.top,
                                        controller: _folderListScrollController,
                                        child: ScrollConfiguration(
                                          behavior:
                                              ScrollConfiguration.of(context)
                                                  .copyWith(
                                            dragDevices: {
                                              PointerDeviceKind.touch,
                                              PointerDeviceKind.mouse,
                                            },
                                          ),
                                          child: SingleChildScrollView(
                                              // shrinkWrap: true,
                                              physics: ClampingScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              controller:
                                                  _folderListScrollController,
                                              child: BlocBuilder<MediaCubit,
                                                  MediaState>(
                                                builder: (context, state) {
                                                  if (state
                                                          .objectsValueListenable !=
                                                      null)
                                                    return ValueListenableBuilder(
                                                        valueListenable: state
                                                            .objectsValueListenable!,
                                                        builder: (context,
                                                            Box<BaseObject> box,
                                                            widget) {
                                                          final foldersList = box
                                                              .values
                                                              .getSortedObjects(
                                                            parentFoldersId: [
                                                              state
                                                                  .rootMediaFolder
                                                                  .id
                                                            ],
                                                          );

                                                          if (foldersList.any(
                                                              (element) =>
                                                                  element
                                                                      .name ==
                                                                  'Media'))
                                                            foldersList.removeWhere(
                                                                (element) =>
                                                                    element
                                                                        .name ==
                                                                    'Media');

                                                          return Row(
                                                            children: [
                                                              ...foldersList
                                                                  .map(
                                                                    (album) =>
                                                                        _folderIcon(
                                                                      album
                                                                          as Folder,
                                                                      isChoosed: album
                                                                              .id ==
                                                                          state
                                                                              .currentFolder
                                                                              .id,
                                                                      blocContext:
                                                                          context,
                                                                      state:
                                                                          state,
                                                                    ),
                                                                  )
                                                                  .toList(),
                                                            ],
                                                          );
                                                        });
                                                  else
                                                    return Container();
                                                },
                                              )

                                              // children: [

                                              // ],
                                              ),
                                        ),
                                      );
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
                          child: BlocBuilder<MediaCubit, MediaState>(
                            builder: (context, state) {
                              return ContextMenuRightTap(
                                translate: translate,
                                theme: Theme.of(context),
                                contextAction: WhereFromContextMenu.media,
                                onTap: (action) {
                                  Navigator.of(context).pop();
                                  _contextMenuAction(state, context, action);
                                },
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    _pathSection(),
                                    ifGrid
                                        ? Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40),
                                            child: Divider(
                                              height: 1,
                                              color: Theme.of(context)
                                                  .dividerColor,
                                            ),
                                          )
                                        : Container(),
                                    BlocBuilder<MediaCubit, MediaState>(
                                      builder: (context, state) {
                                        return Expanded(
                                          child: state.representation ==
                                                  FilesRepresentation.grid
                                              ? state.progress == true
                                                  ? _filesGrid()
                                                  : _progressIndicator(context)
                                              : Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20),
                                                  child: _filesList(
                                                      context, state),
                                                ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pathSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 20, 30, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BlocBuilder<MediaCubit, MediaState>(
            builder: (context, state) {
              return Container(
                constraints: BoxConstraints(maxWidth: 200),
                child: Text(
                  state.currentFolder.name ?? ':(',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).focusColor,
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
          BlocBuilder<MediaCubit, MediaState>(builder: (context, state) {
            return GestureDetector(
              onTap: () {
                context.read<MediaCubit>().update();
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  width: 128,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/file_page/update.svg',
                        color: Theme.of(context).splashColor,
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          translate.update,
                          maxLines: 1,
                          style: TextStyle(
                            color: Theme.of(context).splashColor,
                            fontFamily: kNormalTextFontFamily,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          SizedBox(
            width: 6,
          ),
          BlocBuilder<MediaCubit, MediaState>(builder: (context, state) {
            return IconButton(
              padding: EdgeInsets.zero,
              iconSize: 30,
              onPressed: () {
                context
                    .read<MediaCubit>()
                    .changeRepresentation(FilesRepresentation.table);
              },
              icon: SvgPicture.asset('assets/file_page/list.svg',
                  color: state.representation == FilesRepresentation.table
                      ? Theme.of(context).splashColor
                      : Theme.of(context).toggleButtonsTheme.color),
            );
          }),
          BlocBuilder<MediaCubit, MediaState>(
            builder: (context, state) {
              return IconButton(
                iconSize: 30,
                onPressed: () {
                  context
                      .read<MediaCubit>()
                      .changeRepresentation(FilesRepresentation.grid);
                },
                icon: SvgPicture.asset('assets/file_page/block.svg',
                    // width: 30,
                    // height: 30,
                    //colorBlendMode: BlendMode.softLight,
                    color: state.representation == FilesRepresentation.grid
                        ? Theme.of(context).splashColor
                        : Theme.of(context).toggleButtonsTheme.color),
              );
            },
          ),
        ],
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

  Widget _folderIcon(
    Folder album, {
    required bool isChoosed,
    required BuildContext blocContext,
    required MediaState state,
  }) {
    Color activeColor;
    String icon = 'album';
    if (album.id == '-1') {
      activeColor = Color(0xFF868FFF);
    } else if (album.name == '????????' || album.name == 'Photos') {
      activeColor = Color(0xFF59D7AB);
      icon = 'photo';
    } else if (album.name == '??????????' || album.name == 'Video') {
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
          _searchingFieldController.clear();
          blocContext.read<MediaCubit>().changeFolder(album);

          final mediaAlbumId = state.currentFolder.id;

          StateContainer.of(context)
              .changeChoosedMediaFolderId(album.id == '-1' ? null : album.id);
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
    var cubit = context.read<MediaCubit>();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return MediaOpenPage(
            arguments: MediaOpenPageArgs(
              media: media,
              selectedMedia: selectedMedia,
              selectedFolder: openedFolder,
              mediaCubit: cubit,
            ),
          );
        });
  }

  _contextMenuAction(
    MediaState state,
    BuildContext context,
    ContextMenuAction action,
  ) async {
    switch (action) {
      case ContextMenuAction.addFiles:
        final folderId = StateContainer.of(context).choosedMediaFolderId;
        context.read<MediaCubit>().uploadMediaAction(folderId);
        break;
      case ContextMenuAction.createFolder:
        var albumName = await showDialog<String?>(
            context: context,
            builder: (BuildContext context) {
              return BlurCreateAlbum();
            });
        if (albumName != null) {
          context.read<MediaCubit>().createAlbum(albumName);
        }

        break;
      default:
    }
  }

  Widget _filesGrid() {
    return BlocBuilder<MediaCubit, MediaState>(
      builder: (blocContext, state) {
        return LayoutBuilder(builder: (layoutContext, constrains) {
          // print('min width ${constrains.smallest.width}');

          if (state.objectsValueListenable != null)
            return ValueListenableBuilder(
                valueListenable: state.objectsValueListenable!,
                builder: (context, Box<BaseObject> box, widget) {
                  // Map<DateTime, List<BaseObject>> media = {};
                  // if (state.foldersToListen == [])
                  //   media = box.values.getObjectsSortedByTime(
                  //     parentFolderId: state.currentFolder.id,
                  //     direction: SortingDirection.down,
                  //   );
                  // else

                  var media = box.values.getSortedObjects(
                      parentFoldersId: state.foldersToListen!,
                      direction: SortingDirection.down,
                      sortingText: state.searchText);

                  var mediaList = media.reversed.toList();

                  return Container(
                    // padding: EdgeInsets.symmetric(horizontal: 40),
                    child: GridView.builder(
                      itemCount: mediaList.length,
                      shrinkWrap: true,
                      controller: ScrollController(),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: constrains.smallest.width ~/ 110,
                        childAspectRatio: (1 / 1.22),
                        mainAxisSpacing: 15,
                      ),
                      itemBuilder: (context, index) {
                        var record = mediaList[index];

                        if (mediaList.length != _popupControllers.length) {
                          final controller = CustomPopupMenuController();
                          _popupControllers.add(controller);
                        }

                        _onPointerDown() {
                          _popupControllers[mediaList.indexOf(record)]
                              .showMenu();
                        }

                        return MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onSecondaryTapUp: (_) {
                                  _onPointerDown();
                                },
                                onTap: () {
                                  _onTapItem(state.currentFolderRecords, record,
                                      context, state.currentFolder);
                                },
                                child: IgnorePointer(
                                  child: CustomPopupMenu(
                                      pressType: PressType.singleClick,
                                      barrierColor: Colors.transparent,
                                      showArrow: false,
                                      enablePassEvent: false,
                                      horizontalMargin: 110,
                                      verticalMargin: 0,
                                      controller: _popupControllers[
                                          mediaList.indexOf(record)],
                                      menuBuilder: () {
                                        return MediaPopupMenuActions(
                                            theme: Theme.of(context),
                                            translate: translate,
                                            onTap: (action) async {
                                              _popupControllers[
                                                      mediaList.indexOf(record)]
                                                  .hideMenu();
                                              onActionTap(context, action,
                                                  state, record as Record);
                                            });
                                      },
                                      child: MediaGridElement(
                                          record: record as Record)),
                                )));
                      },
                    ),
                  );
                });
          else
            return Container();
        });
      },
    );
  }

  _popupActions(MediaState state, BuildContext context, FileAction action,
      Record object) async {
    if (action.name == "properties") {
      var res = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return FileInfoView(
                object: object, user: state.valueNotifier?.value);
          });
      if (res != null) {
        context.read<MediaCubit>().fileTapped(object);
      }
    } else if (action.name == "rename") {
      var fileExtention = FileAttribute().getFileExtension(object.name ?? '');
      var result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          var filename = FileAttribute().getFileName(object.name ?? '');
          return BlurRename(filename, true);
        },
      );
      if (result != null &&
          result is String &&
          result != FileAttribute().getFileName(object.name ?? '')) {
        result = result + '.' + fileExtention;
        final res = await context
            .read<MediaCubit>()
            .onActionRenameChosen(object, result);
        if (res == ErrorType.alreadyExist) {
          _rename(context, object, result, fileExtention);
        }
      }
    } else {
      //   controller.hideMenu();
      var result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return BlurDelete();
        },
      );
      if (result == true) {
        context.read<MediaCubit>().onActionDeleteChosen(object);
      }
    }
  }

  void _rename(BuildContext context, BaseObject record, String name,
      String extention) async {
    String newName = await showDialog(
      context: context,
      builder: (BuildContext context) {
        var filename = FileAttribute().getFileName(name);
        return BlurRename(filename, false);
      },
    );
    if (newName != FileAttribute().getFileName(record.name ?? '')) {
      newName = newName + '.' + extention;
      final res = await context
          .read<MediaCubit>()
          .onActionRenameChosen(record, newName);
      if (res == ErrorType.alreadyExist) {
        _rename(context, record, newName, extention);
      }
    }
  }

  void onActionTap(BuildContext context, MediaAction action, MediaState state,
      Record record) async {
    // _popupControllers[state.currentFolderRecords.indexOf(record)].hideMenu();
    if (action == MediaAction.properties) {
      var res = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return FileInfoView(
                object: record, user: state.valueNotifier?.value);
          });
      if (res != null) {
        context.read<MediaCubit>().fileTapped(record);
      }
    } else if (action == MediaAction.rename) {
      var fileExtention = FileAttribute().getFileExtension(record.name ?? '');
      var result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          var filename = FileAttribute().getFileName(record.name ?? '');
          return BlurRename(filename, true);
        },
      );
      if (result != null &&
          result is String &&
          result != FileAttribute().getFileName(record.name ?? '')) {
        result = result + '.' + fileExtention;
        final res = await context
            .read<MediaCubit>()
            .onActionRenameChosen(record, result);
        if (res == ErrorType.alreadyExist) {
          _rename(context, record, result, fileExtention);
        }
      }
    } else if (action == MediaAction.delete) {
      var result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return BlurDelete();
        },
      );
      if (result == true) {
        context.read<MediaCubit>().onActionDeleteChosen(record);
      }
    } else if (action == MediaAction.save) {
      context.read<MediaCubit>().saveFile(record);
    }
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
          if (state.objectsValueListenable != null)
            return ValueListenableBuilder(
                valueListenable: state.objectsValueListenable!,
                builder: (context, Box<BaseObject> box, widget) {
                  // Map<DateTime, List<BaseObject>> media = {};
                  // if (state.foldersToListen == [])
                  //   media = box.values.getObjectsSortedByTime(
                  //     parentFolderId: state.currentFolder.id,
                  //     direction: SortingDirection.down,
                  //   );
                  // else

                  var media = box.values.getSortedObjects(
                      parentFoldersId: state.foldersToListen!,
                      direction: SortingDirection.down,
                      sortingText: state.searchText);

                  var mediaList = media.reversed.toList();
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: ScrollController(),
                    child: Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: DataTable(
                        columnSpacing: 0,
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
                              width: constraints.maxWidth * 0.15,
                              child: Text(
                                translate.format,
                                style: style,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Container(
                              width: constraints.maxWidth * 0.15,
                              child: Text(
                                translate.date,
                                style: style,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Container(
                              width: constraints.maxWidth * 0.1,
                              child: Text(
                                translate.size,
                                style: style,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Container(
                              width: constraints.maxWidth * 0.1,
                              child: SizedBox(
                                width: constraints.maxWidth * 0.1,
                              ),
                            ),
                          ),
                        ],
                        rows: mediaList.map((e) {
                          String? type = '';
                          bool isFile = false;
                          if (mediaList.length > _popupControllers.length) {
                            _popupControllers = [];
                            _initiatingControllers(state);
                          }

                          var record = e as Record;
                          isFile = true;
                          if (record.thumbnail != null &&
                              record.thumbnail!.isNotEmpty) {
                            type = FileAttribute()
                                .getFilesType(record.name!.toLowerCase());
                          }

                          return DataRow.byIndex(
                            index: mediaList.indexOf(e),
                            color: MaterialStateProperty.resolveWith<Color?>(
                                (states) {
                              print(states.toList().toString());
                              if (states.contains(MaterialState.focused)) {
                                return Theme.of(context).splashColor;
                              }
                              return null;
                            }),
                            cells: [
                              DataCell(
                                ContextMenuArea(
                                  builder: (contextArea) => [
                                    FilesPopupMenuActionsMedia(
                                      object: record,
                                      onTap: (action) {
                                        Navigator.of(contextArea).pop();
                                        _popupActions(
                                            state, context, action, record);
                                      },
                                      theme: Theme.of(context),
                                      translate: translate,
                                    )
                                  ],
                                  child: GestureDetector(
                                    onTap: () {
                                      _onTapItem(mediaList, record, context,
                                          state.currentFolder);
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
                                            child: Container(
                                              width: constraints.maxWidth * 0.3,
                                              child: Text(
                                                e.name ?? '',
                                                style: cellTextStyle,
                                                overflow: TextOverflow.ellipsis,
                                              ),
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
                              ),
                              DataCell(
                                Text(
                                  type.isEmpty
                                      ? translate.foldr
                                      : type.toUpperCase(),
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
                                    controller:
                                        _popupControllers[mediaList.indexOf(e)],
                                    menuBuilder: () {
                                      return MediaPopupMenuActions(
                                          theme: Theme.of(context),
                                          translate: translate,
                                          onTap: (action) async {
                                            _popupControllers[
                                                    mediaList.indexOf(e)]
                                                .hideMenu();
                                            if (action ==
                                                MediaAction.properties) {
                                              var res = await showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return FileInfoView(
                                                        object: e,
                                                        user: state
                                                            .valueNotifier
                                                            ?.value);
                                                  });
                                              if (res != null) {
                                                context
                                                    .read<MediaCubit>()
                                                    .fileTapped(e);
                                              }
                                            } else if (action ==
                                                MediaAction.rename) {
                                              var fileExtention =
                                                  FileAttribute()
                                                      .getFileExtension(
                                                          record.name ?? '');
                                              var result = await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  var filename = FileAttribute()
                                                      .getFileName(
                                                          record.name ?? '');
                                                  return BlurRename(
                                                      filename, true);
                                                },
                                              );
                                              if (result != null &&
                                                  result is String &&
                                                  result !=
                                                      FileAttribute()
                                                          .getFileName(
                                                              record.name ??
                                                                  '')) {
                                                result = result +
                                                    '.' +
                                                    fileExtention;
                                                final res = await context
                                                    .read<MediaCubit>()
                                                    .onActionRenameChosen(
                                                        record, result);
                                                if (res ==
                                                    ErrorType.alreadyExist) {
                                                  _rename(context, record,
                                                      result, fileExtention);
                                                }
                                              }
                                            } else {
                                              //   controller.hideMenu();
                                              var result =
                                                  await showDialog<bool>(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return BlurDelete();
                                                },
                                              );
                                              if (result == true) {
                                                context
                                                    .read<MediaCubit>()
                                                    .onActionDeleteChosen(e);
                                              }
                                            }
                                          });
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                  );
                });
          else
            return Container();
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
    var imageUrl = record.thumbnail?.first.publicUrl;
    Widget image;
    if (imageUrl != null && imageUrl.isURL()) {
      image = Image.network(
        record.thumbnail!.first.publicUrl!,
        height: 100,
        fit: BoxFit.fitHeight,
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
            Container(
              height: 67,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: image,
              ),
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
          maxLines: 2,
          style: TextStyle(
            color: Theme.of(context).disabledColor,
            fontFamily: kNormalTextFontFamily,
            fontSize: 14,
            // height: 1.1,
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
                    widget.onTap(MediaAction.rename);
                  },
                  child: MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        ind = 3;
                      });
                    },
                    child: Container(
                      width: 190,
                      height: 40,
                      color: ind == 3 ? mainColor : null,
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
                            'assets/options/rename.svg',
                            height: 20,
                          ),
                          Container(
                            width: 15,
                          ),
                          Text(
                            widget.translate.rename,
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
                    widget.onTap(MediaAction.save);
                  },
                  child: MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        ind = 6;
                      });
                    },
                    child: Container(
                      width: 190,
                      height: 40,
                      color: ind == 6 ? mainColor : null,
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
                            'assets/options/download.svg',
                            height: 20,
                          ),
                          Container(
                            width: 15,
                          ),
                          Text(
                            widget.translate.download,
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

class FilesPopupMenuActionsMedia extends StatefulWidget {
  FilesPopupMenuActionsMedia(
      {required this.theme,
      required this.translate,
      required this.onTap,
      required this.object,
      Key? key})
      : super(key: key);

  final ThemeData theme;
  final S translate;
  final Function(FileAction) onTap;
  final BaseObject object;

  @override
  _FilesPopupMenuActionsState createState() => _FilesPopupMenuActionsState();
}

class _FilesPopupMenuActionsState extends State<FilesPopupMenuActionsMedia> {
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
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
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
                widget.object is Folder
                    ? GestureDetector(
                        onTap: () {
                          widget.onTap(FileAction.addFiles);
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
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/options/add_files.svg',
                                  height: 20,
                                ),
                                Container(
                                  width: 15,
                                ),
                                Text(
                                  widget.translate.add_files,
                                  style: style,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Divider(
                  color: mainColor,
                  height: 1,
                ),
                // GestureDetector(
                //   onTap: () {
                //     widget.onTap(FileAction.move);
                //   },
                //   child: MouseRegion(
                //     onEnter: (event) {
                //       setState(() {
                //         ind = 1;
                //       });
                //     },
                //     child: Container(
                //       width: 190,
                //       height: 40,
                //       color: ind == 1 ? mainColor : null,
                //       padding: EdgeInsets.symmetric(horizontal: 15),
                //       child: Row(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           // Image.asset(
                //           //   'assets/file_page/file_options/move.png',
                //           //   height: 20,
                //           // ),
                //           SvgPicture.asset(
                //             'assets/options/folder.svg',
                //             height: 20,
                //           ),
                //           Container(
                //             width: 15,
                //           ),
                //           Text(
                //             widget.translate.move,
                //             style: style,
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                // Divider(
                //   color: mainColor,
                //   height: 1,
                // ),
                // GestureDetector(
                //   onTap: () {
                //     widget.onTap(FileAction.save);
                //   },
                //   child: MouseRegion(
                //     onEnter: (event) {
                //       setState(() {
                //         ind = 2;
                //       });
                //     },
                //     child: Container(
                //       width: 190,
                //       height: 40,
                //       color: ind == 2 ? mainColor : null,
                //       padding: EdgeInsets.symmetric(horizontal: 15),
                //       child: Row(
                //         crossAxisAlignment: CrossAxisAlignment.center,
                //         children: [
                //           // Image.asset(
                //           //   'assets/file_page/file_options/download.png',
                //           //   height: 20,
                //           // ),
                //           SvgPicture.asset(
                //             'assets/options/download.svg',
                //             height: 20,
                //           ),
                //           Container(
                //             width: 15,
                //           ),
                //           Text(
                //             widget.translate.down,
                //             style: style,
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                Divider(
                  color: mainColor,
                  height: 1,
                ),
                GestureDetector(
                  onTap: () {
                    widget.onTap(FileAction.rename);
                  },
                  child: MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        ind = 3;
                      });
                    },
                    child: Container(
                      width: 190,
                      height: 40,
                      color: ind == 3 ? mainColor : null,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      margin: EdgeInsets.zero,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/options/rename.svg',
                            height: 20,
                          ),
                          Container(
                            width: 15,
                          ),
                          Text(
                            widget.translate.rename,
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
                    widget.onTap(FileAction.properties);
                  },
                  child: MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        ind = 4;
                      });
                    },
                    child: Container(
                      width: 190,
                      height: 40,
                      color: ind == 4 ? mainColor : null,
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
                    widget.onTap(FileAction.delete);
                  },
                  child: MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        ind = 5;
                      });
                    },
                    child: Container(
                      width: 190,
                      height: 40,
                      color: ind == 5
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
