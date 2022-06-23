import 'dart:async';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
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
import 'package:intl/intl.dart';
import 'package:storageup/components/blur/custom_error_popup.dart';
import 'package:storageup/components/blur/delete.dart';
import 'package:storageup/components/blur/rename.dart';
import 'package:storageup/components/properties.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/pages/files/models/sorting_element.dart';
import 'package:storageup/pages/files/opened_folder/opened_folder_cubit.dart';
import 'package:storageup/pages/files/opened_folder/opened_folder_state.dart';
import 'package:storageup/utilities/extensions.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/state_containers/state_container.dart';
import 'package:storageup/utilities/state_containers/state_sorted_container.dart';

class OpenedFolderView extends StatefulWidget {
  OpenedFolderView({
    Key? key,
    required this.currentFolder,
    required this.previousFolders,
    required this.pop,
    required this.push,
  }) : super(key: key);

  final Folder? currentFolder;
  final List<Folder> previousFolders;
  final void Function({
    required OpenedFolderView child,
    required String? folderId,
  }) push;
  final Function(int) pop;

  @override
  _OpenedFolderViewState createState() => _OpenedFolderViewState();
}

class _OpenedFolderViewState extends State<OpenedFolderView>
    with TickerProviderStateMixin {
  S translate = getIt<S>();
  SortingDirection _direction = SortingDirection.down;
  var _bloc = OpenedFolderCubit();
  List<CustomPopupMenuController> _popupControllers = [];
  List<CustomPopupMenuController> _popupControllersGrouped = [];
  Timer? timerForOpenFile;
  int _startTimer = 1;
  var _indexObject = -1;

  void _initiatingControllers(OpenedFolderState state) {
    if (_popupControllers.isEmpty) {
      state.sortedFiles.forEach((element) {
        _popupControllers.add(CustomPopupMenuController());
      });
    }
  }

  void _initiatingControllersForGroupedFiles(OpenedFolderState state) {
    if (_popupControllersGrouped.isEmpty) {
      state.objects.forEach((element) {
        _popupControllersGrouped.add(CustomPopupMenuController());
      });
    }
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
    return BlocProvider(
      create: (context) => _bloc
        ..init(
          widget.currentFolder,
          widget.previousFolders,
        ),
      child: BlocListener<OpenedFolderCubit, OpenedFolderState>(
        listener: (context, state) async {
          if (StateContainer.of(context).isPopUpShowing == false) {
            if (state.status == FormzStatus.submissionFailure) {
              StateContainer.of(context).changeIsPopUpShowing(true);
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BlurCustomErrorPopUp(
                    middleText: translate.something_goes_wrong,
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
        child: Positioned.fill(
          child: Container(
            margin: EdgeInsets.only(top: 30),
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
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: BlocBuilder<OpenedFolderCubit, OpenedFolderState>(
              builder: (context, state) {
                return ContextMenuRightTap(
                  translate: translate,
                  onTap: (action) {
                    Navigator.of(context).pop();
                    _contextAction(state, context, action);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _pathSection(),
                      Divider(
                        color: Theme.of(context).dividerColor,
                      ),
                      state.progress == true
                          ? _filesSection()
                          : _progressIndicator(context),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _progressIndicator(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.9,
      child: Center(
        child: CupertinoActivityIndicator(
          animating: true,
        ),
      ),
    );
  }

  Widget _pathSection() {
    return BlocBuilder<OpenedFolderCubit, OpenedFolderState>(
      bloc: _bloc,
      builder: (context, state) {
        _initiatingControllers(state);
        _initiatingControllersForGroupedFiles(state);
        return Row(
          // crossAxisAlignment: CrossAxisAlignment.baseline,
          // textBaseline: TextBaseline.alphabetic,
          children: [
            // ListView(
            //   shrinkWrap: true,
            //   controller: ScrollController(),
            //   scrollDirection: Axis.horizontal,
            //   physics: ClampingScrollPhysics(),
            //   children: [
            _pathRow(state.previousFolders, state.currentFolder),
            //   ],
            // ),
            Spacer(),
            GestureDetector(
              onTap: () {
                context.read<OpenedFolderCubit>().update();
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  width: 128,
                  height: 34,
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
                        padding: const EdgeInsets.only(top: 0.0),
                        child: Text(
                          translate.update,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          style: TextStyle(
                            color: Theme.of(context).splashColor,
                            fontFamily: kNormalTextFontFamily,
                            height: 1.5,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            StateSortedContainer.of(context).sortedActionButton
                ? IconButton(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    iconSize: 30,
                    onPressed: () {
                      if (_direction == SortingDirection.down) {
                        _direction = SortingDirection.up;
                        StateSortedContainer.of(context)
                            .newSortedDirection(_direction);
                      } else {
                        _direction = SortingDirection.down;
                        StateSortedContainer.of(context)
                            .newSortedDirection(_direction);
                      }
                    },
                    icon: SvgPicture.asset(
                      'assets/file_page/arrows_${StateSortedContainer.of(context).direction.toString().split('.').last}.svg',
                    ),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: IconButton(
                padding: EdgeInsets.zero,
                iconSize: 30,
                onPressed: () {
                  context
                      .read<OpenedFolderCubit>()
                      .changeRepresentation(FilesRepresentation.table);
                },
                icon: SvgPicture.asset(
                  'assets/file_page/list.svg',
                  color: state.representation == FilesRepresentation.table
                      ? Theme.of(context).splashColor
                      : Theme.of(context).toggleButtonsTheme.color,
                ),
              ),
            ),
            IconButton(
              iconSize: 30,
              onPressed: () {
                context
                    .read<OpenedFolderCubit>()
                    .changeRepresentation(FilesRepresentation.grid);
              },
              icon: SvgPicture.asset(
                'assets/file_page/block.svg',
                color: state.representation == FilesRepresentation.grid
                    ? Theme.of(context).splashColor
                    : Theme.of(context).toggleButtonsTheme.color,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _filesSection() {
    return BlocBuilder<OpenedFolderCubit, OpenedFolderState>(
      bloc: _bloc,
      builder: (context, state) {
        var searchText = StateSortedContainer.of(context).search;
        var sortedCriterion = StateSortedContainer.of(context).sortedCriterion;
        var direction = StateSortedContainer.of(context).direction;
        context.read<OpenedFolderCubit>()
          ..setNewCriterionAndDirection(sortedCriterion, direction, searchText)
          ..mapFileSortingByCriterion();
        if (state.representation == FilesRepresentation.grid) {
          return state.criterion == SortingCriterion.byType
              ? _filesGridForType(state)
              : _filesGrid(state);
        } else {
          return state.criterion == SortingCriterion.byType
              ? _filesListSortType(context, state)
              : _filesList(context, state);
        }
      },
    );
  }

  Widget _pathRow(List<Folder> folders, Folder? currentFolder) {
    List<Widget> path = [];
    List<Folder?> allPath = [...folders];
    allPath.add(currentFolder);

    var textStyle = TextStyle(
      color: Theme.of(context).colorScheme.onBackground,
      fontFamily: kNormalTextFontFamily,
      fontSize: 20,
    );
    for (var i = 0; i < allPath.length; i++) {
      var countOfPop = allPath.length - 1 - i;
      Widget pathWidget = GestureDetector(
        onTap: allPath.length == 1 || i == allPath.length - 1
            ? null
            : () {
                widget.pop(countOfPop);
              },
        child: MouseRegion(
          cursor: allPath.length == 0 || i == allPath.length - 1
              ? SystemMouseCursors.basic
              : SystemMouseCursors.click,
          child: Container(
            constraints: BoxConstraints(maxWidth: 120),
            child: Text(
              i == 0 ? translate.files : allPath[i]!.name!,
              overflow: TextOverflow.ellipsis,
              style: i == allPath.length - 1
                  ? textStyle.copyWith(
                      color: Theme.of(context).textTheme.headline2?.color)
                  : textStyle,
            ),
          ),
        ),
      );

      path.add(pathWidget);

      if (i != allPath.length - 1) {
        var seporator = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '/',
            style: textStyle,
          ),
        );

        path.add(seporator);
      }
    }
    return Row(
      textBaseline: TextBaseline.alphabetic,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: path,
    );
  }

  Widget _filesGrid(OpenedFolderState state) {
    return Expanded(
      child: LayoutBuilder(builder: (context, constrains) {
        //print('min width ${constrains.smallest.width}');

        return Container(
            child: BlocBuilder<OpenedFolderCubit, OpenedFolderState>(
                bloc: _bloc,
                builder: (context, state) {
                  return GridView.builder(
                    itemCount: state.sortedFiles.length,
                    shrinkWrap: true,
                    controller: ScrollController(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: constrains.smallest.width ~/ 110,
                      childAspectRatio: (1 / 1.22),
                      mainAxisSpacing: 15,
                    ),
                    itemBuilder: (context, index) {
                      Function() onTap;
                      var obj = state.sortedFiles[index];

                      // if (state.sortedFiles.length !=
                      // _popupControllers.length) {
                      // _popupControllers = [];
                      // _initiatingControllers(state);
                      // }
                      if (state.sortedFiles.length !=
                          _popupControllers.length) {
                        final controller = CustomPopupMenuController();
                        _popupControllers.add(controller);
                      }
                      _onPointerDown() {
                        _popupControllers[state.sortedFiles.indexOf(obj)]
                            .showMenu();
                        //controller.showMenu();
                      }

                      if (obj is Folder) {
                        onTap = () {
                          print(obj);
                          widget.push(
                            child: OpenedFolderView(
                              currentFolder: obj,
                              previousFolders: [
                                ...state.previousFolders,
                                state.currentFolder!
                              ],
                              pop: widget.pop,
                              push: widget.push,
                            ),
                            folderId: obj.id,
                          );
                        };
                      } else {
                        onTap = () {
                          if (_indexObject != index) {
                            setState(() {
                              _indexObject = index;
                            });
                            print('file tapped');
                            startTimer();
                            context
                                .read<OpenedFolderCubit>()
                                .fileTapped(obj as Record);
                          }
                        };
                      }

                      return MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onSecondaryTapDown: (_) {
                              _onPointerDown();
                            },
                            onTap: onTap,
                            child: IgnorePointer(
                              child: CustomPopupMenu(
                                  pressType: PressType.singleClick,
                                  barrierColor: Colors.transparent,
                                  showArrow: false,
                                  enablePassEvent: false,
                                  horizontalMargin: -90,
                                  verticalMargin: -90,
                                  controller: _popupControllers[
                                      state.sortedFiles.indexOf(obj)],
                                  menuBuilder: () {
                                    return FilesPopupMenuActions(
                                      theme: Theme.of(context),
                                      translate: translate,
                                      object: obj,
                                      onTap: (action) async {
                                        _popupControllers[
                                                state.sortedFiles.indexOf(obj)]
                                            .hideMenu();
                                        _popupActions(
                                            state, context, action, obj);
                                      },
                                    );
                                  },
                                  child: ObjectView(
                                      object: state.sortedFiles[index])),
                            ),
                          ));
                      //folderId: obj.id,
                    },
                  );
                }));
      }),
    );
  }

  void _renameFile(
    BuildContext context,
    BaseObject record,
    String name,
    String extension,
  ) async {
    String newName = await showDialog(
      context: context,
      builder: (BuildContext context) {
        var filename = FileAttribute().getFileName(name);
        return BlurRename(filename, false);
      },
    );
    if (newName != FileAttribute().getFileName(record.name ?? '')) {
      newName += '.$extension';
      final res = await context
          .read<OpenedFolderCubit>()
          .onActionRenameChosenFile(record, newName);
      if (res == ErrorType.alreadyExist) {
        _renameFile(
          context,
          record,
          newName,
          extension,
        );
      }
    }
  }

  void _renameFolder(
    BuildContext context,
    BaseObject folder,
    String name,
  ) async {
    String newName = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlurRename(name, false);
      },
    );
    if (newName != folder.name) {
      final res = await context
          .read<OpenedFolderCubit>()
          .onActionRenameChosenFolder(folder, newName);
      if (res == ErrorType.alreadyExist) {
        _renameFolder(context, folder, newName);
      }
    }
  }

  List<GridElement> _gridList(
      OpenedFolderState state, BoxConstraints constrains) {
    print(state.sortedFiles.length);
    print(_popupControllersGrouped.length);
    List<GridElement> grids = [];
    state.groupedFiles.forEach((key, value) {
      grids.add(
        GridElement(
            grid: GridView.builder(
              scrollDirection: Axis.vertical,
              itemCount: value.length,
              primary: false,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: constrains.smallest.width ~/ 113.5,
                childAspectRatio: (1 / 1.1),
              ),
              itemBuilder: (context, index) {
                List<BaseObject> files = value;

                Function() onTap;
                var obj = value[index];

                if (state.objects.length != _popupControllersGrouped.length) {
                  _popupControllersGrouped = [];
                  _initiatingControllersForGroupedFiles(state);
                }

                Future<void> _onPointerDown(PointerDownEvent event) async {
                  if (event.kind == PointerDeviceKind.mouse &&
                      event.buttons == kSecondaryMouseButton) {
                    //print("right button click");
                    _popupControllersGrouped[state.sortedFiles
                            .indexWhere((element) => element.id == obj.id)]
                        .showMenu();
                  }
                }

                final object = files[index];

                if (object is Folder) {
                  onTap = () {
                    print(obj);
                    widget.push(
                      child: OpenedFolderView(
                        currentFolder: object,
                        previousFolders: [
                          ...state.previousFolders,
                          state.currentFolder!,
                        ],
                        pop: widget.pop,
                        push: widget.push,
                      ),
                      folderId: obj.id,
                    );
                  };
                } else {
                  onTap = () {
                    if (_indexObject != index) {
                      setState(() {
                        _indexObject = index;
                      });
                      print('file tapped');
                      startTimer();
                      context
                          .read<OpenedFolderCubit>()
                          .fileTapped(obj as Record);
                    }
                  };
                }
                return MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onTap,
                    child: Listener(
                      onPointerDown: _onPointerDown,
                      behavior: HitTestBehavior.opaque,
                      child: IgnorePointer(
                        child: CustomPopupMenu(
                            pressType: PressType.singleClick,
                            barrierColor: Colors.transparent,
                            showArrow: false,
                            enablePassEvent: false,
                            horizontalMargin: -90,
                            verticalMargin: -90,
                            controller: _popupControllersGrouped[state.objects
                                .indexWhere((element) => element.id == obj.id)],
                            menuBuilder: () {
                              return FilesPopupMenuActions(
                                  theme: Theme.of(context),
                                  translate: translate,
                                  object: obj,
                                  onTap: (action) async {
                                    _popupControllersGrouped[state.objects
                                            .indexWhere((element) =>
                                                element.id == obj.id)]
                                        .hideMenu();
                                    _popupActions(state, context, action, obj);
                                  });
                            },
                            child: ObjectView(object: value[index])),
                      ),
                    ),
                  ),
                );
              },
            ),
            type: key),
      );
    });
    return grids;
  }

  Widget _filesGridForType(OpenedFolderState state) {
    return Expanded(
      child: LayoutBuilder(builder: (context, constrains) {
        var grids = _gridList(state, constrains);

        return ListView(
          scrollDirection: Axis.vertical,
          controller: ScrollController(),
          // physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: List.generate(grids.length, (index) {
            String type = grids[index].type;
            switch (type) {
              case 'folder':
                type = translate.folder_dir;
                break;
              case 'jpg':
                type = translate.photos;
                break;
              case 'txt':
                type = translate.documents;
                break;
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 0.0),
                  child: Container(
                    width: double.infinity,
                    child: Text(
                      type,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Theme.of(context).disabledColor,
                        fontSize: 18,
                        fontFamily: kNormalTextFontFamily,
                      ),
                    ),
                  ),
                ),
                grids[index].grid,
                Divider(
                  height: 1.0,
                  color: Theme.of(context).colorScheme.onSecondary,
                )
              ],
            );
          }),
        );
      }),
    );
  }

  Color _getDataRowColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
      MaterialState.error,
      MaterialState.scrolledUnder,
      MaterialState.selected,
    };

    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    //return Colors.green; // Use the default value.
    return Colors.transparent;
  }

  Widget _filesList(BuildContext context, OpenedFolderState state) {
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

    return BlocBuilder<OpenedFolderCubit, OpenedFolderState>(
      bloc: _bloc,
      builder: (context, state) {
        return Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: ScrollController(),
              child: DataTable(
                columnSpacing: 0,
                dataRowColor:
                    MaterialStateProperty.resolveWith<Color?>(_getDataRowColor),
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
                rows: state.sortedFiles.map((element) {
                  String? type = '';
                  bool isFile = false;
                  if (element is Record) {
                    var record = element;
                    isFile = true;
                    if (record.thumbnail != null &&
                        record.thumbnail!.isNotEmpty) {
                      type = FileAttribute()
                          .getFilesType(record.name!.toLowerCase());
                    }
                  }

                  return DataRow.byIndex(
                    index: state.sortedFiles.indexOf(element),
                    color: MaterialStateProperty.resolveWith<Color?>((states) {
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
                            // if (StateInfoContainer.of(context)?.open == true) {

                            // }
                            var index = state.sortedFiles.indexOf(element);
                            if (element is Folder) {
                              print(element);
                              print("lol");

                              widget.push(
                                child: OpenedFolderView(
                                  currentFolder: element,
                                  previousFolders: [
                                    ...state.previousFolders,
                                    state.currentFolder!
                                  ],
                                  pop: widget.pop,
                                  push: widget.push,
                                ),
                                folderId: element.id,
                              );
                              context
                                  .read<OpenedFolderCubit>()
                                  .changeRepresentation(
                                      FilesRepresentation.table);
                            } else {
                              if (_indexObject != index) {
                                setState(() {
                                  _indexObject = index;
                                });
                                print('file tapped');
                                startTimer();
                                context
                                    .read<OpenedFolderCubit>()
                                    .fileTapped(element as Record);
                              }
                              print('file tapped');
                            }
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  children: [
                                    Image.asset(
                                      isFile
                                          ? type.isNotEmpty
                                              ? 'assets/file_icons/${type}_s.png'
                                              : 'assets/file_icons/unexpected_s.png'
                                          : 'assets/file_icons/folder.png',
                                      fit: BoxFit.contain,
                                      height: 24,
                                      width: 24,
                                    ),
                                    ...isFile &&
                                            (element as Record).loadPercent !=
                                                null
                                        ? _uploadProgress(element.loadPercent)
                                        : [],
                                  ],
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Container(
                                    width: constraints.maxWidth * 0.3,
                                    child: Text(
                                      element.name ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: cellTextStyle,
                                    ),
                                  ),
                                ),
                                // Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: BlocBuilder<OpenedFolderCubit,
                                      OpenedFolderState>(
                                    bloc: _bloc,
                                    builder: (context, state) {
                                      return GestureDetector(
                                        onTap: () {
                                          context
                                              .read<OpenedFolderCubit>()
                                              .setFavorite(element);
                                        },
                                        child: Image.asset(
                                          element.favorite
                                              ? 'assets/file_page/favorite.png'
                                              : 'assets/file_page/not_favorite.png',
                                          height: 18,
                                          width: 18,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      DataCell(
                        Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(
                            type.isEmpty ? translate.foldr : type.toUpperCase(),
                            overflow: TextOverflow.ellipsis,
                            style: cellTextStyle,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          DateFormat('dd.MM.yyyy').format(element.createdAt!),
                          style: cellTextStyle,
                        ),
                      ),
                      DataCell(
                        Text(
                          fileSize(element.size, translate, 1),
                          maxLines: 1,
                          style: cellTextStyle,
                        ),
                      ),
                      DataCell(
                        Theme(
                          data: Theme.of(context).copyWith(
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                          ),
                          child:
                              BlocBuilder<OpenedFolderCubit, OpenedFolderState>(
                            bloc: _bloc,
                            builder: (context, snapshot) {
                              if (state.sortedFiles.length >
                                  _popupControllers.length) {
                                _popupControllers = [];
                                _initiatingControllers(state);
                              }
                              return CustomPopupMenu(
                                pressType: PressType.singleClick,
                                barrierColor: Colors.transparent,
                                showArrow: false,
                                horizontalMargin: 110,
                                verticalMargin: 0,
                                controller: _popupControllers[
                                    state.sortedFiles.indexOf(element)],
                                menuBuilder: () {
                                  return FilesPopupMenuActions(
                                      theme: Theme.of(context),
                                      translate: translate,
                                      object: element,
                                      onTap: (action) async {
                                        _popupControllers[state.sortedFiles
                                                .indexOf(element)]
                                            .hideMenu();
                                        _popupActions(
                                            state, context, action, element);
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
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            );
          }),
        );
      },
    );
  }

  List<Widget> _uploadProgress(double? progress) {
    List<Widget> indicators = [Container()];
    if (progress != null) {
      print('creating indicators with progress: $progress');
      indicators = [
        SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            value: progress / 100,
          ),
        ),
        SizedBox(
          height: 24,
          width: 24,
          child: CupertinoActivityIndicator(
            animating: true,
          ),
        ),
      ];
    }
    return indicators;
  }

  Widget _filesListSortType(BuildContext context, OpenedFolderState state) {
    TextStyle style = TextStyle(
      color: Theme.of(context).textTheme.subtitle1?.color,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      fontFamily: kNormalTextFontFamily,
    );

    return BlocBuilder<OpenedFolderCubit, OpenedFolderState>(
      bloc: _bloc,
      builder: (context, state) {
        return Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: ScrollController(),
              child: DataTable(
                  decoration: BoxDecoration(
                    //color: Colors.grey.shade100,

                    borderRadius: BorderRadius.circular(20),
                  ),
                  showBottomBorder: false,
                  columnSpacing: 0,
                  dataRowColor: MaterialStateProperty.resolveWith<Color?>(
                      _getDataRowColor),
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
                  rows: _buildGroupedFiles(state, constraints, context)),
            );
          }),
        );
      },
    );
  }

  List<DataRow> _buildGroupedFiles(OpenedFolderState state,
      BoxConstraints constraints, BuildContext context) {
    var groupedObj = state.groupedFiles;
    List<DataRow> keyFiles = [];
    TextStyle cellTextStyle = TextStyle(
      color: Theme.of(context).textTheme.subtitle1?.color,
      fontSize: 14,
      fontFamily: kNormalTextFontFamily,
    );

    groupedObj.entries.forEach((element) {
      final lenght = element.value.length + 1;
      for (var i = 0; i < lenght; i++) {
        if (i == 0) {
          var type = element.key;
          switch (type) {
            case 'folder':
              type = translate.folder_dir;
              break;
            case 'jpg':
              type = translate.photos;
              break;
            case 'txt':
              type = translate.documents;
              break;
          }
          keyFiles.add(DataRow(cells: [
            DataCell(Text(
              type,
              style: TextStyle(
                color: Theme.of(context).disabledColor,
                fontSize: 18,
                fontFamily: kNormalTextFontFamily,
              ),
            )),
            DataCell(Container()),
            DataCell(Container()),
            DataCell(Container()),
            DataCell(Container()),
          ]));
        } else {
          var obj = element.value[i - 1];
          bool isFile = false;
          String? type = '';
          if (obj is Record) {
            var record = obj;
            isFile = true;
            if (record.thumbnail != null && record.thumbnail!.isNotEmpty) {
              type = FileAttribute().getFilesType(record.name!.toLowerCase());
            }
          }
          keyFiles.add(DataRow(cells: [
            DataCell(
              GestureDetector(
                onTap: () {
                  // if (StateInfoContainer.of(context)?.open == true) {

                  // }
                  var index = i;
                  if (obj is Folder) {
                    print(obj);
                    print("lol");

                    widget.push(
                      child: OpenedFolderView(
                        currentFolder: obj,
                        previousFolders: [
                          ...state.previousFolders,
                          state.currentFolder!
                        ],
                        pop: widget.pop,
                        push: widget.push,
                      ),
                      folderId: obj.id,
                    );
                    context
                        .read<OpenedFolderCubit>()
                        .changeRepresentation(FilesRepresentation.table);
                  } else {
                    if (_indexObject != index) {
                      setState(() {
                        _indexObject = index;
                      });
                      print('file tapped');
                      startTimer();
                      context
                          .read<OpenedFolderCubit>()
                          .fileTapped(obj as Record);
                    }
                  }
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Stack(
                        children: [
                          Image.asset(
                            isFile
                                ? type.isNotEmpty
                                    ? 'assets/file_icons/${type}_s.png'
                                    : 'assets/file_icons/unexpected_s.png'
                                : 'assets/file_icons/folder.png',
                            fit: BoxFit.contain,
                            height: 24,
                            width: 24,
                          ),
                          ...isFile && (obj as Record).loadPercent != null
                              ? _uploadProgress(obj.loadPercent)
                              : [],
                        ],
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Container(
                          width: constraints.maxWidth * 0.3,
                          child: Text(
                            obj.name ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: cellTextStyle,
                          ),
                        ),
                      ),
                      // Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child:
                            BlocBuilder<OpenedFolderCubit, OpenedFolderState>(
                          bloc: _bloc,
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: () {
                                context
                                    .read<OpenedFolderCubit>()
                                    .setFavorite(obj);
                              },
                              child: Image.asset(
                                obj.favorite
                                    ? 'assets/file_page/favorite.png'
                                    : 'assets/file_page/not_favorite.png',
                                height: 18,
                                width: 18,
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            DataCell(
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  type.isEmpty ? translate.foldr : type.toUpperCase(),
                  overflow: TextOverflow.ellipsis,
                  style: cellTextStyle,
                ),
              ),
            ),
            DataCell(
              Text(
                DateFormat('dd.MM.yyyy').format(obj.createdAt!),
                style: cellTextStyle,
              ),
            ),
            DataCell(
              Text(
                fileSize(obj.size, translate, 1),
                maxLines: 1,
                style: cellTextStyle,
              ),
            ),
            DataCell(
              Theme(
                data: Theme.of(context).copyWith(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                ),
                child: BlocBuilder<OpenedFolderCubit, OpenedFolderState>(
                  bloc: _bloc,
                  builder: (context, snapshot) {
                    if (state.objects.length >
                        _popupControllersGrouped.length) {
                      _popupControllersGrouped = [];
                      _initiatingControllersForGroupedFiles(state);
                    }
                    return CustomPopupMenu(
                      pressType: PressType.singleClick,
                      barrierColor: Colors.transparent,
                      showArrow: false,
                      horizontalMargin: 110,
                      verticalMargin: 0,
                      controller:
                          _popupControllersGrouped[state.objects.indexOf(obj)],
                      menuBuilder: () {
                        return FilesPopupMenuActions(
                          theme: Theme.of(context),
                          translate: translate,
                          object: obj,
                          onTap: (action) async {
                            _popupControllersGrouped[state.objects.indexOf(obj)]
                                .hideMenu();
                            _popupActions(state, context, action, obj);
                          },
                        );
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
                    );
                  },
                ),
              ),
            )
          ]));
          //keyFiles.add(value);
        }
      }
    });

    return keyFiles;
  }

  _contextAction(
    OpenedFolderState state,
    BuildContext context,
    ContextMenuAction action,
  ) async {
    switch (action) {
      case ContextMenuAction.addFiles:
        final folderId = StateContainer.of(context).choosedFilesFolderId;
        if (folderId != null)
          context.read<OpenedFolderCubit>().uploadFilesAction(folderId);
        break;
      case ContextMenuAction.createFolder:
        final folderId = StateContainer.of(context).choosedFilesFolderId;
        var folderName = await showDialog<String?>(
            context: context,
            builder: (BuildContext context) {
              return BlurCreateAlbum();
            });
        if (folderName != null) {
          context.read<OpenedFolderCubit>().createFolder(folderName, folderId);
        }

        break;
      default:
    }
  }

  _popupActions(OpenedFolderState state, BuildContext context,
      FileAction action, BaseObject object) async {
    switch (action) {
      case FileAction.properties:
        var res = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return FileInfoView(
                  object: object, user: state.valueNotifier?.value);
            });
        if (res != null) {
          if (object is Folder) {
            print(object);
            widget.push(
              child: OpenedFolderView(
                currentFolder: object,
                previousFolders: [
                  ...state.previousFolders,
                  state.currentFolder!
                ],
                pop: widget.pop,
                push: widget.push,
              ),
              folderId: object.id,
            );
          } else {
            print('file tapped in properties');

            context.read<OpenedFolderCubit>().fileTapped(object as Record);
          }
        }
        break;
      case FileAction.rename:
        if (object is Record) {
          var fileExtension =
              FileAttribute().getFileExtension(object.name ?? '');
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
            if (fileExtension.isNotEmpty) {
              fileExtension = ".$fileExtension";
            }
            result = "$result$fileExtension";
            final res = await context
                .read<OpenedFolderCubit>()
                .onActionRenameChosenFile(object, result);
            if (res == ErrorType.alreadyExist) {
              _renameFile(context, object, result, fileExtension);
            }
          }
        } else {
          var result = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return BlurRename(object.name, true);
            },
          );
          if (result != null && result is String && result != object.name) {
            final res = await context
                .read<OpenedFolderCubit>()
                .onActionRenameChosenFolder(object, result);
            if (res == ErrorType.alreadyExist) {
              _renameFolder(context, object, result);
            }
          }
        }
        break;
      case FileAction.delete:
        var result = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return BlurDelete();
          },
        );

        if (result == true) {
          context
              .read<OpenedFolderCubit>()
              .onRecordActionChoosed(action, object);
        }
        break;
      case FileAction.move:
        var result = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return MoveFileView(
              object is Folder ? [object] : null,
            );
          },
        );
        if (result != null) {
          List<BaseObject> objects = [];
          objects.add(object);

          context.read<OpenedFolderCubit>().onActionMoveFiles(objects, result);
        }
        break;
      case FileAction.save:
        context.read<OpenedFolderCubit>().fileSave(object as Record);
        print('save objects');
        break;
      case FileAction.addFiles:
        context.read<OpenedFolderCubit>().uploadFilesAction(object.id);
        break;
      default:
    }
  }
}

class ObjectView extends StatelessWidget {
  const ObjectView({Key? key, required this.object}) : super(key: key);
  final BaseObject object;

  @override
  Widget build(BuildContext context) {
    String? type = '';
    bool isFile = false;
    String? thumbnail;
    if (object is Record) {
      var record = object as Record;
      isFile = true;

      if (record.thumbnail != null &&
              record.thumbnail!
                  .isNotEmpty /*&&
          record.thumbnail!.first.name!.contains('.')*/
          ) {
        thumbnail = record.thumbnail?.first.publicUrl;
        type = FileAttribute().getFilesType(record.name!.toLowerCase());
      }
    }

    return LayoutBuilder(
      builder: (context, constrains) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 90,
                width: 80,
                child: isFile && type != 'image' && type != 'video'
                    ? type!.isNotEmpty && type != 'unexpected'
                        ? Image.asset(
                            'assets/file_icons/$type.png',
                            fit: BoxFit.contain,
                          )
                        : Image.asset(
                            'assets/file_icons/files.png',
                            fit: BoxFit.contain,
                          )
                    : type == 'image' ||
                            type == 'video' &&
                                thumbnail != null &&
                                thumbnail.isNotEmpty
                        ? Image.network(
                            thumbnail!,
                            fit: BoxFit.contain,
                          )
                        : type == 'video' &&
                                (thumbnail == null || thumbnail.isEmpty)
                            ? Image.asset(
                                'assets/file_icons/$type.png',
                                fit: BoxFit.contain,
                              )
                            : Image.asset(
                                'assets/file_icons/folder.png',
                                fit: BoxFit.contain,
                              ),
              ),
              ..._uploadProgress(
                  isFile ? (object as Record).loadPercent : null),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Text(
              object.name ?? '',
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: kNormalTextFontFamily,
                fontSize: 14,
                color: Theme.of(context).disabledColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _uploadProgress(double? progress) {
    List<Widget> indicators = [Container()];
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

class ContextMenuRightTap extends StatefulWidget {
  ContextMenuRightTap(
      {required this.translate,
      required this.onTap,
      required this.child,
      Key? key})
      : super(key: key);

  final S translate;
  final Function(ContextMenuAction) onTap;
  final Widget child;

  @override
  _ContextMenuRightTapState createState() => _ContextMenuRightTapState();
}

class _ContextMenuRightTapState extends State<ContextMenuRightTap> {
  @override
  Widget build(BuildContext context) {
    int ind = -1;
    return ContextMenuArea(
      builder: (context) => [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: IntrinsicWidth(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onTap(ContextMenuAction.addFiles);
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
                      color: ind == 0
                          ? Theme.of(context).colorScheme.onSecondary
                          : null,
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.onTap(ContextMenuAction.createFolder);
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
                          ? Theme.of(context).colorScheme.onSecondary
                          : null,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/options/create_folder.svg',
                            height: 20,
                          ),
                          Container(
                            width: 15,
                          ),
                          Text(
                            widget.translate.create_a_folder,
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
      ],
      child: widget.child,
    );
  }
}

class FilesPopupMenuActions extends StatefulWidget {
  FilesPopupMenuActions(
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

class _FilesPopupMenuActionsState extends State<FilesPopupMenuActions> {
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
                GestureDetector(
                  onTap: () {
                    widget.onTap(FileAction.move);
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
                      color: ind == 1 ? mainColor : null,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Image.asset(
                          //   'assets/file_page/file_options/move.png',
                          //   height: 20,
                          // ),
                          SvgPicture.asset(
                            'assets/options/folder.svg',
                            height: 20,
                          ),
                          Container(
                            width: 15,
                          ),
                          Text(
                            widget.translate.move,
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
                    widget.onTap(FileAction.save);
                  },
                  child: MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        ind = 2;
                      });
                    },
                    child: Container(
                      width: 190,
                      height: 40,
                      color: ind == 2 ? mainColor : null,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Image.asset(
                          //   'assets/file_page/file_options/download.png',
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
                            widget.translate.down,
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

class GridElement {
  Widget grid;
  String type;

  GridElement({required this.grid, required this.type});
}
