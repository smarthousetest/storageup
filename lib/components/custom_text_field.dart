import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

final BorderRadius fCustomTextFormBorderRadius = BorderRadius.circular(15.0);

class CustomTextField extends StatefulWidget {
  CustomTextField(
      {required this.hint,
      this.errorMessage = '',
      required this.onChange,
      required this.invalid,
      required this.isPassword,
      this.needErrorValidation = true,
      this.horizontalPadding = 120});

  final String hint;
  final String errorMessage;
  final Function(String) onChange;
  final bool invalid;
  final bool isPassword;
  final bool needErrorValidation;
  final double horizontalPadding;
  @override
  _CustomTextFieldState createState() => _CustomTextFieldState(isPassword);
}

class _CustomTextFieldState extends State<CustomTextField> {
  _CustomTextFieldState(this._hidePassword);

  bool _hidePassword;

  OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderSide: widget.needErrorValidation
          ? BorderSide(color: widget.invalid ? Colors.red : Colors.transparent)
          : BorderSide(color: Colors.transparent),
      borderRadius: fCustomTextFormBorderRadius,
    );
  }

  void _changeObscure() {
    setState(() {
      _hidePassword = !_hidePassword;
      // FocusScope.of(context).unfocus();
    });
  }

  GestureDetector? _suffixIcon() {
    return widget.isPassword
        ? GestureDetector(
            onTap: _changeObscure,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image(
                width: 26.0,
                height: 26.0,
                image: AssetImage(_hidePassword
                    ? 'assets/hide_password.png'
                    : 'assets/show_password.png'),
              ),
            ),
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.needErrorValidation ? _errorMessage(context) : Container(),
            // : SizedBox(
            //     height: 10,
            //   ),
            // elevation: 2.0,
            // shadowColor: Color(0xA9000000),
            // color: theme.primaryColor,
            // borderRadius: fCustomTextFormBorderRadius,
            Container(
              height: 60,
              decoration: BoxDecoration(
                  borderRadius: fCustomTextFormBorderRadius,
                  color: theme.primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x19000000),
                      blurRadius: 3,
                      spreadRadius: 3,
                    )
                  ]),
              child: Center(
                child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: widget.onChange,
                  obscureText: _hidePassword,
                  style: TextStyle(
                    color: theme.disabledColor,
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 20,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp('[ ]'))
                  ],
                  decoration: InputDecoration(
                    suffixIcon: _suffixIcon(),
                    border: InputBorder.none,
                    hintText: widget.hint,
                    hintStyle: TextStyle(
                      color: theme.textTheme.headline1?.color,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 20,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    focusedBorder: outlineInputBorder(),
                    enabledBorder: outlineInputBorder(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _errorMessage(BuildContext context) {
    return Visibility(
      visible: widget.invalid,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          widget.invalid ? widget.errorMessage : '',
          textAlign: TextAlign.left,
          style: TextStyle(
              fontFamily: kNormalTextFontFamily,
              fontSize: 16.0,
              color: Theme.of(context).errorColor),
        ),
      ),
    );
  }
}
