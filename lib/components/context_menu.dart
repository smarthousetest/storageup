import 'package:cpp_native/models/base_object.dart';
import 'package:cpp_native/models/folder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';

import '../models/enums.dart';
import 'context_menu_lib.dart';

class ContextMenuRightTap extends StatefulWidget {
  ContextMenuRightTap(
      {required this.translate,
      required this.onTap,
      required this.child,
      required this.theme,
      Key? key})
      : super(key: key);

  final S translate;
  final Function(ContextMenuAction) onTap;
  final Widget child;
  final ThemeData theme;

  @override
  _ContextMenuRightTapState createState() => _ContextMenuRightTapState();
}

class _ContextMenuRightTapState extends State<ContextMenuRightTap> {
  @override
  Widget build(BuildContext context) {
    var mainColor = widget.theme.colorScheme.onSecondary;
    return ContextMenuArea(
      builder: (context) => [
        ListTile(
          iconColor: widget.theme.disabledColor,
          textColor: widget.theme.disabledColor,
          tileColor: widget.theme.primaryColor,
          hoverColor: mainColor,
          leading: SvgPicture.asset(
            'assets/options/add_files.svg',
            height: 20,
          ),
          title: Transform.translate(
            offset: Offset(-20, 0),
            child: Text(widget.translate.add_files,
                softWrap: false,
                overflow: TextOverflow.visible,
                style: TextStyle(
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 14,
                )),
          ),
          onTap: () {
            widget.onTap(ContextMenuAction.addFiles);
          },
        ),
        Divider(
          color: mainColor,
          height: 1,
        ),
        ListTile(
          iconColor: widget.theme.disabledColor,
          textColor: widget.theme.disabledColor,
          tileColor: widget.theme.primaryColor,
          hoverColor: mainColor,
          leading: SvgPicture.asset(
            'assets/options/create_folder.svg',
            height: 20,
          ),
          title: Transform.translate(
            offset: Offset(-20, 0),
            child: Text(widget.translate.create_a_folder,
                style: TextStyle(
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 14,
                )),
          ),
          onTap: () {
            widget.onTap(ContextMenuAction.createFolder);
          },
        )
      ],
      child: widget.child,
    );
  }
}

class FilesPopupMenuActions extends StatefulWidget {
  FilesPopupMenuActions(
      {required this.theme,
      required this.translate,
      required this.onTap,
      required this.object,
      Key? key})
      : super(key: key);

  final ThemeData theme;
  final S translate;
  final Function(FileAction) onTap;
  final BaseObject object;

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
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1), // changes position of shadow
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
                widget.object is Folder
                    ? GestureDetector(
                        onTap: () {
                          widget.onTap(FileAction.addFiles);
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
                            padding: EdgeInsets.only(left: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/options/add_files.svg',
                                  height: 20,
                                ),
                                Container(
                                  width: 15,
                                ),
                                Text(
                                  widget.translate.add_files,
                                  style: style,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Divider(
                  color: mainColor,
                  height: 1,
                ),
                GestureDetector(
                  onTap: () {
                    widget.onTap(FileAction.move);
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
                ),
                Divider(
                  color: mainColor,
                  height: 1,
                ),
                widget.object is! Folder
                    ? GestureDetector(
                        onTap: () {
                          widget.onTap(FileAction.save);
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
                                  widget.translate.down,
                                  style: style,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
                Divider(
                  color: mainColor,
                  height: 1,
                ),
                GestureDetector(
                  onTap: () {
                    widget.onTap(FileAction.rename);
                  },
                  child: MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        ind = 4;
                      });
                    },
                    child: Container(
                      width: 190,
                      height: 40,
                      color: ind == 4 ? mainColor : null,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      margin: EdgeInsets.zero,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/options/rename.svg',
                            height: 20,
                          ),
                          Container(
                            width: 15,
                          ),
                          Text(
                            widget.translate.rename,
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
                    widget.onTap(FileAction.properties);
                  },
                  child: MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        ind = 5;
                      });
                    },
                    child: Container(
                      width: 190,
                      height: 40,
                      color: ind == 5 ? mainColor : null,
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
                ),
                Divider(
                  color: mainColor,
                  height: 1,
                ),
                GestureDetector(
                  onTap: () {
                    widget.onTap(FileAction.delete);
                  },
                  child: MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        ind = 6;
                      });
                    },
                    child: GestureDetector(
                      onTap: () {
                        widget.onTap(FileAction.delete);
                      },
                      child: Container(
                        width: 190,
                        height: 40,
                        color: ind == 6
                            ? widget.theme.indicatorColor.withOpacity(0.1)
                            : null,
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: GestureDetector(
                          onTap: () {
                            widget.onTap(FileAction.delete);
                          },
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
