import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/pages/sell_space/space_bloc.dart';
import 'package:upstorage_desktop/pages/sell_space/space_event.dart';
import 'package:upstorage_desktop/pages/sell_space/space_state.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/download_location.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/components/custom_progress_bar.dart';
import 'package:upstorage_desktop/utilites/state_info_container.dart';

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

// 79313064863
class FolderList extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();
  List<DownloadLocation> locationsInfo;
  FolderList(this.locationsInfo);
}

class _ButtonTemplateState extends State<FolderList> {
  // List<bool> ifFavoritesPressedList = [];
  // List<bool> isPopupMenuButtonClicked = [];

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      color: Theme.of(context).textTheme.subtitle1?.color,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      fontFamily: kNormalTextFontFamily,
    );
    TextStyle redStyle = TextStyle(
      color: Theme.of(context).indicatorColor,
      fontSize: 14,
      fontFamily: kNormalTextFontFamily,
    );
    TextStyle cellTextStyle = TextStyle(
      color: Theme.of(context).textTheme.subtitle1?.color,
      fontSize: 14,
      fontFamily: kNormalTextFontFamily,
    );
    S translate = getIt<S>();
    bool _isClicked = false;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: LayoutBuilder(
          builder: (context, constraints) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: DataTable(
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
                        width: constraints.maxWidth * 0.05,
                        child: Text(
                          translate.size,
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
                        width: constraints.maxWidth * 0.25,
                        child: Text(
                          translate.trust_level,
                          style: style,
                        ),
                      ),
                    ),
                  ],
                  rows: List<DataRow>.generate(
                    widget.locationsInfo.length,
                    (int index) => DataRow(
                      cells: [
                        DataCell(
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/file_page/folder.svg',
                                height: 24,
                                width: 24,
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(),
                              ),
                              Text(
                                widget.locationsInfo[index].dirPath,
                                maxLines: 1,
                                style: cellTextStyle,
                              ),
                              Expanded(
                                flex: 8,
                                child: Container(),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Row(
                            children: [
                              Text(
                                translate
                                    .gb(widget.locationsInfo[index].countGb),
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
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 30),
                                  child: SizedBox(
                                    width: 100,
                                    child: MyProgressBar(
                                      bgColor: Theme.of(context).dividerColor,
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
                                BlocBuilder<SpaceBloc, SpaceState>(
                                  // bloc: _bloc,
                                  builder: (context, snapshot) {
                                    var controller =
                                        CustomPopupMenuController();
                                    return CustomPopupMenu(
                                      pressType: PressType.singleClick,
                                      barrierColor: Colors.transparent,
                                      showArrow: false,
                                      horizontalMargin: 10,
                                      verticalMargin: 0,
                                      controller: controller,
                                      menuBuilder: () {
                                        return KeeperPopupMenuActions(
                                          theme: Theme.of(context),
                                          translate: translate,
                                          onTap: (action) {
                                            //controller.hideMenu();
                                            if (action == KeeperAction.change) {
                                              controller.hideMenu();
                                            } else
                                              context.read<SpaceBloc>().add(
                                                  DeleteLocation(
                                                      location:
                                                          widget.locationsInfo[
                                                              index]));
                                            controller.hideMenu();
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
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
                  onTap: widget.onTap(KeeperAction.change),
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
                  onTap: () {
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
