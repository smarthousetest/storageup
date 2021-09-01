import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/components/custom_round_graph.dart';
import 'package:upstorage_desktop/components/custom_progress_bar.dart';
import '../../theme.dart';
import '../../constants.dart';

class InfoPage extends StatefulWidget {

  @override
  _InfoPageState createState() => new _InfoPageState();

  InfoPage();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return
      Expanded(
        child: Row(
          children: [
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
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height -
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
                                            color: kLightTheme.focusColor,
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
                                          color: kLightTheme.dividerColor,
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
                                                        color: kLightTheme.dividerColor,
                                                      ),
                                                    ),
                                                    Expanded(
                                                        flex: 20,
                                                        child: Container()),
                                                    Text(
                                                      "50 ₽",
                                                      style: TextStyle(
                                                        color: kLightTheme.splashColor,
                                                        fontSize: 36,
                                                      ),
                                                    ),
                                                    Expanded(
                                                        flex: 5,
                                                        child: Container()),
                                                    Text(
                                                      "Ежедневный доход",
                                                      style: TextStyle(
                                                        color: kLightTheme.focusColor,
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
                                                          color: kLightTheme
                                                              .disabledColor,
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
                                                        color: kLightTheme.dividerColor,
                                                      ),
                                                    ),
                                                    Expanded(
                                                        flex: 20,
                                                        child: Container()),
                                                    Text(
                                                      "3000 ₽",
                                                      style: TextStyle(
                                                        color: kLightTheme.splashColor,
                                                        fontSize: 36,
                                                      ),
                                                    ),
                                                    Expanded(
                                                        flex: 5,
                                                        child: Container()),
                                                    Text(
                                                      "Ваш баланс",
                                                      style: TextStyle(
                                                        color: kLightTheme.focusColor,
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
                                                          color: kLightTheme
                                                              .disabledColor,
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
                                padding:
                                const EdgeInsets.fromLTRB(40, 20, 40, 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Вы арендуете',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: kLightTheme.focusColor,
                                        fontFamily: 'Lato',
                                      ),
                                    ),
                                    Padding(
                                        padding:
                                        EdgeInsets.symmetric(vertical: 20),
                                        child: Divider(
                                          height: 1,
                                          color: kLightTheme.dividerColor,
                                        )),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Пространство заполнено на:',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 14,
                                            color: kLightTheme.disabledColor,
                                          ),
                                        ),
                                        Text(
                                          '45%',
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(0, 25, 0, 10),
                                      child: MyProgressBar(
                                        bgColor: Color(0xffF7F9FB),
                                        color: Color(0xff868FFF),
                                        percent: 42,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '0%',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 12,
                                            color: Color(0xff9C9C9C),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 291,
                                            child: Container(
                                              height: 14,
                                            )),
                                        Text(
                                          '50%',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 12,
                                            color: Color(0xff9C9C9C),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 277,
                                            child: Container(
                                              height: 14,
                                            )),
                                        Text(
                                          '100%',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 12,
                                            color: Color(0xff9C9C9C),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(
                                                  '300ГБ',
                                                  style: TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 36,
                                                    color: kLightTheme.splashColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 11,
                                                ),
                                                Text(
                                                  'Используемое место',
                                                  style: TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 14,
                                                    color: kLightTheme.focusColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  child: Text(
                                                    'Увеличить',
                                                    style: TextStyle(
                                                      fontFamily: 'Lato',
                                                      fontSize: 14,
                                                      color: kLightTheme.disabledColor,
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
                                          Expanded(
                                            child: Column(
                                              children: [
                                                Text(
                                                  '17.17.21',
                                                  style: TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 36,
                                                    color: kLightTheme.splashColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 11,
                                                ),
                                                Text(
                                                  'Следущий платёж',
                                                  style: TextStyle(
                                                    fontFamily: 'Lato',
                                                    fontSize: 14,
                                                    color: kLightTheme.focusColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {},
                                                  child: Text(
                                                    'Оплатить',
                                                    style: TextStyle(
                                                      fontFamily: 'Lato',
                                                      fontSize: 14,
                                                      color: kLightTheme.disabledColor,
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
                                        ],
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
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: Divider(
                          height: 1,
                          color: kLightTheme.dividerColor,
                        ),
                      ),
                      Text(
                        'Используемое пространство',
                        style: TextStyle(
                          color: kLightTheme.disabledColor,
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
                              color: kLightTheme.bottomAppBarColor,
                              fontSize: 36,
                              fontFamily: 'Lato',
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 11),
                            child: Text(
                              'из',
                              style: TextStyle(
                                color: kLightTheme.shadowColor,
                                fontSize: 24,
                                fontFamily: 'Lato',
                              ),
                            ),
                          ),
                          Text(
                            '20 ГБ',
                            style: TextStyle(
                              color: kLightTheme.shadowColor,
                              fontSize: 36,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: SizedBox(
                          height: 10,
                          child: Stack(
                            children: [
                              MyProgressBar(
                                percent: 75,
                                color: Color(0xffFFD75E),
                                bgColor: Color(0xffF7F9FB),
                              ),
                              MyProgressBar(
                                percent: 50,
                                color: Color(0xffFF847E),
                                bgColor: Color.fromARGB(0, 0, 0, 0),
                              ),
                              MyProgressBar(
                                percent: 30,
                                color: Color(0xff59D7AB),
                                bgColor: Color.fromARGB(0, 0, 0, 0),
                              ),
                              MyProgressBar(
                                percent: 15,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 10, 0),
                                        child: Container(
                                          height: 46,
                                          width: 46,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          child: SvgPicture.asset(
                                              'assets/home_page/files_r.svg'),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                              "Файлы",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: kLightTheme.disabledColor,
                                                fontFamily: 'Lato',
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "15 файлов",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: kLightTheme.shadowColor,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 10, 0),
                                        child: Container(
                                          height: 46,
                                          width: 46,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          child: SvgPicture.asset(
                                              'assets/home_page/foto_r.svg'),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                              "Фото",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: kLightTheme.disabledColor,
                                                fontFamily: 'Lato',
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "15 файлов",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: kLightTheme.shadowColor,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 10, 0),
                                        child: Container(
                                          height: 46,
                                          width: 46,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          child: SvgPicture.asset(
                                              'assets/home_page/video_r.svg'),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                              "Видео",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: kLightTheme.disabledColor,
                                                fontFamily: 'Lato',
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "15 файлов",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: kLightTheme.shadowColor,
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
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 10, 0),
                                        child: Container(
                                          height: 46,
                                          width: 46,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          child: SvgPicture.asset(
                                              'assets/home_page/music_r.svg'),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                              "Аудио",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: kLightTheme.disabledColor,
                                                fontFamily: 'Lato',
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "15 файлов",
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: kLightTheme.shadowColor,
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
