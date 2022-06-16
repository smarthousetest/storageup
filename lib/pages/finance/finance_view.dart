import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/components/blur/cancel_sub.dart';
import 'package:upstorage_desktop/components/blur/failed_server_conection.dart';
import 'package:upstorage_desktop/components/custom_button_template.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/pages/finance/finance_bloc.dart';
import 'package:upstorage_desktop/pages/finance/finance_event.dart';
import 'package:upstorage_desktop/pages/finance/finance_state.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/extensions.dart';
import 'package:upstorage_desktop/utilites/state_container.dart';

class FinancePage extends StatefulWidget {
  @override
  _FinancePageState createState() => _FinancePageState();
  FinancePage();
}

class _FinancePageState extends State<FinancePage> {
  S translate = getIt<S>();
  var index = 0;
  List<GlobalKey> _keys = [];
  var pointedSubCardIndex = -1;
  final double _rowSpasing = 20.0;
  final double _rowPadding = 30.0;
  double? _searchFieldWidth;

  void _setWidthSearchFields(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    _searchFieldWidth = width - _rowSpasing * 3 - 30 * 2 - _rowPadding * 2 - 274 - 172;
  }

  @override
  void initState() {
    for (var i = 0; i < 2; i++) {
      _keys.add(GlobalKey());
    }

    super.initState();
  }

  Widget build(BuildContext context) {
    _setWidthSearchFields(context);
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
            color: index == ind ? Theme.of(context).splashColor : Colors.transparent,
          ),
        ),
      );
    };

    ThemeData theme = Theme.of(context);
    return BlocProvider(
      create: (context) => getIt<FinanceBloc>()..add(FinancePageOpened()),
      child: BlocListener<FinanceBloc, FinanceState>(
        listener: (context, state) async {
          if (state.sub?.tariff?.spaceGb == null) {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return BlurFailedServerConnection(true);
              },
            );
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30, top: 30),
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: <BoxShadow>[BoxShadow(color: Color.fromARGB(25, 23, 69, 139), blurRadius: 4, offset: Offset(1, 4))],
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(13.0),
                                child: Align(
                                  alignment: FractionalOffset.centerLeft,
                                  child: Container(width: 20, height: 20, child: SvgPicture.asset("assets/file_page/search.svg")),
                                ),
                              ),
                              Container(
                                width: _searchFieldWidth,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      StateContainer.of(context).changePage(ChosenPage.file);
                                    },
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Container(
                                        child: Text(
                                          translate.search,
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Theme.of(context).disabledColor,
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
                      ),
                    ),
                    Container(
                      height: 46,
                      child: BlocBuilder<FinanceBloc, FinanceState>(builder: (context, state) {
                        return state.valueNotifier != null
                            ? ValueListenableBuilder<User?>(
                                valueListenable: state.valueNotifier!,
                                builder: (context, value, _) {
                                  return Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 20, left: 0),
                                        child: GestureDetector(
                                          onTap: () {
                                            StateContainer.of(context).changePage(ChosenPage.settings);
                                          },
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(23.0),
                                              child: Container(child: value.image),
                                            ),
                                          ),
                                        ),
                                      ),
                                      (MediaQuery.of(context).size.width > 965)
                                          ? Container(
                                              constraints: BoxConstraints(maxWidth: 120),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                                    child: Text(
                                                      value?.firstName ?? value?.email?.split('@').first ?? 'Name',
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        color: Theme.of(context).bottomAppBarColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    value?.email ?? '',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Theme.of(context).bottomAppBarColor,
                                                      height: 1,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  );
                                })
                            : Container();
                      }),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: <BoxShadow>[BoxShadow(color: Color.fromARGB(25, 23, 69, 139), blurRadius: 4, offset: Offset(1, 4))],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  //mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
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
                                      color: index == 0 ? Theme.of(context).focusColor : Theme.of(context).textTheme.subtitle1?.color,
                                      fontFamily: kNormalTextFontFamily,
                                      fontSize: 24,
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
                                        color: index == 1 ? Theme.of(context).focusColor : Theme.of(context).textTheme.subtitle1?.color,
                                        fontFamily: kNormalTextFontFamily,
                                        fontSize: 24,
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
          ],
        ),
      ),
    );
  }

  // Widget subcription(ThemeData theme) {
  //   return activeSub(theme);
  // }

  Widget subcription(ThemeData theme) {
    return ListView(
      controller: ScrollController(),
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
                  fontSize: 24,
                ),
              ),
            ),
          ),
          (MediaQuery.of(context).size.width > 1465)
              ? Padding(
                  padding: const EdgeInsets.only(left: 40, top: 30),
                  child: Row(
                    children: [
                      activeSub(context),
                      subInfo(context),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 40, top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 200),
                            child: subInfo(context),
                          ),
                          activeSub(context),
                        ],
                      ),
                    ],
                  ),
                ),
          ...otherSub(theme),
        ]),
      ],
    );
  }

  Widget activeSub(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 0, top: 0),
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
                BlocBuilder<FinanceBloc, FinanceState>(builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 40.0, left: 40),
                    child: Text(
                      translate.current_subscription_title(state.sub?.tariff?.spaceGb ?? '', state.sub?.tariff?.priceRub ?? ''),
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontFamily: kNormalTextFontFamily,
                        fontSize: 36,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, left: 40),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Theme.of(context).primaryColor,
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
            Align(
              alignment: Alignment.topRight,
              child: SvgPicture.asset(
                "assets/finance_page/ellipse_right.svg",
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: SvgPicture.asset(
                "assets/finance_page/ellipse_left.svg",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget subInfo(BuildContext context) {
    return BlocBuilder<FinanceBloc, FinanceState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.only(left: 0, top: 0, right: 40),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0, left: 40),
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
                padding: const EdgeInsets.only(top: 8.0, left: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      translate.current_subscription_payment(DateTime.now(), state.sub?.tariff?.priceRub?.toInt() ?? ''),
                      style: TextStyle(
                        color: Theme.of(context).bottomAppBarColor,
                        fontFamily: kNormalTextFontFamily,
                        fontSize: 14,
                      ),
                    ),
                    BlocBuilder<FinanceBloc, FinanceState>(builder: (context, state) {
                      var choosedSubGb = state.sub?.tariff?.spaceGb;
                      var allFilledGb = state.packetInfo?.filledSpace;
                      if (allFilledGb == null && choosedSubGb == null) {
                        return GestureDetector(
                          onTap: () async {
                            var str = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return BlurFailedServerConnection(true);
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Text(
                                translate.canceled,
                                style: TextStyle(
                                  color: Theme.of(context).indicatorColor,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () async {
                            var str = await showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return BlurCancelSub(choosedSubGb, DateTime.now(), allFilledGb);
                              },
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: Text(
                                translate.canceled,
                                style: TextStyle(
                                  color: Theme.of(context).indicatorColor,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 14,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    }),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, top: 21),
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
                padding: const EdgeInsets.only(left: 40.0, top: 12),
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
                          color: Theme.of(context).bottomAppBarColor,
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, top: 4),
                child: Row(
                  children: [
                    Text(
                      '••••   ••••   ••••   3282',
                      style: TextStyle(
                        color: Theme.of(context).bottomAppBarColor,
                        fontFamily: kNormalTextFontFamily,
                        fontSize: 14,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: GestureDetector(
                        onTap: () {},
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
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
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  List<Widget> otherSub(ThemeData theme) {
    return [
      Padding(
        padding: const EdgeInsets.only(left: 40, top: 25),
        child: Container(
          child: Text(
            translate.other_sub,
            style: TextStyle(
              color: Theme.of(context).focusColor,
              fontFamily: kNormalTextFontFamily,
              fontSize: 24,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
      Container(
          margin: EdgeInsets.only(left: 40, top: 30, right: 40, bottom: 30),
          height: 312,
          child: BlocBuilder<FinanceBloc, FinanceState>(builder: (context, state) {
            //var sub = state.allSub;
            var subscription = List.from(state.allSub);
            subscription.removeWhere((element) => element.id == state.sub?.tariff?.id);
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: subscription.length,
                itemBuilder: (context, index) {
                  return MouseRegion(
                    onExit: (event) {
                      setState(() {
                        pointedSubCardIndex = -1;
                      });
                    },
                    onEnter: (event) {
                      setState(() {
                        pointedSubCardIndex = index;
                      });
                    },
                    child: Container(
                      width: 230,
                      height: 312,
                      margin: EdgeInsets.only(right: 50),
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).dividerColor, width: 3),
                        color: pointedSubCardIndex == index ? Theme.of(context).splashColor : Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0, left: 35),
                            child: Text(
                              translate.gb(subscription[index].spaceGb.toString()),
                              style: TextStyle(
                                color: pointedSubCardIndex == index ? Theme.of(context).primaryColor : Theme.of(context).splashColor,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 36,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30.0, left: 35),
                            child: Text(
                              translate.subscription_pay_mounth(subscription[index].priceRub ?? ''),
                              maxLines: 2,
                              style: TextStyle(
                                color: pointedSubCardIndex == index ? Theme.of(context).primaryColor : Theme.of(context).bottomAppBarColor,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 35, top: 60),
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: ElevatedButton(
                                onPressed: () {
                                  context.read<FinanceBloc>().add(ChangeSubscription(choosedSub: subscription[index].id!));
                                },
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
                          ),
                        ],
                      ),
                    ),
                  );
                });
          })),
    ];
  }

  Widget withdrawFunds(BuildContext context) {
    return Column(
      children: [],
    );
  }
}
