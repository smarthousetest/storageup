import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upstorage_desktop/components/custom_button_template.dart';
import 'package:upstorage_desktop/pages/files/file_view.dart';
import 'package:upstorage_desktop/pages/info/info_view.dart';

class HomePage extends StatefulWidget {
  static const route = "home_page";

  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChoosedPage choosed_page = ChoosedPage.home;

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

  @override
  void initState() {
    DesktopWindow.setMaxWindowSize(Size(double.infinity, double.infinity));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
            child: Container(
              width: 274,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
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
          ),
          // (Choosed) ? InfoPage() : FilePage(),
          getPage(),
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
