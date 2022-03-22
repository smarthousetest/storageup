import 'package:flutter/material.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

class BlurCreateAlbum extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();

  BlurCreateAlbum();
}

class _ButtonTemplateState extends State<BlurCreateAlbum> {
  var _textController = TextEditingController();
  S translate = getIt<S>();
  bool canSave = false;

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
                        translate.create_album,
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: kNormalTextFontFamily,
                          color: Color(0xff5F5F5F),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: Container(
                          width: 400,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: TextField(
                            textAlignVertical: TextAlignVertical.bottom,
                            textAlign: TextAlign.start,
                            autofocus: true,
                            controller: _textController,
                            onChanged: (_textController) {
                              _textController = _textController.trim();

                              if (_textController.length != 0)
                                setState(() {
                                  canSave = true;
                                });
                              if (_textController.length < 1)
                                setState(() {
                                  canSave = false;
                                });
                            },
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 15, bottom: 21),
                                hoverColor: Theme.of(context).cardColor,
                                focusColor: Theme.of(context).cardColor,
                                fillColor: Theme.of(context).cardColor,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Color(0xffE4E7ED), width: 0.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Color(0xffE4E7ED), width: 0.0),
                                ),
                                hintText: translate.new_album,
                                hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.color,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 14,
                                )),
                            style: TextStyle(
                              color: Theme.of(context).disabledColor,
                              fontFamily: kNormalTextFontFamily,
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
                                    translate.cancel,
                                    style: TextStyle(
                                      color: Theme.of(context).splashColor,
                                      fontSize: 16,
                                      fontFamily: kNormalTextFontFamily,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).cardColor,
                                    fixedSize: Size(140, 42),
                                    elevation: 0,
                                    side: BorderSide(
                                      style: BorderStyle.solid,
                                      color: Theme.of(context).splashColor,
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
                                    if (canSave == true)
                                      Navigator.pop(
                                        context,
                                        _textController.value.text.trim(),
                                      );
                                  },
                                  child: Text(
                                    translate.save,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: kNormalTextFontFamily,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: canSave
                                        ? Theme.of(context).splashColor
                                        : Theme.of(context).canvasColor,
                                    fixedSize: Size(240, 42),
                                    elevation: 0,
                                    side: BorderSide(
                                      style: BorderStyle.solid,
                                      color: canSave
                                          ? Theme.of(context).splashColor
                                          : Theme.of(context).canvasColor,
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
