import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/constants.dart';

class SpaceSellPage extends StatefulWidget {
  @override
  _SpaceSellPageState createState() => _SpaceSellPageState();
  SpaceSellPage();
}

class _SpaceSellPageState extends State<SpaceSellPage> {
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Container(
                height: 46,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
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
                      width: 46,
                      child: Row(
                        children: [
                          Expanded(
                            //child: Padding(
                            //padding: const EdgeInsets.only(right: 30),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color:
                                              Color.fromARGB(25, 23, 69, 139),
                                          blurRadius: 4,
                                          offset: Offset(1, 4))
                                    ]),
                                child: Center(
                                  child: SvgPicture.asset(
                                      "assets/file_page/settings.svg"),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 30, left: 20),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(23.0),
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
                // child: Padding(
                //   padding: const EdgeInsets.all(30),
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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40, top: 20),
                      child: Container(
                        width: 130,
                        child: Text(
                          'Cдача места',
                          style: TextStyle(
                            color: Theme.of(context).focusColor,
                            fontFamily: kNormalTextFontFamily,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 40, top: 20, right: 20),
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          color: Color(0xffF1F8FE),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, top: 20),
                      child: Container(
                        child: Text(
                          'Как это работает?',
                          style: TextStyle(
                            color: Theme.of(context).focusColor,
                            fontFamily: kNormalTextFontFamily,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                  ]),
            )),
          ],
        ),
      ),
    );
  }
}
