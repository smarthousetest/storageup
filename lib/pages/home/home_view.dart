import 'dart:io';
import 'dart:ui';
import 'package:desktop_window/desktop_window.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upstorage_desktop/components/blur/delete.dart';
import 'package:upstorage_desktop/components/blur/exit.dart';
import 'package:upstorage_desktop/components/blur/menu_upload.dart';
import 'package:upstorage_desktop/components/blur/rename.dart';
import 'package:upstorage_desktop/components/custom_button_template.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/pages/finance/finance_view.dart';
import 'package:upstorage_desktop/pages/like/like_view.dart';
import 'package:upstorage_desktop/pages/files/file_view.dart';
import 'package:upstorage_desktop/pages/info/info_view.dart';
import 'package:upstorage_desktop/pages/media/media_view.dart';
import 'package:upstorage_desktop/pages/sell_space/space_view.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/pages/settings/settings_view.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/pages/auth/auth_view.dart';
import 'package:upstorage_desktop/utilites/state_container.dart';

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
    // setState(() {
    //   choosedPage = newPage;
    // });
    StateContainer.of(context).changePage(newPage);
  }

  bool setSize = false;

  void setSizeWindow() {
    var height = 540.0;
    var width = 960.0;

    DesktopWindow.setMinWindowSize(Size(width, height));

    // var heightWindow = MediaQuery.of(context).size.height;
    // var widthWindow = MediaQuery.of(context).size.width;

    // DesktopWindow.setMaxWindowSize(Size(widthWindow, heightWindow));
  }

  Widget getPage() {
    switch (StateContainer.of(context).choosedPage) {
      case ChoosedPage.home:
        return InfoPage();
      case ChoosedPage.file:
        return FilePage();
      case ChoosedPage.like:
        return LikePage();
      case ChoosedPage.sell_space:
        return SpaceSellPage();
      case ChoosedPage.finance:
        return FinancePage();
      case ChoosedPage.settings:
        return SettingsPage();
      case ChoosedPage.media:
        return MediaPage();
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
          blurItem: blurItem,
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
    if (setSize == false) {
      setSizeWindow();
      setSize = true;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: 1480,
              height: 944,
              constraints: BoxConstraints(minWidth: 1320, maxWidth: 1920),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, top: 30, bottom: 30),
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
        ],
      ),
    );
  }

  List<Widget> leftButtonsItem() {
    return [
      CustomMenuButton(
        icon: "assets/home_page/home.svg",
        title: "Главная",
        page: ChoosedPage.home,
        onTap: () {
          changePage(ChoosedPage.home);
        },
      ),
      CustomMenuButton(
        icon: "assets/home_page/files.svg",
        title: "Файлы",
        page: ChoosedPage.file,
        onTap: () {
          changePage(ChoosedPage.file);
        },
      ),
      CustomMenuButton(
        icon: "assets/home_page/media.svg",
        title: "Медиа",
        page: ChoosedPage.media,
        onTap: () {
          changePage(ChoosedPage.media);
        },
      ),
      // CustomMenuButton(
      //   icon: "assets/home_page/like.svg",
      //   title: "Избранное",
      //   page: ChoosedPage.like,
      //   onTap: () {
      //     changePage(ChoosedPage.like);
      //   },
      // ),
      CustomMenuButton(
        icon: "assets/home_page/sell_space.svg",
        title: "Сдача места",
        page: ChoosedPage.sell_space,
        onTap: () {
          changePage(ChoosedPage.sell_space);
        },
      ),
      // CustomMenuButton(
      //   icon: "assets/home_page/finance.svg",
      //   title: "Финансы",
      //   page: ChoosedPage.finance,
      //   onTap: () {
      //     changePage(ChoosedPage.finance);
      //   },
      // ),
      CustomMenuButton(
        icon: "assets/home_page/gear.svg",
        title: "Настройки",
        page: ChoosedPage.settings,
        onTap: () {
          changePage(ChoosedPage.settings);
        },
      ),
      // CustomMenuButton(
      //   icon: "assets/home_page/trash.svg",
      //   title: "Корзина",
      //   page: ChoosedPage.trash,
      //   onTap: () {},
      // ),
      Padding(
        padding: const EdgeInsets.only(left: 30, top: 30, right: 30),
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 25, right: 75),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text(
                translate.latest_file,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  fontFamily: kNormalTextFontFamily,
                ),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 40),
                  child: SvgPicture.asset('assets/file_page/word.svg'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14, top: 20),
                  child: Text(
                    "Доклад",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 17,
                        fontFamily: kNormalTextFontFamily),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 40),
                  child: SvgPicture.asset('assets/file_page/word.svg'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14, top: 20),
                  child: Text(
                    "Документ",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 17,
                        fontFamily: kNormalTextFontFamily),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 40),
                  child: SvgPicture.asset('assets/file_page/pdf.svg'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14, top: 20),
                  child: Text(
                    "Иллюстрация",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 17,
                        fontFamily: kNormalTextFontFamily),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
        child: Container(
          height: 42,
          width: 214,
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
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              side: BorderSide(
                style: BorderStyle.solid,
                color: Theme.of(context).splashColor,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  translate.add,
                  style: TextStyle(
                    color: Theme.of(context).splashColor,
                    fontSize: 17,
                    fontFamily: kNormalTextFontFamily,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Image.asset('assets/file_page/plus.png'),
                ),
              ],
            ),
          ),
        ),
      ),
      Align(
        alignment: FractionalOffset.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 30, left: 40, bottom: 30),
          child: Container(
            width: 93,
            height: 24,
            child: GestureDetector(
              onTap: () async {
                var str = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return BlurExit();
                  },
                );
                // Navigator.pushNamedAndRemoveUntil(
                //     context, AuthView.route, (route) => false);
              },
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: RichText(
                  text: TextSpan(
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 17,
                        fontFamily: kNormalTextFontFamily,
                      ),
                      children: [
                        WidgetSpan(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 15),
                            child: Image.asset('assets/home_page/exit.png'),
                          ),
                        ),
                        TextSpan(
                          text: translate.exit,
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ),
      )
    ];
  }
}
