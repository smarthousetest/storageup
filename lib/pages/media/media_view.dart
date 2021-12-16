import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/components/blur/add_folder.dart';
import 'package:upstorage_desktop/components/dir_button_template.dart';
import 'package:upstorage_desktop/components/properties.dart';
import 'package:upstorage_desktop/constants.dart';
import '../../theme.dart';
import 'media_list/media_list.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/generated/l10n.dart';

class MediaPage extends StatefulWidget {
  @override
  _MediaPageState createState() => new _MediaPageState();

  MediaPage();
}

List<Widget> dirsList = [];

class _MediaPageState extends State<MediaPage> {
  bool ifGrid = true;
  S translate = getIt<S>();

  @override
  Widget build(BuildContext context) {
    // if (dirs_list.isEmpty) _init(context);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 30, top: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                        child: Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Align(
                            alignment: FractionalOffset.centerLeft,
                            child: Container(
                                width: 20,
                                height: 20,
                                child: SvgPicture.asset(
                                    "assets/file_page/search.svg")),
                          ),
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
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: Container(
                height: 224,
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
                              translate.folder_dir,
                              style: TextStyle(
                                color: Theme.of(context).focusColor,
                                fontSize: 20,
                                fontFamily: kNormalTextFontFamily,
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
                                fillColor: Theme.of(context).primaryColor,
                                child: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: Theme.of(context).splashColor,
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
                                  fillColor: Theme.of(context).primaryColor,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context).splashColor,
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
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 31),
                                      child: Container(
                                        width: 130,
                                        height: 130,
                                        child: Listener(
                                          child: ElevatedButton(
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 16),
                                                  child: SvgPicture.asset(
                                                    'assets/home_page/add_folder.svg',
                                                    height: 46,
                                                    width: 46,
                                                  ),
                                                ),
                                                Text(
                                                  translate.create_album,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily:
                                                        kNormalTextFontFamily,
                                                    color: Theme.of(context)
                                                        .disabledColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            onPressed: () async {
                                              var str = await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return BlurAddFolder();
                                                },
                                              );
                                              print(str);
                                              setState(
                                                () {
                                                  dirsList.add(
                                                    CustomDirButton(
                                                      name: str,
                                                      onTap: () async {},
                                                    ),
                                                  );
                                                  print("add");
                                                },
                                              );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: Theme.of(context)
                                                  .primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: BorderSide(
                                                  width: 2,
                                                  color: Theme.of(context)
                                                      .dividerColor,
                                                ),
                                              ),
                                              elevation: 0,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    ListView(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        children: dirsList),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30, right: 0),
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 20, 30, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              child: Text(
                                translate.recent,
                                style: TextStyle(
                                  color: Theme.of(context).focusColor,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 821,
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
                              icon: SvgPicture.asset(
                                  'assets/file_page/list.svg',
                                  // icon: Image.asset('assets/file_page/list.png',
                                  // fit: BoxFit.contain,
                                  // width: 30,
                                  // height: 30,
                                  color: ifGrid
                                      ? Theme.of(context)
                                          .toggleButtonsTheme
                                          .color
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
                              icon: SvgPicture.asset(
                                  'assets/file_page/block.svg',
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Divider(
                                height: 1,
                                color: Theme.of(context).dividerColor,
                              ),
                            )
                          : Container(),
                      Expanded(
                        child: ifGrid ? _filesGrid(context) : MediaList(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filesGrid(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      var crossAxisCount = constrains.minWidth ~/ 145;
      return GridView.count(
        crossAxisCount: crossAxisCount,
        padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
        crossAxisSpacing: 56,
        children: List.generate(17, (index) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: constrains.minWidth / crossAxisCount,
                height: constrains.minWidth / crossAxisCount * 1.3,
                color: Theme.of(context).primaryColor,
                child: Column(
                  children: [
                    ClipRRect(
                      child: Image.asset('assets/test_img/20.jpg'),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        'В.HEIC',
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
    });
  }
}
