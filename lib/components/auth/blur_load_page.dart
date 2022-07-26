import 'dart:ui';

import 'package:flutter/material.dart';

class BlurLoadPage extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();

  BlurLoadPage();
}

class _ButtonTemplateState extends State<BlurLoadPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
              ),
              child: Container(
                color: Colors.black.withAlpha(25),
              ),
            ),
          ),
          Center(
            child: CircularProgressIndicator(
              value: null,
            ),
          ),
        ],
      ),
    );
  }
}
