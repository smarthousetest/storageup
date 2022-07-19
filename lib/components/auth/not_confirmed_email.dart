import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/pages/auth/auth_bloc.dart';
import 'package:storageup/pages/auth/auth_event.dart';
import 'package:storageup/pages/auth/auth_state.dart';
import 'package:storageup/utilities/injection.dart';

class TimerSave {
  static Timer? timer;
  static int timerTime = 30;
  static Function()? onTick;

  static void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (timerTime == 1) {
          timer.cancel();
          timerTime = 30;
          onTick?.call();
        } else {
          timerTime--;
          onTick?.call();
        }
      },
    );
  }
}

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
  bool get canPress => TimerSave.timerTime == 30;

  @override
  void initState() {
    TimerSave.onTick = () => setState(() {});
    super.initState();
  }

  @override
  void dispose() {
    TimerSave.onTick = null;
    super.dispose();
  }

  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
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
          canPress
              ? Padding(
                  padding: const EdgeInsets.only(left: 240, top: 40),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                        onTap: (() {
                          if (canPress == true) {
                            context.read<AuthBloc>().add(AuthSendEmailVerify());
                            TimerSave.startTimer();
                            setState(() {});
                          }
                        }),
                        child: Text(
                          translate.to_send_letter,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontFamily: kNormalTextFontFamily,
                            fontSize: 17.0,
                            color: theme.splashColor,
                          ),
                        )),
                  ),
                )
              : Container(
                  padding: const EdgeInsets.only(
                      bottom: 10.0, left: 190, right: 35, top: 40),
                  child: Text(
                      translate.email_send +
                          "\n${TimerSave.timerTime}" +
                          translate.sec,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.splashColor,
                        fontFamily: kNormalTextFontFamily,
                        fontSize: 17,
                      )),
                ),
          canPress
              ? Expanded(
                  child: Container(),
                  flex: 3,
                )
              : Expanded(
                  child: Container(),
                  flex: 2,
                ),
          Padding(
            padding: const EdgeInsets.only(left: 110, top: 110),
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
