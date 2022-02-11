import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';

final BorderRadius fCustomTextFormBorderRadius = BorderRadius.circular(10.0);

class PasswordTextField extends StatefulWidget {
  PasswordTextField({
    required this.hint,
    this.errorMessage = '',
    required this.onChange,
    required this.invalid,
    required this.isPassword,
    this.needErrorValidation = true,
    required this.onFinishEditing,
    this.horizontalPadding = 0,
    this.autofocus = false,
    required this.controller,
    FocusNode? focusNode,
    List<TextInputFormatter>? inputFormatters,
  })  : this.focusNode = focusNode ?? FocusNode(),
        this.inputFormatters = inputFormatters ??
            [FilteringTextInputFormatter.deny(RegExp('[ ]'))];

  final bool autofocus;
  //final FilteringTextInputFormatter inputFormatters;
  final FocusNode focusNode;
  final String hint;
  final String errorMessage;
  final Function(String) onChange;
  final Function(String) onFinishEditing;
  final bool invalid;
  final TextEditingController controller;
  final bool isPassword;
  final bool needErrorValidation;
  final double horizontalPadding;
  List<TextInputFormatter>? inputFormatters;
  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState(isPassword);
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  _PasswordTextFieldState(this._hidePassword);

  bool _hidePassword;
  bool _isFocused = false;
  FocusNode _node = FocusNode();
  TextEditingController _controller = TextEditingController();

  OutlineInputBorder outlineInputBorder(ThemeData theme, bool isEnabled) {
    return OutlineInputBorder(
      borderSide: widget.needErrorValidation
          ? BorderSide(
              width: 1.5,
              color: widget.invalid
                  ? theme.errorColor
                  : isEnabled
                      ? theme.accentColor
                      : theme.colorScheme.onPrimary)
          : BorderSide(color: Colors.transparent),
      borderRadius: fCustomTextFormBorderRadius,
    );
  }

  // void _changeObscure() {
  //   setState(() {
  //     _hidePassword = !_hidePassword;
  //     //FocusScope.of(context).unfocus();
  //   });
  // }

  // GestureDetector? _suffixIcon() {
  //   return widget.isPassword
  //       ? GestureDetector(
  //           onTap: _changeObscure,
  //           child: MouseRegion(
  //             cursor: SystemMouseCursors.click,
  //             child: Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 9),
  //               child: Image(
  //                 width: 24.0,
  //                 height: 24.0,
  //                 image: AssetImage(_hidePassword
  //                     ? 'assets/hide_password.png'
  //                     : 'assets/show_password.png'),
  //               ),
  //             ),
  //           ),
  //         )
  //       : null;
  // }

  @override
  void initState() {
    _node.addListener(() {
      setState(() {
        _isFocused = _node.hasFocus;
      });
      if (!_node.hasFocus) {
        widget.onFinishEditing(_controller.text);
      }
    });
    super.initState();
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
            widget.needErrorValidation
                ? _errorMessage(context)
                : SizedBox(
                    height: 17,
                  ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: _isFocused ? Color(0xFFF1F8FE) : Colors.transparent,
              ),
              //padding: EdgeInsets.all(4),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.primaryColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    onChanged: widget.onChange,
                    obscureText: _hidePassword,
                    controller: _controller,
                    style: TextStyle(
                      color: theme.disabledColor,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 15,
                    ),
                    inputFormatters: widget.inputFormatters,
                    focusNode: widget.focusNode,
                    autofocus: widget.autofocus,
                    decoration: InputDecoration(
                      //suffixIcon: _suffixIcon(),
                      border: InputBorder.none,
                      hintText: widget.hint,
                      hintStyle: TextStyle(
                        color: theme.textTheme.headline1?.color,
                        fontFamily: kNormalTextFontFamily,
                        fontSize: 15,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 11.0),
                      focusedBorder: outlineInputBorder(theme, true),
                      enabledBorder: outlineInputBorder(theme, false),

                      // disabledBorder: outlineInputBorder(theme, false),
                    ),
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
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        widget.invalid ? widget.errorMessage : '',
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: kNormalTextFontFamily,
            fontSize: 14.0,
            color: Theme.of(context).errorColor),
      ),
    );
  }
}
