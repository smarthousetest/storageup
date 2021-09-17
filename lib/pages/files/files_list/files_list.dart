import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/pages/home/home_view.dart';

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

class _ButtonTemplateState extends State<FilesList> {
  List<bool> ifFavoritesPressedList = [];
  List<bool> ifFileOptionsPressed = [];
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
    // TextStyle fileInfoStyle = TextStyle(
    //   fontSize: 14,
    //   fontFamily: kNormalTextFontFamily,
    // );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            children: [
              Container(
                width: 50,
                child: Text(
                  'Name',
                  style: style,
                ),
              ),
              Container(
                width: 500,
              ),
              Expanded(
                flex: 45,
                child: Container(),
              ),
              Container(
                width: 60,
                child: Text(
                  'Type',
                  style: style,
                ),
              ),
              Expanded(
                flex: 63,
                child: Container(),
              ),
              Container(
                width: 50,
                child: Text(
                  'Date',
                  style: style,
                ),
              ),
              Expanded(
                flex: 70,
                child: Container(),
              ),
              Container(
                width: 60,
                child: Text(
                  'Размер',
                  style: style,
                ),
              ),
              Container(
                width: 20,
              ),
              Expanded(
                flex: 60,
                child: Container(),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(40, 0, 40, 4),
          child: Divider(
            height: 1,
            color: Theme.of(context).cardColor,
          ),
        ),
        Expanded(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: 20,
              itemBuilder: (BuildContext context, int position) {
                ifFileOptionsPressed.add(false);
                bool ifFavoritesPressed = true;
                ifFavoritesPressedList.add(ifFavoritesPressed);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 7),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 42,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              // Theme.of(context).disabledColor
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return Theme.of(context).primaryColor;
                            },
                          )),
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
                                IconButton(
                                  splashRadius: 5,
                                  icon: Image.asset(
                                    'assets/file_page/favorites.png',
                                    height: 18,
                                    width: 18,
                                    color: ifFavoritesPressedList[position]
                                        ? Theme.of(context).splashColor
                                        : Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      ifFavoritesPressedList[position] =
                                          !ifFavoritesPressedList[position];
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
                                PopupMenuButton<FileOptions>(
                                  offset: Offset(10, 49),
                                  iconSize: 30,
                                  color: Theme.of(context).primaryColor,
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: Theme.of(context)
                                          .dividerColor
                                          .withOpacity(0.1),
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  icon: Image.asset(
                                    'assets/file_page/file_options.png',
                                  ),
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem(
                                        child: Container(
                                          width: 170,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/file_page/file_options/share.png',
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
                                        child: Container(
                                          width: 170,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/file_page/file_options/move.png',
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
                                        child: Container(
                                          width: 170,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/file_page/file_options/double.png',
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
                                        child: Container(
                                          width: 170,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/file_page/file_options/favorites.png',
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
                                        child: Container(
                                          width: 170,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/file_page/file_options/download.png',
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
                                        child: Container(
                                          width: 170,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/file_page/file_options/rename.png',
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
                                        child: Container(
                                          width: 170,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/file_page/file_options/info.png',
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
                                        child: Container(
                                          width: 170,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/file_page/file_options/trash.png',
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
              }),
        ),
      ],
    );
  }
}
