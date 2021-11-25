import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/pages/sell_space/folder_list/folder_list.dart';
import 'package:upstorage_desktop/utilities/injection.dart';
import 'package:file_picker/file_picker.dart';

class FinancePage extends StatefulWidget {
  @override
  _FinancePageState createState() => _FinancePageState();
  FinancePage();
}

class _FinancePageState extends State<FinancePage> {
  S translate = getIt<S>();
  var index = 0;
  Widget build(BuildContext context) {
    return Expanded(
      // Padding(
      //   padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
      //   child:
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
          child: Container(
            height: 46,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Container(
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
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(23.0),
                          child: Image.asset('assets/home_page/man.jpg'),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              "Александр Рождественский",
                              style: TextStyle(
                                fontSize: 17,
                                color: Theme.of(context).bottomAppBarColor,
                              ),
                            ),
                          ),
                          Text(
                            "votreaa@mail.ru",
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).bottomAppBarColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: IndexedStack(
            index: index,
            children: [
              Column(
                children: [subscriptionManagement(context)],
              ),
              Column(
                children: [withdrawFunds(context)],
              ),
            ],
          ),
        )
      ]),
    );
  }

  Widget subscriptionManagement(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
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
            alignment: Alignment.center,
            child: ListView(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 20),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              child: Text(
                                translate.management,
                                style: TextStyle(
                                  color: Theme.of(context).focusColor,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              index = 1;
                              print(index);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Container(
                                child: Text(
                                  translate.funds,
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .subtitle1
                                        ?.color,
                                    fontFamily: kNormalTextFontFamily,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
                ),
                Stack(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 40, top: 15, right: 40),
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, top: 14),
                    child: Container(
                      width: 220,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Theme.of(context).splashColor,
                      ),
                    ),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 30),
                  child: Container(
                    child: Text(
                      translate.active_sub,
                      style: TextStyle(
                        color: Theme.of(context).focusColor,
                        fontFamily: kNormalTextFontFamily,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40, top: 30),
                    child: Container(
                      width: 510,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Theme.of(context).splashColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Color.fromARGB(25, 23, 69, 139),
                              blurRadius: 4,
                              offset: Offset(1, 4))
                        ],
                      ),
                    ),
                  ),
                ]),
              ]),
            ])),
      ),
    );
  }

  Widget withdrawFunds(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
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
            alignment: Alignment.center,
            child: ListView(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 20),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              index = 0;
                              print(index);
                            });
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              child: Text(
                                translate.management,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.color,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Container(
                                child: Text(
                                  translate.funds,
                                  style: TextStyle(
                                    color: Theme.of(context).focusColor,
                                    fontFamily: kNormalTextFontFamily,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
                ),
                Stack(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 40, top: 15, right: 40),
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 285, top: 14),
                    child: Container(
                      width: 150,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Theme.of(context).splashColor,
                      ),
                    ),
                  ),
                ]),
              ]),
            ])),
      ),
    );
  }
}
