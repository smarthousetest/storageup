import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upstorage_desktop/components/custom_button_template.dart';
import 'package:upstorage_desktop/components/custom_round_graph.dart';

import '../../constants.dart';

class HomePage extends StatefulWidget {
  static const route = "home_page";
  HomePage({Key? key}) : super(key: key);

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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                            child: Container(
                              constraints: BoxConstraints(minHeight: 466),
                              height: MediaQuery.of(context).size.height -
                                  HEIGHT_TOP_FIND_BLOCK -
                                  PADDING_SIZE -
                                  PADDING_SIZE -
                                  HEIGHT_BOTTOM_BLOCK,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 20, 40, 26),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 24,
                                      width: 300,
                                      child: Text(
                                        "Вы сдаёте",
                                        style: TextStyle(
                                          color: Color(0xff5F5F5F),
                                          fontSize: 20,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Expanded(flex: 20, child: Container()),
                                    Expanded(
                                      flex: 1,
                                      child: Divider(
                                        height: 1,
                                        color: Color(0xffF1F8FE),
                                      ),
                                    ),
                                    Expanded(flex: 25, child: Container()),
                                    Expanded(
                                      flex: 376,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                MyProgressIndicator(
                                                  percent: 70.0,
                                                  text:
                                                      "Места на вашем устройстве арендовано",
                                                  color: Color(0xff868FFF),
                                                ),
                                                Expanded(
                                                    flex: 20,
                                                    child: Container()),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 103),
                                                  child: Divider(
                                                    height: 1,
                                                    color: Color(0xffF1F8FE),
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 20,
                                                    child: Container()),
                                                Text(
                                                  "50 ₽",
                                                  style: TextStyle(
                                                    color: Color(0xff70BBF6),
                                                    fontSize: 36,
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 5,
                                                    child: Container()),
                                                Text(
                                                  "Ежедневный доход",
                                                  style: TextStyle(
                                                    color: Color(0xff5F5F5F),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Expanded(
                                                    flex: 32,
                                                    child: Container()),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 27),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  MyProgressIndicator(
                                                    percent: 35.0,
                                                    text:
                                                        "Арендованого места заполнено",
                                                    color: Color(0xff59D7AB),
                                                  ),
                                                  Expanded(
                                                      flex: 20,
                                                      child: Container()),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 103),
                                                    child: Divider(
                                                      height: 1,
                                                      color: Color(0xffF1F8FE),
                                                    ),
                                                  ),
                                                  Expanded(
                                                      flex: 20,
                                                      child: Container()),
                                                  Text(
                                                    "3000 ₽",
                                                    style: TextStyle(
                                                      color: Color(0xff70BBF6),
                                                      fontSize: 36,
                                                    ),
                                                  ),
                                                  Expanded(
                                                      flex: 5,
                                                      child: Container()),
                                                  Text(
                                                    "Ваш баланс",
                                                    style: TextStyle(
                                                      color: Color(0xff5F5F5F),
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  Expanded(
                                                      flex: 32,
                                                      child: Container()),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 372,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 15, 15),
            child: Container(
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: Container(
                            height: 46,
                            width: 46,
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
                                  color: Color(0xff5A5A5A),
                                ),
                              ),
                            ),
                            Text(
                              "votreaa@mail.ru",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff5A5A5A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30),
                      child: Divider(
                        height: 1,
                        color: Color(0xffF1F8FE),
                      ),
                    ),
                    Text(
                      'Используемое пространство',
                      style: TextStyle(
                        color: Color(0xff7D7D7D),
                        fontSize: 16,
                        fontFamily: 'Lato',
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          '4,36',
                          style: TextStyle(
                            color: Color(0xff5A5A5A),
                            fontSize: 36,
                            fontFamily: 'Lato',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 11),
                          child: Text(
                            'из',
                            style: TextStyle(
                              color: Color(0xffC4C4C4),
                              fontSize: 24,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ),
                        Text(
                          '20 ГБ',
                          style: TextStyle(
                            color: Color(0xffC4C4C4),
                            fontSize: 36,
                            fontFamily: 'Lato',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
