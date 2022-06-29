import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

class BlurRename extends StatefulWidget {
  final name;
  final bool hint;

  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();

  BlurRename(this.name, this.hint);
}

class _ButtonTemplateState extends State<BlurRename> {
  S translate = getIt<S>();
  var myController = TextEditingController();
  bool canSave = false;
  bool hintColor = false;
  bool hintSymbvols = true;

  @override
  void initState() {
    myController = TextEditingController(text: widget.name);
    hintColor = widget.hint;
    super.initState();
    myController.selection = TextSelection(
      baseOffset: 0,
      extentOffset: widget.name.length,
    );
  }

  void onSubmit() {
    if (canSave == true) {
      Navigator.pop(context, myController.value.text.trim());
    } else {
      null;
    }
    print(widget.name);
  }

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
            child: Container(
              width: 520,
              height: 235,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(60, 25, 0, 0),
                    child: Container(
                      width: 400,
                      height: 190,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translate.rename,
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: kNormalTextFontFamily,
                              color: Theme.of(context).focusColor,
                            ),
                          ),
                          Padding(
                            padding: hintColor
                                ? EdgeInsets.only(top: 0)
                                : EdgeInsets.only(top: 20),
                            child: Text(
                              translate.wrong_filename,
                              style: TextStyle(
                                fontSize: hintColor ? 0 : 14,
                                fontFamily: kNormalTextFontFamily,
                                color: hintColor
                                    ? Colors.white
                                    : Theme.of(context).errorColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: hintSymbvols
                                ? EdgeInsets.only(top: 0)
                                : EdgeInsets.only(top: 20),
                            child: Text(
                              translate.wrong_symbvols,
                              style: TextStyle(
                                fontSize: hintSymbvols ? 0 : 14,
                                fontFamily: kNormalTextFontFamily,
                                color: hintSymbvols
                                    ? Colors.white
                                    : Theme.of(context).errorColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: hintColor && hintSymbvols
                                ? EdgeInsets.only(top: 42)
                                : EdgeInsets.only(top: 5),
                            child: Container(
                              width: 400,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              alignment: Alignment.center,
                              child: TextFormField(
                                controller: myController,
                                autofocus: true,
                                onFieldSubmitted: (_) {
                                  onSubmit();
                                },
                                onChanged: (myController) {
                                  print(myController);
                                  myController = myController.trim();
                                  if (myController.contains(
                                              RegExp(r'[\\/:*?\"<>|]'), 0) ==
                                          true &&
                                      myController.isNotEmpty) {
                                    setState(() {
                                      hintSymbvols = false;
                                      canSave = false;
                                    });
                                  } else if (myController.isNotEmpty) {
                                    setState(() {
                                      hintSymbvols = true;
                                      canSave = true;
                                    });
                                  } else {
                                    setState(() {
                                      hintSymbvols = true;
                                      canSave = false;
                                    });
                                  }
                                },
                                style: TextStyle(
                                    color: Theme.of(context).disabledColor,
                                    fontSize: 14,
                                    fontFamily: kNormalTextFontFamily),
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.only(left: 15, bottom: 8),
                                  hoverColor: Theme.of(context).cardColor,
                                  focusColor: Theme.of(context).cardColor,
                                  fillColor: Theme.of(context).cardColor,
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 0.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: Theme.of(context).cardColor,
                                        width: 0.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Container(
                              width: 400,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        translate.cancel,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                          fontSize: 16,
                                          fontFamily: kNormalTextFontFamily,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Theme.of(context).primaryColor,
                                        fixedSize: Size(140, 42),
                                        elevation: 0,
                                        side: BorderSide(
                                          style: BorderStyle.solid,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: ElevatedButton(
                                      onPressed: onSubmit,
                                      child: Text(
                                        translate.save,
                                        style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 16,
                                          fontFamily: kNormalTextFontFamily,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: canSave
                                            ? Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                            : Theme.of(context).canvasColor,
                                        fixedSize: Size(240, 42),
                                        elevation: 0,
                                        side: BorderSide(
                                          style: BorderStyle.solid,
                                          color: canSave
                                              ? Theme.of(context).splashColor
                                              : Theme.of(context).canvasColor,
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
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                      width: 60,
                      alignment: Alignment.topRight,
                      padding: EdgeInsets.only(right: 10, top: 10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child:
                                SvgPicture.asset('assets/file_page/close.svg')),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
