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
  var textController = TextEditingController();
  S translate = getIt<S>();
  bool canSave = false;
  bool hintSymbvols = true;

  String? get mediaRootFolderId => mediaRootFolderId;

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
                        padding: hintSymbvols
                            ? EdgeInsets.only(top: 0)
                            : EdgeInsets.only(top: 5),
                        child: Text(
                          translate.wrong_symbvols,
                          style: TextStyle(
                            fontSize: hintSymbvols ? 0 : 14,
                            fontFamily: kNormalTextFontFamily,
                            color: hintSymbvols
                                ? Colors.white
                                : Theme.of(context).errorColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: hintSymbvols
                            ? EdgeInsets.only(top: 25)
                            : EdgeInsets.only(top: 5),
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
                            controller: textController,
                            onChanged: (textController) {
                              textController = textController.trim();
                              if (textController.contains(
                                          RegExp(r'[\\/:*?\"<>|]'), 0) ==
                                      true &&
                                  textController.isNotEmpty) {
                                setState(() {
                                  hintSymbvols = false;
                                  canSave = false;
                                });
                              } else if (textController.isNotEmpty) {
                                setState(() {
                                  hintSymbvols = true;
                                  canSave = true;
                                });
                              } else {
                                setState(() {
                                  hintSymbvols = true;
                                  canSave = false;
                                });
                              }
                            },
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  left: 15,
                                  bottom: 21,
                                ),
                                hoverColor: Theme.of(context).cardColor,
                                focusColor: Theme.of(context).cardColor,
                                fillColor: Theme.of(context).cardColor,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Color(0xffE4E7ED),
                                    width: 0.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                    color: Color(0xffE4E7ED),
                                    width: 0.0,
                                  ),
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
                                  onPressed: () async {
                                    if (canSave == true) {
                                      Navigator.pop(
                                        context,
                                        textController.value.text.trim(),
                                      );
                                    } else {
                                      null;
                                    }
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
