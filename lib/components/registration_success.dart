import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/pages/auth/auth_bloc.dart';
import 'package:storageup/pages/auth/auth_event.dart';
import 'package:storageup/pages/auth/auth_state.dart';
import 'package:storageup/utilities/injection.dart';

class RegistrationSuccess extends StatefulWidget {
  RegistrationSuccess({
    Key? key,
    required this.state,
    required this.changePage,
  }) : super(key: key);

  final AuthState state;
  final VoidCallback changePage;

  @override
  State<RegistrationSuccess> createState() => _RegistrationSuccessState();
}

class _RegistrationSuccessState extends State<RegistrationSuccess> {
  static const delayBetweenSendingEmails = Duration(seconds: 30);

  S translate = getIt<S>();

  DateTime? lastSubmittedTime;
  Timer? timer;

  Duration getTimeLeftToWaitUntilNextResend(DateTime nowDateTime) {
    var submittedTime = lastSubmittedTime;

    if (submittedTime is! DateTime) {
      return Duration(seconds: 0);
    }

    return delayBetweenSendingEmails - nowDateTime.difference(submittedTime);
  }

  bool isEmailResendAvailable(DateTime nowDateTime) {
    var submittedTime = lastSubmittedTime;

    if (submittedTime is! DateTime) {
      return true;
    }

    if (nowDateTime.difference(submittedTime) >= Duration(seconds: 30)) {
      return true;
    }

    return false;
  }

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var nowDateTime = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(),
          flex: 5,
        ),
        Center(
          child: Text(
            translate.email_confirming_reg,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontFamily: kNormalTextFontFamily,
              fontSize: 28.0,
              color: theme.disabledColor,
            ),
          ),
        ),
        Expanded(
          child: Container(),
          flex: 2,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 120),
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              text: translate.email_confirming_confirm + "\n\n",
              style: TextStyle(
                color: theme.disabledColor,
                fontFamily: kNormalTextFontFamily,
                fontSize: 17.0,
              ),
              children: [
                TextSpan(
                    text: translate.email_confirming_letter,
                    style: TextStyle(
                      color: theme.disabledColor,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 17.0,
                    )),
                TextSpan(
                    text: widget.state.emailRegister.value + "\n",
                    style: TextStyle(
                      color: theme.disabledColor,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 17.0,
                    )),
                TextSpan(
                    text: translate.email_confirming_link,
                    style: TextStyle(
                      color: theme.disabledColor,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 17.0,
                    )),
              ],
            ),
          ),
        ),
        Expanded(
          child: Container(),
          flex: 3,
        ),
        MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              if (isEmailResendAvailable(nowDateTime)) {
                print("Resend letter");
                context.read<AuthBloc>().add(AuthSendEmailVerify());
                lastSubmittedTime = DateTime.now();
              }
            },
            child: Text(
              isEmailResendAvailable(nowDateTime)
                  ? translate.to_send_letter
                  : "${translate.resend_letter_available} ${translate.seconds(getTimeLeftToWaitUntilNextResend(nowDateTime).inSeconds)}",
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontFamily: kNormalTextFontFamily,
                fontSize: 17.0,
                color: theme.splashColor,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 97,
        ),
        Expanded(child: Container()),
        Container(
          height: 60,
          width: 480,
          child: ElevatedButton(
            onPressed: () {
              context.read<AuthBloc>().add(AuthClear());
              widget.changePage();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              // padding: EdgeInsets.symmetric(
              //   horizontal: 140,
              //   vertical: 20,
              // ),
              primary: theme.splashColor,
              elevation: 1,
            ),
            child: Text(
              translate.back_to_authorization,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                color: theme.primaryColor,
                fontFamily: kNormalTextFontFamily,
                fontSize: 17,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 100,
        ),
      ],
    );
  }
} // RegitrationSuccess
