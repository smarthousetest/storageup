import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/pages/home/home_view.dart';

enum ChoosedPage {
  home,
  file,
  media,
  like,
  sell_space,
  finance,
  settings,
  trash,
}

class CustomMenuButton extends StatefulWidget {
  final String icon, title;
  Function() function;

  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();

  CustomMenuButton(
      {required this.icon, required this.title, required this.function});
}

class _ButtonTemplateState extends State<CustomMenuButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 5),
      child: SizedBox(
        width: 214,
        height: 44,
        child: ElevatedButton.icon(
          onPressed: widget.function,
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
