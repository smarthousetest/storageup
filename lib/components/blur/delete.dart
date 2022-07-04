import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/utilities/injection.dart';

class BlurDelete extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();

  BlurDelete();
}

class _ButtonTemplateState extends State<BlurDelete> {
  S translate = getIt<S>();
  bool delete = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 520,
        height: 193,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(60, 30, 0, 0),
              child: Container(
                width: 420,
                height: 193,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      translate.deleting,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: kNormalTextFontFamily,
                        color: Color(0xff5F5F5F),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Text(
                        translate.realy_delete,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: kNormalTextFontFamily,
                          color: Theme.of(context).disabledColor,
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
                padding: const EdgeInsets.only(top: 20, right: 15),
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
