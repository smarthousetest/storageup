import 'package:flutter/material.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

class OpenedFolderView extends StatefulWidget {
  OpenedFolderView({
    Key? key,
    required this.currentFolder,
    required this.previousFolders,
    required this.pop,
    required this.push,
  }) : super(key: key);

  final Folder currentFolder;
  final List<Folder> previousFolders;
  final Function(Widget) push;
  final Function() pop;

  @override
  _OpenedFolderViewState createState() => _OpenedFolderViewState();
}

class _OpenedFolderViewState extends State<OpenedFolderView> {
  S translate = getIt<S>();
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(bottom: 30, top: 30),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Color.fromARGB(25, 23, 69, 139),
                blurRadius: 4,
                offset: Offset(1, 4))
          ],
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ..._pathRow(widget.previousFolders, widget.currentFolder),
              ],
            ),
          ],
        ),
      ),
    ));
  }

  List<Widget> _pathRow(List<Folder> folders, Folder currentFolder) {
    List<Widget> path = [];
    List<Folder> allPath = folders;
    allPath.add(currentFolder);

    var textStyle = TextStyle(
      color: Theme.of(context).colorScheme.onBackground,
      fontFamily: kNormalTextFontFamily,
      fontSize: 20,
    );
    for (var i = 0; i < allPath.length; i++) {
      Widget pathWidget = GestureDetector(
        onTap:
            allPath.length == 1 || i == allPath.length - 1 ? null : widget.pop,
        child: MouseRegion(
          cursor: allPath.length == 0 || i == allPath.length - 1
              ? SystemMouseCursors.basic
              : SystemMouseCursors.click,
          child: Text(
            i == 0 ? translate.files : allPath[i].name!,
            style: textStyle,
          ),
        ),
      );

      path.add(pathWidget);

      if (i != allPath.length - 1) {
        var seporator = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            '/',
            style: textStyle,
          ),
        );

        path.add(seporator);
      }
    }
    return path;
  }
}
