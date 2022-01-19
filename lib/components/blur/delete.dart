import 'package:flutter/material.dart';
import 'package:upstorage_desktop/pages/home/home_view.dart';

class BlurDelete extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();
  Blur blurItem;
  BlurDelete({required this.blurItem});
}

class _ButtonTemplateState extends State<BlurDelete> {
  @override
  Widget build(BuildContext context) {
    return Center(
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
                      'Удаление',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Lato',
                        color: Color(0xff5F5F5F),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Text('Вы действительно хотите удалить'),
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
                                onPressed: () {},
                                child: Text(
                                  'Удалить',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: 'Lato',
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xffFF847E),
                                  fixedSize: Size(240, 42),
                                  elevation: 0,
                                  side: BorderSide(
                                    style: BorderStyle.solid,
                                    color: Color(0xffFF847E),
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
    );
  }
}
