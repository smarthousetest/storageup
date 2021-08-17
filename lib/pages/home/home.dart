import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upstorage_desktop/components/custom_button_template.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
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
                      children: [
                        CustomMenuButton(
                          icon: "assets/home_page/home.svg",
                          title: "Главная",
                        ),
                        CustomMenuButton(
                          icon: "assets/home_page/files.svg",
                          title: "Файлы",
                        ),
                        CustomMenuButton(
                          icon: "assets/home_page/media.svg",
                          title: "Медиа",
                        ),
                        CustomMenuButton(
                          icon: "assets/home_page/like.svg",
                          title: "Избранное",
                        ),
                        CustomMenuButton(
                          icon: "assets/home_page/sell_space.svg",
                          title: "Сдача места",
                        ),
                        CustomMenuButton(
                          icon: "assets/home_page/finance.svg",
                          title: "Финансы",
                        ),
                        CustomMenuButton(
                          icon: "assets/home_page/gear.svg",
                          title: "Настройки",
                        ),
                        CustomMenuButton(
                          icon: "assets/home_page/trash.svg",
                          title: "Корзина",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Container(
                        // height: ((_key_central_block.currentContext!.size!.height / 944) * 466),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      // height: ((_key_central_block.currentContext.size!.height / 944) * 372),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
