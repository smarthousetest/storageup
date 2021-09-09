import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upstorage_desktop/pages/home/home_view.dart';

class BlurRename extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();
  BlurRename();
}

class _ButtonTemplateState extends State<BlurRename> {
  final myController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
              ),
              child: Container(
                color: Colors.black.withAlpha(25),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 520,
              height: 212,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(60, 25, 0, 0),
                    child: Container(
                      width: 400,
                      height: 212,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Переименовать',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Lato',
                              color: Color(0xff5F5F5F),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Container(
                              width: 400,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Color(0xffF7F9FB),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: TextField(
                                controller: myController,
                                textAlignVertical: TextAlignVertical.bottom,
                                textAlign: TextAlign.start,
                                autofocus: true,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                    ),
                                    hintText: 'Новое имя',
                                    hintStyle: TextStyle(
                                      color: Color(0xff7D7D7D),
                                      fontFamily: 'Lato',
                                      fontSize: 14,
                                    )),
                                style: TextStyle(
                                  color: Color(0xff7D7D7D),
                                  fontFamily: 'Lato',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 26),
                            child: Container(
                              width: 400,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: ElevatedButton(
                                      onPressed: () {
                                      },
                                      child: Text(
                                        'Отмена',
                                        style: TextStyle(
                                          color: Color(0xff70BBF6),
                                          fontSize: 16,
                                          fontFamily: 'Lato',
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        fixedSize: Size(140, 42),
                                        elevation: 0,
                                        side: BorderSide(
                                          style: BorderStyle.solid,
                                          color: Color(0xff70BBF6),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context, myController.text);
                                      },
                                      child: Text(
                                        'Сохранить',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontFamily: 'Lato',
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Color(0xff70BBF6),
                                        fixedSize: Size(240, 42),
                                        elevation: 0,
                                        side: BorderSide(
                                          style: BorderStyle.solid,
                                          color: Color(0xff70BBF6),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 60,
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xff70BBF6),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}