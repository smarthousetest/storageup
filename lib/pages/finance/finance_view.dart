import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/pages/finance/finance_bloc.dart';
import 'package:upstorage_desktop/pages/finance/finance_event.dart';
import 'package:upstorage_desktop/pages/finance/finance_state.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/extensions.dart';

class FinancePage extends StatefulWidget {
  @override
  _FinancePageState createState() => _FinancePageState();
  FinancePage();
}

class _FinancePageState extends State<FinancePage> {
  S translate = getIt<S>();
  var index = 0;
  List<GlobalKey> _keys = [];

  @override
  void initState() {
    for (var i = 0; i < 2; i++) {
      _keys.add(GlobalKey());
    }

    super.initState();
  }

  Widget build(BuildContext context) {
    var decoration = () {
      return BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      );
    };

    var decorationUnderline = (int ind) {
      return BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
            style: BorderStyle.solid,
            color: index == ind
                ? Theme.of(context).splashColor
                : Colors.transparent,
          ),
        ),
      );
    };
    ThemeData theme = Theme.of(context);
    return BlocProvider(
      create: (context) => FinanceBloc()..add(FinancePageOpened()),
      child: Expanded(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30, top: 30),
              child: Container(
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
                      height: 46,
                      child: BlocBuilder<FinanceBloc, FinanceState>(
                          builder: (context, state) {
                        return Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 30, left: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(23.0),
                                child: Container(child: state.user.image),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    state.user?.fullName ?? '',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color:
                                          Theme.of(context).bottomAppBarColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  state.user?.email ?? '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).bottomAppBarColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(30),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 40, right: 40, top: 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          mainAxisAlignment: MainAxisAlignment.start,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Container(
                              decoration: decoration(),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    index = 0;
                                    print(index);
                                  });
                                },
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 10),
                                    decoration: decorationUnderline(0),
                                    child: Text(
                                      translate.management,
                                      key: _keys[0],
                                      style: TextStyle(
                                        color: index == 0
                                            ? Theme.of(context).focusColor
                                            : Theme.of(context)
                                                .textTheme
                                                .subtitle1
                                                ?.color,
                                        fontFamily: kNormalTextFontFamily,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: decoration(),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    index = 1;
                                    print(index);
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 10),
                                      decoration: decorationUnderline(1),
                                      child: Text(
                                        translate.funds,
                                        key: _keys[1],
                                        style: TextStyle(
                                          color: index == 1
                                              ? Theme.of(context).focusColor
                                              : Theme.of(context)
                                                  .textTheme
                                                  .subtitle1
                                                  ?.color,
                                          fontFamily: kNormalTextFontFamily,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: IndexedStack(
                          index: index,
                          sizing: StackFit.passthrough,
                          children: [
                            subcription(theme),
                            withdrawFunds(context),
                          ],
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
    );
  }

  Widget subcription(ThemeData theme) {
    return Expanded(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [activeSub(theme)],
    ));
  }

  Widget activeSub(ThemeData theme) {
    return Expanded(
      child: ListView(
        controller: ScrollController(),
        scrollDirection: Axis.horizontal,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 30),
              child: Container(
                child: Text(
                  translate.active_sub,
                  style: TextStyle(
                    color: Theme.of(context).focusColor,
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 30),
                  child: Container(
                    width: 510,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Theme.of(context).splashColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 40.0, left: 40),
                              child: Text(
                                '5 ГБ за 149 ₽/месяц',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 36,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10.0, left: 40),
                              child: Text(
                                translate.offer,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 40, top: 26),
                              child: Container(
                                height: 42,
                                width: 200,
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: Size(double.maxFinite, 60),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                  ),
                                  child: Text(
                                    '1490 ₽/год',
                                    style: TextStyle(
                                      color: Theme.of(context).splashColor,
                                      fontFamily: kNormalTextFontFamily,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 30, right: 40),
                  child: Container(
                    width: 510,
                    height: 220,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                        width: 2,
                      ),
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 40.0, left: 40),
                              child: Text(
                                translate.payment,
                                style: TextStyle(
                                  color: Theme.of(context).bottomAppBarColor,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, left: 40),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Следующая оплата 27.08.21 составит 149 ₽',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).bottomAppBarColor,
                                      fontFamily: kNormalTextFontFamily,
                                      fontSize: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: Text(
                                          translate.canceled,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .indicatorColor,
                                            fontFamily: kNormalTextFontFamily,
                                            fontSize: 14,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 40.0, top: 21),
                              child: Text(
                                translate.card,
                                style: TextStyle(
                                  color: Theme.of(context).bottomAppBarColor,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 40.0, top: 12),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/finance_page/visa.svg",
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      '07/24',
                                      style: TextStyle(
                                        color:
                                            Theme.of(context).bottomAppBarColor,
                                        fontFamily: kNormalTextFontFamily,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 40.0, top: 4),
                              child: Row(
                                children: [
                                  Text(
                                    '••••   ••••   ••••   3282',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).bottomAppBarColor,
                                      fontFamily: kNormalTextFontFamily,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      translate.change,
                                      style: TextStyle(
                                        color: Theme.of(context).splashColor,
                                        fontFamily: kNormalTextFontFamily,
                                        fontSize: 14,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
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
            otherSub(theme),
          ]),
        ],
      ),
    );
  }

  otherSub(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 25),
          child: Container(
            child: Text(
              translate.other_sub,
              style: TextStyle(
                color: Theme.of(context).focusColor,
                fontFamily: kNormalTextFontFamily,
                fontSize: 20,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 30, right: 40),
          child: Row(
            children: [
              Container(
                width: 240,
                height: 312,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context).dividerColor, width: 3),
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0, left: 40),
                          child: Text(
                            '2 ГБ',
                            style: TextStyle(
                              color: Theme.of(context).splashColor,
                              fontFamily: kNormalTextFontFamily,
                              fontSize: 36,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0, left: 40),
                          child: Text(
                            translate.free_sub,
                            maxLines: 2,
                            style: TextStyle(
                              color: Theme.of(context).bottomAppBarColor,
                              fontFamily: kNormalTextFontFamily,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 40, top: 60),
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text(
                              translate.select,
                              style: TextStyle(
                                color: Theme.of(context).splashColor,
                                fontSize: 16,
                                fontFamily: kNormalTextFontFamily,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              fixedSize: Size(160, 42),
                              elevation: 0,
                              side: BorderSide(
                                style: BorderStyle.solid,
                                color: Theme.of(context).splashColor,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                  width: 240,
                  height: 312,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).dividerColor, width: 3),
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0, left: 40),
                            child: Text(
                              '100 ГБ',
                              style: TextStyle(
                                color: Theme.of(context).splashColor,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 36,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0, left: 40),
                            child: Text(
                              '189 ₽/месяц',
                              maxLines: 2,
                              style: TextStyle(
                                color: Theme.of(context).bottomAppBarColor,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, left: 40),
                            child: Text(
                              '1890 ₽/год',
                              maxLines: 2,
                              style: TextStyle(
                                color: Theme.of(context).bottomAppBarColor,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 40, top: 40),
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                translate.select,
                                style: TextStyle(
                                  color: Theme.of(context).splashColor,
                                  fontSize: 16,
                                  fontFamily: kNormalTextFontFamily,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                fixedSize: Size(160, 42),
                                elevation: 0,
                                side: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Theme.of(context).splashColor,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                  width: 240,
                  height: 312,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).dividerColor, width: 3),
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0, left: 40),
                            child: Text(
                              '500 ГБ',
                              style: TextStyle(
                                color: Theme.of(context).splashColor,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 36,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0, left: 40),
                            child: Text(
                              '189 ₽/месяц',
                              maxLines: 2,
                              style: TextStyle(
                                color: Theme.of(context).bottomAppBarColor,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, left: 40),
                            child: Text(
                              '1890 ₽/год',
                              maxLines: 2,
                              style: TextStyle(
                                color: Theme.of(context).bottomAppBarColor,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 40, top: 40),
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                translate.select,
                                style: TextStyle(
                                  color: Theme.of(context).splashColor,
                                  fontSize: 16,
                                  fontFamily: kNormalTextFontFamily,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                fixedSize: Size(160, 42),
                                elevation: 0,
                                side: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Theme.of(context).splashColor,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Container(
                  width: 240,
                  height: 312,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).dividerColor,
                      width: 3,
                    ),
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0, left: 40),
                            child: Text(
                              '1 ТБ',
                              style: TextStyle(
                                color: Theme.of(context).splashColor,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 36,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0, left: 40),
                            child: Text(
                              '189 ₽/месяц',
                              maxLines: 2,
                              style: TextStyle(
                                color: Theme.of(context).bottomAppBarColor,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, left: 40),
                            child: Text(
                              '1890 ₽/год',
                              maxLines: 2,
                              style: TextStyle(
                                color: Theme.of(context).bottomAppBarColor,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 40, top: 40),
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                translate.select,
                                style: TextStyle(
                                  color: Theme.of(context).splashColor,
                                  fontSize: 16,
                                  fontFamily: kNormalTextFontFamily,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                fixedSize: Size(160, 42),
                                elevation: 0,
                                side: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Theme.of(context).splashColor,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
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
      ],
    );
  }

  Widget withdrawFunds(BuildContext context) {
    return Expanded(
      child: Column(
        children: [],
      ),
    );
  }
}
