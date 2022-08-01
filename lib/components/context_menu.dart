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
      required this.contextAction,
      Key? key})
      : super(key: key);

  final S translate;
  final Function(ContextMenuAction) onTap;
  final Widget child;
  final ThemeData theme;
  final WhereFromContextMenu contextAction;

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
            widget.contextAction == WhereFromContextMenu.files
                ? 'assets/options/add_files.svg'
                : 'assets/options/add_media.svg',
            height: 20,
          ),
          title: Transform.translate(
            offset: Offset(-20, 0),
            child: Text(
                widget.contextAction == WhereFromContextMenu.files
                    ? widget.translate.add_files
                    : widget.translate.add_media,
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
            widget.contextAction == WhereFromContextMenu.files
                ? 'assets/options/create_folder.svg'
                : 'assets/options/create_album.svg',
            height: 20,
          ),
          title: Transform.translate(
            offset: Offset(-20, 0),
            child: Text(
                widget.contextAction == WhereFromContextMenu.files
                    ? widget.translate.create_a_folder
                    : widget.translate.create_album,
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
