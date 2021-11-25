import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/components/blur/change_password.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/utilities/injection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:upstorage_desktop/components/blur/rename_name.dart';
import 'package:upstorage_desktop/components/blur/delete_account.dart';

enum FileOptions { changePhoto, remove }

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
  SettingsPage();
}

class _SettingsPageState extends State<SettingsPage> {
  S translate = getIt<S>();
  var index = 0;
  var focusName = true;
  var focusNodeForName = FocusNode();
  bool _isClicked = false;
  String dropdownValue = 'Русский';
  String dropdownDateValue = 'ДД/ММ/ГГГГ';

  Widget build(BuildContext context) {
    return Expanded(
      child: IndexedStack(
        index: index,
        children: [
          Column(
            children: [personalData(context)],
          ),
          Column(
            children: [options(context)],
          ),
          Column(
            children: [regulations(context)],
          ),
        ],
      ),
    );
  }

  Widget personalData(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color.fromARGB(25, 23, 69, 139),
                  blurRadius: 4,
                  offset: Offset(1, 4))
            ],
          ),
          child: ListView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Text(
                          translate.personal_data,
                          style: TextStyle(
                            color: Theme.of(context).focusColor,
                            fontFamily: kNormalTextFontFamily,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 1;
                            print(index);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              child: Text(
                                translate.options,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.color,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 2;
                            print(index);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              child: Text(
                                translate.regulations,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.color,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Stack(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 40, top: 15, right: 40),
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, top: 14),
                    child: Container(
                      width: 149,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Theme.of(context).splashColor,
                      ),
                    ),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 40),
                  child: Text(
                    translate.profile_photo,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: kNormalTextFontFamily,
                        color: Theme.of(context).focusColor),
                  ),
                ),
                Stack(children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 13, left: 40),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).focusColor,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/file_page/val.jpg",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 100, left: 124),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isClicked
                            ? Theme.of(context).dividerColor
                            : Theme.of(context).cardColor,
                      ),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: PopupMenuButton<FileOptions>(
                            offset: Offset(40, -80),
                            iconSize: 20,
                            elevation: 0,
                            color: Theme.of(context).primaryColor,
                            //padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).dividerColor),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            icon: SvgPicture.asset(
                              "assets/file_page/photo.svg",
                              color: _isClicked
                                  ? Theme.of(context).splashColor
                                  : Theme.of(context).focusColor,
                            ),
                            onSelected: (_) {
                              setState(() {
                                _isClicked = false;
                              });
                            },
                            onCanceled: () {
                              setState(() {
                                _isClicked = false;
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              setState(() {
                                _isClicked = true;
                              });
                              return [
                                PopupMenuItem<FileOptions>(
                                  height: 44,
                                  child: Container(
                                    width: 185,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/file_page/photo_change.svg',
                                          height: 18,
                                        ),
                                        Container(
                                          width: 15,
                                        ),
                                        Text(
                                          'Изменить фото',
                                          style: TextStyle(
                                            color: Theme.of(context).focusColor,
                                            fontSize: 14,
                                            fontFamily: kNormalTextFontFamily,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                // PopupMenuDivider(
                                //   height: 1,
                                // ),

                                PopupMenuItem(
                                  height: 44,
                                  child: Container(
                                    width: 185,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .indicatorColor
                                          .withAlpha(10),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/file_page/trash.svg',
                                          height: 18,
                                        ),
                                        Container(
                                          width: 15,
                                        ),
                                        Text(
                                          'Удалить',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .indicatorColor,
                                            fontSize: 14,
                                            fontFamily: kNormalTextFontFamily,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ];
                            }),
                      ),
                    ),
                  ),
                ]),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25, left: 40),
                      child: Text(
                        translate.user_name,
                        style: TextStyle(
                            fontSize: 18,
                            fontFamily: kNormalTextFontFamily,
                            color: Theme.of(context).focusColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 25),
                      child: GestureDetector(
                        onTap: () async {
                          var str = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return BlurRenameName();
                            },
                          );
                          // setState(() {
                          //   focusName = !focusName;
                          // });
                          // focusNodeForName.requestFocus();
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: SvgPicture.asset(
                            "assets/file_page/pencil.svg",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 15),
                  child: Container(
                    height: 42,
                    width: 350,
                    child: TextFormField(
                      focusNode: focusNodeForName,
                      initialValue: "Александр Рождественский",
                      readOnly: focusName,
                      style: TextStyle(
                          color: Theme.of(context).disabledColor,
                          fontSize: 15,
                          fontFamily: kNormalTextFontFamily),
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 15, top: 11, bottom: 11),
                        filled: focusName,
                        //hintText: "Александр Рождественский",
                        hoverColor: Theme.of(context).cardColor,
                        focusColor: Theme.of(context).primaryColor,
                        fillColor: Theme.of(context).cardColor,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Color(0xffE4E7ED), width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide:
                              BorderSide(color: Color(0xffE4E7ED), width: 1.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, left: 40),
                  child: Text(
                    translate.mail,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: kNormalTextFontFamily,
                        color: Theme.of(context).focusColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 15),
                  child: Container(
                    height: 42,
                    width: 350,
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xffE4E7ED))),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, top: 11),
                      child: Text(
                        "votreaa@mail.ru",
                        style:
                            TextStyle(color: Theme.of(context).disabledColor),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 20, right: 40),
                  child: Container(
                    height: 1,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    var str = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BlurChangePassword();
                      },
                    );
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, left: 40),
                      child: Container(
                        width: 350,
                        height: 42,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: FractionalOffset.centerLeft,
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).cardColor,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SvgPicture.asset(
                                      "assets/file_page/key.svg",
                                      alignment: Alignment.center,
                                      width: 20,
                                      height: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                translate.change_password,
                                style: TextStyle(
                                    color: Theme.of(context).disabledColor,
                                    fontFamily: kNormalTextFontFamily,
                                    fontSize: 17),
                              ),
                            ),
                            Align(
                              alignment: FractionalOffset.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 148),
                                child: Container(
                                    child: SvgPicture.asset(
                                        "assets/file_page/arrow.svg")),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    var str = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BlurDeletingAccount();
                      },
                    );
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20, left: 40),
                      child: Container(
                        width: 350,
                        height: 42,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Align(
                              alignment: FractionalOffset.centerLeft,
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).cardColor,
                                ),
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: SvgPicture.asset(
                                        "assets/file_page/trash.svg",
                                        alignment: Alignment.center,
                                        width: 20,
                                        height: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Text(
                                translate.delete_account,
                                style: TextStyle(
                                    color: Theme.of(context).disabledColor,
                                    fontFamily: kNormalTextFontFamily,
                                    fontSize: 17),
                              ),
                            ),
                            Align(
                              alignment: FractionalOffset.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 148),
                                child: Container(
                                    child: SvgPicture.asset(
                                        "assets/file_page/arrow.svg")),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget options(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color.fromARGB(25, 23, 69, 139),
                  blurRadius: 4,
                  offset: Offset(1, 4))
            ],
          ),
          child: ListView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 0;
                            print(index);
                          });
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Text(
                            translate.personal_data,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.subtitle1?.color,
                              fontFamily: kNormalTextFontFamily,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Container(
                                  child: Text(
                                    translate.options,
                                    style: TextStyle(
                                      color: Theme.of(context).focusColor,
                                      fontFamily: kNormalTextFontFamily,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 2;
                            print(index);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              child: Text(
                                translate.regulations,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.color,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Stack(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 40, top: 15, right: 40),
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 217, top: 14),
                    child: Container(
                      width: 110,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Theme.of(context).splashColor,
                      ),
                    ),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.only(top: 25, left: 40),
                  child: Text(
                    translate.parameters,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: kNormalTextFontFamily,
                        color: Theme.of(context).focusColor),
                  ),
                ),
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 25, left: 40),
                      child: Text(
                        translate.language,
                        style: TextStyle(
                            fontSize: 17,
                            fontFamily: kNormalTextFontFamily,
                            color: Theme.of(context).disabledColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 400, top: 20),
                      child: SizedBox(
                        width: 140,
                        child: ButtonTheme(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                width: 1,
                                color: Theme.of(context).dividerColor),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          alignedDropdown: true,
                          child: DropdownButton(
                            dropdownColor: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            isExpanded: true,
                            value: dropdownValue,
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: SvgPicture.asset(
                                  "assets/file_page/array_down.svg"),
                            ),
                            underline: Container(
                              height: 2,
                              width: 140,
                              color: Theme.of(context).dividerColor,
                            ),
                            style: TextStyle(
                                color: Theme.of(context).disabledColor),
                            elevation: 10,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                            items: <String>['Русский', 'English']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Center(
                                    child: Text(
                                  value,
                                )),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 40),
                      child: Text(
                        translate.date_format,
                        style: TextStyle(
                            fontSize: 17,
                            fontFamily: kNormalTextFontFamily,
                            color: Theme.of(context).disabledColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 335, top: 10),
                      child: SizedBox(
                        width: 140,
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            dropdownColor: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            isExpanded: true,
                            value: dropdownDateValue,
                            icon: Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: SvgPicture.asset(
                                  "assets/file_page/array_down.svg"),
                            ),
                            underline: Container(
                              height: 2,
                              width: 140,
                              color: Theme.of(context).dividerColor,
                            ),
                            style: TextStyle(
                                color: Theme.of(context).disabledColor),
                            elevation: 10,
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownDateValue = newValue!;
                              });
                            },
                            items: <String>[
                              'ДД/ММ/ГГГГ',
                              'ДД/ММ/ГГ',
                              'ММ/ГГ',
                              'ДД/ММ',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Center(
                                    child: Text(value,
                                        textAlign: TextAlign.center)),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget regulations(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color.fromARGB(25, 23, 69, 139),
                  blurRadius: 4,
                  offset: Offset(1, 4))
            ],
          ),
          child: ListView(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 40, top: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 0;
                            print(index);
                          });
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Text(
                            translate.personal_data,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.subtitle1?.color,
                              fontFamily: kNormalTextFontFamily,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                index = 1;
                                print(index);
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Container(
                                  child: Text(
                                    translate.options,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          ?.color,
                                      fontFamily: kNormalTextFontFamily,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              child: Text(
                                translate.regulations,
                                style: TextStyle(
                                  color: Theme.of(context).focusColor,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Stack(children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 40, top: 15, right: 40),
                    child: Container(
                      height: 1,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 355, top: 14),
                    child: Container(
                      width: 240,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Theme.of(context).splashColor,
                      ),
                    ),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 125, top: 20, right: 125, bottom: 20),
                  child: Column(
                    children: [
                      Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            translate.privacy_policy,
                            style: TextStyle(
                              color: Theme.of(context).focusColor,
                              fontFamily: kNormalTextFontFamily,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            translate.provisions,
                            style: TextStyle(
                              color: Theme.of(context).focusColor,
                              fontFamily: kNormalTextFontFamily,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          translate.personal,
                          style: TextStyle(
                            color: Theme.of(context).focusColor,
                            fontFamily: kNormalTextFontFamily,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
