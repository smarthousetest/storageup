import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upstorage_desktop/components/blur/create_album.dart';
import 'package:upstorage_desktop/components/blur/delete.dart';
import 'package:upstorage_desktop/components/blur/menu_upload.dart';
import 'package:upstorage_desktop/components/blur/rename.dart';
import 'package:upstorage_desktop/components/blur/three_directory.dart';
import 'package:upstorage_desktop/components/custom_button_template.dart';
import 'package:upstorage_desktop/pages/files/file_view.dart';
import 'package:upstorage_desktop/pages/info/info_view.dart';

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
  ChoosedPage choosed_page = ChoosedPage.home;
  Blur blur_item = Blur.rename;

  void changePage(ChoosedPage new_page) {
    setState(() {
      choosed_page = new_page;
    });
  }

  Widget getPage() {
    switch (choosed_page) {
      case ChoosedPage.home:
        return InfoPage();
      case ChoosedPage.file:
        return FilePage();
      default:
        return InfoPage();
    }
  }

  Widget getBlurItem() {
    switch (blur_item) {
      case Blur.none:
        return Container();
      case Blur.rename:
        return BlurRename(
          blur_item: blur_item,
        );
      case Blur.delete:
        return BlurDelete(
          blur_item: blur_item,
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
      backgroundColor: Color(0xfff7f9fb),
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
                  Container(
                    width: 274,
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                            children: left_buttons_item(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  getPage(),
                ],
              ),
            ),
          ),
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
                          color: Colors.black.withAlpha(25),
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

  List<Widget> left_buttons_item() {
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
        function: () {},
      ),
      CustomMenuButton(
        icon: "assets/home_page/sell_space.svg",
        title: "Сдача места",
        function: () {},
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
    ];
  }
}
