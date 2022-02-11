import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/components/custom_progress_bar.dart';
import 'keeper_info.dart';

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
  List<String> dirPath;
  final List<KeeperInfo> keeperInfo;
  List<int> countGb = [0];
  FolderList(this.keeperInfo, this.dirPath, this.countGb);
}

class _ButtonTemplateState extends State<FolderList> {
  // List<bool> ifFavoritesPressedList = [];
  // List<bool> isPopupMenuButtonClicked = [];
  ScrollController _controller = ScrollController();

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

    // TextStyle fileInfoStyle = TextStyle(
    //   fontSize: 14,
    //   fontFamily: kNormalTextFontFamily,
    // );

    return Padding(
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
                      //width: constraints.maxWidth * 0.1,
                      child: Text(
                        translate.size,
                        style: style,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      //width: constraints.maxWidth * 0.1,
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
                  widget.dirPath.length,
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
                              widget.dirPath[index],
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
                              '${widget.countGb[index]} GB',
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
                              PopupMenuButton<FileOptions>(
                                offset: Offset(10, 49),
                                iconSize: 20,
                                elevation: 2,
                                color: Theme.of(context).primaryColor,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 1,
                                      color: Theme.of(context).dividerColor),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                icon: Image.asset(
                                  'assets/file_page/file_options.png',
                                ),
                                onSelected: (_) {
                                  setState(() {
                                    _isClicked = false;
                                  });
                                },
                                onCanceled: () {
                                  setState(() {
                                    _isClicked = false;
                                  });
                                },
                                itemBuilder: (BuildContext context) {
                                  setState(() {
                                    _isClicked = true;
                                  });
                                  return [
                                    PopupMenuItem(
                                      height: 40,
                                      child: Container(
                                        width: 170,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/file_page/file_options/rename.png',
                                              height: 20,
                                            ),
                                            Container(
                                              width: 15,
                                            ),
                                            Text(
                                              'Изменить',
                                              style: cellTextStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    PopupMenuDivider(
                                      height: 1,
                                    ),
                                    PopupMenuItem(
                                      height: 40,
                                      child: Container(
                                        width: 170,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/file_page/file_options/trash.png',
                                              height: 20,
                                            ),
                                            Container(
                                              width: 15,
                                            ),
                                            Text(
                                              'Удалить',
                                              style: redStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ];
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
