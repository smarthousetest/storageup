import 'package:flutter/material.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/utilities/injection.dart';

class SignInWelcome extends StatefulWidget {
  const SignInWelcome({
    Key? key,
    required this.changePage,
  }) : super(key: key);

  final VoidCallback changePage;

  @override
  State<SignInWelcome> createState() => _SignInWelcomeState();
}

class _SignInWelcomeState extends State<SignInWelcome> {
  S translate = getIt<S>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var widthOfContainer = 560.0;

    return Container(
      width: widthOfContainer,
      decoration: BoxDecoration(
          color: theme.accentColor,
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage('assets/auth/oblakaRight.png'),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 112,
          ),
          Text(
            translate.welcome_to_upstorage,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: theme.primaryColor,
                fontSize: 28,
                fontFamily: kNormalTextFontFamily,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Text(
              translate.still_dont_have_account,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 17,
                fontFamily: kNormalTextFontFamily,
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 51),
            child: Container(
              //height: 375,
              child: Image.asset(
                'assets/auth/man_right.png',
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Spacer(),
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
                translate.register,
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  color: theme.accentColor,
                  fontFamily: kNormalTextFontFamily,
                  //height: 1.176470588235294,
                  fontSize: 17,
                ),
              )),
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
