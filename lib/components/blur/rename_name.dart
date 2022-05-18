import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/components/blur/failed_server_conection.dart';
import 'package:upstorage_desktop/components/blur/something_goes_wrong.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

import '../../models/enums.dart';
import '../../utilites/services/auth_service.dart';

class BlurRenameName extends StatefulWidget {
  final String name;
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();
  BlurRenameName(this.name);
}

class _ButtonTemplateState extends State<BlurRenameName> {
  S translate = getIt<S>();
  AuthService _authController = getIt<AuthService>();
  var myController = TextEditingController();
  bool canSave = false;
  bool hintColor = true;

  @override
  void initState() {
    myController = TextEditingController(text: widget.name);
    super.initState();
  }

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
              height: 235,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
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
                            translate.user_name,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: kNormalTextFontFamily,
                              color: Theme.of(context).focusColor,
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(
                                translate.wrong_username,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: kNormalTextFontFamily,
                                  color: hintColor
                                      ? Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                      : Theme.of(context).errorColor,
                                ),
                              ),
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
                              child: TextFormField(
                                controller: myController,
                                autofocus: true,
                                onChanged: (myController) {
                                  print(myController);
                                  myController = myController.trim();
                                  if (myController.isEmpty ||
                                      myController.length <= 2) {
                                    setState(() {
                                      canSave = false;
                                      hintColor = false;
                                    });
                                  }
                                  if (myController.isNotEmpty &&
                                      myController.length > 2) {
                                    setState(() {
                                      canSave = true;
                                      hintColor = true;
                                    });
                                  }
                                },
                                style: TextStyle(
                                    color: Theme.of(context).disabledColor,
                                    fontSize: 14,
                                    fontFamily: kNormalTextFontFamily),
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(left: 15, bottom: 8),
                                  hoverColor: Theme.of(context).cardColor,
                                  focusColor: Theme.of(context).cardColor,
                                  fillColor: Theme.of(context).cardColor,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 0.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 0.0),
                                  ),
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
                                        primary: Theme.of(context).primaryColor,
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
                                      onPressed: () async {
                                        if (canSave) {
                                          final result =
                                              await _authController.changeName(
                                                  name: myController.value.text
                                                      .trim());
                                          Navigator.pop(context,
                                              myController.value.text.trim());
                                          if (result ==
                                              AuthenticationStatus
                                                  .externalError) {
                                            await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return BlurSomethingGoesWrong(
                                                    true);
                                              },
                                            );
                                          } else if (result ==
                                              AuthenticationStatus.noInternet) {
                                            await showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return BlurFailedServerConnection(
                                                    true);
                                              },
                                            );
                                          }
                                        }
                                        print(widget.name);
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
                            child:
                                SvgPicture.asset('assets/file_page/close.svg')),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
