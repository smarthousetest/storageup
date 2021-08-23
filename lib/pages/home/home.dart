import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upstorage_desktop/components/custom_button_template.dart';
import 'package:upstorage_desktop/components/custom_round_graph.dart';
import 'package:upstorage_desktop/components/custom_progress_bar.dart';

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
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  MyProgressIndicator(
                                                    percent: 70.0,
                                                    text:
                                                        "Места на вашем устройстве арендовано",
                                                    color: Color(0xff868FFF),
                                                    radius: 120,
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
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Expanded(
                                                      flex: 32,
                                                      child: Container()),
                                                  ElevatedButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                      'Увеличить',
                                                      style: TextStyle(
                                                        fontFamily: 'Lato',
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff7D7D7D),
                                                      ),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.white,
                                                      fixedSize: Size(200, 46),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  MyProgressIndicator(
                                                    percent: 35.0,
                                                    text:
                                                        "Арендованого места заполнено",
                                                    color: Color(0xff59D7AB),
                                                    radius: 120,
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
                                                  ElevatedButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                      'Оплатить',
                                                      style: TextStyle(
                                                        fontFamily: 'Lato',
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff7D7D7D),
                                                      ),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Colors.white,
                                                      fixedSize: Size(200, 46),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                    ),
                                                  )
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
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Вы арендуете',
                                     style: TextStyle(
                                       fontSize: 20,
                                       color: Color(0xff5F5F5F),
                                       fontFamily: 'Lato',
                                     ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Divider(
                                      height: 1,
                                      color: Color(0xffF1F8FE),
                                    )
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Пространство заполнено на:',
                                        style: TextStyle(
                                          fontFamily: 'Lato',
                                          fontSize: 14,
                                          color: Color(0xff7D7D7D),
                                        ),
                                      ),
                                      Text(
                                        '45%',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(23),
                            ),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      child: Container(
                        child: Stack(
                          children: [
                            MyProgressBar(
                              percent: 75,
                              text: 'text',
                              color: Color(0xffFFD75E),
                              bgColor: Color(0xffF7F9FB),
                            ),
                            MyProgressBar(
                              percent: 50,
                              text: 'text',
                              color: Color(0xffFF847E),
                              bgColor: Color.fromARGB(0, 0, 0, 0),
                            ),
                            MyProgressBar(
                              percent: 30,
                              text: 'text',
                              color: Color(0xff59D7AB),
                              bgColor: Color.fromARGB(0, 0, 0, 0),
                            ),
                            MyProgressBar(
                              percent: 15,
                              text: 'text',
                              color: Color(0xff868FFF),
                              bgColor: Color.fromARGB(0, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: ElevatedButton(
                                onPressed: () {
                                  print('Files');
                                },
                                autofocus: true,
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shadowColor: Color.fromARGB(5, 0, 0, 0),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: Container(
                                        height: 46,
                                        width: 46,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: SvgPicture.asset(
                                            'assets/home_page/files_r.svg'),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            "Файлы",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff7D7D7D),
                                              fontFamily: 'Lato',
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "15 файлов",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xffC4C4C4),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: ElevatedButton(
                                onPressed: () {
                                  print('Foto');
                                },
                                autofocus: true,
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shadowColor: Color.fromARGB(5, 0, 0, 0),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: Container(
                                        height: 46,
                                        width: 46,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: SvgPicture.asset(
                                            'assets/home_page/foto_r.svg'),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            "Фото",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff7D7D7D),
                                              fontFamily: 'Lato',
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "15 файлов",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xffC4C4C4),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: ElevatedButton(
                                onPressed: () {
                                  print('Video');
                                },
                                autofocus: true,
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shadowColor: Color.fromARGB(5, 0, 0, 0),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: Container(
                                        height: 46,
                                        width: 46,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: SvgPicture.asset(
                                            'assets/home_page/video_r.svg'),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            "Видео",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff7D7D7D),
                                              fontFamily: 'Lato',
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "15 файлов",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xffC4C4C4),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                              child: ElevatedButton(
                                onPressed: () {
                                  print('Audio');
                                },
                                autofocus: true,
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.white,
                                  shadowColor: Color.fromARGB(5, 0, 0, 0),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: Container(
                                        height: 46,
                                        width: 46,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: SvgPicture.asset(
                                            'assets/home_page/music_r.svg'),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            "Аудио",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff7D7D7D),
                                              fontFamily: 'Lato',
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "15 файлов",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xffC4C4C4),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
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
          ),
        ],
      ),
    );
  }
}
