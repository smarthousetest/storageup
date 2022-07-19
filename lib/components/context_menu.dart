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
