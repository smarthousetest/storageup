import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upstorage_desktop/pages/files/file_view.dart';

class CustomDirButton extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();
  String name;

  CustomDirButton({required this.name});
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
                    Text(
                      'Добавить файлы',
                      style: TextStyle(
                        color: Color(0xff7D7D7D),
                      ),
                    ),
                  ],
                ),
                value: 1),
            PopupMenuItem(
                child: Text(
                  'Копировать',
                  style: TextStyle(
                    color: Color(0xff7D7D7D),
                  ),
                ),
                value: 2),
            PopupMenuItem(
                child: Text(
                  'Вырезать',
                  style: TextStyle(
                    color: Color(0xff7D7D7D),
                  ),
                ),
                value: 3),
            PopupMenuItem(
                child: Text(
                  'Переименовать',
                  style: TextStyle(
                    color: Color(0xff7D7D7D),
                  ),
                ),
                value: 4),
            PopupMenuItem(
                child: Text(
                  'Свойства',
                  style: TextStyle(
                    color: Color(0xff7D7D7D),
                  ),
                ),
                value: 5),
            PopupMenuItem(
                child: Text(
                  'Удалить',
                  style: TextStyle(
                    color: Color(0xff7D7D7D),
                  ),
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
          ));
          break;
        case 2:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Скопировано'),
              behavior: SnackBarBehavior.floating));
          break;
        case 3:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Вырезано'),
              behavior: SnackBarBehavior.floating));
          break;
        case 4:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Переименовано'),
              behavior: SnackBarBehavior.floating));
          break;
        case 5:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Свойства'),
              behavior: SnackBarBehavior.floating));
          break;
        case 6:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Удалено'),
              behavior: SnackBarBehavior.floating));
          break;
        default:
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          onPressed: () {
            dirs_list.add(
            CustomDirButton(
              name: 'Создать\n папку',
            ));
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
            ),
            elevation: 0,
          ),
        ),
        onPointerDown: _onPointerDown,
      ),
    );
  }
}


