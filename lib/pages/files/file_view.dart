import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storageup/components/user_info.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/models/user.dart';
import 'package:storageup/pages/files/models/sorting_element.dart';
import 'package:storageup/pages/files/opened_folder/opened_folder_shared_state_cubit.dart';
import 'package:storageup/pages/files/opened_folder/opened_folder_state.dart';
import 'package:storageup/pages/files/opened_folder/opened_folder_view.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/state_containers/state_container.dart';
import 'package:storageup/utilities/state_containers/state_sorted_container.dart';

import 'file_bloc.dart';
import 'file_event.dart';
import 'file_state.dart';

class FilePage extends StatefulWidget {
  @override
  _FilePageState createState() => new _FilePageState();

  FilePage();
}

class _FilePageState extends State<FilePage> {
  bool ifGrid = true;
  S translate = getIt<S>();
  var index = 0;

  List<OpenedFolderView> _openedFolders = [];
  int _sortingTextFieldIndex = -1;
  final double _rowPadding = 30.0;

  bool _isSearchFieldChosen = true;
  final TextEditingController _searchingFieldController =
      TextEditingController();
  final FocusNode focusNode = FocusNode();

  GlobalKey stickyKey = GlobalKey();
  GlobalKey propertiesWidthKey = GlobalKey();

  FilesSharedStateCubit filesSharedStateCubit = FilesSharedStateCubit(
    FilesSharedState(representation: FilesRepresentation.grid),
  );

  @override
  void initState() {
    _openedFolders.add(
      OpenedFolderView(
        currentFolder: null,
        previousFolders: [],
        pop: _pop,
        push: _push,
        filesSharedStateCubit: filesSharedStateCubit,
      ),
    );
    _initFilterList();
    super.initState();
  }

  @override
  void dispose() {
    filesSharedStateCubit.close();
    super.dispose();
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
    //_prepareFields(context);
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
      _isSearchFieldChosen = !_isSearchFieldChosen;
    });
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
                        Expanded(
                          child: LayoutBuilder(builder: (context, constrains) {
                            return _searchField(context, constrains);
                          }),
                        ),
                        _sortingTextFieldIndex != -1
                            ? SizedBox(width: 20)
                            : SizedBox(width: 15),
                        LayoutBuilder(builder: (context, constrains) {
                          return _sortingField(context, constrains);
                        }),
                        _infoUser(context),
                      ],
                    ),
                  ),
                  Expanded(
                    child: IndexedStack(
                      sizing: StackFit.expand,
                      key: ValueKey<int>(index),
                      index: index,
                      children: _openedFolders,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  var controller = CustomPopupMenuController();
  bool isRemoveFilterButtonHovered = false;
  bool isClearSearchTextButtonHovered = false;

  Widget _sortingField(BuildContext context, BoxConstraints constrains) {
    return BlocBuilder<FilesBloc, FilesState>(builder: (
      context,
      state,
    ) {
      return Row(
        children: [
          Container(
            //width: 46,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_sortingTextFieldIndex != -1)
                  FractionallySizedBox(
                    heightFactor: 1,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
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
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              _getSortingElements()[_sortingTextFieldIndex]
                                  .text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Theme.of(context).disabledColor,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              var item = _getSortingElements()[2];
                              _onActionSheetTap(context, item);
                              setState(() {
                                _sortingTextFieldIndex = -1;
                              });
                            },
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              onEnter: (event) {
                                setState(() {
                                  isRemoveFilterButtonHovered = false;
                                });
                              },
                              onHover: (event) {
                                setState(() {
                                  isRemoveFilterButtonHovered = true;
                                });
                              },
                              onExit: (event) {
                                setState(() {
                                  isRemoveFilterButtonHovered = false;
                                });
                              },
                              child: SvgPicture.asset(
                                'assets/file_page/close.svg',
                                height: 16,
                                width: 16,
                                color: isRemoveFilterButtonHovered
                                    ? null
                                    : Theme.of(context).disabledColor,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                SizedBox(
                  width: 15,
                ),
                Container(
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
                  child: CustomPopupMenu(
                    pressType: PressType.singleClick,
                    barrierColor: Colors.transparent,
                    showArrow: false,
                    horizontalMargin: 210,
                    verticalMargin: 0,
                    controller: controller,
                    menuBuilder: () {
                      var items = _getSortingElements();
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
                              _isSearchFieldChosen
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
                                color: _sortingTextFieldIndex != -1
                                    ? Theme.of(context).splashColor
                                    : Theme.of(context).disabledColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
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
            onTap: _isSearchFieldChosen
                ? null
                : () {
                    setState(() {
                      _changeSortFieldsVisibility(context);
                      StateSortedContainer.of(context).actionForButton();
                      StateSortedContainer.of(context)
                          .newSortedCriterion(SortingCriterion.byDateCreated);
                      focusNode.requestFocus();
                    });
                  },
          ),
          Expanded(
            child: Container(
              child: BlocBuilder<FilesBloc, FilesState>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 10.0),
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
                      ).copyWith(
                        suffix: _clearSearchButton(context),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _clearSearchButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 15, top: 3),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isClearSearchTextButtonHovered = false;
          });
          StateSortedContainer.of(context).searchAction('');
          _searchingFieldController.text = '';
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (event) {
            setState(() {
              isClearSearchTextButtonHovered = false;
            });
          },
          onHover: (event) {
            setState(() {
              isClearSearchTextButtonHovered = true;
            });
          },
          onExit: (event) {
            setState(() {
              isClearSearchTextButtonHovered = false;
            });
          },
          child: SvgPicture.asset(
            'assets/file_page/close.svg',
            height: 16,
            width: 16,
            alignment: Alignment.center,
            color: isClearSearchTextButtonHovered
                ? null
                : Theme.of(context).disabledColor,
          ),
        ),
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
                  },
                )
              : Container();
        },
      ),
    );
  }

  void _onActionSheetTap(BuildContext context, SortingElement item) {
    setState(() {
      isRemoveFilterButtonHovered = false;
      _sortingTextFieldIndex = _getSortingElements()
          .indexWhere((element) => element.text == item.text);
    });
    StateSortedContainer.of(context).newSortedCriterion(item.type);
  }

  void _push({required OpenedFolderView child, required String? folderId}) {
    setState(() {
      _openedFolders.add(child);
      index++;
    });

    StateContainer.of(context).changeChoosedFilesFolderId(folderId);
  }

  void _pop(int countOfPop) {
    for (var i = 0; i < countOfPop; i++) {
      setState(() {
        if (_openedFolders.length != 1) {
          _openedFolders.removeLast();
          index--;
        }
      });
    }

    final chosenFolder = _openedFolders[index].currentFolder?.id;

    StateContainer.of(context).changeChoosedFilesFolderId(chosenFolder);
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
    var chosenStyle = TextStyle(
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
            offset: Offset(0, 3),
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
                            style: ind == 0 ? chosenStyle : style,
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
                            style: ind == 1 ? chosenStyle : style,
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
                            style: ind == 2 ? chosenStyle : style,
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
                            style: ind == 3 ? chosenStyle : style,
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
