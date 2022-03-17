import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/pages/auth/auth_bloc.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

class BlurChangePassword extends StatefulWidget {
  //ValueSetter? callback;
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();
  BlurChangePassword();
}

class ChangePasswordPopupResult {
  String oldPassword;
  String newPassword;
  ChangePasswordPopupResult(this.oldPassword, this.newPassword);
}

class _ButtonTemplateState extends State<BlurChangePassword> {
  S translate = getIt<S>();
  //final myController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final _oldPass = TextEditingController();

  final _pass = TextEditingController();
  final _confirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Material(
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
                              padding: const EdgeInsets.only(top: 10),
                              child: TextFormField(
                                controller: _oldPass,
                                onChanged: (content) {},
                                style: TextStyle(
                                    color: Theme.of(context).disabledColor,
                                    fontSize: 14,
                                    fontFamily: kNormalTextFontFamily),
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(left: 15, bottom: 8),
                                  hintText: translate.old_password,
                                  hintStyle: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        ?.color,
                                    fontFamily: kNormalTextFontFamily,
                                    fontSize: 15,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).accentColor,
                                        width: 1.5),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: Color(0xffE4E7ED), width: 1.5),
                                  ),
                                ),
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
                              padding: const EdgeInsets.only(top: 10),
                              child: Form(
                                key: _form,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      validator: (val) {
                                        if (val != null) {
                                          if (val.isEmpty) return 'Empty';
                                        }
                                        return null;
                                      },
                                      controller: _pass,
                                      onChanged: (content) {},
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).disabledColor,
                                          fontSize: 14,
                                          fontFamily: kNormalTextFontFamily),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            left: 15, bottom: 8),
                                        hintText: translate.new_password,
                                        hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline1
                                              ?.color,
                                          fontFamily: kNormalTextFontFamily,
                                          fontSize: 15,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                              color:
                                                  Theme.of(context).accentColor,
                                              width: 1.5),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                              color: Color(0xffE4E7ED),
                                              width: 1.5),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: TextFormField(
                                        validator: (val) {
                                          if (val != null) {
                                            if (val.isEmpty) return 'Empty';
                                            if (val != _pass.text)
                                              return 'Not Match';
                                          }
                                          return null;
                                        },
                                        controller: _confirmPass,
                                        onChanged: (content) {},
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).disabledColor,
                                            fontSize: 14,
                                            fontFamily: kNormalTextFontFamily),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(
                                              left: 15, bottom: 8),
                                          hintText: translate.repeat_passsword,
                                          hintStyle: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .headline1
                                                ?.color,
                                            fontFamily: kNormalTextFontFamily,
                                            fontSize: 15,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                                color: Theme.of(context)
                                                    .accentColor,
                                                width: 1.5),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                                color: Color(0xffE4E7ED),
                                                width: 1.5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
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
                                            color:
                                                Theme.of(context).splashColor,
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
                                            color:
                                                Theme.of(context).splashColor,
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
                                          _form.currentState!.validate();
                                          Navigator.pop(
                                              context,
                                              ChangePasswordPopupResult(
                                                  _oldPass.value.text,
                                                  _confirmPass.value.text));
                                        },
                                        child: Text(
                                          translate.save,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16,
                                            fontFamily: kNormalTextFontFamily,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary: // _form.currentState.validate()
                                              Theme.of(context).splashColor,
                                          // Theme.of(context).primaryColor,
                                          fixedSize: Size(240, 42),
                                          elevation: 0,
                                          side: BorderSide(
                                            style: BorderStyle.solid,
                                            color:
                                                Theme.of(context).splashColor,
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
                        padding: EdgeInsets.only(right: 10, top: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: SvgPicture.asset(
                                  'assets/file_page/close.svg')),
                        )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
