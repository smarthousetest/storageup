import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:upstorage_desktop/components/blur/change_password.dart';
import 'package:upstorage_desktop/components/blur/delete_avatar.dart';
import 'package:upstorage_desktop/components/blur/failed_server_conection.dart';
import 'package:upstorage_desktop/components/blur/something_goes_wrong.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/main.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/pages/auth/auth_view.dart';
import 'package:upstorage_desktop/pages/settings/settings_bloc.dart';
import 'package:upstorage_desktop/pages/settings/settings_event.dart';
import 'package:upstorage_desktop/pages/settings/settings_state.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/components/blur/rename_name.dart';
import 'package:upstorage_desktop/components/blur/delete_account.dart';
import 'package:upstorage_desktop/utilites/language_locale.dart';
import 'package:upstorage_desktop/utilites/state_containers/state_container.dart';
import 'package:upstorage_desktop/utilites/extensions.dart';

import '../../models/enums.dart';

enum FileOptions { changePhoto, remove }

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();

  SettingsPage();
}

class _SettingsPageState extends State<SettingsPage> {
  S translate = getIt<S>();
  var name = "Александр Рождественский";
  var index = 0;
  var focusName = true;
  var focusNodeForName = FocusNode();
  bool _isClicked = false;
  String dropdownValue = 'Русский';
  String dropdownDateValue = 'ДД/ММ/ГГГГ';
  List<GlobalKey> _keys = [];

  @override
  void initState() {
    for (var i = 0; i < 3; i++) {
      _keys.add(GlobalKey());
    }

    super.initState();
  }

  Widget build(BuildContext context) {
    //dropdownValue = StateContainer.of(context).locale.languageCode;
    var decoration = () {
      return BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
          ),
        ),
      );
    };

    var decorationUnderline = (int ind) {
      return BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
            style: BorderStyle.solid,
            color: index == ind
                ? Theme.of(context).splashColor
                : Colors.transparent,
          ),
        ),
      );
    };

    return BlocProvider(
      create: (context) => SettingsBloc()..add(SettingsPageOpened()),
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
                offset: Offset(1, 4),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  mainAxisAlignment: MainAxisAlignment.start,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Container(
                      decoration: decoration(),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 0;
                            print(index);
                          });
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            padding: EdgeInsets.only(bottom: 10),
                            decoration: decorationUnderline(0),
                            child: Text(
                              translate.personal_data,
                              key: _keys[0],
                              style: TextStyle(
                                color: index == 0
                                    ? Theme.of(context).focusColor
                                    : Theme.of(context)
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
                    Container(
                      decoration: decoration(),
                      child: GestureDetector(
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
                              padding: EdgeInsets.only(bottom: 10),
                              decoration: decorationUnderline(1),
                              child: Text(
                                translate.options,
                                key: _keys[1],
                                style: TextStyle(
                                  color: index == 1
                                      ? Theme.of(context).focusColor
                                      : Theme.of(context)
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
                    ),
                    Container(
                      decoration: decoration(),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            index = 2;
                            print(index);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 29),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 10),
                              decoration: decorationUnderline(2),
                              child: Text(
                                translate.regulations,
                                key: _keys[2],
                                style: TextStyle(
                                  color: index == 2
                                      ? Theme.of(context).focusColor
                                      : Theme.of(context)
                                          .textTheme
                                          .subtitle1
                                          ?.color,
                                  fontFamily: kNormalTextFontFamily,
                                  overflow: TextOverflow.ellipsis,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        child: Container(
                          padding: EdgeInsets.only(bottom: 12),
                          child: Text(
                            '',
                            style: TextStyle(
                              color: index == 2
                                  ? Theme.of(context).focusColor
                                  : Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      ?.color,
                              fontFamily: kNormalTextFontFamily,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 20,
                            ),
                          ),
                          decoration: decoration(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  return IndexedStack(
                    index: index,
                    sizing: StackFit.passthrough,
                    children: [
                      personalData(context),
                      options(context),
                      regulations(context),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  var controller = CustomPopupMenuController();

  Widget personalData(BuildContext context) {
    return ListView(controller: ScrollController(), children: [
      Padding(
        padding: const EdgeInsets.only(left: 40, top: 30),
        child: Container(
          child: Text(
            translate.profile_photo,
            maxLines: 1,
            style: TextStyle(
              color: Theme.of(context).focusColor,
              fontFamily: kNormalTextFontFamily,
              fontSize: 18,
            ),
          ),
        ),
      ),
      BlocListener<SettingsBloc, SettingsState>(
        listener: (context, state) async {
          if (state.status == FormzStatus.submissionFailure) {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return BlurSomethingGoesWrong(true);
              },
            );
          } else if (state.status == FormzStatus.submissionCanceled) {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return BlurFailedServerConnection(true);
              },
            );
          }
        },
        child:
            BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
          return Stack(children: [
            state.valueNotifier != null
                ? ValueListenableBuilder<User?>(
                    valueListenable: state.valueNotifier!,
                    builder: (context, value, _) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 13, left: 40),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Container(
                            width: 120,
                            height: 120,
                            child: value.image,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );
                    })
                : Container(),
            CustomPopupMenu(
              pressType: PressType.singleClick,
              barrierColor: Colors.transparent,
              showArrow: false,
              horizontalMargin: -185,
              verticalMargin: 0,
              controller: controller,
              menuBuilder: () {
                return SettingsPopupMenuActions(
                  theme: Theme.of(context),
                  translate: translate,
                  onTap: (action) async {
                    controller.hideMenu();

                    if (action == AvatarAction.changeAvatar) {
                      controller.hideMenu();
                      context
                          .read<SettingsBloc>()
                          .add(SettingsChangeProfileImage());
                    } else {
                      controller.hideMenu();
                      var result = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return BlurDeletePic();
                        },
                      );
                      if (result) {
                        context
                            .read<SettingsBloc>()
                            .add(SettingsDeleteProfileImage());
                      }
                    }
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 100, left: 124),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.menuIsShowing
                        ? Theme.of(context).dividerColor
                        : Theme.of(context).cardColor,
                  ),
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: SvgPicture.asset(
                        "assets/file_page/photo.svg",
                        color: controller.menuIsShowing
                            ? Theme.of(context).splashColor
                            : Theme.of(context).focusColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]);
        }),
      ),
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 40),
            child: Text(
              translate.user_name,
              style: TextStyle(
                fontSize: 18,
                fontFamily: kNormalTextFontFamily,
                color: Theme.of(context).focusColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, top: 25),
            child: BlocBuilder<SettingsBloc, SettingsState>(
                builder: (context, state) {
              return GestureDetector(
                onTap: () async {
                  var str = await showDialog<String>(
                    context: context,
                    builder: (BuildContext context) {
                      return BlurRenameName(state.user!.firstName!);
                    },
                  );
                  if (str != null)
                    context
                        .read<SettingsBloc>()
                        .add(SettingsNameChanged(name: str));
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: SvgPicture.asset(
                    "assets/file_page/pencil.svg",
                  ),
                ),
              );
            }),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(left: 40, top: 15),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 350,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Color(0xffE4E7ED),
                  )),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 11),
                child: BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                  return Text(
                    state.user?.firstName ??
                        state.user?.email?.split('@').first ??
                        'Name',
                    maxLines: 1,
                    style: TextStyle(
                        color: Theme.of(context).disabledColor,
                        overflow: TextOverflow.ellipsis),
                  );
                }),
              ),
            ),
          ],
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
        child: Row(
          children: [
            Container(
              height: 42,
              width: 350,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Color(0xffE4E7ED),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15, top: 11),
                child: BlocBuilder<SettingsBloc, SettingsState>(
                    builder: (context, state) {
                  return Text(
                    state.user?.email ?? '',
                    style: TextStyle(color: Theme.of(context).disabledColor),
                  );
                }),
              ),
            ),
          ],
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
      BlocBuilder<SettingsBloc, SettingsState>(builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            var str = await showDialog(
              context: context,
              builder: (BuildContext context) {
                return BlurChangePassword(state.user!);
              },
            );
            if (str is ChangePasswordPopupResult) {
              context.read<SettingsBloc>().add(
                    SettingsPasswordChanged(
                        oldPassword: str.oldPassword,
                        newPassword: str.newPassword),
                  );
              context.read<SettingsBloc>().add(SettingsLogOut());
              Navigator.pushNamedAndRemoveUntil(
                  context, AuthView.route, (route) => false);
              ;
            }

            // await _tokenRepository.setApiToken('');
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 40),
              child: Row(
                children: [
                  Container(
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
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Spacer(),
                        Align(
                          alignment: FractionalOffset.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 148, top: 2),
                            child: Container(
                                child: SvgPicture.asset(
                                    "assets/file_page/arrow.svg")),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
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
            padding: const EdgeInsets.only(top: 20, left: 40, bottom: 30),
            child: Row(
              children: [
                Container(
                  width: 350,
                  height: 42,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
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
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Spacer(),
                      Align(
                        alignment: FractionalOffset.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 148, top: 2),
                          child: Container(
                              child: SvgPicture.asset(
                                  "assets/file_page/arrow.svg")),
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
    ]);
  }

  Widget options(BuildContext context) {
    return ListView(controller: ScrollController(), children: [
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 450),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                BlocBuilder<SettingsBloc, SettingsState>(
                  builder: (context, state) {
                    // String languageEn = '';
                    // String languageRu = '';

                    // switch (state.language) {
                    //   case 'ru':
                    //     language = translate.russian;
                    //     break;
                    //   default:
                    //     language = translate.english;
                    //     break;
                    // }
                    // if (Intl.systemLocale == 'en') {
                    //   languageEn = translate.english;
                    // } else {
                    //   languageRu = translate.russian;
                    // }

                    if (StateContainer.of(context).locale.languageCode == 'en')
                      dropdownValue = 'English';
                    else
                      dropdownValue = 'Русский';

                    var english =
                        Intl.withLocale('en', () => translate.english);
                    // state.language.contains('en') ? translate.english : translate.russian;
                    var russian =
                        Intl.withLocale('ru', () => translate.russian);
                    return Padding(
                      padding: const EdgeInsets.only(top: 20),
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
                                // if (newValue == russian) {
                                //   context.read<SettingsBloc>().add(
                                //       LanguageChanged(newLanguage: RUSSIAN));
                                //   _changeLanguage(RUSSIAN);
                                // } else {
                                //   context.read<SettingsBloc>().add(
                                //       LanguageChanged(newLanguage: ENGLISH));
                                //   _changeLanguage(ENGLISH);
                                // }
                                StateContainer.of(context).changeLocale(
                                  Locale(
                                    newValue == 'English' ? 'en' : 'ru',
                                  ),
                                );
                              });
                            },
                            items: <String>[
                              russian,
                              english,
                            ].map<DropdownMenuItem<String>>((String value) {
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
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      Row(
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 450),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 40),
                  child: Text(
                    translate.date_format,
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: kNormalTextFontFamily,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
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
                        style:
                            TextStyle(color: Theme.of(context).disabledColor),
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
                                child:
                                    Text(value, textAlign: TextAlign.center)),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ]);
  }

  Future<void> _changeLanguage(String langCode) async {
    Locale locale = await setLocale(langCode);

    MyApp.setLocale(context, locale);
    await Future.delayed(Duration(milliseconds: 500));
  }

  Widget regulations(BuildContext context) {
    return ListView(controller: ScrollController(), children: [
      Padding(
        padding: const EdgeInsets.only(
          left: 125,
          top: 20,
          right: 125,
          bottom: 20,
        ),
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
      ),
    ]);
  }
}

class SettingsPopupMenuActions extends StatefulWidget {
  SettingsPopupMenuActions(
      {required this.theme,
      required this.translate,
      required this.onTap,
      Key? key})
      : super(key: key);

  final ThemeData theme;
  final S translate;
  final Function(AvatarAction) onTap;

  @override
  _SettingsPopupMenuActionsState createState() =>
      _SettingsPopupMenuActionsState();
}

class _SettingsPopupMenuActionsState extends State<SettingsPopupMenuActions> {
  int ind = -1;

  @override
  Widget build(BuildContext context) {
    var style = TextStyle(
      fontFamily: kNormalTextFontFamily,
      fontSize: 14,
      color: Theme.of(context).disabledColor,
    );
    var mainColor = widget.theme.colorScheme.onSecondary;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: mainColor,
            spreadRadius: 3,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: IntrinsicWidth(
            child: Column(
              children: [
                GestureDetector(
                  onTapDown: (_) {
                    print('change photo tapped ');
                    widget.onTap(AvatarAction.changeAvatar);
                  },
                  child: MouseRegion(
                    onEnter: (event) {
                      setState(() {
                        ind = 0;
                      });
                    },
                    child: Container(
                      width: 190,
                      height: 40,
                      color: ind == 0 ? mainColor : null,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      margin: EdgeInsets.zero,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/file_page/photo_change.svg',
                            height: 20,
                          ),
                          Container(
                            width: 15,
                          ),
                          Text(
                            widget.translate.change_photo,
                            style: style,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: mainColor,
                  height: 1,
                ),
                MouseRegion(
                  onEnter: (event) {
                    setState(() {
                      ind = 1;
                    });
                  },
                  child: GestureDetector(
                    onTapDown: (_) {
                      print('delete photo tapped ');
                      widget.onTap(AvatarAction.delete);
                    },
                    child: Container(
                      width: 190,
                      height: 40,
                      color: ind == 1
                          ? widget.theme.indicatorColor.withOpacity(0.1)
                          : null,
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Image.asset(
                          //   'assets/file_page/file_options/trash.png',
                          //   height: 20,
                          // ),
                          SvgPicture.asset(
                            'assets/file_page/trash.svg',
                            height: 20,
                            color: widget.theme.indicatorColor,
                          ),
                          Container(
                            width: 15,
                          ),
                          Text(
                            widget.translate.delete,
                            style: style.copyWith(
                                color: Theme.of(context).errorColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
