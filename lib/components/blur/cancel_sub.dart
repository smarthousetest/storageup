import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/utilites/extensions.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

class BlurCancelSub extends StatefulWidget {
  var choosedSubGb;
  DateTime dateTime;
  var filledGb;
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();
  BlurCancelSub(this.choosedSubGb, this.dateTime, this.filledGb);
}

class _ButtonTemplateState extends State<BlurCancelSub> {
  S translate = getIt<S>();

  @override
  Widget build(BuildContext context) {
    var textStyle = TextStyle(
      fontSize: 14,
      fontFamily: kNormalTextFontFamily,
      color: Theme.of(context).textTheme.headline2?.color,
    );
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
            child: Container(
              width: 580,
              height: 254,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 25, 0, 0),
                    child: Container(
                      width: 480,
                      height: 212,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            translate.unsubscribe,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: kNormalTextFontFamily,
                              color: Theme.of(context).focusColor,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 0),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        translate.cancel_sub(widget.dateTime,
                                            widget.choosedSubGb),
                                        style: textStyle),
                                    Text(
                                        translate.filled_gb(fileSize(
                                            widget.filledGb, translate)),
                                        style: textStyle),
                                    Text(translate.will_be_deleted,
                                        style: textStyle),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(translate.further_use,
                                          style: textStyle),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 25),
                              child: Container(
                                width: 260,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          translate.delete_file,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 16,
                                            fontFamily: kNormalTextFontFamily,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          primary:
                                              Theme.of(context).indicatorColor,
                                          fixedSize: Size(260, 42),
                                          elevation: 0,
                                          side: BorderSide(
                                            style: BorderStyle.solid,
                                            color: Theme.of(context)
                                                .indicatorColor,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 40,
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context).splashColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
