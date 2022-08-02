import 'package:flutter/material.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/utilities/injection.dart';

class BlurDeleteKeeper extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();

  BlurDeleteKeeper();
}

class _ButtonTemplateState extends State<BlurDeleteKeeper> {
  S translate = getIt<S>();
  bool delete = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 500,
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
              child: Container(
                width: 400,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      translate.deleting,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: kNormalTextFontFamily,
                        color: Theme.of(context).focusColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 25),
                      child: Text(
                        translate.delete_keeper_text1,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: kNormalTextFontFamily,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                    Text(
                      translate.delete_keeper_text2,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: kNormalTextFontFamily,
                        color: Theme.of(context).disabledColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Text(
                        translate.delete_keeper_text3,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: kNormalTextFontFamily,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context, false);
                                    },
                                    child: Text(
                                      translate.cancel,
                                      style: TextStyle(
                                        color: Theme.of(context).disabledColor,
                                        fontSize: 16,
                                        fontFamily: kNormalTextFontFamily,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).cardColor,
                                      fixedSize: Size(130, 42),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context, delete);
                                    },
                                    child: Text(
                                      translate.delete,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: kNormalTextFontFamily,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Theme.of(context).indicatorColor,
                                      fixedSize: Size(115, 42),
                                      elevation: 0,
                                      side: BorderSide(
                                        style: BorderStyle.solid,
                                        color: Theme.of(context).indicatorColor,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: FractionalOffset.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 20, right: 22),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context, false);
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Icon(
                      Icons.close,
                      color: Theme.of(context).splashColor,
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
}
