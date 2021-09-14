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
  CustomDirButton({required this.name,  this.onTap});
}

class _ButtonTemplateState extends State<CustomDirButton> {
  Future<void> _onPointerDown(PointerDownEvent event) async {
    if (event.kind == PointerDeviceKind.mouse &&
        event.buttons == kSecondaryMouseButton) {
      final overlay =
          Overlay.of(context)!.context.findRenderObject() as RenderBox;
      final menuItem = await showMenu<int>(
          context: context,
          color: Colors.white,
          items: [
            PopupMenuItem(
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/file_page/upload.svg',
                      width: 20,
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Text(
                        'Добавить файлы',
                        style: TextStyle(
                          color: Color(0xff7D7D7D),
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
                    Image.asset(
                      'assets/home_page/glad.jpg',
                      width: 20,
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Text(
                        'Копировать',
                        style: TextStyle(
                          color: Color(0xff7D7D7D),
                        ),
                      ),
                    ),
                  ],
                ),
                value: 2),
            PopupMenuItem(
                child: Row(
                  children: [
                    Image.asset(
                      'assets/home_page/glad.jpg',
                      width: 20,
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Text(
                        'Вырезать',
                        style: TextStyle(
                          color: Color(0xff7D7D7D),
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
                      'assets/file_page/rename.svg',
                      width: 20,
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                      child: Text(
                        'Переименовать',
                        style: TextStyle(
                          color: Color(0xff7D7D7D),
                        ),
                      ),
                    ),
                  ],
                ),
                value: 4),
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
                          color: Color(0xff7D7D7D),
                        ),
                      ),
                    ),
                  ],
                ),
                value: 5),
            PopupMenuItem(
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
                          color: Color(0xff7D7D7D),
                        ),
                      ),
                    ),
                  ],
                ),
                value: 6),
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
<<<<<<< Updated upstream
              elevation: 0,
=======
            ],
          ),
          onPressed: () async {
            var str = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return BlurRename();
              },
            );
            print(str);
            dirs_list.add(CustomDirButton(
              name: str,
            ));
            context.findAncestorStateOfType<_ButtonTemplateState>();
            // print(dirs_list.length);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                width: 2,
                color: Color(0xffF1F8FE),
              ),
>>>>>>> Stashed changes
            ),
          ),
          onPointerDown: _onPointerDown,
        ),
      ),
    );
  }
}
