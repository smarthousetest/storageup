import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storageup/components/custom_button_template.dart';
import 'package:storageup/components/user_info.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/models/user.dart';
import 'package:storageup/pages/files/models/sorting_element.dart';
import 'package:storageup/pages/files/opened_folder/opened_folder_view.dart';
import 'package:storageup/utilities/extensions.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/state_containers/state_container.dart';
import 'package:storageup/utilities/state_containers/state_info_container.dart';
import 'package:storageup/utilities/state_containers/state_sorted_container.dart';

import 'file_bloc.dart';
import 'file_event.dart';
import 'file_state.dart';

class FilePage extends StatefulWidget {
  @override
  _FilePageState createState() => new _FilePageState();
  //var index = 0;
  FilePage();
}

class _FilePageState extends State<FilePage> {
  bool ifGrid = true;
  S translate = getIt<S>();
  var index = 0;

  List<OpenedFolderView> _opendedFolders = [];
  int _sortingTextFieldIndex = -1;
  final double _rowSpasing = 20.0;
  final double _rowPadding = 30.0;
  double? _searchFieldWidth;
  bool _isSearchFieldChoosen = true;
  final TextEditingController _searchingFieldController =
      TextEditingController();
  final FocusNode focusNode = FocusNode();

  GlobalKey stickyKey = GlobalKey();
  GlobalKey propertiesWidthKey = GlobalKey();

  @override
  void initState() {
    _opendedFolders.add(
      OpenedFolderView(
        currentFolder: null, //state.currentFolder!,
        previousFolders: [],
        pop: _pop,
        push: _push,
      ),
    );
    _initFilterList();
    super.initState();
  }

  void _prepareFields(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (MediaQuery.of(context).size.width < 967) {
      setState(() {
        _searchFieldWidth =
            width - _rowSpasing * 3 - 30 * 3 - _rowPadding * 2 - 274 - 80;
      });
    } else
      setState(() {
        _searchFieldWidth =
            width - _rowSpasing * 3 - 30 * 3 - _rowPadding * 2 - 274 - 173;
      });
  }

  void postPrepareFields(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    _searchFieldWidth =
        width - _rowSpasing * 3 - 30 * 2 - _rowPadding * 2 - 274 - 60 - 320;
  }

  void _initFilterList() {
    _sortingTextFieldIndex = -1;
  }

  List<SortingElement> _getSortingElements() {
    return [
      SortingElement(
        text: translate.by_type,
        type: SortingCriterion.byType,
      ),
      SortingElement(
        text: translate.by_name,
        type: SortingCriterion.byName,
      ),
      SortingElement(
        text: translate.by_date_added,
        type: SortingCriterion.byDateCreated,
      ),
      SortingElement(
        text: translate.by_size,
        type: SortingCriterion.bySize,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    _prepareFields(context);
    return BlocProvider(
      create: (context) => getIt<FilesBloc>()..add(FilesPageOpened()),
      child: BlocListener<FilesBloc, FilesState>(
        listener: (context, state) async {
          setState(() {
            var folderId = state.currentFolder;
            if (folderId != null) {
              StateContainer.of(context)
                  .changeChoosedFilesFolderId(folderId.id);
            }
          });
        },
        child: FileInheritedWidget(state: this, child: _fileView(context)),
      ),
    );
  }

  void _changeSortFieldsVisibility(BuildContext context) {
    setState(() {
      _isSearchFieldChoosen = !_isSearchFieldChoosen;
    });
    //context.read<FilesBloc>().add(FilesSortingClear());
  }

  Widget _fileView(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(_rowPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  /* Expanded(
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 1200),
                      transitionBuilder: (child, animation) => SizeTransition(
                        sizeFactor: animation,
                        child: IndexedStack(
                          key: ValueKey<int>(widget.index),
                          index: widget.index,
                          children: _opendedFolders,
                        ),
                      ),
                      child:*/
                  Expanded(
                    child: IndexedStack(
                      sizing: StackFit.expand,
                      key: ValueKey<int>(index),
                      index: index,
                      children: _opendedFolders,
                    ),
                  ),
                  // ),
                  // ),
                  // Expanded(
                  //   child: IndexedStack(
                  //     index: widget.index,
                  //     children: _opendedFolders,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
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
                    offset: Offset(1, 4),
                  )
                ],
              ),
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
                      StateSortedContainer.of(context)
                          .newSortedCriterion(SortingCriterion.byDateCreated);
                      focusNode.requestFocus();
                      // _searchingFieldController
                    });
                    // _searchingFieldController.clear();
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
                      focusNode: focusNode,
                      autofocus: true,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Theme.of(context).disabledColor,
                      ),
                      onChanged: (value) {
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
    return Container(
      child: BlocBuilder<FilesBloc, FilesState>(
        builder: (context, state) {
          return state.valueNotifier != null
              ? ValueListenableBuilder<User?>(
                  valueListenable: state.valueNotifier!,
                  builder: (context, value, _) {
                    return UserInfo(
                      user: value,
                      isExtended: MediaQuery.of(context).size.width > 966,
                      padding: EdgeInsets.only(right: 20, left: 20),
                      textInfoConstraints:
                          BoxConstraints(maxWidth: 95, minWidth: 50),
                    );
                  })
              : Container();
        },
      ),
    );
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

  void _push({required OpenedFolderView child, required String? folderId}) {
    setState(() {
      _opendedFolders.add(child);
      index++;
    });

    StateContainer.of(context).changeChoosedFilesFolderId(folderId);
  }

  void _pop(int countOfPop) {
    for (var i = 0; i < countOfPop; i++) {
      setState(() {
        if (_opendedFolders.length != 1) {
          _opendedFolders.removeLast();
          index--;
        }
      });
    }

    final choosedFolder = _opendedFolders[index].currentFolder?.id;

    StateContainer.of(context).changeChoosedFilesFolderId(choosedFolder);
  }
}

class FileInheritedWidget extends InheritedWidget {
  final _FilePageState state;

  FileInheritedWidget({
    Key? key,
    required this.state,
    required Widget child,
  }) : super(key: key, child: child);

  static FileInheritedWidget of(BuildContext context) {
    final FileInheritedWidget? result =
        context.dependOnInheritedWidgetOfExactType<FileInheritedWidget>();

    return result!;
  }

  @override
  bool updateShouldNotify(FileInheritedWidget old) => state != old.state;
}

class FileInfoViewEvent {}

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
