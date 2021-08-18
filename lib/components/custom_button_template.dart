import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomMenuButton extends StatefulWidget {
  final String icon, title;

  @override
  _ButtomTemplateState createState() => new _ButtomTemplateState();

  CustomMenuButton({required this.icon, required this.title});
}

class _ButtomTemplateState extends State<CustomMenuButton> {
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
  CustomMenuButton(
    icon: "assets/home_page/home.svg",
    title: "Главная",
  ),
  CustomMenuButton(
    icon: "assets/home_page/files.svg",
    title: "Файлы",
  ),
  CustomMenuButton(
    icon: "assets/home_page/media.svg",
    title: "Медиа",
  ),
  CustomMenuButton(
    icon: "assets/home_page/like.svg",
    title: "Избранное",
  ),
  CustomMenuButton(
    icon: "assets/home_page/sell_space.svg",
    title: "Сдача места",
  ),
  CustomMenuButton(
    icon: "assets/home_page/finance.svg",
    title: "Финансы",
  ),
  CustomMenuButton(
    icon: "assets/home_page/gear.svg",
    title: "Настройки",
  ),
  CustomMenuButton(
    icon: "assets/home_page/trash.svg",
    title: "Корзина",
  ),
];
