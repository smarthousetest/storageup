import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

class BlurDeleteKeeper extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();
  BlurDeleteKeeper();
}

class _ButtonTemplateState extends State<BlurDeleteKeeper> {
  S translate = getIt<S>();
  bool delete = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
              child: Container(
                width: 400,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      translate.realy_delete_keeper,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: kNormalTextFontFamily,
                        color: Color(0xff5F5F5F),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 90, top: 25),
                      child: Text(
                        translate.delete_keeper_text1,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: kNormalTextFontFamily,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 205),
                      child: Text(
                        translate.delete_keeper_text2,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: kNormalTextFontFamily,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        translate.delete_keeper_text3,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: kNormalTextFontFamily,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Container(
                        width: 420,
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
                                    color: Color(0xff70BBF6),
                                    fontSize: 16,
                                    fontFamily: kNormalTextFontFamily,
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
                                  Navigator.pop(context, delete);
                                },
                                child: Text(
                                  translate.delete,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: kNormalTextFontFamily,
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
            Align(
              alignment: FractionalOffset.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, right: 22),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: SvgPicture.asset("assets/file_page/close.svg"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
