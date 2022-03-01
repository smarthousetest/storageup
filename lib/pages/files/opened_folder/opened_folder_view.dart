import 'package:cpp_native/file_typification/file_typification.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/models/record.dart';
import 'package:upstorage_desktop/pages/files/models/sorting_element.dart';
import 'package:upstorage_desktop/pages/files/opened_folder/opened_folder_cubit.dart';
import 'package:upstorage_desktop/pages/files/opened_folder/opened_folder_state.dart';
import 'package:upstorage_desktop/utilites/extensions.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/state_info_container.dart';
import 'package:upstorage_desktop/utilites/state_sorted_container.dart';

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
  final void Function(
      {required OpenedFolderView child, required String? folderId}) push;
  final Function(int) pop;

  @override
  _OpenedFolderViewState createState() => _OpenedFolderViewState();
}

class _OpenedFolderViewState extends State<OpenedFolderView> {
  S translate = getIt<S>();
  SortingDirection _direction = SortingDirection.down;
  var _bloc = OpenedFolderCubit();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc
        ..init(
          widget.currentFolder,
          widget.previousFolders,
        ),
      child: Expanded(
        child: Container(
          margin: EdgeInsets.only(top: 30),
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
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _pathSection(),
              Divider(
                color: Theme.of(context).dividerColor,
              ),
              _filesSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pathSection() {
    return BlocBuilder<OpenedFolderCubit, OpenedFolderState>(
      bloc: _bloc,
      builder: (context, state) {
        return Row(
          // crossAxisAlignment: CrossAxisAlignment.baseline,
          // textBaseline: TextBaseline.alphabetic,
          children: [
            _pathRow(state.previousFolders, state.currentFolder),
            Spacer(),
            StateSortedContainer.of(context).sortedActionButton
                ? IconButton(
                    padding: EdgeInsets.zero,
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
              padding: const EdgeInsets.only(left: 30.0),
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

        // if (state.search != searchText) {
        //   context.read<OpenedFolderCubit>().mapSortedFieldChanged(
        //         searchText,
        //       );
        // }
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
          return _filesList(context, state);
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
          child: Text(
            i == 0 ? translate.files : allPath[i]!.name!,
            style: i == allPath.length - 1
                ? textStyle.copyWith(
                    color: Theme.of(context).textTheme.headline2?.color)
                : textStyle,
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
        // print('min width ${constrains.smallest.width}');

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

                  Future<void> _onPointerDown(PointerDownEvent event) async {
                    if (event.kind == PointerDeviceKind.mouse &&
                        event.buttons == kSecondaryMouseButton) {
                      print("right button click");
                    }
                  }

                  if (obj is Folder) {
                    onTap = () {
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
                    };
                  } else {
                    onTap = () {
                      print('file tapped');
                    };
                  }

                  return GestureDetector(
                      onTap: onTap,
                      child: Listener(
                        //   child: BlocBuilder<OpenedFolderCubit, OpenedFolderState>(
                        //       builder: (context, state) {
                        //     var controller = CustomPopupMenuController();
                        //     return CustomPopupMenu(
                        //       pressType: PressType.singleClick,
                        //       barrierColor: Colors.transparent,
                        //       showArrow: false,
                        //       horizontalMargin: 110,
                        //       verticalMargin: 0,
                        //       controller: controller,
                        //       menuBuilder: () {
                        //         return FilesPopupMenuActions(
                        //           theme: Theme.of(context),
                        //           translate: translate,
                        //           onTap: (action) {
                        //             controller.hideMenu();
                        //             if (action == FileAction.properties) {
                        //               StateInfoContainer.of(context)
                        //                   ?.setInfoObject(obj);
                        //               controller.hideMenu();
                        //             } else
                        //               context
                        //                   .read<OpenedFolderCubit>()
                        //                   .onRecordActionChoosed(action, obj);
                        //           },
                        //         );
                        //       },
                        child: ObjectView(object: state.sortedFiles[index]),
                        onPointerDown: _onPointerDown,
                      ));
                  // }),

                  //),
                  //  );
                },
              );
            },
          ),
        );
      }),
    );
  }

  List<GridElement> _gridList(
      OpenedFolderState state, BoxConstraints constrains) {
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
                crossAxisCount: constrains.smallest.width ~/ 110,
                childAspectRatio: (1 / 1.1),
              ),
              itemBuilder: (context, index) {
                List<BaseObject> files = value;

                Function() onTap;
                var obj = state.sortedFiles[index];

                Future<void> _onPointerDown(PointerDownEvent event) async {
                  if (event.kind == PointerDeviceKind.mouse &&
                      event.buttons == kSecondaryMouseButton) {
                    print("right button click");
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
                    print('file tapped');
                  };
                }
                return GestureDetector(
                    onTap: onTap,
                    child: Listener(
                        onPointerDown: _onPointerDown,
                        child: ObjectView(object: files[index])));
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
                columnSpacing: 25,
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
                        Row(
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
                                        (element as Record).loadPercent != null
                                    ? _uploadProgress(element.loadPercent)
                                    : [],
                              ],
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                element.name ?? '',
                                style: cellTextStyle,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Spacer(),
                            BlocBuilder<OpenedFolderCubit, OpenedFolderState>(
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
                            )
                          ],
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
                          DateFormat('dd.MM.yyyy').format(element.createdAt!),
                          style: cellTextStyle,
                        ),
                      ),
                      DataCell(
                        Text(
                          filesize(element.size, translate, 1),
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
                              var controller = CustomPopupMenuController();
                              return CustomPopupMenu(
                                pressType: PressType.singleClick,
                                barrierColor: Colors.transparent,
                                showArrow: false,
                                horizontalMargin: 110,
                                verticalMargin: 0,
                                controller: controller,
                                menuBuilder: () {
                                  return FilesPopupMenuActions(
                                    theme: Theme.of(context),
                                    translate: translate,
                                    onTap: (action) {
                                      controller.hideMenu();
                                      if (action == FileAction.properties) {
                                        StateInfoContainer.of(context)
                                            ?.setInfoObject(element);
                                        controller.hideMenu();
                                      } else
                                        context
                                            .read<OpenedFolderCubit>()
                                            .onRecordActionChoosed(
                                                action, element);
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
}

class ObjectView extends StatelessWidget {
  const ObjectView({Key? key, required this.object}) : super(key: key);
  final BaseObject object;
  @override
  Widget build(BuildContext context) {
    String? type = '';
    bool isFile = false;
    if (object is Record) {
      var record = object as Record;
      isFile = true;
      if (record.thumbnail != null &&
              record.thumbnail!
                  .isNotEmpty /*&&
          record.thumbnail!.first.name!.contains('.')*/
          ) {
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
                child: isFile && type != 'image'
                    ? type!.isNotEmpty
                        ? Image.asset(
                            'assets/file_icons/$type.png',
                            fit: BoxFit.contain,
                          )
                        : Image.asset(
                            'assets/file_icons/files.png',
                            fit: BoxFit.contain,
                          )
                    : type == 'image'
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              (object as Record).thumbnail!.first.publicUrl!,
                              fit: BoxFit.contain,
                            ),
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
          Text(
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

class FilesPopupMenuActions extends StatefulWidget {
  FilesPopupMenuActions(
      {required this.theme,
      required this.translate,
      required this.onTap,
      Key? key})
      : super(key: key);

  final ThemeData theme;
  final S translate;
  final Function(FileAction) onTap;
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
                MouseRegion(
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
                        // Image.asset(
                        //   'assets/file_page/file_options/share.png',
                        //   height: 20,
                        // ),
                        SvgPicture.asset(
                          'assets/options/share.svg',
                          height: 20,
                        ),
                        Container(
                          width: 15,
                        ),
                        Text(
                          widget.translate.share,
                          style: style,
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(
                  color: mainColor,
                  height: 1,
                ),
                MouseRegion(
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
                Divider(
                  color: mainColor,
                  height: 1,
                ),
                MouseRegion(
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
                          widget.translate.download,
                          style: style,
                        ),
                      ],
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
                        ind = 4;
                      });
                    },
                    child: Container(
                      width: 190,
                      height: 40,
                      color: ind == 4
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

class GridFileElement extends StatefulWidget {
  const GridFileElement({
    Key? key,
    // required this.widget,
    required this.isSelectable,
    required this.file,
  }) : super(key: key);

  // final GridItemWidget widget;
  final BaseObject file;
  final bool isSelectable;

  @override
  State<GridFileElement> createState() => _GridFileElementState();
}

class _GridFileElementState extends State<GridFileElement> {
  @override
  Widget build(BuildContext context) {
    // bool hasThumbnail = false;
    bool isFile = false;
    String? type = '';
    List<Widget> indicators = [Container()];
    if (widget.file is Record) {
      var record = widget.file as Record;
      isFile = true;
      // print(record.thumbnail?.first.publicUrl);
      if (record.thumbnail != null &&
              record.thumbnail!
                  .isNotEmpty /*&&
          record.thumbnail!.first.name!.contains('.')*/
          ) {
        type = FileAttribute().getFilesType(
            record.name!.toLowerCase()); //record.thumbnail?.first.name;
        // print(type);
      }

      if (record.loadPercent != null && record.loadPercent != 99) {
        indicators = [
          Visibility(
            child: CircularProgressIndicator(
              value: record.loadPercent! / 100,
            ),
          ),
          CircularProgressIndicator.adaptive(),
        ];
      }
    }

    return LayoutBuilder(
      builder: (context, constrains) => Material(
        type: MaterialType.transparency,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              // height: 100,
              width: constrains.minWidth - 17,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    // height: 100,
                    width: constrains.minWidth - 17,
                    child: isFile && type != 'image'
                        ? type!.isNotEmpty
                            ? Image.asset(
                                'assets/file_icons/$type.png',
                                fit: BoxFit.contain,
                              )
                            : Image.asset(
                                'assets/file_icons/files.png',
                                fit: BoxFit.contain,
                              )
                        : type == 'image'
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  (widget.file as Record)
                                      .thumbnail!
                                      .first
                                      .publicUrl!,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : Image.asset(
                                'assets/file_icons/folder.png',
                                fit: BoxFit.contain,
                              ),
                  ),
                  Container(
                    width: 100,
                    // height: 100,
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.only(bottom: 5),
                    child: Visibility(
                      visible: widget.isSelectable,
                      child: SvgPicture.asset(
                        widget.file.isChoosed
                            ? 'assets/media_page/choosed_icon.svg'
                            : 'assets/media_page/unchoosed_icon.svg',
                        alignment: Alignment.bottomCenter,
                        height: 16,
                        width: 16,
                      ),
                    ),
                  ),
                  ...indicators,
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Container(
                child: Text(
                  widget.file.name ?? 'name does not exist',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    color: Theme.of(context).textTheme.headline6?.color,
                    fontSize: 14,
                    fontFamily: kNormalTextFontFamily,
                  ),
                ),
              ),
            ),
            Text(
              DateFormat('dd.MM.yyyy').format(widget.file.createdAt ??
                  DateTime.now()), //TODO remove this costil'
              style: TextStyle(
                decoration: TextDecoration.none,
                color: Theme.of(context).disabledColor,
                fontSize: 10,
                fontFamily: kNormalTextFontFamily,
              ),
            ),
          ],
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
