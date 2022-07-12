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
    int ind = -1;
    return ContextMenuArea(
      builder: (context) => [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: IntrinsicWidth(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onTap(ContextMenuAction.addFiles);
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
                          SvgPicture.asset(
                            'assets/options/add_files.svg',
                            height: 20,
                            color: ind == 0
                                ? widget.theme.splashColor
                                : widget.theme.disabledColor,
                          ),
                          Container(
                            width: 15,
                          ),
                          Text(widget.translate.add_files,
                              style: TextStyle(
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 14,
                                color: ind == 0
                                    ? widget.theme.splashColor
                                    : widget.theme.disabledColor,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    widget.onTap(ContextMenuAction.createFolder);
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
                          SvgPicture.asset(
                            'assets/options/create_folder.svg',
                            height: 20,
                            color: ind == 1
                                ? widget.theme.splashColor
                                : widget.theme.disabledColor,
                          ),
                          Container(
                            width: 15,
                          ),
                          Text(widget.translate.create_a_folder,
                              style: TextStyle(
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 14,
                                color: ind == 1
                                    ? widget.theme.splashColor
                                    : widget.theme.disabledColor,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
      child: widget.child,
    );
  }
}
