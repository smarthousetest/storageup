import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlurRename extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();

  BlurRename();
}

class _ButtonTemplateState extends State<BlurRename> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 520,
        height: 210,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(478, 0, 20, 0),
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Color(0xff70BBF6),
                ),
                onPressed: () {},
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 180),
              child: Text(
                'Переименовать',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Lato',
                  color: Color(0xff5F5F5F),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(60, 25, 60, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffF7F9FB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: 'Enter a search term',
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
              padding: const EdgeInsets.fromLTRB(0, 26, 0, 0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 298),
                      child: ElevatedButton(
                        onPressed: () {},
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
                          fixedSize: Size(94, 36),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 57, 0),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        'Ок',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Lato',
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff70BBF6),
                        fixedSize: Size(53, 36),
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
            )
          ],
        ),
      ),
    );
  }
}
