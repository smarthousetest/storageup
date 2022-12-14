import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:storageup/components/blur/custom_error_popup.dart';
import 'package:storageup/components/custom_text_field.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/pages/auth/forgot_password/forgot_password_event.dart';
import 'package:storageup/utilities/state_containers/state_container.dart';
import 'package:storageup/utilities/injection.dart';

import 'forgot_password_bloc.dart';
import 'forgot_password_state.dart';

class ForgotPasswordView extends StatefulWidget {
  ForgotPasswordView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
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
    return BlocProvider(
      create: (context) => getIt<ForgotPasswordBloc>(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 230,
          vertical: 150,
        ),
        child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) async {
            if (StateContainer.of(context).isPopUpShowing == false) {
              if (state.status == FormzStatus.submissionFailure) {
                StateContainer.of(context).changeIsPopUpShowing(true);
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return BlurCustomErrorPopUp(
                      middleText: translate.something_goes_wrong,
                    );
                  },
                );
                StateContainer.of(context).changeIsPopUpShowing(false);
              } else if (state.status == FormzStatus.submissionCanceled) {
                StateContainer.of(context).changeIsPopUpShowing(true);
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return BlurCustomErrorPopUp(
                        middleText: translate.no_internet);
                  },
                );
                StateContainer.of(context).changeIsPopUpShowing(false);
              }
            }
          },
          child: Material(
            borderRadius: BorderRadius.circular(13),
            color: theme.primaryColor,
            child: BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(top: 20.0, right: 20.0),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Image.asset(
                            'assets/auth/close.png',
                            width: 12,
                            height: 12,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        translate.password_recovery,
                        style: TextStyle(
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 26.0,
                          color: theme.disabledColor,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(),
                      flex: 2,
                    ),
                    ..._body(theme, state),
                    BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                      builder: (context, state) {
                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 245.0),
                          child: OutlinedButton(
                            onPressed: _buttonAction(state, context),
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(double.maxFinite, 60),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              // padding: EdgeInsets.symmetric(
                              //   horizontal: 135,
                              //   vertical: 20,
                              // ),
                              backgroundColor: state.email.invalid ||
                                      state.email.value.isEmpty
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                            ),
                            child: Text(
                              state.status == FormzStatus.submissionSuccess
                                  ? translate.back_to_main
                                  : translate.continue_button,
                              style: TextStyle(
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 17.0,
                                color: theme.primaryColor,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: Container(),
                      flex: 2,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  final node = FocusNode();

  List<Widget> _body(ThemeData theme, ForgotPasswordState state) {
    if (state.status != FormzStatus.submissionSuccess)
      return _bodyRequest(theme);
    else
      return _bodyResult(theme);
  }

  List<Widget> _bodyRequest(ThemeData theme) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 200),
        child: Center(
          child: Text(
            translate.password_recovery_enter_email,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.disabledColor,
              fontSize: 18,
              fontFamily: kNormalTextFontFamily,
            ),
          ),
        ),
      ),
      Expanded(
        child: Container(),
        flex: 2,
      ),
      BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
        builder: (context, state) {
          return RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (event) {
                if (event.isKeyPressed(LogicalKeyboardKey.backspace) ||
                    event.isKeyPressed(LogicalKeyboardKey.delete)) {
                  FocusScope.of(context).requestFocus(node);
                }
              },
              child: CustomTextField(
                autofocus: true,
                hint: translate.email,
                focusNode: node,
                onChange: (email) {
                  context.read<ForgotPasswordBloc>().add(
                        ForgotPasswordEmailChanged(
                          email: email,
                          needValidation: true,
                        ),
                      );
                },
                onSubmitted: () {
                  var action = _buttonAction(state, context);

                  if (action is Function()) {
                    action();
                  }
                },
                invalid: state.email.invalid && state.email.value.isNotEmpty ||
                    state.error == AuthError.wrongCredentials,
                errorMessage: state.error == AuthError.wrongCredentials
                    ? translate.non_existent_email
                    : translate.wrong_email,
                needErrorValidation: true,
                isPassword: false,
                horizontalPadding: 170,
                onFinishEditing: (String) {},
              ));
        },
      ),
      Expanded(
        child: Container(),
        flex: 4,
      ),
    ];
  }

  Function()? _buttonAction(
    ForgotPasswordState state,
    BuildContext context,
  ) {
    if (state.status == FormzStatus.submissionSuccess)
      return () {
        Navigator.pop(context);
      };

    if (state.email.valid && state.email.value.isNotEmpty)
      return () {
        setState(() {
          context.read<ForgotPasswordBloc>().add(ForgotPasswordConfirmed());
        });
      };
    else
      return null;
  }

  // bool nothingOnEmail = false;

  List<Widget> _bodyResult(ThemeData theme) {
    var nowDateTime = DateTime.now();

    return [
      BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
        builder: (context, state) {
          Expanded(
            child: Container(),
            flex: 4,
          );
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 170.0),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: translate.restore_password_before_email,
                style: TextStyle(
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 18,
                  color: theme.disabledColor,
                ),
                children: [
                  TextSpan(text: state.email.value),
                  TextSpan(
                    text: translate.restore_password_after_email,
                  )
                ],
              ),
            ),
          );
        },
      ),
      Expanded(
        child: Container(),
        flex: 1,
      ),
      BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
        builder: (context, state) {
          return Center(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  if (isEmailResendAvailable(nowDateTime)) {
                    print("Resend letter");
                    context
                        .read<ForgotPasswordBloc>()
                        .add(ForgotPasswordConfirmed());
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
                    fontSize: 17,
                    color: theme.splashColor,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      Expanded(
        child: Container(),
        flex: 3,
      ),
    ];
  }
}
