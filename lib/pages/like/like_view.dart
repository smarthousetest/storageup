import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/components/blur/rename.dart';
import 'package:upstorage_desktop/components/dir_button_template.dart';
import 'package:upstorage_desktop/constants.dart';
import '../../theme.dart';
import 'like_list/like_list.dart';

class LikePage extends StatefulWidget {
  //FavoritesPage({Key? key}) : super(key: key);

  @override
  _LikePageState createState() => _LikePageState();
  LikePage();
}

class _LikePageState extends State<LikePage> {
  bool ifGrid = true;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
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
                                      color: Color.fromARGB(25, 23, 69, 139),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 20, 40, 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            child: Text(
                              'Избранное',
                              style: TextStyle(
                                color: Theme.of(context).focusColor,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 100,
                            child: Container(),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            iconSize: 30,
                            onPressed: () {
                              setState(() {
                                ifGrid = false;
                              });
                              print('ifGrid is $ifGrid');
                            },
                            icon: SvgPicture.asset('assets/file_page/list.svg',
                                // icon: Image.asset('assets/file_page/list.png',
                                // fit: BoxFit.contain,
                                // width: 30,
                                // height: 30,
                                color: ifGrid
                                    ? Theme.of(context).toggleButtonsTheme.color
                                    : Theme.of(context).splashColor),
                          ),
                          IconButton(
                            iconSize: 30,
                            onPressed: () {
                              setState(() {
                                ifGrid = true;
                              });
                              print('ifGrid is $ifGrid');
                            },
                            icon: SvgPicture.asset('assets/file_page/block.svg',
                                // width: 30,
                                // height: 30,
                                //colorBlendMode: BlendMode.softLight,
                                color: ifGrid
                                    ? Theme.of(context).splashColor
                                    : Theme.of(context)
                                        .toggleButtonsTheme
                                        .color),
                          ),
                        ],
                      ),
                    ),
                    ifGrid
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Divider(
                              height: 1,
                              color: Theme.of(context).dividerColor,
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: ifGrid ? _filesGrid(context) : LikeList(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _filesGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: (MediaQuery.of(context).size.width > 1380)
          ? (1076 ~/ 160)
          : ((MediaQuery.of(context).size.width - 384) ~/ (160)),
      padding: EdgeInsets.fromLTRB(20, 20, 36, 40),
      crossAxisSpacing: 56,
      children: List.generate(17, (index) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 101,
              height: 128,
              color: Theme.of(context).primaryColor,
              //padding: const EdgeInsets.all(8.0),
              // decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(8),
              //     image: DecorationImage(
              //       image: AssetImage('assets/test_img/1.jpg'),
              //     )),
              child: Column(
                children: [
                  // Container(
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(8),
                  //       image: DecorationImage(
                  //         image: AssetImage('assets/test_img/1.jpg'),
                  //       )),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
                  //   child: Image.asset(
                  //     'assets/file_page/like.png',
                  //     height: 24,
                  //     width: 24,
                  //   ),
                  // ),
                  ClipRRect(
                    child: Image.asset('assets/test_img/1.jpg'),
                    borderRadius: BorderRadius.circular(8),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      '1.jpg',
                      style: TextStyle(
                        color: Theme.of(context).disabledColor,
                        fontSize: 14,
                        fontFamily: kNormalTextFontFamily,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
