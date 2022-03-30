import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/pages/sell_space/folder_list/folder_list_bloc.dart';
import 'package:upstorage_desktop/pages/sell_space/folder_list/folder_list_event.dart';
import 'package:upstorage_desktop/pages/sell_space/folder_list/folder_list_state.dart';
import 'package:upstorage_desktop/pages/sell_space/space_state.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/download_location.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/components/custom_progress_bar.dart';

enum FileOptions {
  share,
  move,
  double,
  toFavorites,
  download,
  rename,
  info,
  remove,
}

class FolderList extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();

  FolderList();
}

class _ButtonTemplateState extends State<FolderList> {
  // List<bool> ifFavoritesPressedList = [];
  // List<bool> isPopupMenuButtonClicked = [];
  List<DownloadLocation> locationsInfo = [];
  List<CustomPopupMenuController> _popupControllers = [];
  void _initiatingControllers(FolderListState state) {
    if (_popupControllers.isEmpty) {
      locationsInfo.forEach((element) {
        _popupControllers.add(CustomPopupMenuController());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
    S translate = getIt<S>();

    return BlocProvider(
      create: (context) => FolderListBloc()..add(FolderListPageOpened()),
      child: BlocBuilder<FolderListBloc, FolderListState>(
        builder: (context, state) {
          locationsInfo = state.locationsInfo;
          return LayoutBuilder(
            builder: (context, constraints) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: DataTable(
                      columnSpacing: 0,
                      horizontalMargin: 0,
                      columns: [
                        DataColumn(
                          label: Container(
                            width: constraints.maxWidth * 0.05,
                            child: Text(
                              translate.name,
                              style: style,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: constraints.maxWidth * 0.45,
                            child: Text(
                              translate.path,
                              style: style,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: constraints.maxWidth * 0.05,
                            child: Text(
                              translate.size,
                              overflow: TextOverflow.visible,
                              style: style,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: constraints.maxWidth * 0.05,
                            child: Text(
                              translate.date,
                              overflow: TextOverflow.visible,
                              style: style,
                            ),
                          ),
                        ),
                        DataColumn(
                          label: Container(
                            width: constraints.maxWidth * 0.1,
                            child: Text(
                              translate.trust_level,
                              overflow: TextOverflow.visible,
                              style: style,
                            ),
                          ),
                        ),
                      ],
                      rows: state.locationsInfo.map((element) {
                        return DataRow.byIndex(
                          index: state.locationsInfo.indexOf(element),
                          cells: [
                            DataCell(
                              SizedBox(
                                width: constraints.maxWidth * 0.07,
                                child: Text(
                                  element.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: cellTextStyle,
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  SizedBox(
                                    width: constraints.maxWidth * 0.4,
                                    child: Text(
                                      element.dirPath,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: cellTextStyle,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  Text(
                                    translate.gb(element.countGb),
                                    maxLines: 1,
                                    style: cellTextStyle,
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Row(
                                children: [
                                  Text(
                                    DateFormat.yMd().format(DateTime.now()),
                                    //widget.keeperInfo[index].dateTime,
                                    maxLines: 1,
                                    style: cellTextStyle,
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Theme(
                                data: Theme.of(context).copyWith(
                                  hoverColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      '70',
                                      //'${widget.keeperInfo[index].trustLevel}%',
                                      maxLines: 1,
                                      style: cellTextStyle,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 20),
                                      child: SizedBox(
                                        width: 100,
                                        child: MyProgressBar(
                                          bgColor:
                                              Theme.of(context).dividerColor,
                                          color: Theme.of(context).splashColor,
                                          percent: 70,
                                          // (widget.keeperInfo[index].trustLevel)!
                                          //     .toDouble(),
                                        ),
                                      ),
                                    ),
                                    // Expanded(
                                    //   flex: 1,
                                    //   child: Container(),
                                    // ),
                                    BlocBuilder<FolderListBloc,
                                        FolderListState>(
                                      // bloc: _bloc,
                                      builder: (context, state) {
                                        _initiatingControllers(state);
                                        // var controller =
                                        //     CustomPopupMenuController();
                                        if (state.locationsInfo.length >
                                            _popupControllers.length) {
                                          _popupControllers = [];
                                          _initiatingControllers(state);
                                        }
                                        return CustomPopupMenu(
                                          pressType: PressType.singleClick,
                                          barrierColor: Colors.transparent,
                                          showArrow: false,
                                          horizontalMargin: 10,
                                          verticalMargin: 0,
                                          controller: _popupControllers[state
                                              .locationsInfo
                                              .indexOf(element)],
                                          menuBuilder: () {
                                            return KeeperPopupMenuActions(
                                              theme: Theme.of(context),
                                              translate: translate,
                                              onTap: (action) {
                                                _popupControllers[state
                                                        .locationsInfo
                                                        .indexOf(element)]
                                                    .hideMenu();
                                                if (action ==
                                                    KeeperAction.change) {
                                                } else {
                                                  context
                                                      .read<FolderListBloc>()
                                                      .add(DeleteLocation(
                                                          location: element));
                                                  setState(() {});
                                                }
                                              },
                                            );
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
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList()),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Padding listDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
      child: Divider(
        height: 1,
        color: Theme.of(context).cardColor,
      ),
    );
  }
}

class KeeperPopupMenuActions extends StatefulWidget {
  KeeperPopupMenuActions(
      {required this.theme,
      required this.translate,
      required this.onTap,
      Key? key})
      : super(key: key);

  final ThemeData theme;
  final S translate;
  final Function(KeeperAction) onTap;
  @override
  _KeeperPopupMenuActionsState createState() => _KeeperPopupMenuActionsState();
}

class _KeeperPopupMenuActionsState extends State<KeeperPopupMenuActions> {
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
                  onTapDown: (_) {
                    widget.onTap(KeeperAction.change);
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
                          Image.asset(
                            'assets/file_page/file_options/rename.png',
                            height: 20,
                          ),
                          Container(
                            width: 15,
                          ),
                          Text(
                            widget.translate.change,
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
                  onTapDown: (_) {
                    widget.onTap(KeeperAction.delete);
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
