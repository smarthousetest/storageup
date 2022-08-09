import 'package:flutter/material.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/utilities/injection.dart';

class SellSpaceNoInternetPage extends StatefulWidget {
  const SellSpaceNoInternetPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SellSpaceNoInternetPage> createState() =>
      _SellSpaceNoInternetPageState();
}

class _SellSpaceNoInternetPageState extends State<SellSpaceNoInternetPage> {
  S translate = getIt<S>();

  @override
  Widget build(BuildContext context) {
    return ListView(controller: ScrollController(), children: [
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        Container(
            child: Image.asset("assets/space_sell/sell_space_no_internet.png")),
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 30),
          child: Container(
            child: Text(
              translate.sell_space_no_internet_part_1,
              style: TextStyle(
                color: Theme.of(context).textTheme.subtitle1?.color,
                fontFamily: kNormalTextFontFamily,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 15),
          child: Container(
            child: Text(
              translate.sell_space_no_internet_part_2,
              style: TextStyle(
                color: Theme.of(context).textTheme.subtitle1?.color,
                fontFamily: kNormalTextFontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ]),
    ]);
  }
}
