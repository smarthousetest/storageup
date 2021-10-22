import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:upstorage_desktop/components/custom_text_field.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/pages/auth/forgot_password/forgot_password_event.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

import 'forgot_password_bloc.dart';
import 'forgot_password_state.dart';

class ForgotPasswordView extends StatefulWidget {
  ForgotPasswordView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  S translate = getIt<S>();

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
                      child: Icon(
                        Icons.close,
                        color: theme.splashColor,
                        size: 15,
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
                    flex: 3,
                  ),
                  ..._body(theme, state),
                  BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 245.0),
                        child: ElevatedButton(
                          onPressed: _buttonAction(state, context),
                          style: ElevatedButton.styleFrom(
                            primary: theme.colorScheme.onSurface,
                            onSurface: theme.colorScheme.onBackground,
                            minimumSize: Size(0, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
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
    );
  }

  List<Widget> _body(ThemeData theme, ForgotPasswordState state) {
    if (state.status == FormzStatus.submissionSuccess)
      return _bodyResult(theme);
    else
      return _bodyRequest(theme);
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
        flex: 1,
      ),
      BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
        builder: (context, state) {
          return CustomTextField(
            autofocus: true,
            hint: translate.email,
            onChange: (email) {
              context.read<ForgotPasswordBloc>().add(ForgotPasswordEmailChanged(
                  email: email, needValidation: true));
            },

            onFinishEditing: (email) {
              context.read<ForgotPasswordBloc>().add(ForgotPasswordEmailChanged(
                  email: email, needValidation: true));
            }, /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            invalid: state.email.invalid && state.email.value.isNotEmpty,
            errorMessage: translate.wrong_email,
            isPassword: false,
            horizontalPadding: 170,
          );
        },
      ),
      Expanded(
        child: Container(),
        flex: 3,
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

  bool nothingOnEmail = false;

  List<Widget> _bodyResult(ThemeData theme) {
    return [
      BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
        builder: (context, state) {
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
                    text: translate.resore_password_after_email,
                  )
                ],
              ),
            ),
          );
        },
      ),
      Expanded(
        child: Container(),
        flex: 3,
      ),
      BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
        builder: (context, state) {
          return Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  nothingOnEmail = !nothingOnEmail;
                });
                nothingOnEmail
                    ? context
                        .read<ForgotPasswordBloc>()
                        .add(ForgotPasswordConfirmed())
                    : print("nothing to Email");
              },
              child: Text(
                nothingOnEmail
                    ? translate.nothing_on_email
                    : translate.to_send_letter,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 17,
                  color: theme.disabledColor,
                ),
              ),
            ),
          );
        },
      ),
      Expanded(
        child: Container(),
        flex: 1,
      ),
    ];
  }
}
