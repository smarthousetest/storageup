import 'package:flutter/material.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/utilities/injection.dart';

class AlreadyHaveAccount extends StatefulWidget {
  AlreadyHaveAccount({Key? key, required this.changePage}) : super(key: key);

  final VoidCallback changePage;

  @override
  State<AlreadyHaveAccount> createState() => _AlreadyHaveAccountState();
}

class _AlreadyHaveAccountState extends State<AlreadyHaveAccount> {
  S translate = getIt<S>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var widthOfContainer = 560.0;
    return Container(
      width: widthOfContainer,
      decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage('assets/auth/cloudsLeft.png'),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 125,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              translate.already_have_an_account,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: theme.primaryColor,
                  fontSize: 28,
                  fontFamily: kNormalTextFontFamily,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Image.asset(
              'assets/auth/man_left.png',
              fit: BoxFit.fitWidth,
            ),
          ),
          Expanded(child: Container()),
          Container(
            height: 60,
            width: 320,
            child: ElevatedButton(
              onPressed: () {
                widget.changePage();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                primary: theme.primaryColor,
              ),
              child: Center(
                child: Text(
                  translate.sign_in,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.scaffoldBackgroundColor,
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 17,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
