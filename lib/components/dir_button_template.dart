import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomDirButton extends StatefulWidget {

  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();

  CustomDirButton();
}

class _ButtonTemplateState extends State<CustomDirButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      child: ElevatedButton(
        child: Column(
          children: [
            Text(
                'Создать\n папку',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Lato',
                color: Color(0xff7D7D7D),
              ),
            ),
          ],
        ),
        onPressed: () {},
        style: ElevatedButton.styleFrom(
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(10),
           side: BorderSide(
             width: 2,
             color: Color(0xffF1F8FE),

           )
         )
        ),
      ),
    );
  }
}

List<Widget> dirs_list = [];
