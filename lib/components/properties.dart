import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/utilities/injection.dart';

class PropertiesView extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();
  PropertiesView();
}

class _ButtonTemplateState extends State<PropertiesView> {
  S translate = getIt<S>();
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 30, top: 30, bottom: 30, left: 0),
        child: Container(
            width: 320,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Color.fromARGB(25, 23, 69, 139),
                    blurRadius: 4,
                    offset: Offset(1, 4))
              ],
            ),
            child: ListView(controller: ScrollController(), children: [
              Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                height: 46,
                                width: 46,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(23),
                                ),
                                child: Image.asset('assets/home_page/man.jpg'),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    "Александр Рождественский",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color:
                                          Theme.of(context).bottomAppBarColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  "votreaa@mail.ru",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: Divider(
                            height: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Center(
                            child: Text(
                              translate.properties,
                              style: TextStyle(
                                color: Theme.of(context).focusColor,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Center(
                            child: SvgPicture.asset(
                                "assets/file_page/word_big.svg"),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Center(
                            child: Text(
                              "Документация",
                              style: TextStyle(
                                color: Theme.of(context).disabledColor,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 0, top: 25, right: 0),
                          child: Container(
                            width: 260,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      translate.size,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground,
                                        fontFamily: kNormalTextFontFamily,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 100,
                                      child: Container(),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "678 Кб",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          fontFamily: kNormalTextFontFamily,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 18),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        translate.type,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          fontFamily: kNormalTextFontFamily,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 100,
                                        child: Container(),
                                      ),
                                      Text(
                                        "Файл",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          fontFamily: kNormalTextFontFamily,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 18),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        translate.format,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          fontFamily: kNormalTextFontFamily,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 100,
                                        child: Container(),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "TXT",
                                          textAlign: TextAlign.end,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            fontFamily: kNormalTextFontFamily,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 18),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        translate.created,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          fontFamily: kNormalTextFontFamily,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 100,
                                        child: Container(),
                                      ),
                                      Text(
                                        "12 мая 2021 г., 23:37",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          fontFamily: kNormalTextFontFamily,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 18),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        translate.changed,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          fontFamily: kNormalTextFontFamily,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 100,
                                        child: Container(),
                                      ),
                                      Text(
                                        "25 июня 2021 г., 21:20",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          fontFamily: kNormalTextFontFamily,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 18),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        translate.viewed,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          fontFamily: kNormalTextFontFamily,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 100,
                                        child: Container(),
                                      ),
                                      Text(
                                        "сегодня, 15:11",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          fontFamily: kNormalTextFontFamily,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 18),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        translate.location,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          fontFamily: kNormalTextFontFamily,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 100,
                                        child: Container(),
                                      ),
                                      Text(
                                        "папка «Документы»",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          fontFamily: kNormalTextFontFamily,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 0, top: 25, bottom: 30),
                          child: Container(
                            height: 42,
                            width: 260,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(double.maxFinite, 60),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: Theme.of(context).splashColor,
                              ),
                              child: Text(
                                translate.open,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ])),
            ])));
  }
}
