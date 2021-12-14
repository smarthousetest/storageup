import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:upstorage_desktop/components/password_text_field.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/pages/auth/models/password.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

class BlurChangePassword extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();
  BlurChangePassword();
}

class _ButtonTemplateState extends State<BlurChangePassword> {
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
              width: 520,
              height: 374,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(60, 0, 0, 0),
                    child: Container(
                      width: 400,
                      height: 374,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Text(
                              translate.change_Password,
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: kNormalTextFontFamily,
                                color: Theme.of(context).focusColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: PasswordTextField(
                              hint: translate.old_password,
                              onChange: (Password) {},
                              onFinishEditing: (Password) {},
                              invalid: false,
                              isPassword: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Container(
                              height: 1,
                              width: 400,
                              decoration: BoxDecoration(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                translate.new_password_8,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: kNormalTextFontFamily,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: PasswordTextField(
                              hint: translate.new_password,
                              onChange: (Password) {},
                              onFinishEditing: (Password) {},
                              invalid: false,
                              isPassword: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: PasswordTextField(
                              hint: translate.repeat_passsword,
                              onChange: (Password) {},
                              onFinishEditing: (Password) {},
                              invalid: false,
                              isPassword: true,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
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
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(
                                            context, myController.text);
                                      },
                                      child: Text(
                                        translate.save,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16,
                                          fontFamily: kNormalTextFontFamily,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Theme.of(context).splashColor,
                                        fixedSize: Size(240, 42),
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
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).splashColor,
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
        ],
      ),
    );
  }
}
