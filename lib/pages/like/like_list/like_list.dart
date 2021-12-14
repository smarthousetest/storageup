import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

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

class LikeList extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();

  LikeList();
}

class _ButtonTemplateState extends State<LikeList> {
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
      fontWeight: FontWeight.w700,
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: LayoutBuilder(
        builder: (context, constraints) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: double.infinity,
              child: DataTable(
                columnSpacing: 20,
                columns: [
                  DataColumn(
                    label: Container(
                      width: constraints.maxWidth * 0.4,
                      child: Text(
                        translate.name,
                        style: style,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      width: constraints.maxWidth * 0.07,
                      child: Text(
                        translate.format,
                        style: style,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Container(
                      width: constraints.maxWidth * 0.07,
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
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(
                        Row(
                          children: [
                            Image.asset(
                              'assets/file_page/word.png',
                              height: 24,
                              width: 24,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
                            Text(
                              "Документация",
                              maxLines: 1,
                              style: cellTextStyle,
                            ),
                            Expanded(
                              flex: 30,
                              child: Container(),
                            ),
                            GestureDetector(
                                child: Image.asset(
                              'assets/file_page/favorite.png',
                              height: 18,
                              width: 18,
                              // color: Theme.of(context).splashColor,
                            )),
                          ],
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            Text(
                              'DOCX',
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
                              '01.05.21',
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
                              '678 Кб',
                              maxLines: 1,
                              style: cellTextStyle,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(),
                            ),
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
                                      width: 190,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            'assets/file_page/file_options/share.png',
                                            height: 20,
                                          ),
                                          Container(
                                            width: 15,
                                          ),
                                          Text(
                                            'Share',
                                            style: style,
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
                                            'assets/file_page/file_options/move.png',
                                            height: 20,
                                          ),
                                          Container(
                                            width: 15,
                                          ),
                                          Text(
                                            'Move',
                                            style: style,
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
                                            'assets/file_page/file_options/double.png',
                                            height: 20,
                                          ),
                                          Container(
                                            width: 15,
                                          ),
                                          Text(
                                            'Double',
                                            style: style,
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
                                            'assets/file_page/file_options/favorites.png',
                                            height: 20,
                                          ),
                                          Container(
                                            width: 15,
                                          ),
                                          Text(
                                            'Add to favorites',
                                            style: style,
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
                                            'assets/file_page/file_options/download.png',
                                            height: 20,
                                          ),
                                          Container(
                                            width: 15,
                                          ),
                                          Text(
                                            'Download',
                                            style: style,
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
                                            'assets/file_page/file_options/rename.png',
                                            height: 20,
                                          ),
                                          Container(
                                            width: 15,
                                          ),
                                          Text(
                                            'Rename',
                                            style: style,
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
                                            'assets/file_page/file_options/info.png',
                                            height: 20,
                                          ),
                                          Container(
                                            width: 15,
                                          ),
                                          Text(
                                            'Info',
                                            style: style,
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
                                            'Delete',
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
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding listDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
      child: Divider(
        height: 1,
        color: Theme.of(context).cardColor,
      ),
    );
  }
}
