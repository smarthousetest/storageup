import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class CustomDirButton extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();
  String name;
  TextEditingController? dir_name;
  Function()? onTap;
  CustomDirButton({required this.name, this.onTap});
}

class _ButtonTemplateState extends State<CustomDirButton> {
  Future<void> _onPointerDown(PointerDownEvent event) async {
    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons == kSecondaryMouseButton) {
      final overlay =
          Overlay.of(context)!.context.findRenderObject() as RenderBox;
      final menuItem = await showMenu<int>(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
          context: context,
          color: Colors.white,
          items: [
            PopupMenuItem(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/file_page/like.svg',
                      width: 20,
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Text(
                        'В избранное',
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                value: 1),
            PopupMenuItem(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/file_page/save_dir.svg',
                      width: 20,
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Text(
                        'Скачать',
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                value: 2),
            PopupMenuItem(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/file_page/rename.svg',
                      width: 20,
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Text(
                        'Переименовать',
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                value: 3),
            PopupMenuItem(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/file_page/info.svg',
                      width: 20,
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Text(
                        'Свойства',
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                value: 4),
            PopupMenuItem(
                child: Container(
                  color: Theme.of(context).indicatorColor.withAlpha(30),
                  height: 43,
                  width: 189,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/file_page/trash.svg',
                        width: 20,
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                        child: Text(
                          'Удалить',
                          style: TextStyle(
                            color: Theme.of(context).indicatorColor,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                value: 5),
          ],
          position: RelativeRect.fromSize(
              event.position & Size(48.0, 48.0), overlay.size));
      // Check if menu item clicked
      switch (menuItem) {
        case 1:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Добавлено'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 1),
          ));
          break;
        case 2:
          print('');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Скопировано'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 1),
          ));
          break;
        case 3:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Вырезано'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 1),
          ));
          break;
        case 4:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Переименовано'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
              action: SnackBarAction(
                label: '',
                onPressed: () {},
              ),
            ),
          );

          break;
        case 5:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Свойства'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 1),
          ));
          break;
        case 6:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Удалено'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 1),
          ));
          break;
        default:
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 31),
      child: Container(
        width: 140,
        height: 140,
        child: Listener(
          child: ElevatedButton(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: SvgPicture.asset(
                    'assets/home_page/files_r.svg',
                    height: 58,
                    width: 58,
                  ),
                ),
                Text(
                  widget.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Lato',
                    color: Color(0xff7D7D7D),
                  ),
                ),
              ],
            ),
            onPressed: widget.onTap,
            /*onPressed: () async {
              var str = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BlurRename();
                },
              );
              print(str);
              setState(() {
                dirs_list.add(
                  CustomDirButton(
                    name: str,
                  ),
                );
              });
              // print(dirs_list.length);
            },*/
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  width: 2,
                  color: Color(0xffF1F8FE),
                ),
              ),
              elevation: 0,
            ),
          ),
          onPointerDown: _onPointerDown,
        ),
      ),
    );
  }
}
