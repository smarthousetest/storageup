import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formz/formz.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:upstorage_desktop/components/custom_text_field.dart';
import 'package:upstorage_desktop/components/expanded_section.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/pages/auth/auth_event.dart';
import 'package:upstorage_desktop/pages/auth/forgot_password/forgot_password_view.dart';
import 'package:upstorage_desktop/pages/home/home_view.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/constants.dart';
import 'auth_bloc.dart';
import 'auth_state.dart';

class AuthView extends StatefulWidget {
  AuthView({Key? key}) : super(key: key);

  static const route = 'auth_page';

  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool _isSignIn = true;
  bool _isAnimationCompleted = true;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollController controller = ScrollController();

  S translate = getIt<S>();
  @override
  void dispose() {
    // focusNodeForName.dispose();
    // focusNodePasswordReg.dispose();
    // focusNodeForMail.dispose();
    // focusNodePasswordLog.dispose();
    // focusNodeMailLog.dispose();
    super.dispose();
  }

  S translate = getIt<S>();
  @override
  void initState() {
    var height = 780.0;
    var width = 1280.0;
    if (Platform.isWindows) {
      width = 1296.0;
    }
    if (Platform.isLinux) {
      width = 1392.0;
      height = 866.0;
    }
    DesktopWindow.setMinWindowSize(Size(width, height));
    DesktopWindow.setMaxWindowSize(Size(width, height));
    DesktopWindow.setWindowSize(Size(width, height));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    if (!_isSignIn && _isAnimationCompleted) {
      //controller.jumpTo(MediaQuery.of(context).size.width * 0.6);
      controller.jumpTo(720);
    }

    return BlocProvider(
      create: (context) => getIt<AuthBloc>()..add(AuthPageOpened()),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == FormzStatus.submissionSuccess &&
              state.action == RequestedAction.login) {
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.route, (route) => false);
          }
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            body: Stack(
              children: [
                Container(
                  width: 1280,
                  color: theme.primaryColor,
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ExpandedSection(
                        child: _register(theme),
                        expand: !_isSignIn,
                      ),
                      _mainSection(theme),
                      ExpandedSection(
                        child: _signIn(theme),
                        expand: _isSignIn,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 22.5,
                        child: SvgPicture.asset(
                          'assets/auth/logo.svg',
                          color: _isSignIn
                              ? theme.accentColor
                              : theme.primaryColor,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'StorageUp',
                        style: TextStyle(
                          fontFamily: 'Ubuntu',
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                          color: _isSignIn
                              ? theme.accentColor
                              : theme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void printSize() async {
    // var size = await DesktopWindow.getWindowSize();
    // print('w= ${size.width} , h = ${size.height}');
  }

  Widget _signIn(ThemeData theme) {
    //var fullWidth = MediaQuery.of(context).size.width;
    var widthOfContainer = 560.0;
    printSize();
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
                _changePage();
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

  Widget _register(ThemeData theme) {
    var fullWidth = MediaQuery.of(context).size.width;
    // var widthOfContainer = fullWidth * 0.4;
    var widthOfContainer = 560.0;
    return Container(
      width: widthOfContainer,
      decoration: BoxDecoration(
          color: theme.accentColor,
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
                _changePage();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                // padding: EdgeInsets.symmetric(
                //   horizontal: 100,
                //   vertical: 18,
                // ),
                primary: theme.primaryColor,
              ),
              child: Center(
                child: Text(
                  translate.sign_in,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.accentColor,
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

  Widget _mainSection(ThemeData theme) {
    //var width = MediaQuery.of(context).size.width * 0.565;
    var width = 720.0;
    return LayoutBuilder(builder: (context, constrains) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width, minWidth: width),
        child: ListView(
          scrollDirection: Axis.horizontal,
          controller: controller,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width, minWidth: width),
                child: _signInMain(theme)),
            ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width, minWidth: width),
                child: _registerMain(theme)),
          ],
        ),
      );
    });
  }

  var focusNodeMailLog = FocusNode();
  var focusNodePasswordLog = FocusNode();
  var focusNodeLogin = FocusNode();
  var currentFocusNode = FocusNode();

  Widget _signInMain(ThemeData theme) {
    List<LogicalKeyboardKey> keys = [];
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return RawKeyboardListener(
          autofocus: true,
          focusNode: FocusNode(),
          onKey: (event) {
            final key = event.logicalKey;
            if (event is RawKeyDownEvent) {
              if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                FocusScope.of(context).requestFocus(currentFocusNode);
                print("login");
              }
              setState(() {
                return keys.add(key);
              });
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(),
                flex: 3,
              ),
              // SizedBox(
              //   height: 130,
              // ),
              Text(
                translate.sign_in_to_account,
                style: TextStyle(
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: theme.disabledColor,
                ),
              ),
              // Expanded(
              //   child: Container(),
              // ),
              SizedBox(height: 63),
              RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (event) {
                  if ((event.isKeyPressed(LogicalKeyboardKey.enter) ||
                          event.logicalKey == LogicalKeyboardKey.tab) &&
                      event is RawKeyDownEvent) {
                    FocusScope.of(context).requestFocus(focusNodePasswordLog);
                    print("mail");
                  }
                },
                child: CustomTextField(
                  autofocus: true,
                  focusNode: focusNodeMailLog,
                  hint: translate.email,
                  errorMessage: translate.wrong_email,
                  needErrorValidation: true,
                  onChange: (email) {
                    context.read<AuthBloc>().add(AuthLoginEmailChanged(
                        email: email, needValidation: true));
                  },
                  onFinishEditing: (email) {
                    context.read<AuthBloc>().add(AuthLoginEmailChanged(
                        email: email, needValidation: true));
                  },
                  invalid: state.emailLogin.invalid &&
                      state.emailLogin.value.isNotEmpty,
                  isPassword: false,
                ),
              ),
              RawKeyboardListener(
                focusNode: FocusNode(),
                onKey: (event) {
                  if (event.isKeyPressed(LogicalKeyboardKey.enter) &&
                      event is RawKeyDownEvent) {
                    if (_isLoginFieldValid(state)) {
                      context.read<AuthBloc>().add(AuthLoginConfirmed());
                    }
                    print("password");
                  }
                },
                child: CustomTextField(
                  focusNode: focusNodePasswordLog,
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
                  invalid: state.passwordLogin.invalid &&
                      state.passwordLogin.value.isNotEmpty,
                  isPassword: true,
                ),
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
                        color: state.rememberMe
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onPrimary,
                      ),
                      padding: EdgeInsets.all(1.5),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                          color: theme.primaryColor,
                        ),
                        child: Checkbox(
                          value: state.rememberMe,
                          side: BorderSide(width: 1, color: Colors.transparent),
                          splashRadius: 0,
                          checkColor: theme.accentColor,
                          activeColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0)),
                          onChanged: (_) {
                            context
                                .read<AuthBloc>()
                                .add(AuthRememberMeChanged());
                          },
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
                        'assets/auth/facebook.png',
                        width: 27,
                        height: 27,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 25.0,
                  ),
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
                  //TODO change this shit
                  visible: state.status == FormzStatus.submissionFailure &&
                      state.action == RequestedAction.login,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/auth/error.png',
                        height: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        state.error == AuthError.wrongCredentials
                            ? translate.wrong_cred
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
              )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 120),
                child: Container(
                  height: 60,
                  child: OutlinedButton(
                    focusNode: currentFocusNode,
                    autofocus: true,
                    onPressed: _isLoginFieldValid(state)
                        ? () {
                            context.read<AuthBloc>().add(AuthLoginConfirmed());
                          }
                        : null,
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
                      backgroundColor: _isLoginFieldValid(state)
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
        );
      },
    );
  }

  bool _isLoginFieldValid(AuthState state) {
    return state.emailLogin.valid &&
        state.emailLogin.value.isNotEmpty &&
        state.passwordLogin.valid &&
        state.passwordLogin.value.isNotEmpty;
  }

  var focusNodePasswordReg = FocusNode();
  var focusNodeForName = FocusNode();
  var focusNodeForMail = FocusNode();

  Widget _registerMain(ThemeData theme) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return state.status.isSubmissionSuccess
            ? _registrationSuccessed(theme, context, state)
            : _registrationInProgress(theme, context, state);
      },
    );
  }

  _registrationInProgress(
      ThemeData theme, BuildContext context, AuthState state) {
    return Column(
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
        RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (event) {
            if ((event.logicalKey == LogicalKeyboardKey.enter ||
                    event.logicalKey == LogicalKeyboardKey.tab) &&
                event is RawKeyDownEvent) {
              focusNodeForMail.requestFocus();
              print("name");
            }
          },
          child: CustomTextField(
            focusNode: focusNodeForName,
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
            needErrorValidation: true,
            invalid: state.name.invalid && state.name.value.isNotEmpty,
            isPassword: false,
            inputFormatters: [],
          ),
        ),
        RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (event) {
            if ((event.logicalKey == LogicalKeyboardKey.enter ||
                    event.logicalKey == LogicalKeyboardKey.tab) &&
                event is RawKeyDownEvent) {
              focusNodePasswordReg.requestFocus();
              print("mail");
            }
          },
          child: CustomTextField(
            focusNode: focusNodeForMail,
            hint: translate.email,
            errorMessage: translate.wrong_email,
            onChange: (email) {
              context.read<AuthBloc>().add(
                  AuthRegisterEmailChanged(email: email, needValidation: true));
            },
            onFinishEditing: (email) {
              context.read<AuthBloc>().add(
                  AuthRegisterEmailChanged(email: email, needValidation: true));
            },
            needErrorValidation: true,
            invalid: state.emailRegister.invalid &&
                state.emailRegister.value.isNotEmpty,
            isPassword: false,
          ),
        ),

        RawKeyboardListener(
          focusNode: FocusNode(),
          onKey: (event) {
            if (event.logicalKey == LogicalKeyboardKey.enter &&
                event is RawKeyDownEvent) {
              if (_isRegisterFieldsValid(state)) {
                context.read<AuthBloc>().add(AuthRegisterConfirmed());
                print('fewwfew');
              }
            }
          },
          child: CustomTextField(
            focusNode: focusNodePasswordReg,
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
            needErrorValidation: true,
            invalid: state.passwordRegister.invalid &&
                state.passwordRegister.value.isNotEmpty,
            isPassword: true,
          ),
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
                  color: state.acceptedTermsOfUse
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.onPrimary,
                ),
                padding: EdgeInsets.all(1.5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
                    color: theme.primaryColor,
                  ),
                  child: Checkbox(
                    value: state.acceptedTermsOfUse,
                    side: BorderSide(width: 1, color: Colors.transparent),
                    splashRadius: 0,
                    checkColor: theme.accentColor,
                    activeColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0)),
                    onChanged: (_) {
                      context
                          .read<AuthBloc>()
                          .add(AuthAcceptTermsOfUseChanged());
                    },
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
                          )),
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
                visible: state.status == FormzStatus.submissionFailure &&
                    state.action == RequestedAction.registration,
                child: Row(
                  children: [
                    Image.asset(
                      'assets/auth/error.png',
                      height: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      state.error == AuthError.emailAlreadyRegistered
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
              focusNode: currentFocusNode,
              onPressed: _isRegisterFieldsValid(state)
                  ? () {
                      context.read<AuthBloc>().add(AuthRegisterConfirmed());
                    }
                  : null,
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
                backgroundColor: _isRegisterFieldsValid(state)
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
    );
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

  void _changePage() {
    setState(() {
      if (_isSignIn) {
        _isAnimationCompleted = false;
        controller
            .animateTo(MediaQuery.of(context).size.width * 0.563,
                duration: Duration(milliseconds: 500), curve: Curves.linear)
            .then((value) => _isAnimationCompleted = true);
        focusNodeForName.requestFocus();
        _isSignIn = !_isSignIn;
      } else {
        controller.animateTo(0,
            duration: Duration(milliseconds: 500), curve: Curves.linear);
        focusNodeMailLog.requestFocus();
        _isSignIn = !_isSignIn;
      }
    });
  }

  void _onForgotPasswordTapped() {
    showDialog(context: context, builder: (context) => ForgotPasswordView());
  }

  Widget _registrationSuccessed(
      ThemeData theme, BuildContext context, AuthState state) {
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
                    text: state.emailRegister.value + "\n",
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
            onTap: () => context.read<AuthBloc>().add(AuthSendEmailVerify()),
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
              _changePage();
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

  Widget _registrationComplete(
      ThemeData theme, BuildContext context, AuthState state) {
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
              _changePage();
            },
            // onPressed: () {
            //   context.read<AuthBloc>().add(AuthClear());
            // },
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
