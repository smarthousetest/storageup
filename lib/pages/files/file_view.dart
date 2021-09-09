import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/components/blur/rename.dart';
import 'package:upstorage_desktop/components/dir_button_template.dart';
import '../../theme.dart';

class FilePage extends StatefulWidget {
  @override
  _FilePageState createState() => new _FilePageState();

  FilePage();
}

class _FilePageState extends State<FilePage> {
  List<Widget> dirs_list = [];

  @override
  Widget build(BuildContext context) {
    if (dirs_list.isEmpty) _init(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 46,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 40, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 310,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(23.0),
                            child: Image.asset('assets/home_page/glad.jpg'),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Text(
                                "Валерий Жмышенко",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: kLightTheme.bottomAppBarColor,
                                ),
                              ),
                            ),
                            Text(
                              "votreaa@mail.ru",
                              style: TextStyle(
                                fontSize: 12,
                                color: kLightTheme.bottomAppBarColor,
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Container(
                height: 234,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 30,
                        child: Row(
                          children: [
                            Text(
                              'Папки',
                              style: TextStyle(
                                color: kLightTheme.focusColor,
                                fontSize: 20,
                                fontFamily: 'Lato',
                              ),
                            ),
                            Expanded(
                              flex: 861,
                              child: SizedBox(),
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              child: RawMaterialButton(
                                onPressed: () {},
                                fillColor: Colors.white,
                                child: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: Colors.blue,
                                  size: 20.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Container(
                                width: 30,
                                height: 30,
                                child: RawMaterialButton(
                                  onPressed: () {},
                                  fillColor: Colors.white,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.blue,
                                    size: 20.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [...dirs_list],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                      child: Row(
                        children: [
                          Text(
                            'Недавние',
                            style: TextStyle(
                              color: Color(0xff5F5F5F),
                              fontFamily: 'Lato',
                              fontSize: 20,
                            ),
                          ),
                          Expanded(
                            flex: 829,
                            child: Container(),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: SvgPicture.asset(
                              'assets/file_page/list.svg',
                              width: 30,
                              height: 30,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                'assets/file_page/grid.svg',
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Divider(
                        height: 1,
                        color: Color(0xffF1F8FE),
                      ),
                    ),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount:
                            (MediaQuery.of(context).size.width > 1380)
                                ? (1076 ~/ 160)
                                : ((MediaQuery.of(context).size.width - 384) ~/
                                    (160)),
                        padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
                        crossAxisSpacing: 56,
                        children: List.generate(17, (index) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 101,
                                height: 128,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      child:
                                          Image.asset('assets/test_img/1.jpg'),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 0),
                                      child: Text(
                                        '1.jpg',
                                        style: TextStyle(
                                          color: Color(0xff7D7D7D),
                                          fontSize: 14,
                                          fontFamily: 'Lato',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _init(BuildContext context) {
    dirs_list.add(
      CustomDirButton(
        name: 'Создать\n папку',
        onTap: () async {
          var str = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return BlurRename();
            },
          );
          print(str);
          setState(
            () {
              dirs_list.add(
                CustomDirButton(
                  name: str,
                  onTap: () async {

                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
