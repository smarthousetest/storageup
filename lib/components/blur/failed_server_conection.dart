import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

class BlurFailedServerConnection extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();
  BlurFailedServerConnection();
}

class _ButtonTemplateState extends State<BlurFailedServerConnection> {
  S translate = getIt<S>();
  bool delete = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 520,
        height: 215,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translate.error,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        fontFamily: kNormalTextFontFamily,
                        color: Color(0xff5F5F5F),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Text(
                        translate.server_connection_error,
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
                        translate.check_ethernet_connection,
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
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  translate.ok,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: kNormalTextFontFamily,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xff70BBF6),
                                  fixedSize: Size(73, 42),
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
