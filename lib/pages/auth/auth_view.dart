import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formz/formz.dart';
import 'package:os_specification/os_specification.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:storageup/components/auth/already_have_account.dart';
import 'package:storageup/components/auth/not_confirmed_email.dart';
import 'package:storageup/components/auth/registration_in_progress.dart';
import 'package:storageup/components/auth/sign_in_main.dart';
import 'package:storageup/components/auth/sign_in_welcome.dart';
import 'package:storageup/components/expanded_section.dart';
import 'package:storageup/components/registration_success.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/pages/auth/auth_event.dart';
import 'package:storageup/pages/home/home_view.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:window_size/window_size.dart';

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
  bool showNotConfirmedEmail = false;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();
  final ScrollController controller = ScrollController();
  var signInEmailNode = FocusNode();

  S translate = getIt<S>();

  @override
  void initState() {
    var os = OsSpecifications.getOs();
    double height = 780.0;
    double width = 1280.0;
    if (Platform.isWindows) {
      height = 780 * os.getScreenScale();
      width = 1296 * os.getScreenScale();
    }
    if (Platform.isLinux) {
      width = 1332.0;
      height = 866.0;
    }
    DesktopWindow.setMinWindowSize(Size(width, height));
    DesktopWindow.setMaxWindowSize(Size(width, height));
    DesktopWindow.setWindowSize(Size(width, height));

    if (Platform.isLinux) {
      setWindowMaxSize(Size(width, height));
      setWindowMinSize(Size(width, height));
    }

    super.initState();
  }

  @override
  void dispose() {
    signInEmailNode.dispose();
    super.dispose();
  }

  void _changePage() {
    setState(() {
      if (_isSignIn) {
        _isAnimationCompleted = false;
        controller
            .animateTo(MediaQuery.of(context).size.width * 0.563,
                duration: Duration(milliseconds: 500), curve: Curves.linear)
            .then((value) => _isAnimationCompleted = true);
        _isSignIn = !_isSignIn;
      } else {
        controller.animateTo(0,
            duration: Duration(milliseconds: 500), curve: Curves.linear);
        signInEmailNode.requestFocus();
        _isSignIn = !_isSignIn;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    if (!_isSignIn && _isAnimationCompleted) {
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ExpandedSection(
                        child: _register(theme),
                        expand: !_isSignIn,
                      ),
                      _mainSection(theme),
                      ExpandedSection(
                        child: _signIn(),
                        expand: _isSignIn,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, top: 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                      Padding(
                        padding: const EdgeInsets.only(top: 0.0, left: 50),
                        child: Text(
                          '© АО "НПП "Радар ммс"',
                          style: TextStyle(
                            color: _isSignIn
                                ? theme.accentColor
                                : theme.primaryColor,
                            fontSize: 11,
                            fontFamily: kNormalTextFontFamily,
                          ),
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

  Widget _signIn() {
    return SignInWelcome(
      changePage: _changePage,
    );
  }

  Widget _register(ThemeData theme) {
    return AlreadyHaveAccount(changePage: _changePage);
  }

  Widget _mainSection(ThemeData theme) {
    var width = 720.0;
    return LayoutBuilder(
      builder: (context, constrains) {
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
                  child: _signInMain()),
              ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: width, minWidth: width),
                  child: _registerMain()),
            ],
          ),
        );
      },
    );
  }

  Widget _signInMain() {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.error == AuthError.noVerifiedEmail) {
          showNotConfirmedEmail = true;
        } else {
          showNotConfirmedEmail = false;
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return showNotConfirmedEmail
              ? NotConfirmedEmail(
                  onPressed: () {
                    _isSignIn = false;
                    _changePage();
                    showNotConfirmedEmail = false;
                  },
                  state: state)
              : SignInMain(
                  state: state,
                  signInEmailNode: signInEmailNode,
                );
        },
      ),
    );
  }

  Widget _registerMain() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        return state.status.isSubmissionSuccess
            ? _registrationSuccess(state)
            : _registrationInProgress(state);
      },
    );
  }

  _registrationInProgress(AuthState state) {
    return RegistrationInProgress(state: state);
  }

  Widget _registrationSuccess(AuthState state) {
    return RegistrationSuccess(state: state, changePage: _changePage);
  }
}
