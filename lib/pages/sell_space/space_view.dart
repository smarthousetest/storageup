import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/components/custom_button_template.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/pages/sell_space/folder_list/folder_list_view.dart';
import 'package:upstorage_desktop/pages/sell_space/space_bloc.dart';
import 'package:upstorage_desktop/pages/sell_space/space_state.dart';
import 'package:upstorage_desktop/pages/sell_space/space_event.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:upstorage_desktop/utilites/extensions.dart';
import 'package:upstorage_desktop/utilites/state_container.dart';

class SpaceSellPage extends StatefulWidget {
  static const route = "sell_space_page";

  @override
  _SpaceSellPageState createState() => _SpaceSellPageState();

  SpaceSellPage();
}

class PathCheck {
  static List<String> _restrictedWords = [
    'OneDrive',
    'Program Files',
    'Program Files (x86)',
  ];

  bool isPathCorrect(String path){
    var partsOfPath = path.split(Platform.pathSeparator);
    for(var part in partsOfPath){
      for(var restrictedWord in _restrictedWords){
        if(part == restrictedWord){
          return false;
        }
      }
    }
    return true;
  }

  ///Function check is a path contain "OneDrive" part
  ///If contain, return path before "OneDrive" part
  static String doPathCorrect(String path) {
    var partPath = path.split(Platform.pathSeparator);
    for (int i = 0; i < partPath.length; i++) {
      for (var restrictedWord in _restrictedWords) {
        if (partPath[i] == restrictedWord) {
          var result = partPath.sublist(0, i);
          result.add(path.split(Platform.pathSeparator).last);
          return result.join(Platform.pathSeparator);
        }
      }
    }
    return path;
  }

  @override
  String toString() {
    return _restrictedWords.toString();
  }

}

class _SpaceSellPageState extends State<SpaceSellPage> {
  Future<String?> getFilesPaths() async {
    String? result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      return PathCheck.doPathCorrect(result);
    }
    return null;
  }

  //final List<DownloadLocation> locationsInfo;
  double? _searchFieldWidth;
  var index = 0;
  S translate = getIt<S>();
  String dirPath = '';
  double _currentSliderValue = 32;
  int countGbSpace = 0;
  final double _rowPadding = 30.0;
  GlobalKey nameWidthKey = GlobalKey();
  final myController = TextEditingController();

  void _setWidthSearchFields(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    _searchFieldWidth = width - _rowPadding * 4 - 274 - 222;
  }

  Widget build(BuildContext context) {
    _setWidthSearchFields(context);

    return BlocProvider(
        create: (context) => SpaceBloc()
          ..add(SpacePageOpened())
          ..add(SendKeeperVersion()),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 30,
              right: 30,
              top: 30,
            ),
            child: Container(
              height: 46,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
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
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Align(
                                alignment: FractionalOffset.centerLeft,
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  child: SvgPicture.asset("assets/file_page/search.svg"),
                                ),
                              ),
                            ),
                            Container(
                              width: _searchFieldWidth,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    StateContainer.of(context).changePage(ChosenPage.file);
                                  },
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Container(
                                      child: Text(
                                        translate.search,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: BlocBuilder<SpaceBloc, SpaceState>(builder: (context, state) {
                      return state.valueNotifier != null
                          ? ValueListenableBuilder<User?>(
                              valueListenable: state.valueNotifier!,
                              builder: (context, value, _) {
                                return Row(
                                  key: nameWidthKey,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        right: 20,
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          StateContainer.of(context).changePage(ChosenPage.settings);
                                        },
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(23.0),
                                            child: Container(child: value.image),
                                          ),
                                        ),
                                      ),
                                    ),
                                    (MediaQuery.of(context).size.width > 965)
                                        ? Container(
                                            constraints: BoxConstraints(maxWidth: 110),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                                  child: Text(
                                                    value?.firstName ?? value?.email?.split('@').first ?? 'Name',
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      color: Theme.of(context).bottomAppBarColor,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  value?.email ?? '',
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Theme.of(context).bottomAppBarColor,
                                                    height: 1,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                  ],
                                );
                              })
                          : Container();
                    }),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SpaceBloc, SpaceState>(builder: (context, state) {
              var fl = folderList(context);
              return IndexedStack(
                sizing: StackFit.expand,
                key: ValueKey<int>(index),
                index: index,
                children: [
                  state.keeper.isEmpty ? rentingAPlace(context) : fl,
                  Column(
                    children: [addSpace(context)],
                  ),
                  fl,
                ],
              );
            }),
          )
        ]));
  }

  Widget rentingAPlace(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
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
        // ListView(controller: ScrollController(), children: [
        //   (MediaQuery.of(context).size.width > 1340)
        //       ? Padding(
        //           padding: const EdgeInsets.only(left: 558, top: 83),
        //           child: Container(
        //             child: Image.asset(
        //               'assets/file_page/man+back.png',
        //               //fit: BoxFit.fitWidth,
        //             ),
        //           ),
        //         )
        //       : Container(),
        child: ListView(controller: ScrollController(), children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 20),
              child: Container(
                child: Text(
                  translate.sell_space,
                  maxLines: 1,
                  style: TextStyle(
                    color: Theme.of(context).focusColor,
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 40,
                top: 20,
                right: 40,
              ),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 40,
                top: 20,
              ),
              child: Container(
                child: Text(
                  translate.how_work,
                  style: TextStyle(
                    color: Theme.of(context).focusColor,
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 40,
                top: 15,
              ),
              child: Row(
                children: [
                  Container(
                    child: Text(
                      translate.rent_space + "\n" + translate.make_money,
                      style: TextStyle(
                        color: Theme.of(context).disabledColor,
                        fontFamily: kNormalTextFontFamily,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 40,
                top: 15,
              ),
              child: Container(
                child: Text(
                  '${translate.select_folder}\n${translate.store_files}\n${translate.money}',
                  style: TextStyle(
                    color: Theme.of(context).disabledColor,
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 20),
              child: Container(
                child: Text(
                  translate.money_two_step,
                  style: TextStyle(
                    color: Theme.of(context).focusColor,
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 20),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Color(0xff868FFF),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                      child: Text(
                        translate.folder,
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 10),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Color(0xff868FFF),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Container(
                      child: Text(
                        translate.size_of_space,
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 40,
                top: 15,
              ),
              child: Container(
                child: Text(
                  translate.upload_file + "\n" + translate.your_balance,
                  style: TextStyle(
                    color: Theme.of(context).disabledColor,
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 40,
                top: 20,
                right: 40,
              ),
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 40,
                top: 20,
              ),
              child: Container(
                child: Text(
                  translate.not_storage,
                  style: TextStyle(
                    color: Theme.of(context).focusColor,
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 40,
                top: 20,
                bottom: 30,
              ),
              child: Container(
                height: 42,
                width: 200,
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      index = 1;
                      print(index);
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.maxFinite, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Theme.of(context).splashColor,
                  ),
                  child: Text(
                    translate.add_location,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ]),
      ),
    );
  }

  Widget addSpace(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(30.0),
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
          child: ListView(controller: ScrollController(), children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 20),
                child: Row(
                  children: [
                    Container(
                      child: Text(
                        translate.sell_space + " / ",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.subtitle1?.color,
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        translate.add_location,
                        style: TextStyle(
                          color: Theme.of(context).focusColor,
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 20, right: 40),
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 26),
                child: Row(children: [
                  Container(
                    child: Text(
                      translate.select_storage,
                      style: TextStyle(
                        color: Theme.of(context).focusColor,
                        fontFamily: kNormalTextFontFamily,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        child: SvgPicture.asset(
                          'assets/file_page/prompt.svg',
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40, top: 15),
                    child: Container(
                      height: 42,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color(0xffE4E7ED),
                          )),
                      child: BlocBuilder<SpaceBloc, SpaceState>(
                        builder: (context, state) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 15, top: 11),
                            child: Text(
                              dirPath,
                              maxLines: 1,
                              style: TextStyle(color: Theme.of(context).disabledColor),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  BlocBuilder<SpaceBloc, SpaceState>(
                    builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: Container(
                          height: 42,
                          width: 200,
                          child: OutlinedButton(
                            onPressed: () async {
                              String? path = await getFilesPaths();
                              print(path);
                              setState(
                                () {
                                  if (path != null) {
                                    dirPath = path;
                                  }
                                },
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(double.maxFinite, 60),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              backgroundColor: Theme.of(context).splashColor,
                            ),
                            child: Text(
                              translate.overview,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              _setName(context),
              Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 40, top: 25),
                      child: Container(
                        child: Text(
                          translate.set_size,
                          style: TextStyle(
                            color: Theme.of(context).focusColor,
                            fontFamily: kNormalTextFontFamily,
                            fontSize: 16,
                          ),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 25),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        child: SvgPicture.asset(
                          'assets/file_page/prompt.svg',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 10),
                child: Container(
                  child: Text(
                    translate.min_storage,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 8),
                child: Container(
                  child: Text(
                    translate.max_storage,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40, top: 20),
                    child: Container(
                      width: 350,
                      height: 20,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Theme.of(context).splashColor,
                          inactiveTrackColor: Theme.of(context).dividerColor,
                          trackShape: RectangularSliderTrackShape(),
                          trackHeight: 8.0,
                          thumbColor: Theme.of(context).primaryColor,
                          overlayShape: RoundSliderOverlayShape(overlayRadius: 0),
                          //thumbShape:
                          //RoundSliderThumbShape(enabledThumbRadius: 10),
                        ),
                        child: Slider(
                          min: 32,
                          max: 180,
                          value: _currentSliderValue,
                          onChanged: (double value) {
                            setState(
                              () {
                                _currentSliderValue = value;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Stack(children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      child: Container(
                        height: 42,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            translate.gb(_currentSliderValue.toInt()),
                            style: TextStyle(
                              color: Theme.of(context).disabledColor,
                              fontFamily: kNormalTextFontFamily,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      child: Container(
                        height: 42,
                        width: 42,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              if (_currentSliderValue > 32) {
                                _currentSliderValue = _currentSliderValue - 1;
                              }
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.maxFinite, 60),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0))),
                            backgroundColor: Theme.of(context).cardColor,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.remove,
                              size: 15,
                              color: Theme.of(context).focusColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 178, top: 20),
                      child: Container(
                        height: 42,
                        width: 42,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(
                              () {
                                if (_currentSliderValue < 180) {
                                  _currentSliderValue = _currentSliderValue + 1;
                                }
                              },
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.maxFinite, 60),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10.0), bottomRight: Radius.circular(10.0))),
                            backgroundColor: Theme.of(context).cardColor,
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              size: 15,
                              color: Theme.of(context).focusColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])
                ],
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 40, top: 25),
                  child: Container(
                    child: Text(
                      translate.your_income,
                      style: TextStyle(
                        color: Theme.of(context).focusColor,
                        fontFamily: kNormalTextFontFamily,
                        fontSize: 16,
                      ),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.only(left: 40, top: 8),
                  child: Container(
                    child: Text(
                      translate.our_tariff,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.subtitle1?.color,
                        fontFamily: kNormalTextFontFamily,
                        fontSize: 14,
                      ),
                    ),
                  )),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40, top: 30),
                    child: Container(
                      child: Text(
                        translate.earnings,
                        style: TextStyle(
                          color: Theme.of(context).focusColor,
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 27, top: 30),
                    child: Container(
                      width: 140,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "${(_currentSliderValue.toInt() * 0.2).toInt()} ₽/день",
                          style: TextStyle(
                            color: Theme.of(context).disabledColor,
                            fontFamily: kNormalTextFontFamily,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 31, bottom: 30),
                child: Container(
                  height: 42,
                  width: 200,
                  child: BlocBuilder<SpaceBloc, SpaceState>(builder: (context, state) {
                    return OutlinedButton(
                      onPressed: () async {
                        bool checkValidate = dirPath.isNotEmpty && myController.text.isNotEmpty;
                        if (!checkValidate) {
                          print('path null');
                        } else {
                          var name = myController.text.trim();
                          // _currentSliderValue.toInt();
                          context.read<SpaceBloc>().add(SaveDirPath(pathDir: dirPath, countGb: _currentSliderValue.toInt(), name: name));
                          await context.read<SpaceBloc>().stream.first;
                          setState(
                            () {
                              index = 2;
                            },
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.maxFinite, 60),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        backgroundColor: dirPath.isEmpty && myController.value.text.isEmpty ? Theme.of(context).canvasColor : Theme.of(context).splashColor,
                      ),
                      child: Text(
                        translate.save,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 17,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  _setName(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 26),
          child: Row(children: [
            Container(
              child: Text(
                translate.name_storage,
                style: TextStyle(
                  color: Theme.of(context).focusColor,
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  child: SvgPicture.asset(
                    'assets/file_page/prompt.svg',
                  ),
                ),
              ),
            ),
          ]),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 15),
              child: Container(
                height: 42,
                width: 350,
                // decoration: BoxDecoration(
                //     color: Theme.of(context).primaryColor,
                //     borderRadius: BorderRadius.circular(10),
                //     border: Border.all(color: Color(0xffE4E7ED))),
                child: BlocBuilder<SpaceBloc, SpaceState>(
                  builder: (context, state) {
                    return TextField(
                      controller: myController,
                      textAlignVertical: TextAlignVertical.bottom,
                      textAlign: TextAlign.start,
                      //autofocus: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 15, bottom: 21),
                        hoverColor: Theme.of(context).cardColor,
                        focusColor: Theme.of(context).cardColor,
                        fillColor: Theme.of(context).cardColor,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xffE4E7ED), width: 0.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(color: Color(0xffE4E7ED), width: 0.0),
                        ),
                      ),
                      style: TextStyle(
                        color: Theme.of(context).disabledColor,
                        fontFamily: kNormalTextFontFamily,
                        fontSize: 14,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget folderList(BuildContext context) {
    return Positioned.fill(
      child: Container(
        margin: EdgeInsets.all(30),
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
        //alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    child: Text(
                      translate.sell_space,
                      maxLines: 1,
                      style: TextStyle(
                        color: Theme.of(context).focusColor,
                        fontFamily: kNormalTextFontFamily,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 100,
                    child: Container(),
                  ),
                  Container(
                    height: 30,
                    width: 142,
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          index = 1;
                          print(index);
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.maxFinite, 60),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        backgroundColor: Theme.of(context).splashColor,
                      ),
                      child: Text(
                        translate.add_location,
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: FolderList(key: Key('test')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




