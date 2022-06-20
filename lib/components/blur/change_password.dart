import 'dart:ui';
import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:os_specification/os_specification.dart';
import 'package:upstorage_desktop/components/blur/failed_server_conection.dart';
import 'package:upstorage_desktop/components/blur/something_goes_wrong.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/pages/auth/auth_bloc.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/pages/auth/auth_view.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

import '../../utilites/services/auth_service.dart';

class BlurChangePassword extends StatefulWidget {
  //ValueSetter? callback;
  User user;

  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();

  BlurChangePassword(
    this.user,
  );
}

class ChangePasswordPopupResult {
  String oldPassword;
  String newPassword;

  ChangePasswordPopupResult(
    this.oldPassword,
    this.newPassword,
  );
}

class _ButtonTemplateState extends State<BlurChangePassword> {
  S translate = getIt<S>();

  //final myController = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final _oldPass = TextEditingController();

  final _pass = TextEditingController();
  final _confirmPass = TextEditingController();
  AuthService _authController = getIt<AuthService>();
  bool canSaveNew = false;
  bool canSaveConfirm = false;
  bool wrongOldPass = true;
  bool canSaveHint = true;
  bool oldPassword = true;
  bool hintBorder1 = true;
  bool hintBorder2 = true;
  bool hideText1 = true;
  bool hideText2 = true;
  bool hideText3 = true;

  void _hider1() {
    setState(() {
      hideText1 = !hideText1;
    });
  }

  void _hider2() {
    setState(() {
      hideText2 = !hideText2;
    });
  }

  void _hider3() {
    setState(() {
      hideText3 = !hideText3;
    });
  }

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
                height: 420,
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
                        height: 420,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
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
                              padding: wrongOldPass ? const EdgeInsets.only(top: 28) : const EdgeInsets.only(top: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  wrongOldPass ? " " : translate.wrong_old_password,
                                  style: TextStyle(
                                    fontSize: wrongOldPass ? 0 : 14,
                                    fontFamily: kNormalTextFontFamily,
                                    color: Theme.of(context).errorColor,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: TextFormField(
                                obscureText: hideText1,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
                                ],
                                controller: _oldPass,
                                onChanged: (content) {
                                  setState(() {
                                    wrongOldPass = true;
                                  });
                                },
                                style: TextStyle(
                                  color: Theme.of(context).disabledColor,
                                  fontSize: 14,
                                  fontFamily: kNormalTextFontFamily,
                                ),
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(left: 15, bottom: 8),
                                  hintText: translate.old_password,
                                  hintStyle: TextStyle(
                                    color: Theme.of(context).textTheme.headline1?.color,
                                    fontFamily: kNormalTextFontFamily,
                                    fontSize: 14,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: wrongOldPass ? Theme.of(context).accentColor : Theme.of(context).errorColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                      color: wrongOldPass ? Color(0xffE4E7ED) : Theme.of(context).errorColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  suffixIcon: InkWell(
                                      onTap: _hider1,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 25,
                                          vertical: 10.5,
                                        ),
                                        child: Image(
                                          width: 26.0,
                                          height: 26.0,
                                          image: AssetImage(hideText1 ? 'assets/hide_password.png' : 'assets/show_password.png'),
                                        ),
                                      )),
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
                              padding: const EdgeInsets.only(top: 5),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  translate.new_password_8,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: kNormalTextFontFamily,
                                    color: (hintBorder1 && hintBorder2) ? Theme.of(context).colorScheme.onBackground : Theme.of(context).errorColor,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: canSaveHint ? const EdgeInsets.only(top: 0) : const EdgeInsets.only(top: 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  canSaveHint ? "" : translate.passwords_dont_match,
                                  style: TextStyle(
                                    fontSize: canSaveHint ? 0 : 14,
                                    fontFamily: kNormalTextFontFamily,
                                    color: Theme.of(context).errorColor,
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
                                      obscureText: hideText2,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
                                      ],
                                      validator: (val) {
                                        if (val != null) {
                                          if (val.isEmpty) return 'Empty';
                                        }
                                        return null;
                                      },
                                      controller: _pass,
                                      onChanged: (content) {
                                        if (content.isEmpty || content.length < 8) {
                                          setState(() {
                                            canSaveHint = false;
                                            hintBorder1 = false;
                                            canSaveNew = false;
                                          });
                                        }
                                        if (content.isNotEmpty && content.length >= 8) {
                                          setState(() {
                                            hintBorder1 = true;
                                            canSaveNew = true;
                                            canSaveHint = false;
                                            canSaveConfirm = false;

                                            if (_confirmPass.text == _pass.text) {
                                              canSaveConfirm = true;
                                              canSaveHint = true;
                                            }
                                          });
                                        }
                                      },
                                      style: TextStyle(
                                        color: Theme.of(context).disabledColor,
                                        fontSize: 14,
                                        fontFamily: kNormalTextFontFamily,
                                      ),
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 15, bottom: 8),
                                        hintText: translate.new_password,
                                        hintStyle: TextStyle(
                                          color: Theme.of(context).textTheme.headline1?.color,
                                          fontFamily: kNormalTextFontFamily,
                                          fontSize: 14,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                            color: hintBorder1 ? Theme.of(context).accentColor : Theme.of(context).errorColor,
                                            width: 1.5,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                          borderSide: BorderSide(
                                            color: hintBorder1 ? Color(0xffE4E7ED) : Theme.of(context).errorColor,
                                            width: 1.5,
                                          ),
                                        ),
                                        suffixIcon: InkWell(
                                            onTap: _hider2,
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10.5),
                                              child: Image(
                                                width: 26.0,
                                                height: 26.0,
                                                image: AssetImage(hideText2 ? 'assets/hide_password.png' : 'assets/show_password.png'),
                                              ),
                                            )),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: TextFormField(
                                        obscureText: hideText3,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
                                        ],
                                        validator: (val) {
                                          if (val != null) {
                                            if (val.isEmpty) return 'Empty';
                                            if (val != _pass.text) return 'Not Match';
                                          }
                                          return null;
                                        },
                                        controller: _confirmPass,
                                        onChanged: (content) {
                                          if (content.isEmpty || content.length < 8) {
                                            setState(() {
                                              hintBorder2 = false;
                                              canSaveConfirm = false;
                                              canSaveHint = false;
                                            });
                                          } else if (content.isNotEmpty && content.length >= 8) {
                                            setState(() {
                                              hintBorder2 = true;
                                              canSaveHint = false;
                                              canSaveConfirm = false;
                                              if (_confirmPass.text == _pass.text) {
                                                canSaveConfirm = true;
                                                canSaveHint = true;
                                              }
                                            });
                                          }
                                        },
                                        style: TextStyle(
                                          color: Theme.of(context).disabledColor,
                                          fontSize: 14,
                                          fontFamily: kNormalTextFontFamily,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.only(left: 15, bottom: 8),
                                          hintText: translate.repeat_password,
                                          hintStyle: TextStyle(
                                            color: Theme.of(context).textTheme.headline1?.color,
                                            fontFamily: kNormalTextFontFamily,
                                            fontSize: 14,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                              color: hintBorder2 ? Theme.of(context).colorScheme.secondary : Theme.of(context).errorColor,
                                              width: 1.5,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10.0),
                                            borderSide: BorderSide(
                                              color: hintBorder2 ? Color(0xffE4E7ED) : Theme.of(context).errorColor,
                                              width: 1.5,
                                            ),
                                          ),
                                          suffixIcon: InkWell(
                                              onTap: _hider3,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10.5),
                                                child: Image(
                                                  width: 26.0,
                                                  height: 26.0,
                                                  image: AssetImage(hideText3 ? 'assets/hide_password.png' : 'assets/show_password.png'),
                                                ),
                                              )),
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
                                          null;
                                          print(widget.key); //?????
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
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 20),
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          if (canSaveConfirm == true) {
                                            _form.currentState!.validate();
                                            final result = await _authController.changePassword(
                                              oldPassword: _oldPass.value.text,
                                              newPassword: _confirmPass.value.text,
                                            );
                                            if (result == AuthenticationStatus.wrongPassword) {
                                              setState(() {
                                                wrongOldPass = false;
                                              });
                                            } else if (result == AuthenticationStatus.authenticated) {
                                              var hashedPassword = new DBCrypt().hashpw(_confirmPass.value.text, new DBCrypt().gensalt());
                                              var os = OsSpecifications.getOs();
                                              os.setKeeperHash(widget.user.email!, hashedPassword);
                                              setState(() {
                                                wrongOldPass = true;
                                                _showReAuthDialog();
                                              });
                                            } else if (result == AuthenticationStatus.unauthenticated) {
                                              Navigator.pop(context);
                                              await showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return BlurSomethingGoesWrong(true);
                                                },
                                              );
                                            } else {
                                              Navigator.pop(context);
                                              await showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return BlurFailedServerConnection(true);
                                                },
                                              );
                                            }
                                            /* Navigator.pop(
                                              context,
                                              ChangePasswordPopupResult(
                                                  _oldPass.value.text,
                                                  _confirmPass.value.text));
                                                  */
                                          }
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
                                          primary: // _form.currentState.validate()
                                              canSaveNew && canSaveConfirm ? Theme.of(context).splashColor : Theme.of(context).canvasColor,
                                          // Theme.of(context).primaryColor,
                                          fixedSize: Size(240, 42),
                                          elevation: 0,
                                          side: BorderSide(
                                            style: BorderStyle.solid,
                                            color: canSaveNew && canSaveConfirm ? Theme.of(context).splashColor : Theme.of(context).canvasColor,
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
                        padding: EdgeInsets.only(right: 10, top: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: SvgPicture.asset('assets/file_page/close.svg'),
                          ),
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

  void _showReAuthDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              translate.notification_re_auth,
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                fontSize: 20,
                fontFamily: kNormalTextFontFamily,
                color: Theme.of(context).focusColor,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                  left: 200,
                  right: 200,
                  top: 30,
                  bottom: 10,
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pushNamedAndRemoveUntil(context, AuthView.route, (route) => false);
                  },
                  child: Text(
                    translate.ok,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontFamily: kNormalTextFontFamily,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: // _form.currentState.validate()
                        Theme.of(context).splashColor,

                    // Theme.of(context).primaryColor,
                    fixedSize: Size(100, 42),
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
            ],
          );
        });
  }
}
