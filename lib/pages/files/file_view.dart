import 'dart:async';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/components/blur/add_folder.dart';
import 'package:upstorage_desktop/components/dir_button_template.dart';
import 'package:upstorage_desktop/components/properties.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/pages/files/models/sorting_element.dart';
import 'package:upstorage_desktop/pages/files/opened_folder/opened_folder_view.dart';
import 'package:upstorage_desktop/utilites/state_info_container.dart';
import 'package:upstorage_desktop/utilites/state_sorted_container.dart';
import 'files_list/files_list.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'file_bloc.dart';
import 'file_state.dart';
import 'file_event.dart';
import 'package:upstorage_desktop/utilites/extensions.dart';

class FilePage extends StatefulWidget {
  @override
  _FilePageState createState() => new _FilePageState();
  var index = 0;
  FilePage();
}

class _FilePageState extends State<FilePage> {
  bool ifGrid = true;
  S translate = getIt<S>();

  List<Widget> _opendedFolders = [];
  int _sortingTextFieldIndex = -1;
  final double _rowSpasing = 20.0;
  final double _rowPadding = 30.0;
  double? _searchFieldWidth;
  bool _isSearchFieldChoosen = true;
  final TextEditingController _searchingFieldController =
      TextEditingController();
  //SortingDirection _direction = SortingDirection.neutral;
  GlobalKey stickyKey = GlobalKey();
  GlobalKey propertiesWidthKey = GlobalKey();
  //SortingCriterion _lastCriterion = SortingCriterion.byDateCreated;

  @override
  void initState() {
    _opendedFolders.add(
      Column(
        children: [
          OpenedFolderView(
              currentFolder: null, //state.currentFolder!,
              previousFolders: [],
              pop: _pop,
              push: _push),
        ],
      ),
    );
    _initFilterList();
    super.initState();
  }

  Timer? _timer;

  void _prepareFields(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final keyContext = stickyKey.currentContext;
    final keyInfoContext = propertiesWidthKey.currentContext;

    if (keyContext != null) {
      _timer?.cancel();
      _timer = null;
      final box = keyContext.findRenderObject() as RenderBox;
      if (StateInfoContainer.of(context)?.object != null) {
        Future.delayed(Duration(seconds: 1), () {
          _prepareFields(context);
        });
      } else
        setState(() {
          _searchFieldWidth = width -
              _rowSpasing * 3 -
              30 * 3 -
              _rowPadding * 2 -
              274 -
              box.size.width;
        });
    } else if (keyInfoContext != null) {
      // _timer?.cancel();
      // _timer = null;

      final box = keyInfoContext.findRenderObject() as RenderBox;
      // var res = box.size.width;
      setState(() {
        _searchFieldWidth = width -
            _rowSpasing * 3 -
            30 * 3 -
            _rowPadding * 2 -
            274 -
            box.size.width;
      });
    } else {
      _searchFieldWidth =
          width - _rowSpasing * 3 - 30 * 2 - _rowPadding * 2 - 274 - 60 - 320;
      Future.delayed(Duration(seconds: 1), () {
        _prepareFields(context);
      });
      // if (_timer == null) {
      //   _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      //     _prepareFields(context);
      //   });
      // }
    }
  }

  void postPrepareFields(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    _searchFieldWidth =
        width - _rowSpasing * 3 - 30 * 2 - _rowPadding * 2 - 274 - 60 - 320;
  }

  void _initFilterList() {
    // _items = [
    //   SortingElement(text: translate.by_type, type: SortingCriterion.byType),
    //   SortingElement(text: translate.by_name, type: SortingCriterion.byName),
    //   SortingElement(
    //       text: translate.by_date_added, type: SortingCriterion.byDateCreated),
    //   SortingElement(
    //       text: translate.by_date_viewed, type: SortingCriterion.byDateViewed),
    //   SortingElement(text: translate.by_size, type: SortingCriterion.bySize),
    // ];
    _sortingTextFieldIndex = -1;
  }

  List<SortingElement> _getSortingElements() {
    return [
      SortingElement(text: translate.by_type, type: SortingCriterion.byType),
      SortingElement(text: translate.by_name, type: SortingCriterion.byName),
      SortingElement(
          text: translate.by_date_added, type: SortingCriterion.byDateCreated),
      SortingElement(text: translate.by_size, type: SortingCriterion.bySize),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // if (dirs_list.isEmpty) _init(context);
    _prepareFields(context);
    return BlocProvider(
      create: (context) => getIt<FilesBloc>()..add(FilesPageOpened()),
      child: BlocListener<FilesBloc, FilesState>(
        listener: (context, state) {},
        child: _filewView(context),
      ),
    );
  }

  void _changeSortFieldsVisibility(BuildContext context) {
    setState(() {
      _isSearchFieldChoosen = !_isSearchFieldChoosen;
    });
    context.read<FilesBloc>().add(FilesSortingClear());
  }

  Widget _filewView(BuildContext context) {
    return Expanded(
      child: Container(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(_rowPadding),
                child: Column(
                  children: [
                    Container(
                      height: 46,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          LayoutBuilder(builder: (context, constrains) {
                            return _searchField(context, constrains);
                          }),
                          SizedBox(
                            width: _rowSpasing,
                          ),
                          LayoutBuilder(builder: (context, constrains) {
                            return _sortingField(context, constrains);
                          }),
                          _infoUser(context),
                        ],
                      ),
                    ),
                    Expanded(
                      child: IndexedStack(
                        index: widget.index,
                        children: _opendedFolders,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            StateInfoContainer.of(context)?.object == null
                ? Container()
                : showViewFileInfo(),
          ],
        ),
      ),
    );
  }

  var controller = CustomPopupMenuController();

  Widget _sortingField(BuildContext context, BoxConstraints constrains) {
    return BlocBuilder<FilesBloc, FilesState>(builder: (
      context,
      state,
    ) {
      return Row(
        children: [
          GestureDetector(
            onTap: () {
              //controller.showMenu();
            },
            child: Container(
              width: _isSearchFieldChoosen ? 46 : _searchFieldWidth! + 46,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Color.fromARGB(25, 23, 69, 139),
                        blurRadius: 4,
                        offset: Offset(1, 4))
                  ]),
              child: Container(
                //width: 46,
                child: Row(children: [
                  Container(
                      width: _isSearchFieldChoosen ? 0 : _searchFieldWidth,
                      child: Center(
                          child: _sortingTextFieldIndex == -1
                              ? Text(
                                  translate.file_sorting,
                                  style: TextStyle(
                                    color: Theme.of(context).splashColor,
                                  ),
                                )
                              : Text(
                                  _getSortingElements()[_sortingTextFieldIndex]
                                      .text,
                                  style: TextStyle(
                                    color: Theme.of(context).disabledColor,
                                  ),
                                ))),
                  CustomPopupMenu(
                    pressType: PressType.singleClick,
                    barrierColor: Colors.transparent,
                    showArrow: false,
                    horizontalMargin: 210,
                    verticalMargin: 0,
                    controller: controller,
                    menuBuilder: () {
                      var items = _getSortingElements();
                      //_changeSortFieldsVisibility(context);
                      return SortingMenuActions(
                        theme: Theme.of(context),
                        translate: translate,
                        onTap: (action) {
                          controller.hideMenu();
                          switch (action) {
                            case SortingCriterion.byType:
                              _onActionSheetTap(context, items[0]);
                              break;
                            case SortingCriterion.byName:
                              _onActionSheetTap(context, items[1]);
                              break;
                            case SortingCriterion.byDateCreated:
                              _onActionSheetTap(context, items[2]);
                              break;

                            case SortingCriterion.bySize:
                              _onActionSheetTap(context, items[3]);
                              break;
                          }
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.all(9.0),
                          child: GestureDetector(
                            onTap: () {
                              _isSearchFieldChoosen
                                  ? setState(() {
                                      _changeSortFieldsVisibility(context);
                                      StateSortedContainer.of(context)
                                          .actionForButton();
                                    })
                                  : print('a');
                              controller.showMenu();
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: SvgPicture.asset(
                                "assets/file_page/settings.svg",
                                color: _isSearchFieldChoosen
                                    ? Theme.of(context).disabledColor
                                    : _sortingTextFieldIndex == -1
                                        ? Theme.of(context).splashColor
                                        : Theme.of(context).disabledColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _searchField(BuildContext context, BoxConstraints constrains) {
    return Container(
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
          GestureDetector(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                width: 46,
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Align(
                    alignment: FractionalOffset.centerLeft,
                    child: Container(
                        width: 20,
                        height: 20,
                        child: SvgPicture.asset("assets/file_page/search.svg")),
                  ),
                ),
              ),
            ),
            onTap: _isSearchFieldChoosen
                ? null
                : () {
                    setState(() {
                      _changeSortFieldsVisibility(context);
                      StateSortedContainer.of(context).actionForButton();
                    });

                    _searchingFieldController.clear();
                  },
          ),
          Container(
            width: _isSearchFieldChoosen ? _searchFieldWidth : 0,
            child: BlocBuilder<FilesBloc, FilesState>(
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Center(
                    child: TextField(
                      // autofocus: true,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).disabledColor,
                      ),
                      onChanged: (value) {
                        context
                            .read<FilesBloc>()
                            .add(FilesSortingFieldChanged(sortingText: value));
                        StateSortedContainer.of(context).searchAction(value);
                      },
                      controller: _searchingFieldController,
                      decoration: InputDecoration.collapsed(
                        hintText: translate.search,
                        hintStyle: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoUser(BuildContext context) {
    return StateInfoContainer.of(context)?.object == null
        ? Container(
            child: BlocBuilder<FilesBloc, FilesState>(
              builder: (context, state) {
                return Row(
                  key: stickyKey,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10, left: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(23.0),
                        child: state.user.image,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          state.user?.fullName ?? 'Александр',
                          style: TextStyle(
                            fontSize: 17,
                            color: Theme.of(context).bottomAppBarColor,
                          ),
                        ),
                        Text(
                          state.user?.email ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).bottomAppBarColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          )
        : Container();
  }

  void _onActionSheetTap(BuildContext context, SortingElement item) {
    setState(() {
      _sortingTextFieldIndex = _getSortingElements()
          .indexWhere((element) => element.text == item.text);
    });
    // _lastCriterion = item.type;
    StateSortedContainer.of(context).newSortedCriterion(item.type);
  }

  // Function() _onArrowTap(BuildContext context) {
  //   return !_isSearchFieldChoosen
  //       ? () {
  //           setState(() {
  //             if (_direction == SortingDirection.down) {
  //               _direction = SortingDirection.up;
  //             } else {
  //               _direction = SortingDirection.down;
  //             }
  //           });
  //           context.read<FilesBloc>().add(FileSortingByCriterion(
  //               criterion: _lastCriterion, direction: _direction));
  //         }
  //       : () {
  //           _changeSortFieldsVisibility(context);
  //           context.read<FilesBloc>().add(FileSortingByCriterion(
  //               criterion: _lastCriterion, direction: _direction));
  //           _direction = SortingDirection.down;
  //         };
  // }

  Widget showViewFileInfo() {
    try {
      if (StateInfoContainer.of(context)?.object == null) {
        return Container();
      } else {
        // _prepareFields(context);
        return BlocBuilder<FilesBloc, FilesState>(builder: (context, state) {
          return Container(
              child: FileInfoView(
            key: propertiesWidthKey,
            user: state.user,
            object: StateInfoContainer.of(context)?.object,
          ));
        });
      }
    } catch (e) {
      return Container();
    }
  }

  void _push(Widget child) {
    setState(() {
      _opendedFolders.add(child);
      widget.index++;
    });
  }

  void _pop(int countOfPop) {
    for (var i = 0; i < countOfPop; i++) {
      setState(() {
        if (_opendedFolders.length != 1) {
          _opendedFolders.removeLast();
          widget.index--;
        }
      });
    }
  }

  Widget _recentFiles() {
    return Expanded(child: BlocBuilder<FilesBloc, FilesState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
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
                                onPressed: () {},
                                fillColor: Theme.of(context).primaryColor,
                                child: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: Theme.of(context).splashColor,
                                  size: 20.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Container(
                                width: 30,
                                height: 30,
                                child: RawMaterialButton(
                                  onPressed: () {},
                                  fillColor: Theme.of(context).primaryColor,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context).splashColor,
                                    size: 20.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _foldersSection(context)
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30, right: 0),
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
                        padding: const EdgeInsets.fromLTRB(40, 20, 30, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              child: Text(
                                translate.recent,
                                style: TextStyle(
                                  color: Theme.of(context).focusColor,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 821,
                              child: Container(),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 30,
                              onPressed: () {
                                setState(() {
                                  ifGrid = false;
                                });
                                print('ifGrid is $ifGrid');
                              },
                              icon: SvgPicture.asset(
                                  'assets/file_page/list.svg',
                                  color: ifGrid
                                      ? Theme.of(context)
                                          .toggleButtonsTheme
                                          .color
                                      : Theme.of(context).splashColor),
                            ),
                            IconButton(
                              iconSize: 30,
                              onPressed: () {
                                setState(() {
                                  ifGrid = true;
                                });
                                print('ifGrid is ');
                              },
                              icon: SvgPicture.asset(
                                  'assets/file_page/block.svg',
                                  color: ifGrid
                                      ? Theme.of(context).splashColor
                                      : Theme.of(context)
                                          .toggleButtonsTheme
                                          .color),
                            ),
                          ],
                        ),
                      ),
                      ifGrid
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Divider(
                                height: 1,
                                color: Theme.of(context).dividerColor,
                              ),
                            )
                          : Container(),
                      Expanded(
                        child: ifGrid ? _filesGrid(context) : FilesList(),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    ));
  }

  Widget _foldersSection(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 31),
                  child: Container(
                    width: 130,
                    height: 130,
                    child: BlocBuilder<FilesBloc, FilesState>(
                      builder: (context, state) {
                        return Listener(
                          child: OutlinedButton(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: SvgPicture.asset(
                                    'assets/home_page/add_folder.svg',
                                    height: 46,
                                    width: 46,
                                  ),
                                ),
                                Text(
                                  translate.create_a_folder,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: kNormalTextFontFamily,
                                    color: Theme.of(context).disabledColor,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              var str = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return BlurAddFolder();
                                },
                              );
                              print(str);
                              if (str is String)
                                context.read<FilesBloc>().add(FileAddFolder(
                                    name: str,
                                    parentFolderId: state.currentFolder?.id));
                            },
                            style: OutlinedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).dividerColor,
                                ),
                              ),
                              elevation: 0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                _expandedSection(theme),
              ])),
    );
  }

  Widget _expandedSection(ThemeData theme) {
    return Container(
      child: BlocBuilder<FilesBloc, FilesState>(
        builder: (context, state) {
          if (state.currentFolder != null) {
            var folders =
                state.allFiles.where((item) => item is Folder).toList();
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: folders.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return CustomDirButton(
                    name: translate.all_files,
                    readonly: true,
                    description: translate.count_of_files(
                        state.currentFolder?.records?.length ?? 0),
                    onTap: () {
                      _push(OpenedFolderView(
                          currentFolder: state.currentFolder!,
                          previousFolders: [],
                          pop: _pop,
                          push: _push));
                    },
                  );
                } else {
                  var folder = folders[index - 1] as Folder;
                  return CustomDirButton(
                    name: folder.name!,
                    readonly: false,
                    description:
                        translate.count_of_files(folder.records?.length ?? 0),
                    onTap: () {
                      setState(() {
                        widget.index = 1;
                        print(index - 1);
                      });
                    },
                  );
                }
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _filesGrid(BuildContext context) {
    // var path = '';
    // var dir = Directory(path);
    // var isExist = dir.existsSync();

    return LayoutBuilder(builder: (context, constrains) {
      var crossAxisCount = constrains.minWidth ~/ 160;
      return GridView.count(
        crossAxisCount: crossAxisCount,
        padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
        crossAxisSpacing: 56,
        children: List.generate(17, (index) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: constrains.minWidth / crossAxisCount,
                height: constrains.minWidth / crossAxisCount * 1.3,
                color: Theme.of(context).primaryColor,
                child: Column(
                  children: [
                    ClipRRect(
                      child: Image.asset('assets/test_img/1.jpg'),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        '1.jpg',
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
                          fontSize: 14,
                          fontFamily: kNormalTextFontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    });
  }

  Widget openFolder(BuildContext context) {
    return Expanded(
      child: BlocBuilder<FilesBloc, FilesState>(builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 30, top: 30),
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
                  padding: const EdgeInsets.fromLTRB(40, 20, 30, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.index = 0;
                            });
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Text(
                              translate.files + " / ",
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        state.currentFolder?.name ?? "",
                        style: TextStyle(
                          color: Theme.of(context).focusColor,
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 20,
                        ),
                      ),
                      Expanded(
                        flex: 821,
                        child: Container(),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 30,
                        onPressed: () {
                          setState(() {
                            ifGrid = false;
                          });
                          print('ifGrid is $ifGrid');
                        },
                        icon: SvgPicture.asset('assets/file_page/list.svg',
                            color: ifGrid
                                ? Theme.of(context).toggleButtonsTheme.color
                                : Theme.of(context).splashColor),
                      ),
                      IconButton(
                        iconSize: 30,
                        onPressed: () {
                          setState(() {
                            ifGrid = true;
                          });
                          print('ifGrid is $ifGrid');
                        },
                        icon: SvgPicture.asset('assets/file_page/block.svg',
                            color: ifGrid
                                ? Theme.of(context).splashColor
                                : Theme.of(context).toggleButtonsTheme.color),
                      ),
                    ],
                  ),
                ),
                ifGrid
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Divider(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                      )
                    : Container(),
                Expanded(
                  child: ifGrid ? _filesGrid(context) : FilesList(),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

class SortingMenuActions extends StatefulWidget {
  SortingMenuActions(
      {required this.theme,
      required this.translate,
      required this.onTap,
      Key? key})
      : super(key: key);

  final ThemeData theme;
  final S translate;
  final Function(SortingCriterion) onTap;
  @override
  _SortingPopupMenuActionsState createState() =>
      _SortingPopupMenuActionsState();
}

class _SortingPopupMenuActionsState extends State<SortingMenuActions> {
  int ind = -1;
  @override
  Widget build(BuildContext context) {
    var style = TextStyle(
      fontFamily: kNormalTextFontFamily,
      fontSize: 14,
      color: Theme.of(context).disabledColor,
    );
    var choosedStyle = TextStyle(
      fontFamily: kNormalTextFontFamily,
      fontSize: 14,
      color: Theme.of(context).splashColor,
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
                    widget.onTap(SortingCriterion.byType);
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
                          Text(
                            widget.translate.by_type,
                            style: ind == 0 ? choosedStyle : style,
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
                    widget.onTap(SortingCriterion.byName);
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
                          Text(
                            widget.translate.by_name,
                            style: ind == 1 ? choosedStyle : style,
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
                    widget.onTap(SortingCriterion.byDateCreated);
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
                          Text(
                            widget.translate.by_date_added,
                            style: ind == 2 ? choosedStyle : style,
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
                    widget.onTap(SortingCriterion.bySize);
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
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.translate.by_size,
                            style: ind == 3 ? choosedStyle : style,
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
