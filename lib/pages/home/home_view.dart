import 'dart:io';
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upstorage_desktop/components/blur/delete.dart';
import 'package:upstorage_desktop/components/blur/menu_upload.dart';
import 'package:upstorage_desktop/components/blur/rename.dart';
import 'package:upstorage_desktop/components/custom_button_template.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/pages/like/like_view.dart';
import 'package:upstorage_desktop/pages/files/file_view.dart';
import 'package:upstorage_desktop/pages/info/info_view.dart';
import 'package:upstorage_desktop/pages/sell_space/space_view.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

enum Blur {
  rename,
  delete,
  create_album,
  menu_upload,
  three_directory,
  none,
}

class HomePage extends StatefulWidget {
  static const route = "home_page";

  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChoosedPage choosedPage = ChoosedPage.home;
  Blur blurItem = Blur.rename;

  S translate = getIt<S>();
  void changePage(ChoosedPage newPage) {
    setState(() {
      choosedPage = newPage;
    });
  }

  Widget getPage() {
    switch (choosedPage) {
      case ChoosedPage.home:
        return InfoPage();
      case ChoosedPage.file:
        return FilePage();
      case ChoosedPage.like:
        return LikePage();
      case ChoosedPage.sell_space:
        return SpaceSellPage();
      default:
        return InfoPage();
    }
  }

  Widget getBlurItem() {
    switch (blurItem) {
      case Blur.none:
        return Container();
      case Blur.rename:
        return BlurRename(
            //blur_item: blur_item,
            );
      case Blur.delete:
        return BlurDelete(
          blur_item: blurItem,
        );
      // case Blur.create_album:
      //   return BlurCreateAlbum(blur_item: blur_item,);
      // case Blur.menu_upload:
      //   return BlurMenuUpload(blur_item: blur_item,);
      // case Blur.three_directory:
      //   return BlurCreateThreeDirectory(blur_item: blur_item,);
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 1380,
              height: 944,
              constraints: BoxConstraints(minWidth: 1320, maxWidth: 1320),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 0, top: 30, bottom: 30),
                    child: Container(
                      width: 274,
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
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 30, 47, 15),
                            child: SvgPicture.asset(
                              'assets/home_page/storage_title.svg',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 15, 30, 25),
                            child: SvgPicture.asset(
                              'assets/home_page/separator.svg',
                            ),
                          ),
                          Expanded(
                            child: ListView(
                              controller: ScrollController(),
                              children: leftButtonsItem(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  getPage(),
                ],
              ),
            ),
          ),
          // Visibility(
          //   visible: false,
          //     child: Stack(
          //   children: [
          //     Positioned.fill(
          //       child: BackdropFilter(
          //         filter: ImageFilter.blur(
          //           sigmaX: 5,
          //           sigmaY: 5,
          //         ),
          //         child: Container(
          //           color: Colors.black.withAlpha(25), // цвет не тут
          //         ),
          //       ),
          //     ),
          //     someWidget,
          //   ],
          // )),
          (1 > 2)
              ? Stack(
                  children: [
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 5,
                          sigmaY: 5,
                        ),
                        child: Container(
                          color: Colors.black.withAlpha(25), //   // цвет не тут
                        ),
                      ),
                    ),
                    getBlurItem(),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  List<Widget> leftButtonsItem() {
    return [
      CustomMenuButton(
        icon: "assets/home_page/home.svg",
        title: "Главная",
        function: () {
          changePage(ChoosedPage.home);
        },
      ),
      CustomMenuButton(
        icon: "assets/home_page/files.svg",
        title: "Файлы",
        function: () {
          changePage(ChoosedPage.file);
        },
      ),
      CustomMenuButton(
        icon: "assets/home_page/media.svg",
        title: "Медиа",
        function: () {},
      ),
      CustomMenuButton(
        icon: "assets/home_page/like.svg",
        title: "Избранное",
        function: () {
          changePage(ChoosedPage.like);
        },
      ),
      CustomMenuButton(
        icon: "assets/home_page/sell_space.svg",
        title: "Сдача места",
        function: () {
          changePage(ChoosedPage.sell_space);
        },
      ),
      CustomMenuButton(
        icon: "assets/home_page/finance.svg",
        title: "Финансы",
        function: () {},
      ),
      CustomMenuButton(
        icon: "assets/home_page/gear.svg",
        title: "Настройки",
        function: () {},
      ),
      CustomMenuButton(
        icon: "assets/home_page/trash.svg",
        title: "Корзина",
        function: () {},
      ),
      SizedBox(
        height: 259,
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: ElevatedButton(
          onPressed: () async {
            var str = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return BlurMenuUpload();
              },
            );
            /*FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any, allowMultiple: true);
            List<String?> list = result!.paths;*/

            // var systemTempDir = Directory.current;
            // await for (var entity in systemTempDir.list(recursive: true, followLinks: false,)) {
            //   print(entity.path);
            // }
          },
          child: Center(
            child: RichText(
              text: TextSpan(
                  style: TextStyle(
                    color: Theme.of(context).splashColor,
                    fontSize: 17,
                    fontFamily: kNormalTextFontFamily,
                  ),
                  children: [
                    TextSpan(
                      text: "translate.add",
                    ),
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image.asset('assets/file_page/plus.png'),
                      ),
                    ),
                  ]),
              textAlign: TextAlign.center,
            ),
          ),
          style: ElevatedButton.styleFrom(
            fixedSize: Size(214, 42), /////
            primary: Theme.of(context).primaryColor,
            elevation: 0,
            side: BorderSide(
              style: BorderStyle.solid,
              color: Theme.of(context).splashColor,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    ];
  }
}
