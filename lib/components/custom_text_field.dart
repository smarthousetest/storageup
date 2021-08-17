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
      this.needErrorValidation = true});

  final String hint;
  final String errorMessage;
  final Function(String) onChange;
  final bool invalid;
  final bool isPassword;
  final bool needErrorValidation;
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
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.needErrorValidation
                ? _errorMessage(context)
                : SizedBox(
                    height: 10,
                  ),
            Material(
              elevation: 2.0,
              shadowColor: Color(0xA9000000),
              color: Colors.white,
              borderRadius: fCustomTextFormBorderRadius,
              child: TextFormField(
                onChanged: widget.onChange,
                obscureText: _hidePassword,
                style: TextStyle(
                  color: Color(0xFF7D7D7D),
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
                    color: Color(0xFFC4C4C4),
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 20,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  focusedBorder: outlineInputBorder(),
                  enabledBorder: outlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _errorMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Text(
        widget.invalid ? widget.errorMessage : '',
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: kNormalTextFontFamily,
            color: Theme.of(context).errorColor),
      ),
    );
  }
}
