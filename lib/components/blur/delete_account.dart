import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/utilities/injection.dart';

class BlurDeletingAccount extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();
  BlurDeletingAccount();
}

class _ButtonTemplateState extends State<BlurDeletingAccount> {
  S translate = getIt<S>();
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
              width: 700,
              height: 518,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 25, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 200),
                          child: Text(
                            translate.accaunt_deleting,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: kNormalTextFontFamily,
                              color: Theme.of(context).focusColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            translate.permanently_delete +
                                "\n" +
                                translate.in_StorageUp,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: kNormalTextFontFamily,
                              color: Theme.of(context).focusColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Text(
                            translate.cannot_recovered,
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: kNormalTextFontFamily,
                              color: Theme.of(context).focusColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Row(
                            children: [
                              Text(
                                translate.before_deleting,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: kNormalTextFontFamily,
                                  color: Theme.of(context).focusColor,
                                ),
                              ),
                              GestureDetector(
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Text(
                                    translate.contact_us,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: kNormalTextFontFamily,
                                      color: Theme.of(context).splashColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                translate.we_can_help,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: kNormalTextFontFamily,
                                  color: Theme.of(context).focusColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 22),
                          child: Container(
                            width: 400,
                            height: 42,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: TextFormField(
                              style: TextStyle(
                                  color: Theme.of(context).disabledColor,
                                  fontSize: 14,
                                  fontFamily: kNormalTextFontFamily),
                              decoration: InputDecoration(
                                hintText: translate.enter_password,
                                hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.color,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 15,
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: 15, bottom: 8),
                                hoverColor: Theme.of(context).primaryColor,
                                focusColor: Theme.of(context).primaryColor,
                                fillColor: Theme.of(context).primaryColor,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Color(0xffE4E7ED), width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Color(0xffE4E7ED), width: 1.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            translate.reason_deleting,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: kNormalTextFontFamily,
                              color: Theme.of(context).focusColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: 600,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: TextFormField(
                              maxLines: 9,
                              style: TextStyle(
                                  color: Theme.of(context).disabledColor,
                                  fontSize: 14,
                                  fontFamily: kNormalTextFontFamily),
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 15.0),
                                hintText: translate.tell_us,
                                hintStyle: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.color,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 15,
                                ),
                                hoverColor: Theme.of(context).primaryColor,
                                focusColor: Theme.of(context).primaryColor,
                                fillColor: Theme.of(context).primaryColor,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Color(0xffE4E7ED), width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Color(0xffE4E7ED), width: 1.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 26),
                          child: Container(
                            width: 600,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context, myController.text);
                                  },
                                  child: Text(
                                    translate.delete_permanently,
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontSize: 16,
                                      fontFamily: kNormalTextFontFamily,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Theme.of(context).indicatorColor,
                                    fixedSize: Size(240, 42),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Container(
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
                                        primary: Colors.white,
                                        fixedSize: Size(140, 42),
                                        elevation: 0,
                                        side: BorderSide(
                                          style: BorderStyle.solid,
                                          color: Theme.of(context).splashColor,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
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
                  Align(
                    alignment: FractionalOffset.topRight,
                    child: Container(
                      width: 60,
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).splashColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
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
