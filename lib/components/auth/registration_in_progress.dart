import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:storageup/components/blur/term_of_use_registration.dart';
import 'package:storageup/components/custom_text_field.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/pages/auth/auth_bloc.dart';
import 'package:storageup/pages/auth/auth_event.dart';
import 'package:storageup/pages/auth/auth_state.dart';
import 'package:storageup/utilities/injection.dart';

class RegistrationInProgress extends StatefulWidget {
  const RegistrationInProgress({Key? key, required this.state});

  final AuthState state;

  @override
  State<RegistrationInProgress> createState() => _RegistrationInProgressState();
}

class _RegistrationInProgressState extends State<RegistrationInProgress> {
  S translate = getIt<S>();

  var singUpEmailNode = FocusNode();
  var signUpPasswordNode = FocusNode();
  var signUpNameNode = FocusNode();
  var signUpTermsOfUse = FocusNode();

  @override
  void initState() {
    singUpEmailNode.onKeyEvent = (_, event) {
      if (event.logicalKey == LogicalKeyboardKey.tab && event is KeyDownEvent) {
        signUpPasswordNode.requestFocus();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    };
    signUpNameNode.onKeyEvent = (_, event) {
      if (event.logicalKey == LogicalKeyboardKey.tab && event is KeyDownEvent) {
        singUpEmailNode.requestFocus();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    };
    signUpPasswordNode.onKeyEvent = (_, event) {
      if (event.logicalKey == LogicalKeyboardKey.tab && event is KeyDownEvent) {
        signUpTermsOfUse.requestFocus();
        setState(() {});
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    };
    signUpTermsOfUse.onKeyEvent = (_, event) {
      if (event.logicalKey == LogicalKeyboardKey.tab && event is KeyDownEvent) {
        signUpTermsOfUse.unfocus();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.enter &&
          event is KeyDownEvent) {
        if (widget.state.acceptedTermsOfUse) {
          onRegister(context, widget.state);
        } else {
          context.read<AuthBloc>().add(AuthAcceptTermsOfUseChanged());
        }
      }
      return KeyEventResult.ignored;
    };
    super.initState();
  }

  void onRegister(BuildContext context, AuthState state) {
    if (_isRegisterFieldsValid(state)) {
      context.read<AuthBloc>().add(AuthRegisterConfirmed());
    }
  }

  bool _isRegisterFieldsValid(AuthState state) {
    return state.name.valid &&
        state.name.value.isNotEmpty &&
        state.emailRegister.valid &&
        state.emailRegister.value.isNotEmpty &&
        state.passwordRegister.valid &&
        state.passwordRegister.value.isNotEmpty &&
        state.acceptedTermsOfUse;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Shortcuts(
      shortcuts: {
        SingleActivator(LogicalKeyboardKey.arrowUp):
            SubmitIntent(context, widget.state),
      },
      child: Actions(
        actions: {
          SubmitIntent: CallbackAction<SubmitIntent>(
            onInvoke: (SubmitIntent intent) =>
                onRegister(intent.context, intent.state),
          ),
        },
        child: Focus(
          autofocus: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 130,
              ),
              Center(
                child: Text(
                  translate.registration,
                  style: TextStyle(
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 28,
                    color: theme.disabledColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              // Expanded(
              //   child: Container(),
              // ),
              SizedBox(height: 63),
              CustomTextField(
                focusNode: signUpNameNode,
                hint: translate.user_name,
                errorMessage: translate.wrong_username,
                onChange: (name) {
                  context
                      .read<AuthBloc>()
                      .add(AuthNameChanged(name: name, needValidation: true));
                },
                onFinishEditing: (name) {
                  context
                      .read<AuthBloc>()
                      .add(AuthNameChanged(name: name, needValidation: true));
                },
                onSubmitted: () {
                  onRegister(context, widget.state);
                },
                needErrorValidation: true,
                invalid: widget.state.name.invalid &&
                    widget.state.name.value.isNotEmpty,
                isPassword: false,
                inputFormatters: [],
              ),
              CustomTextField(
                focusNode: singUpEmailNode,
                hint: translate.email,
                errorMessage: translate.wrong_email,
                onChange: (email) {
                  context.read<AuthBloc>().add(AuthRegisterEmailChanged(
                      email: email, needValidation: true));
                },
                onFinishEditing: (email) {
                  context.read<AuthBloc>().add(AuthRegisterEmailChanged(
                      email: email, needValidation: true));
                },
                onSubmitted: () {
                  onRegister(context, widget.state);
                },
                needErrorValidation: true,
                invalid: widget.state.emailRegister.invalid &&
                    widget.state.emailRegister.value.isNotEmpty,
                isPassword: false,
              ),

              CustomTextField(
                focusNode: signUpPasswordNode,
                //focusNode: focusNode,
                hint: translate.password,
                errorMessage: translate.wrong_password,
                onChange: (password) {
                  context.read<AuthBloc>().add(AuthRegisterPasswordChanged(
                      password: password, needValidation: true));
                },
                onFinishEditing: (password) {
                  context.read<AuthBloc>().add(AuthRegisterPasswordChanged(
                      password: password, needValidation: true));
                },
                onSubmitted: () {
                  onRegister(context, widget.state);
                },
                needErrorValidation: true,
                invalid: widget.state.passwordRegister.invalid &&
                    widget.state.passwordRegister.value.isNotEmpty,
                isPassword: true,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 123, right: 134),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 21,
                      width: 21,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        color: widget.state.acceptedTermsOfUse
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
                          focusNode: signUpTermsOfUse,
                          onFocusChange: (value) {
                            setState(() {});
                          },
                          child: Checkbox(
                            value: widget.state.acceptedTermsOfUse,
                            side: BorderSide(
                                width: 1,
                                color: signUpTermsOfUse.hasFocus
                                    ? theme.accentColor
                                    : Colors.transparent),
                            splashRadius: 0,
                            checkColor: theme.accentColor,
                            activeColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0)),
                            onChanged: (_) {
                              context
                                  .read<AuthBloc>()
                                  .add(AuthAcceptTermsOfUseChanged());
                              signUpTermsOfUse.requestFocus();
                            },
                          ),
                        ),
                      ),
                    ),
                    // Container(
                    //   height: 21,
                    //   width: 21,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(6.0),
                    //     boxShadow: state.acceptedTermsOfUse
                    //         ? [
                    //             BoxShadow(
                    //               color: Colors.grey.withOpacity(0.3),
                    //               blurRadius: 1, // changes position of shadow
                    //             ),
                    //           ]
                    //         : null,
                    //   ),
                    //   child: Checkbox(
                    //     value: state.acceptedTermsOfUse,
                    //     side: BorderSide(
                    //       width: 1,
                    //       color: state.acceptedTermsOfUse
                    //           ? Color.fromRGBO(23, 69, 139, 0)
                    //           : theme.errorColor,
                    //     ),
                    //     splashRadius: 0,
                    //     checkColor: theme.accentColor,
                    //     activeColor: theme.primaryColor,
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(6.0)),
                    //     onChanged: (_) {
                    //       context.read<AuthBloc>().add(AuthAcceptTermsOfUseChanged());
                    //     },
                    //   ),
                    // ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          text: translate.term_of_use_before,
                          style: TextStyle(
                            fontFamily: kNormalTextFontFamily,
                            fontSize: 16,
                            color: theme.disabledColor,
                          ),
                          children: [
                            TextSpan(
                                text: translate.term_of_use,
                                style: TextStyle(
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 16,
                                  color: theme.accentColor,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return TermOfUseBlur();
                                      },
                                    );
                                  }),
                            TextSpan(text: translate.term_of_use_after),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 120),
                    child: Visibility(
                      visible: widget.state.status ==
                              FormzStatus.submissionFailure &&
                          widget.state.action == RequestedAction.registration,
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/auth/error.png',
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            widget.state.error ==
                                    AuthError.emailAlreadyRegistered
                                ? translate.already_registered_email
                                : translate.something_goes_wrong,
                            style: TextStyle(
                              fontFamily: kNormalTextFontFamily,
                              fontSize: 16,
                              color: theme.disabledColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  flex: 2),
              // ElevatedButton(
              //   onPressed: _isRegisterFieldsValid(state)
              //       ? () {
              //           context.read<AuthBloc>().add(AuthRegisterConfirmed());
              //         }
              //       : null,
              //   style: ElevatedButton.styleFrom(
              //     shape:
              //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              //     padding: EdgeInsets.symmetric(
              //       horizontal: 64,
              //       vertical: 18,
              //     ),
              //     primary: theme.primaryColor,
              //     onSurface: theme.primaryColor,
              //     elevation: 2,
              //   ),
              //   child: Text(
              //     translate.register,
              //     style: TextStyle(
              //       color: _isRegisterFieldsValid(state)
              //           ? theme.accentColor
              //           : theme.textTheme.headline1?.color,
              //       fontFamily: kNormalTextFontFamily,
              //       fontSize: 20,
              //     ),
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 120),
                child: Container(
                  height: 60,
                  child: OutlinedButton(
                    // focusNode: currentFocusNode,
                    onPressed: () => onRegister(context, widget.state),
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.maxFinite, 60),
                      shape: RoundedRectangleBorder(
                          // side: BorderSide(
                          //   color: Colors.transparent,
                          // ),
                          borderRadius: BorderRadius.circular(15)),
                      padding: EdgeInsets.symmetric(
                        horizontal: 135,
                        vertical: 20,
                      ),
                      backgroundColor: _isRegisterFieldsValid(widget.state)
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onPrimary,
                    ),
                    child: Text(
                      translate.register,
                      style: TextStyle(
                        color: theme.primaryColor,
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
        ),
      ),
    );
  }
}

class SubmitIntent extends Intent {
  final BuildContext context;
  final AuthState state;

  SubmitIntent(this.context, this.state);
}
