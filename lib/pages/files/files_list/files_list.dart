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

class FilesList extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();

  FilesList();
}
// Widget Data Table

class _ButtonTemplateState extends State<FilesList> {
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
    S translate = getIt<S>();
    bool _isClicked = false;
    bool _liked = false;
    // TextStyle fileInfoStyle = TextStyle(
    //   fontSize: 14,
    //   fontFamily: kNormalTextFontFamily,
    // );

    return LayoutBuilder(
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
                      translate.format,
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
                    width: constraints.maxWidth * 0.2,
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
                          Text(
                            "Документация",
                            maxLines: 1,
                            style: style,
                          ),
                          Expanded(
                            flex: 30,
                            child: Container(),
                          ),
                          GestureDetector(
                            child: _liked
                                ? Image.asset(
                                    'assets/file_page/favorite.png',
                                    height: 18,
                                    width: 18,
                                    // color: Theme.of(context).splashColor,
                                  )
                                : Image.asset(
                                    'assets/file_page/not_favorite.png',
                                    height: 18,
                                    width: 18,
                                    // color: Theme.of(context).splashColor,
                                  ),
                            onTap: () {
                              setState(() {
                                var newValue = !_liked;
                                _liked = newValue;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          Text(
                            'DOCX',
                            maxLines: 1,
                            style: style,
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
                            style: style,
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
                            style: style,
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

          //   child: Row(
          //     children: [
          //       Container(
          //         width: 50,
          //         child: Text(
          //           'Name',
          //           style: style,
          //         ),
          //       ),
          //       Container(
          //         width: 500,
          //       ),
          //       Expanded(
          //         flex: 45,
          //         child: Container(),
          //       ),
          //       Container(
          //         width: 60,
          //         child: Text(
          //           'Type',
          //           style: style,
          //         ),
          //       ),
          //       Expanded(
          //         flex: 63,
          //         child: Container(),
          //       ),
          //       Container(
          //         width: 50,
          //         child: Text(
          //           'Date',
          //           style: style,
          //         ),
          //       ),
          //       Expanded(
          //         flex: 70,
          //         child: Container(),
          //       ),
          //       Container(
          //         width: 60,
          //         child: Text(
          //           'Размер',
          //           style: style,
          //         ),
          //       ),
          //       Container(
          //         width: 20,
          //       ),
          //       Expanded(
          //         flex: 60,
          //         child: Container(),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: 10,
          // ),
          // listDivider(context),
          // Expanded(
          //   child: ListView.builder(
          //       controller: _controller,
          //       scrollDirection: Axis.vertical,
          //       shrinkWrap: true,
          //       itemCount: 20,
          //       itemBuilder: (BuildContext context, int position) {
          //         // if (isPopupMenuButtonClicked.length < 20) {
          //         //   isPopupMenuButtonClicked.add(false);
          //         //   ifFavoritesPressedList.add(false);
          //         // }

          //         // var heartPath = ifFavoritesPressedList[position]
          //         //     ? 'assets/file_page/favorites.png'
          //         //     : 'assets/file_page/file_options/favorites.png';
          //         // print(heartPath);
          //         return FilesListElement(
          //           position: position,
          //         );
          //       }),
          // ),
          // listDivider(context),
          // SizedBox(
          //   height: 20,
          // )
        ],
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

class FilesListElement extends StatefulWidget {
  FilesListElement({Key? key, required this.position}) : super(key: key);
  int position;

  @override
  _FilesListElementState createState() => _FilesListElementState();
}

class _FilesListElementState extends State<FilesListElement> {
  bool _isClicked = false;
  bool _liked = false;
  @override
  Widget build(BuildContext context) {
    TextStyle redStyle = TextStyle(
      color: Theme.of(context).indicatorColor,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      fontFamily: kNormalTextFontFamily,
    );
    TextStyle style = TextStyle(
      color: Theme.of(context).textTheme.subtitle1?.color,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      fontFamily: kNormalTextFontFamily,
    );
    return Padding(
      padding: EdgeInsets.only(bottom: 7, top: widget.position == 0 ? 4 : 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 42,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                // Theme.of(context).disabledColor
                primary: _isClicked
                    ? Theme.of(context).dividerColor
                    : Theme.of(context).primaryColor,

                //       MaterialStateProperty.resolveWith<Color>(
                // (Set<MaterialState> states) {
                //   return Theme.of(context).primaryColor;
                // },
              ),
              onPressed: () {},
              child: Container(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/home_page/glad.jpg',
                        height: 25,
                        width: 25,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Container(
                        width: 466,
                        child: Text(
                          'text',
                          maxLines: 1,
                          style: style,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 15,
                      child: Container(),
                    ),
                    GestureDetector(
                      // splashRadius: 15,
                      child: _liked
                          ? Image.asset(
                              'assets/file_page/favorite.png',
                              height: 18,
                              width: 18,
                              // color: Theme.of(context).splashColor,
                            )
                          : Image.asset(
                              'assets/file_page/not_favorite.png',
                              height: 18,
                              width: 18,
                              // color: Theme.of(context).splashColor,
                            ),
                      onTap: () {
                        setState(() {
                          var newValue = !_liked;
                          _liked = newValue;
                        });
                      },
                    ),
                    Expanded(
                      flex: 50,
                      child: Container(),
                    ),
                    Container(
                      width: 50,
                      child: Text(
                        'DOCX',
                        maxLines: 1,
                        style: style,
                      ),
                    ),
                    Expanded(
                      flex: 88,
                      child: Container(),
                    ),
                    Container(
                      width: 55,
                      height: 17,
                      child: Text(
                        '01.05.21',
                        maxLines: 1,
                        style: style,
                      ),
                    ),
                    Expanded(
                      flex: 80,
                      child: Container(),
                    ),
                    Container(
                      width: 50,
                      height: 17,
                      child: Text(
                        '678 Кб',
                        maxLines: 1,
                        style: style,
                      ),
                    ),
                    Expanded(
                      flex: 55,
                      child: Container(),
                    ),
                    // PopupMenuButton<FileOptions>(
                    //   offset: Offset(10, 49),
                    //   iconSize: 20,
                    //   elevation: 2,
                    //   color: Theme.of(context).primaryColor,
                    //   padding: EdgeInsets.zero,
                    //   shape: RoundedRectangleBorder(
                    //     side: BorderSide(
                    //         width: 1, color: Theme.of(context).dividerColor),
                    //     borderRadius: BorderRadius.circular(5.0),
                    //   ),
                    //   icon: Image.asset(
                    //     'assets/file_page/file_options.png',
                    //   ),
                    //   onSelected: (_) {
                    //     setState(() {
                    //       _isClicked = false;
                    //     });
                    //   },
                    //   onCanceled: () {
                    //     setState(() {
                    //       _isClicked = false;
                    //     });
                    //   },
                    //   itemBuilder: (BuildContext context) {
                    //     setState(() {
                    //       _isClicked = true;
                    //     });
                    //     return [
                    //       PopupMenuItem(
                    //         height: 40,
                    //         child: Container(
                    //           width: 190,
                    //           child: Row(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               Image.asset(
                    //                 'assets/file_page/file_options/share.png',
                    //                 height: 20,
                    //               ),
                    //               Container(
                    //                 width: 15,
                    //               ),
                    //               Text(
                    //                 'Share',
                    //                 style: style,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       PopupMenuDivider(
                    //         height: 1,
                    //       ),
                    //       PopupMenuItem(
                    //         height: 40,
                    //         child: Container(
                    //           width: 170,
                    //           child: Row(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               Image.asset(
                    //                 'assets/file_page/file_options/move.png',
                    //                 height: 20,
                    //               ),
                    //               Container(
                    //                 width: 15,
                    //               ),
                    //               Text(
                    //                 'Move',
                    //                 style: style,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       PopupMenuDivider(
                    //         height: 1,
                    //       ),
                    //       PopupMenuItem(
                    //         height: 40,
                    //         child: Container(
                    //           width: 170,
                    //           child: Row(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               Image.asset(
                    //                 'assets/file_page/file_options/double.png',
                    //                 height: 20,
                    //               ),
                    //               Container(
                    //                 width: 15,
                    //               ),
                    //               Text(
                    //                 'Double',
                    //                 style: style,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       PopupMenuDivider(
                    //         height: 1,
                    //       ),
                    //       PopupMenuItem(
                    //         height: 40,
                    //         child: Container(
                    //           width: 170,
                    //           child: Row(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               Image.asset(
                    //                 'assets/file_page/file_options/favorites.png',
                    //                 height: 20,
                    //               ),
                    //               Container(
                    //                 width: 15,
                    //               ),
                    //               Text(
                    //                 'Add to favorites',
                    //                 style: style,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       PopupMenuDivider(
                    //         height: 1,
                    //       ),
                    //       PopupMenuItem(
                    //         height: 40,
                    //         child: Container(
                    //           width: 170,
                    //           child: Row(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               Image.asset(
                    //                 'assets/file_page/file_options/download.png',
                    //                 height: 20,
                    //               ),
                    //               Container(
                    //                 width: 15,
                    //               ),
                    //               Text(
                    //                 'Download',
                    //                 style: style,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       PopupMenuDivider(
                    //         height: 1,
                    //       ),
                    //       PopupMenuItem(
                    //         height: 40,
                    //         child: Container(
                    //           width: 170,
                    //           child: Row(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               Image.asset(
                    //                 'assets/file_page/file_options/rename.png',
                    //                 height: 20,
                    //               ),
                    //               Container(
                    //                 width: 15,
                    //               ),
                    //               Text(
                    //                 'Rename',
                    //                 style: style,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       PopupMenuDivider(
                    //         height: 1,
                    //       ),
                    //       PopupMenuItem(
                    //         height: 40,
                    //         child: Container(
                    //           width: 170,
                    //           child: Row(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               Image.asset(
                    //                 'assets/file_page/file_options/info.png',
                    //                 height: 20,
                    //               ),
                    //               Container(
                    //                 width: 15,
                    //               ),
                    //               Text(
                    //                 'Info',
                    //                 style: style,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //       PopupMenuDivider(
                    //         height: 1,
                    //       ),
                    //       PopupMenuItem(
                    //         height: 40,
                    //         child: Container(
                    //           width: 170,
                    //           child: Row(
                    //             crossAxisAlignment: CrossAxisAlignment.center,
                    //             children: [
                    //               Image.asset(
                    //                 'assets/file_page/file_options/trash.png',
                    //                 height: 20,
                    //               ),
                    //               Container(
                    //                 width: 15,
                    //               ),
                    //               Text(
                    //                 'Delete',
                    //                 style: redStyle,
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ];
                    //   },
                    // ),
                    // Container(
                    //   width: 30,
                    //   height: 30,
                    //   color: Colors.amber,
                    // ),
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
