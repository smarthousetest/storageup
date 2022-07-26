import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:storageup/components/auth/blur_load_page.dart';
import 'package:storageup/components/custom_text_field.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/pages/auth/auth_bloc.dart';
import 'package:storageup/pages/auth/auth_event.dart';
import 'package:storageup/pages/auth/auth_state.dart';
import 'package:storageup/pages/auth/forgot_password/forgot_password_view.dart';
import 'package:storageup/utilities/injection.dart';

class SignInMain extends StatefulWidget {
  SignInMain({Key? key, required this.state, required this.signInEmailNode})
      : super(key: key);

  final AuthState state;
  final FocusNode signInEmailNode;

  @override
  State<SignInMain> createState() => _SignInMainState();
}

class _SignInMainState extends State<SignInMain> {
  S translate = getIt<S>();

  late BuildContext dialogContext;
  var signInPasswordNode = FocusNode();
  var rememberMeNode = FocusNode();
  var submitButtonNode = FocusNode();

  Future<void> onSignIn(BuildContext context, AuthState state) async {
    if (_isLoginFieldValid(state)) {
      context.read<AuthBloc>().add(AuthLoginConfirmed());
    }
  }

  bool _isLoginFieldValid(AuthState state) {
    return state.emailLogin.valid &&
        state.emailLogin.value.isNotEmpty &&
        state.passwordLogin.valid &&
        state.passwordLogin.value.isNotEmpty;
  }

  void _onForgotPasswordTapped() {
    showDialog(context: context, builder: (context) => ForgotPasswordView());
  }

  @override
  void initState() {
    widget.signInEmailNode.onKeyEvent = (_, event) {
      if (event.logicalKey == LogicalKeyboardKey.tab && event is KeyDownEvent) {
        signInPasswordNode.requestFocus();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    };
    signInPasswordNode.onKeyEvent = (_, event) {
      if (event.logicalKey == LogicalKeyboardKey.tab && event is KeyDownEvent) {
        rememberMeNode.requestFocus();
        setState(() {});
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    };
    rememberMeNode.onKeyEvent = (_, event) {
      if (event.logicalKey == LogicalKeyboardKey.tab && event is KeyDownEvent) {
        submitButtonNode.requestFocus();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.enter &&
          event is KeyDownEvent) {
        if (widget.state.rememberMe) {
          onSignIn(context, widget.state);
        } else {
          context.read<AuthBloc>().add(AuthRememberMeChanged());
        }
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    };
    submitButtonNode.onKeyEvent = (_, event) {
      onSignIn(context, widget.state);
      return KeyEventResult.handled;
    };
    super.initState();
  }

  @override
  void dispose() {
    signInPasswordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state.status == FormzStatus.submissionFailure &&
            state.action == RequestedAction.login) {
          Timer(const Duration(milliseconds: 200),
              () => Navigator.pop(dialogContext));
        }
      },
      child: Focus(
        onKeyEvent: (node, event) {
          if (event.logicalKey == LogicalKeyboardKey.enter &&
              event is KeyDownEvent) {
            onSignIn(context, widget.state);
            return KeyEventResult.handled;
          }

          return KeyEventResult.ignored;
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(),
              flex: 3,
            ),
            Text(
              translate.sign_in_to_account,
              style: TextStyle(
                fontFamily: kNormalTextFontFamily,
                fontSize: 28,
                fontWeight: FontWeight.w400,
                color: theme.disabledColor,
              ),
            ),
            SizedBox(height: 63),
            CustomTextField(
              autofocus: true,
              focusNode: widget.signInEmailNode,
              hint: translate.email,
              errorMessage: translate.wrong_email,
              needErrorValidation: true,
              onChange: (email) {
                context.read<AuthBloc>().add(
                    AuthLoginEmailChanged(email: email, needValidation: true));
              },
              onFinishEditing: (email) {
                context.read<AuthBloc>().add(
                    AuthLoginEmailChanged(email: email, needValidation: true));
              },
              onSubmitted: () {
                onSignIn(context, widget.state);
              },
              invalid: widget.state.emailLogin.invalid &&
                  widget.state.emailLogin.value.isNotEmpty,
              isPassword: false,
            ),
            CustomTextField(
              focusNode: signInPasswordNode,
              hint: translate.password,
              errorMessage: translate.wrong_password,
              onChange: (password) {
                context.read<AuthBloc>().add(AuthLoginPasswordChanged(
                      password: password,
                      needValidation: true,
                    ));
              },
              onFinishEditing: (password) {
                context.read<AuthBloc>().add(AuthLoginPasswordChanged(
                      password: password,
                      needValidation: true,
                    ));
              },
              onSubmitted: () {
                onSignIn(context, widget.state);
              },
              invalid: widget.state.passwordLogin.invalid &&
                  widget.state.passwordLogin.value.isNotEmpty,
              isPassword: true,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 123,
                right: 120,
              ),
              child: Row(
                children: [
                  Container(
                    height: 23,
                    width: 23,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      color: widget.state.rememberMe
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onPrimary,
                    ),
                    padding: EdgeInsets.all(1.5),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: theme.primaryColor,
                      ),
                      child: Focus(
                        focusNode: rememberMeNode,
                        child: Checkbox(
                          value: widget.state.rememberMe,
                          side: BorderSide(
                              width: 1,
                              color: rememberMeNode.hasFocus
                                  ? theme.scaffoldBackgroundColor
                                  : Colors.transparent),
                          splashRadius: 0,
                          checkColor: theme.scaffoldBackgroundColor,
                          activeColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0)),
                          onChanged: (_) {
                            if (!rememberMeNode.hasFocus) {
                              rememberMeNode.requestFocus();
                            }
                            context
                                .read<AuthBloc>()
                                .add(AuthRememberMeChanged());
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    translate.remember_me,
                    style: TextStyle(
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 17,
                      color: theme.disabledColor,
                    ),
                  ),
                  Expanded(child: Container()),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: _onForgotPasswordTapped,
                      child: Text(
                        translate.forgot_password,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 17,
                          color: theme.splashColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Divider(
                      height: 1,
                      endIndent: 10,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  Text(
                    translate.or_continue_with,
                    style: TextStyle(
                      fontSize: 17,
                      height: 0.82,
                      fontFamily: kNormalTextFontFamily,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      height: 1,
                      indent: 10,
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container(
                //   decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(15),
                //       color: theme.primaryColor,
                //       boxShadow: [
                //         BoxShadow(
                //           color:
                //               theme.colorScheme.onBackground.withOpacity(0.5),
                //           blurRadius: 4,
                //         )
                //       ]),
                //   child: Padding(
                //     padding: const EdgeInsets.all(12.0),
                //     child: Image.asset(
                //       'assets/auth/facebook.png',
                //       width: 27,
                //       height: 27,
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   width: 25.0,
                // ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: theme.primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color:
                              theme.colorScheme.onBackground.withOpacity(0.5),
                          blurRadius: 4,
                        )
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      'assets/auth/google.png',
                      width: 27,
                      height: 27,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 120),
              child: Visibility(
                visible: widget.state.status == FormzStatus.submissionFailure &&
                    widget.state.action == RequestedAction.login,
                child: Row(
                  children: [
                    widget.state.error != AuthError.noVerifiedEmail
                        ? Image.asset(
                            'assets/auth/error.png',
                            height: 20,
                            width: 20,
                          )
                        : SizedBox(
                            width: 5,
                          ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        widget.state.error == AuthError.wrongCredentials
                            ? translate.wrong_cred
                            : widget.state.error == AuthError.noVerifiedEmail
                                ? ''
                                : widget.state.error == AuthError.noInternet
                                    ? translate.no_internet_auth
                                    : translate.internal_server_error_auth,
                        style: TextStyle(
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 16,
                          color: theme.disabledColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 120),
              child: Container(
                height: 60,
                child: OutlinedButton(
                  autofocus: true,
                  focusNode: submitButtonNode,
                  onPressed: () async => {
                    onSignIn(context, widget.state),
                    await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        dialogContext = context;
                        return BlurLoadPage();
                      },
                    ),
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.maxFinite, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    padding: EdgeInsets.symmetric(
                      horizontal: 135,
                      vertical: 20,
                    ),
                    backgroundColor: _isLoginFieldValid(widget.state)
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onPrimary,
                  ),
                  child: Center(
                      child: Text(
                    translate.sign_in,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 17,
                    ),
                  )),
                ),
              ),
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
} // SignInMain
