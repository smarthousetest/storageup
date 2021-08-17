import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LeftButtonsColumn extends StatefulWidget {
  final String icon, title;

  @override
  _ButtomTemplateState createState() => new _ButtomTemplateState();

  LeftButtonsColumn({required this.icon, required this.title});
}

class _ButtomTemplateState extends State<LeftButtonsColumn> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 5),
      child: SizedBox(
        width: 214,
        height: 44,
        child: ElevatedButton.icon(
          onPressed: () {},
            label: Text(widget.title),
          icon: SvgPicture.asset(widget.icon),
          style: ElevatedButton.styleFrom(
            alignment: Alignment.centerLeft,
            primary: Colors.white,
            onPrimary: const Color.fromARGB(255, 156, 156, 156),
            shadowColor: const Color.fromARGB(0, 0, 0, 0),
            side: const BorderSide(
              style: BorderStyle.none,
            ),
            textStyle:
                const TextStyle(fontSize: 17, fontWeight: FontWeight.normal),
          ),


        ),
      ),
    );
  }
}

List buttons = [
  LeftButtonsColumn(
    icon: "assets/home_page/home.svg",
    title: "Главная",
  ),
  LeftButtonsColumn(
    icon: "assets/home_page/files.svg",
    title: "Файлы",
  ),
  LeftButtonsColumn(
    icon: "assets/home_page/media.svg",
    title: "Медиа",
  ),
  LeftButtonsColumn(
    icon: "assets/home_page/like.svg",
    title: "Избранное",
  ),
  LeftButtonsColumn(
    icon: "assets/home_page/sell_space.svg",
    title: "Сдача места",
  ),
  LeftButtonsColumn(
    icon: "assets/home_page/finance.svg",
    title: "Финансы",
  ),
  LeftButtonsColumn(
    icon: "assets/home_page/gear.svg",
    title: "Настройки",
  ),
  LeftButtonsColumn(
    icon: "assets/home_page/trash.svg",
    title: "Корзина",
  ),
];
