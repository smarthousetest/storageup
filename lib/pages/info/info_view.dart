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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 726,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
                child: Container(
                  height: 46,
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
                ),
              ),
              Expanded(
                // child: ListView(
                //  controller: ScrollController(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ListView(
                      controller: ScrollController(),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                          child: SizedBox(
                            height: 465,
                            width: 726,
                            child: Container(
                              constraints: BoxConstraints(minHeight: 466),
                              /*MediaQuery.of(context).size.height -
                                    HEIGHT_TOP_FIND_BLOCK -
                                    PADDING_SIZE -
                                    PADDING_SIZE -
                                    HEIGHT_BOTTOM_BLOCK,*/
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
                                padding:
                                    const EdgeInsets.fromLTRB(40, 19, 40, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 24,
                                      child: Text(
                                        "Вы сдаёте",
                                        style: TextStyle(
                                          color: Theme.of(context).focusColor,
                                          fontSize: 20,
                                          fontFamily: kNormalTextFontFamily,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Divider(
                                        height: 1,
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                    SizedBox(height: 23),
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
                                                    color: Color(0xff868FFF),
                                                    radius: 120,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 24),
                                                    child: Container(
                                                      height: 17,
                                                      child: Text(
                                                        'Места на вашем устройстве арендовано',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor,
                                                          fontFamily:
                                                              kNormalTextFontFamily,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    child: Container(
                                                      width: 200,
                                                      child: Divider(
                                                        height: 1,
                                                        color: Theme.of(context)
                                                            .dividerColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    child: Container(
                                                      height: 49,
                                                      child: Text(
                                                        "50 ₽",
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .splashColor,
                                                          fontSize: 36,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Container(
                                                      height: 17,
                                                      child: Text(
                                                        "Ежедневный доход",
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .focusColor,
                                                          fontSize: 14,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 30, 0, 32),
                                                    child: ElevatedButton(
                                                      onPressed: () {},
                                                      child: Text(
                                                        'Увеличить',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              kNormalTextFontFamily,
                                                          fontSize: 14,
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor,
                                                        ),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        fixedSize:
                                                            Size(200, 42),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
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
                                                    color: Color(
                                                        0xff59D7AB), // цвет индикатора
                                                    radius: 120,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 24),
                                                    child: Container(
                                                      height: 17,
                                                      child: Text(
                                                          'Арендованого места заполнено',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                kNormalTextFontFamily,
                                                          )),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    child: Container(
                                                      width: 200,
                                                      child: Divider(
                                                        height: 1,
                                                        color: Theme.of(context)
                                                            .dividerColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20),
                                                    child: Container(
                                                      height: 49,
                                                      child: Text(
                                                        "3000 ₽",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .splashColor,
                                                          fontSize: 36,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 5),
                                                    child: Container(
                                                      height: 17,
                                                      child: Text(
                                                        "Ваш баланс",
                                                        style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .focusColor,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(0, 30, 0, 32),
                                                    child: ElevatedButton(
                                                      onPressed: () {},
                                                      child: Text(
                                                        'Оплатить',
                                                        style: TextStyle(
                                                          fontFamily:
                                                              kNormalTextFontFamily,
                                                          fontSize: 14,
                                                          color: Theme.of(
                                                                  context)
                                                              .disabledColor,
                                                        ),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                        primary:
                                                            Theme.of(context)
                                                                .primaryColor,
                                                        fixedSize:
                                                            Size(200, 42),
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
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
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, right: 30, bottom: 30),
                          child: SizedBox(
                            height: 372,
                            width: 726,
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
                                padding:
                                    const EdgeInsets.fromLTRB(40, 20, 40, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Вы арендуете',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context).focusColor,
                                        fontFamily: kNormalTextFontFamily,
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: Divider(
                                        height: 1,
                                        color: Theme.of(context).dividerColor,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Пространство заполнено на:',
                                          style: TextStyle(
                                            fontFamily: 'Lato',
                                            fontSize: 14,
                                            color:
                                                Theme.of(context).disabledColor,
                                          ),
                                        ),
                                        Text(
                                          '45%',
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 25, 0, 10),
                                      child: MyProgressBar(
                                        bgColor: Theme.of(context).cardColor,
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
                                            fontFamily: kNormalTextFontFamily,
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
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
                                            fontFamily: kNormalTextFontFamily,
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
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
                                            fontFamily: kNormalTextFontFamily,
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 30),
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
                                                    fontFamily:
                                                        kNormalTextFontFamily,
                                                    fontSize: 36,
                                                    color: Theme.of(context)
                                                        .splashColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 11,
                                                ),
                                                Text(
                                                  'Используемое место',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        kNormalTextFontFamily,
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .focusColor,
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
                                                      fontFamily:
                                                          kNormalTextFontFamily,
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                          .disabledColor,
                                                    ),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Theme.of(context)
                                                        .primaryColor,
                                                    fixedSize: Size(200, 46),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
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
                                                    fontFamily:
                                                        kNormalTextFontFamily,
                                                    fontSize: 36,
                                                    color: Theme.of(context)
                                                        .splashColor,
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 11,
                                                ),
                                                Text(
                                                  'Следущий платёж',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        kNormalTextFontFamily,
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .focusColor,
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
                                                      fontFamily:
                                                          kNormalTextFontFamily,
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                          .disabledColor,
                                                    ),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    primary: Theme.of(context)
                                                        .primaryColor,
                                                    fixedSize: Size(200, 46),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        (MediaQuery.of(context).size.width > 1380)
            ? Padding(
                padding: const EdgeInsets.only(right: 0, top: 30, bottom: 30),
                child: Container(
                  width: 320,
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
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                height: 46,
                                width: 46,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(23),
                                ),
                                child: Image.asset('assets/home_page/man.jpg'),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    "А. Рождественский",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color:
                                          Theme.of(context).bottomAppBarColor,
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
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: Divider(
                            height: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        Text(
                          'Используемое пространство',
                          style: TextStyle(
                            color: Theme.of(context).disabledColor,
                            fontSize: 14,
                            fontFamily: kNormalTextFontFamily,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '4,36',
                              style: TextStyle(
                                color: Theme.of(context).bottomAppBarColor,
                                fontSize: 36,
                                fontFamily: kNormalTextFontFamily,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 11),
                              child: Text(
                                'из',
                                style: TextStyle(
                                  color: Theme.of(context).shadowColor,
                                  fontSize: 24,
                                  fontFamily: kNormalTextFontFamily,
                                ),
                              ),
                            ),
                            Text(
                              '20 ГБ',
                              style: TextStyle(
                                color: Theme.of(context).shadowColor,
                                fontSize: 36,
                                fontFamily: kNormalTextFontFamily,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                            height: 10,
                            child: Stack(
                              children: [
                                MyProgressBar(
                                  percent: 75,
                                  color: Color(0xffFFD75E),
                                  bgColor: Theme.of(context).cardColor,
                                ),
                                MyProgressBar(
                                  percent: 50,
                                  color: Color(0xffFF847E),
                                  bgColor: Color.fromARGB(0, 0, 0, 0),

                                  ///
                                ),
                                MyProgressBar(
                                  percent: 30,
                                  color: Color(0xff59D7AB),
                                  bgColor: Color.fromARGB(0, 0, 0, 0),

                                  ///
                                ),
                                MyProgressBar(
                                  percent: 15,
                                  color: Color(0xff868FFF),
                                  bgColor: Color.fromARGB(0, 0, 0, 0),

                                  ///
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
                                  padding: const EdgeInsets.only(top: 20),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print('Files');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      shadowColor:
                                          Color.fromARGB(5, 0, 0, 0), //
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Text(
                                                "Файлы",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .disabledColor,
                                                  fontFamily:
                                                      kNormalTextFontFamily,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "15 файлов",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(context)
                                                    .shadowColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print('Foto');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor,
                                      shadowColor: Color.fromARGB(5, 0, 0, 0),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Text(
                                                "Фото",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .disabledColor,
                                                  fontFamily:
                                                      kNormalTextFontFamily,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "15 файлов",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(context)
                                                    .shadowColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print('Video');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor,
                                      shadowColor: Color.fromARGB(5, 0, 0, 0),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Text(
                                                "Видео",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .disabledColor,
                                                  fontFamily:
                                                      kNormalTextFontFamily,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "15 файлов",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(context)
                                                    .shadowColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      print('Audio');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).primaryColor,
                                      shadowColor: Color.fromARGB(5, 0, 0, 0),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 10),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
                                              child: Text(
                                                "Аудио",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .disabledColor,
                                                  fontFamily:
                                                      kNormalTextFontFamily,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "15 файлов",
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(context)
                                                    .shadowColor,
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
                ))
            : Container(),
      ],
    );
  }
}
