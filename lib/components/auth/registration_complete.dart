import 'package:flutter/material.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

class RegistrationComplete extends StatefulWidget {
  RegistrationComplete({
    Key? key,
    required this.changePage,
  }) : super(key: key);

  final VoidCallback changePage;

  @override
  State<RegistrationComplete> createState() => _RegistrationCompleteState();
}

class _RegistrationCompleteState extends State<RegistrationComplete> {
  S translate = getIt<S>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(),
            flex: 3,
          ),
          Center(
            child: Text(
              translate.register_complete,
              style: TextStyle(
                color: theme.disabledColor,
                fontFamily: kNormalTextFontFamily,
                fontSize: 28.0,
              ),
            ),
          ),
          Expanded(
            child: Container(),
            flex: 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 160),
            child: Text(
              translate.email_successfully,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.disabledColor,
                fontFamily: kNormalTextFontFamily,
                fontSize: 17.0,
              ),
            ),
          ),
          SizedBox(
            height: 250,
          ),
          ElevatedButton(
            onPressed: () {
              widget.changePage();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.symmetric(
                horizontal: 147,
                vertical: 25,
              ),
              primary: theme.splashColor,
              elevation: 1,
            ),
            child: Text(
              translate.go_to_authorization,
              style: TextStyle(
                color: theme.primaryColor,
                fontFamily: kNormalTextFontFamily,
                fontSize: 17,
              ),
            ),
          ),
          Expanded(
            child: Container(),
            flex: 3,
          ),
        ]);
  }
}
