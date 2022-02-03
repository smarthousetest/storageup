import 'package:cpp_native/file_typification/file_typification.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/models/base_object.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/models/record.dart';
import 'package:upstorage_desktop/pages/files/opened_folder/opened_folder_cubit.dart';
import 'package:upstorage_desktop/pages/files/opened_folder/opened_folder_state.dart';
import 'package:upstorage_desktop/utilites/extensions.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

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
  final Function(Widget) push;
  final Function(int) pop;

  @override
  _OpenedFolderViewState createState() => _OpenedFolderViewState();
}

class _OpenedFolderViewState extends State<OpenedFolderView> {
  S translate = getIt<S>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OpenedFolderCubit()
        ..init(
          widget.currentFolder,
          widget.previousFolders,
        ),
      child: Expanded(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 30),
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
      builder: (context, state) {
        return Row(
          // crossAxisAlignment: CrossAxisAlignment.baseline,
          // textBaseline: TextBaseline.alphabetic,
          children: [
            _pathRow(state.previousFolders, state.currentFolder),
            Spacer(),
            IconButton(
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
      builder: (context, state) {
        if (state.representation == FilesRepresentation.grid) {
          return _filesGrid();
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

  Widget _filesGrid() {
    return Expanded(
      child: LayoutBuilder(builder: (context, constrains) {
        print('min width ${constrains.smallest.width}');

        return Container(
          child: BlocBuilder<OpenedFolderCubit, OpenedFolderState>(
            // buildWhen: (previous, current) {
            //   print('last obj vs cur ${previous.objects != current.objects}');
            //   return previous.objects != current.objects;
            // },
            builder: (context, state) {
              return GridView.builder(
                itemCount: state.objects.length,
                shrinkWrap: true,
                controller: ScrollController(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: constrains.smallest.width ~/ 110,
                  childAspectRatio: (1 / 1.22),
                  mainAxisSpacing: 15,
                ),
                itemBuilder: (context, index) {
                  Function() onTap;
                  var obj = state.objects[index];
                  if (obj is Folder) {
                    onTap = () {
                      widget.push(
                        OpenedFolderView(
                          currentFolder: obj,
                          previousFolders: [
                            ...state.previousFolders,
                            state.currentFolder!
                          ],
                          pop: widget.pop,
                          push: widget.push,
                        ),
                      );
                    };
                  } else {
                    onTap = () {
                      context
                          .read<OpenedFolderCubit>()
                          .fileTapped(obj as Record);
                    };
                  }
                  return GestureDetector(
                    onTap: onTap,
                    child: ObjectView(object: state.objects[index]),
                  );
                },
              );
            },
          ),
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
                rows: state.objects.map((e) {
                  String? type = '';
                  bool isFile = false;
                  if (e is Record) {
                    var record = e;
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
                    index: state.objects.indexOf(e),
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
                                ...isFile && (e as Record).loadPercent != null
                                    ? _uploadProgress(e.loadPercent)
                                    : [],
                              ],
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
                            BlocBuilder<OpenedFolderCubit, OpenedFolderState>(
                              builder: (context, state) {
                                return GestureDetector(
                                  onTap: () {
                                    context
                                        .read<OpenedFolderCubit>()
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
                          filesize(e.size, translate, 1),
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
                            menuBuilder: () {
                              return FilesPopupMenuActions(
                                theme: Theme.of(context),
                                translate: translate,
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
      {required this.theme, required this.translate, Key? key})
      : super(key: key);

  final ThemeData theme;
  final S translate;
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
                MouseRegion(
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
                Divider(
                  color: mainColor,
                  height: 1,
                ),
                MouseRegion(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
