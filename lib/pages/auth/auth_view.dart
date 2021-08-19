import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:upstorage_desktop/components/custom_text_field.dart';
import 'package:upstorage_desktop/components/expanded_section.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/pages/auth/auth_event.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

import '../../constants.dart';
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
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    if (!_isSignIn && _isAnimationCompleted) {
      controller.jumpTo(MediaQuery.of(context).size.width * 0.6);
    }

    return BlocProvider(
      create: (context) => getIt<AuthBloc>(),
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                      color: _isSignIn ? theme.accentColor : theme.primaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'UpStorage',
                    style: TextStyle(
                      fontFamily: kBoldTextFontFamily,
                      fontSize: 20,
                      color:
                          _isSignIn ? theme.disabledColor : theme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _signIn(ThemeData theme) {
    var fullWidth = MediaQuery.of(context).size.width;
    var widthOfContainer = fullWidth * 0.4;
    return Container(
      width: widthOfContainer,
      decoration: BoxDecoration(
          color: theme.accentColor,
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage('assets/auth/oblaka.png'),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(),
            flex: 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Text(
              translate.welcome_to_upsctorage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 32,
                fontFamily: kNormalTextFontFamily,
              ),
            ),
          ),
          Expanded(
            child: Container(),
            flex: 1,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Text(
              translate.still_dont_have_account,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 20,
                fontFamily: kNormalTextFontFamily,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Image.asset('assets/auth/man_right.png'),
          ),
          ElevatedButton(
            onPressed: () {
              _changePage();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.symmetric(
                horizontal: 64,
                vertical: 18,
              ),
              primary: theme.primaryColor,
            ),
            child: Text(
              translate.register,
              style: TextStyle(
                color: theme.accentColor,
                fontFamily: kNormalTextFontFamily,
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            child: Container(),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _register(ThemeData theme) {
    var fullWidth = MediaQuery.of(context).size.width;
    var widthOfContainer = fullWidth * 0.4;
    return Container(
      width: widthOfContainer,
      decoration: BoxDecoration(
          color: theme.accentColor,
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage('assets/auth/oblaka.png'),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(),
            flex: 3,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Text(
              translate.allready_have_an_account,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.primaryColor,
                fontSize: 32,
                fontFamily: kNormalTextFontFamily,
              ),
            ),
          ),
          Expanded(child: Container()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Image.asset('assets/auth/man_left.png'),
          ),
          Expanded(child: Container()),
          ElevatedButton(
            onPressed: () {
              _changePage();
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              padding: EdgeInsets.symmetric(
                horizontal: 135,
                vertical: 18,
              ),
              primary: theme.primaryColor,
            ),
            child: Text(
              translate.sign_in,
              style: TextStyle(
                color: theme.accentColor,
                fontFamily: kNormalTextFontFamily,
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            child: Container(),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _mainSection(ThemeData theme) {
    var width = MediaQuery.of(context).size.width * 0.6;
    return LayoutBuilder(builder: (context, constrains) {
      return ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width),
        child: ListView(
          scrollDirection: Axis.horizontal,
          controller: controller,
          physics: NeverScrollableScrollPhysics(),
          children: [
            ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width),
                child: _signInMain(theme)),
            ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width),
                child: _registerMain(theme)),
          ],
        ),
      );
    });
  }

  Widget _signInMain(ThemeData theme) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
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
                fontSize: 32,
                color: theme.disabledColor,
              ),
            ),
            Expanded(
              child: Container(),
            ),
            CustomTextField(
              hint: translate.email,
              errorMessage: translate.wrong_email,
              needErrorValidation: true,
              onChange: (email) {
                context
                    .read<AuthBloc>()
                    .add(AuthLoginEmailChanged(email: email));
              },
              invalid:
                  state.emailLogin.invalid && state.emailLogin.value.isNotEmpty,
              isPassword: false,
            ),
            CustomTextField(
              hint: translate.password,
              errorMessage: translate.wrong_password,
              onChange: (password) {
                context
                    .read<AuthBloc>()
                    .add(AuthLoginPasswordChanged(password: password));
              },
              invalid: state.passwordLogin.invalid &&
                  state.passwordLogin.value.isNotEmpty,
              isPassword: true,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 120,
                right: 120,
              ),
              child: Row(
                children: [
                  Container(
                    height: 21,
                    width: 21,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: theme.primaryColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 1,
                          ),
                        ]),
                    child: Checkbox(
                      value: state.rememberMe,
                      side: BorderSide(width: 1, color: Colors.transparent),
                      splashRadius: 0,
                      checkColor: theme.accentColor,
                      activeColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      onChanged: (_) {
                        context.read<AuthBloc>().add(AuthRememberMeChanged());
                      },
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    translate.remember_me,
                    style: TextStyle(
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 18,
                      color: theme.disabledColor,
                    ),
                  ),
                  Expanded(child: Container()),
                  Text(
                    translate.forgot_password,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 18,
                      color: theme.disabledColor,
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
                      height: 2,
                      endIndent: 10,
                      color: theme.hintColor,
                    ),
                  ),
                  Text(
                    translate.or_continue_with,
                    style: TextStyle(
                      fontSize: 20,
                      height: 0.82,
                      fontFamily: kNormalTextFontFamily,
                      color: theme.hintColor,
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      height: 1,
                      indent: 10,
                      color: theme.hintColor,
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
                Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(100),
                  child: CircleAvatar(
                    minRadius: 30,
                    backgroundColor: theme.primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset('assets/auth/facebook.png'),
                    ),
                  ),
                ),
                SizedBox(
                  width: 25.0,
                ),
                Material(
                  elevation: 2.0,
                  borderRadius: BorderRadius.circular(100),
                  child: CircleAvatar(
                    minRadius: 30,
                    backgroundColor: theme.primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset('assets/auth/google.png'),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(child: Container()),
            ElevatedButton(
              onPressed: _isLoginFieldValid(state)
                  ? () {
                      context.read<AuthBloc>().add(AuthLoginConfirmed());
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.symmetric(
                  horizontal: 135,
                  vertical: 18,
                ),
                primary: theme.primaryColor,
                onSurface: theme.primaryColor,
                elevation: 2,
              ),
              child: Text(
                translate.sign_in,
                style: TextStyle(
                  color: _isLoginFieldValid(state)
                      ? theme.accentColor
                      : theme.textTheme.headline1?.color,
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(child: Container()),
          ],
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

  Widget _registerMain(ThemeData theme) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(),
              flex: 2,
            ),
            Center(
              child: Text(
                translate.registration,
                style: TextStyle(
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 32,
                  color: theme.disabledColor,
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            CustomTextField(
              hint: translate.user_name,
              errorMessage: translate.wrong_username,
              onChange: (name) {
                context.read<AuthBloc>().add(AuthNameChanged(name: name));
              },
              needErrorValidation: true,
              invalid: state.name.invalid && state.name.value.isNotEmpty,
              isPassword: false,
            ),
            CustomTextField(
              hint: translate.email,
              errorMessage: translate.wrong_email,
              onChange: (email) {
                context
                    .read<AuthBloc>()
                    .add(AuthRegisterEmailChanged(email: email));
              },
              needErrorValidation: true,
              invalid: state.emailRegister.invalid &&
                  state.emailRegister.value.isNotEmpty,
              isPassword: false,
            ),
            CustomTextField(
              hint: translate.password,
              errorMessage: translate.wrong_password,
              onChange: (password) {
                context
                    .read<AuthBloc>()
                    .add(AuthRegisterPasswordChanged(password: password));
              },
              needErrorValidation: true,
              invalid: state.passwordRegister.invalid &&
                  state.passwordRegister.value.isNotEmpty,
              isPassword: true,
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 120, right: 200),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 21,
                    width: 21,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        boxShadow: state.acceptedTermsOfUse
                            ? [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 1, // changes position of shadow
                                ),
                              ]
                            : null),
                    child: Checkbox(
                      value: state.acceptedTermsOfUse,
                      side: BorderSide(
                        width: 1,
                        color: state.acceptedTermsOfUse
                            ? Color.fromRGBO(23, 69, 139, 0)
                            : theme.errorColor,
                      ),
                      splashRadius: 0,
                      checkColor: theme.accentColor,
                      activeColor: theme.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.0)),
                      onChanged: (_) {
                        context
                            .read<AuthBloc>()
                            .add(AuthAcceptTermsOfUseChanged());
                      },
                    ),
                  ),
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
            Expanded(child: Container(), flex: 2),
            ElevatedButton(
              onPressed: _isRegisterFieldsValid(state)
                  ? () {
                      context.read<AuthBloc>().add(AuthRegisterConfirmed());
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                padding: EdgeInsets.symmetric(
                  horizontal: 64,
                  vertical: 18,
                ),
                primary: theme.primaryColor,
                onSurface: theme.primaryColor,
                elevation: 2,
              ),
              child: Text(
                translate.register,
                style: TextStyle(
                  color: _isRegisterFieldsValid(state)
                      ? theme.accentColor
                      : theme.textTheme.headline1?.color,
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 20,
                ),
              ),
            ),
            Expanded(child: Container()),
          ],
        );
      },
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
            .animateTo(MediaQuery.of(context).size.width * 0.6,
                duration: Duration(milliseconds: 500), curve: Curves.linear)
            .then((value) => _isAnimationCompleted = true);
        _isSignIn = !_isSignIn;
      } else {
        controller.animateTo(0,
            duration: Duration(milliseconds: 500), curve: Curves.linear);
        _isSignIn = !_isSignIn;
      }
    });
  }
}
