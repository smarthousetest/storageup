import 'package:flutter/material.dart';
import 'package:upstorage_desktop/components/blur/menu_upload.dart';
import 'package:upstorage_desktop/models/enums.dart';

class BlurCreateAlbum extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();

  BlurCreateAlbum();
}

class _ButtonTemplateState extends State<BlurCreateAlbum> {
  var _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
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
                        'Создание альбома',
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
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.center,
                          child: TextField(
                            textAlignVertical: TextAlignVertical.bottom,
                            textAlign: TextAlign.start,
                            autofocus: true,
                            controller: _textController,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                hintText: 'Новый альбом',
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
                                    Navigator.pop(context);
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
                                    Navigator.pop(
                                      context,
                                      _textController.value.text,
                                    );
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
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
