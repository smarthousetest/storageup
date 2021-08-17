import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:upstorage_desktop/components/custom_text_field.dart';
import 'package:upstorage_desktop/components/expanded_section.dart';

import '../../constants.dart';

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

  @override
  Widget build(BuildContext context) {
    if (!_isSignIn && _isAnimationCompleted) {
      controller.jumpTo(MediaQuery.of(context).size.width * 0.6);
    }
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                ExpandedSection(
                  child: _register(),
                  expand: !_isSignIn,
                ),
                _mainSection(),
                ExpandedSection(
                  child: _signIn(),
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
                  backgroundColor: _isSignIn ? Colors.blue : Colors.white,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  'UpStorage',
                  style: TextStyle(
                    fontFamily: kBoldTextFontFamily,
                    fontSize: 20,
                    color: _isSignIn ? Color(0xFF7D7D7D) : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _signIn() {
    var fullWidth = MediaQuery.of(context).size.width;
    var widthOfContainer = fullWidth * 0.4;
    return Container(
      width: widthOfContainer,
      decoration: BoxDecoration(
          color: Color(0xFF64AEEA),
          image: DecorationImage(
            fit: BoxFit.fitWidth,
            image: AssetImage('assets/auth/oblaka.png'),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(),
            flex: 2,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: Text(
              'Добро пожаловать в UpStorage',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
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
              'Еще нет аккаунта? Скорее присоединяйся к нам!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
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
              primary: Colors.white,
            ),
            child: Text(
              'Зарегистрироваться',
              style: TextStyle(
                color: Color(0xFF64AEEA),
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

  Widget _register() {
    var fullWidth = MediaQuery.of(context).size.width;
    var widthOfContainer = fullWidth * 0.4;
    return Container(
      width: widthOfContainer,
      decoration: BoxDecoration(
          color: Color(0xFF64AEEA),
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
              'Уже есть аккаунт?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
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
              primary: Colors.white,
            ),
            child: Text(
              'Войти',
              style: TextStyle(
                color: Color(0xFF64AEEA),
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

  bool _checkBoxMain = false;

  Widget _mainSection() {
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
                child: _signInMain()),
            ConstrainedBox(
                constraints: BoxConstraints(maxWidth: width),
                child: _registerMain()),
          ],
        ),
      );
    });
  }

  Widget _signInMain() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Container(),
          flex: 3,
        ),
        Text(
          'Вход в учетную запись',
          style: TextStyle(
            fontFamily: kNormalTextFontFamily,
            fontSize: 32,
            color: Color(0xFF7D7D7D),
          ),
        ),
        Expanded(
          child: Container(),
        ),
        CustomTextField(
          hint: 'Email',
          onChange: (_) {},
          invalid: false,
          isPassword: false,
        ),
        CustomTextField(
          hint: 'Пароль',
          onChange: (_) {},
          invalid: false,
          isPassword: true,
        ),
        SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 115,
            right: 120,
          ),
          child: Row(
            children: [
              Checkbox(
                value: _checkBoxMain,
                onChanged: (_) {
                  setState(() {
                    _checkBoxMain = !_checkBoxMain;
                  });
                },
              ),
              Text(
                'Запомнить меня',
                style: TextStyle(
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 18,
                  color: Color(0xFF7D7D7D),
                ),
              ),
              Expanded(child: Container()),
              Text(
                'Забыли пароль?',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 20,
                  color: Color(0xFF7D7D7D),
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
                  color: Color(0xFFEDEDED),
                ),
              ),
              Text(
                'или продолжить с',
                style: TextStyle(
                    fontSize: 20,
                    height: 0.82,
                    fontFamily: kNormalTextFontFamily,
                    color: Color(0xFFEDEDED)),
              ),
              Expanded(
                child: Divider(
                  height: 1,
                  indent: 10,
                  color: Color(0xFFEDEDED),
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
                backgroundColor: Colors.white,
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
                backgroundColor: Colors.white,
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
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            padding: EdgeInsets.symmetric(
              horizontal: 135,
              vertical: 18,
            ),
            primary: Colors.white,
          ),
          child: Text(
            'Войти',
            style: TextStyle(
              color: Color(0xFF64AEEA),
              fontFamily: kNormalTextFontFamily,
              fontSize: 20,
            ),
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }

  bool _checkboxRegister = false;

  Widget _registerMain() {
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
            'Регистрация',
            style: TextStyle(
              fontFamily: kNormalTextFontFamily,
              fontSize: 32,
              color: Color(0xFF7D7D7D),
            ),
          ),
        ),
        Expanded(
          child: Container(),
        ),
        CustomTextField(
          hint: 'Имя пользователя',
          onChange: (_) {},
          invalid: false,
          isPassword: false,
        ),
        CustomTextField(
          hint: 'Email',
          onChange: (_) {},
          invalid: false,
          isPassword: false,
        ),
        CustomTextField(
          hint: 'Пароль',
          onChange: (_) {},
          invalid: false,
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
              Checkbox(
                value: _checkboxRegister,
                onChanged: (_) {
                  setState(() {
                    _checkboxRegister = !_checkboxRegister;
                  });
                },
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'Я принимаю условия ',
                    style: TextStyle(
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 16,
                      color: Color(0xFF7D7D7D),
                    ),
                    children: [
                      TextSpan(
                          text: 'Пользовательского соглашения',
                          style: TextStyle(
                            fontFamily: kNormalTextFontFamily,
                            fontSize: 16,
                            color: Color(0xFF64AEEA),
                          )),
                      TextSpan(
                          text:
                              ' и даю свое согласие на обработку моих персональных данных'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(child: Container(), flex: 2),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            padding: EdgeInsets.symmetric(
              horizontal: 64,
              vertical: 18,
            ),
            primary: Colors.white,
          ),
          child: Text(
            'Зарегистрироваться',
            style: TextStyle(
              color: Color(0xFF64AEEA),
              fontFamily: kNormalTextFontFamily,
              fontSize: 20,
            ),
          ),
        ),
        Expanded(child: Container()),
      ],
    );
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
