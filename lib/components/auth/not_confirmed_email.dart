import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/pages/auth/auth_bloc.dart';
import 'package:storageup/pages/auth/auth_event.dart';
import 'package:storageup/pages/auth/auth_state.dart';
import 'package:storageup/utilities/injection.dart';

class NotConfirmedEmail extends StatefulWidget {
  NotConfirmedEmail({
    Key? key,
    required this.onPressed,
    required this.state,
  }) : super(key: key);

  final AuthState state;
  final VoidCallback onPressed;

  @override
  State<NotConfirmedEmail> createState() => _NotConfirmedEmailState();
}

class _NotConfirmedEmailState extends State<NotConfirmedEmail> {
  S translate = getIt<S>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(),
            flex: 3,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 190, right: 160, top: 73),
            child: Text(
              translate.confirm_email,
              style: TextStyle(
                color: theme.disabledColor,
                fontFamily: kNormalTextFontFamily,
                fontSize: 28.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 120, top: 40),
            child: Column(
              children: [
                Text(
                  translate.you_cant_enter,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.disabledColor,
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 17.0,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 120, top: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate.we_send + ' ' + widget.state.emailLogin.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.disabledColor,
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 17.0,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate.for_confirm,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.disabledColor,
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 17.0,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 240, top: 97),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () =>
                    context.read<AuthBloc>().add(AuthSendEmailVerify()),
                child: Text(
                  translate.to_send_letter,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 17.0,
                    color: theme.splashColor,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 110, top: 131),
            child: ElevatedButton(
              onPressed: widget.onPressed,
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
          ),
          Expanded(
            child: Container(),
            flex: 3,
          ),
        ]);
  }
} // NotConfirmedEmail
