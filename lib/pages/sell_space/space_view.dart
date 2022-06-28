import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/components/custom_button_template.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/models/download_location.dart';
import 'package:upstorage_desktop/models/keeper/keeper.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/pages/sell_space/folder_list/folder_list_view.dart';
import 'package:upstorage_desktop/pages/sell_space/space_bloc.dart';
import 'package:upstorage_desktop/pages/sell_space/space_state.dart';
import 'package:upstorage_desktop/pages/sell_space/space_event.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/extensions.dart';
import 'package:upstorage_desktop/utilites/state_containers/state_container.dart';

class SpaceSellPage extends StatefulWidget {
  static const route = "sell_space_page";

  @override
  _SpaceSellPageState createState() => _SpaceSellPageState();

  SpaceSellPage();
}

// class PathCheck {
//   static List<String> _restrictedWords = [
//     'OneDrive',
//     'Program Files',
//     'Program Files (x86)',
//   ];

//   bool isPathCorrect(String path) {
//     var partsOfPath = path.split(Platform.pathSeparator);
//     for (var part in partsOfPath) {
//       for (var restrictedWord in _restrictedWords) {
//         if (part == restrictedWord) {
//           return false;
//         }
//       }
//     }
//     return true;
//   }

//   ///Function check is a path contain "OneDrive" part
//   ///If contain, return path before "OneDrive" part
//   static String doPathCorrect(String path) {
//     var partPath = path.split(Platform.pathSeparator);
//     for (int i = 0; i < partPath.length; i++) {
//       for (var restrictedWord in _restrictedWords) {
//         if (partPath[i] == restrictedWord) {
//           var result = partPath.sublist(0, i);
//           result.add(path.split(Platform.pathSeparator).last);
//           return result.join(Platform.pathSeparator);
//         }
//       }
//     }
//     return path;
//   }

//   @override
//   String toString() {
//     return _restrictedWords.toString();
//   }
// }

class _SpaceSellPageState extends State<SpaceSellPage> {
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
  DownloadLocation? changeKeeper;

  void _setWidthSearchFields(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    _searchFieldWidth = width - _rowPadding * 4 - 274 - 222;
  }

  changePageIndex(int newIndex, DownloadLocation keeper) {
    setState(() {
      index = newIndex;
      changeKeeper = keeper;
      myController.text = keeper.name;
      _currentSliderValue = changeKeeper!.countGb.toDouble();
    });
  }

  Widget build(BuildContext context) {
    _setWidthSearchFields(context);

    return BlocProvider(
        create: (context) => SpaceBloc()
          ..add(SpacePageOpened())
          ..add(SendKeeperVersion()),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
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
                                  child: SvgPicture.asset(
                                      "assets/file_page/search.svg"),
                                ),
                              ),
                            ),
                            Container(
                              width: _searchFieldWidth,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: GestureDetector(
                                  onTap: () {
                                    StateContainer.of(context)
                                        .changePage(ChosenPage.file);
                                  },
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: Container(
                                      child: Text(
                                        translate.search,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color:
                                              Theme.of(context).disabledColor,
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
                    child: BlocBuilder<SpaceBloc, SpaceState>(
                        builder: (context, state) {
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
                                          StateContainer.of(context)
                                              .changePage(ChosenPage.settings);
                                        },
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(23.0),
                                            child:
                                                Container(child: value.image),
                                          ),
                                        ),
                                      ),
                                    ),
                                    (MediaQuery.of(context).size.width > 965)
                                        ? Container(
                                            constraints:
                                                BoxConstraints(maxWidth: 110),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: Text(
                                                    value?.firstName ??
                                                        value?.email
                                                            ?.split('@')
                                                            .first ??
                                                        'Name',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      color: Theme.of(context)
                                                          .bottomAppBarColor,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  value?.email ?? '',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Theme.of(context)
                                                        .bottomAppBarColor,
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
          SpaceInheritedWidget(
            index: index,
            state: this,
            child: Expanded(
              child: Container(
                margin: const EdgeInsets.all(30),
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
                child: BlocBuilder<SpaceBloc, SpaceState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      //mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 40, right: 40, top: 20),
                          child: _title(context, state),
                        ),
                        BlocBuilder<SpaceBloc, SpaceState>(
                          builder: (context, state) {
                            var fl = folderList(context);
                            return Expanded(
                                child: IndexedStack(
                              sizing: StackFit.passthrough,
                              key: ValueKey<int>(index),
                              index: index,
                              children: [
                                state.keeper.isEmpty
                                    ? rentingAPlace(context)
                                    : fl,
                                addSpace(context, changeKeeper),
                                fl
                              ],
                            ));
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ]));
  }

  Widget _title(BuildContext context, SpaceState state) {
    if (index == 1) {
      return Row(children: [
        GestureDetector(
          onTap: () {
            setState(() {
              index = 0;
              changeKeeper = null;
              myController.text = '';
              _currentSliderValue = 32;
            });
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
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
          ),
        ),
        Container(
          child: Text(
            changeKeeper?.id == null
                ? translate.add_location
                : translate.change_place,
            style: TextStyle(
              color: Theme.of(context).focusColor,
              fontFamily: kNormalTextFontFamily,
              fontSize: 20,
            ),
          ),
        ),
      ]);
    } else if (state.keeper.isNotEmpty || index == 2) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        mainAxisAlignment: MainAxisAlignment.start,
        textBaseline: TextBaseline.alphabetic,
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
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
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
      );
    } else {
      return Container(
        child: Text(
          translate.sell_space,
          maxLines: 1,
          style: TextStyle(
            color: Theme.of(context).focusColor,
            fontFamily: kNormalTextFontFamily,
            fontSize: 20,
          ),
        ),
      );
    }
  }

  Widget rentingAPlace(BuildContext context) {
    return ListView(controller: ScrollController(), children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          padding: const EdgeInsets.only(left: 40, top: 20),
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
          padding: const EdgeInsets.only(left: 40, top: 15),
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
          padding: const EdgeInsets.only(left: 40, top: 15),
          child: Container(
            child: Text(
              translate.select_folder +
                  "\n" +
                  translate.store_files +
                  "\n" +
                  translate.money,
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
                    color: Color(0xff868FFF), shape: BoxShape.circle),
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
                    color: Color(0xff868FFF), shape: BoxShape.circle),
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
          padding: const EdgeInsets.only(left: 40, top: 15),
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
          padding: const EdgeInsets.only(left: 40, top: 20, right: 40),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 20),
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
          padding: const EdgeInsets.only(left: 40, top: 20, bottom: 30),
          child: Container(
            height: 42,
            width: 200,
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  index = 1;
                });
              },
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.maxFinite, 60),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
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
    ]);
  }

  Widget addSpace(BuildContext context, DownloadLocation? changeKepper) {
    return ListView(controller: ScrollController(), children: [
      BlocBuilder<SpaceBloc, SpaceState>(
        builder: (context, state) {
          if (changeKeeper != null) {
            context
                .read<SpaceBloc>()
                .add(GetPathToKeeper(pathForChange: changeKepper?.dirPath));
          }

          var maxSpace = (state.availableSpace / GB).round();
          //print(maxSpace);
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40, top: 15),
                      child: Container(
                        height: 42,
                        width: 350,
                        decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Color(0xffE4E7ED))),
                        child: BlocBuilder<SpaceBloc, SpaceState>(
                          builder: (context, state) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 15, top: 11),
                              child: Text(
                                changeKeeper == null
                                    ? state.pathToKeeper
                                    : changeKeeper!.dirPath,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Theme.of(context).disabledColor),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    BlocBuilder<SpaceBloc, SpaceState>(
                        builder: (context, state) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 20, top: 15),
                        child: Container(
                          height: 42,
                          width: 101,
                          child: OutlinedButton(
                            onPressed: () async {
                              if (changeKeeper == null) {
                                context
                                    .read<SpaceBloc>()
                                    .add(GetPathToKeeper());
                                print(state.pathToKeeper);
                                setState(
                                  () {
                                    dirPath = state.pathToKeeper;
                                  },
                                );
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(double.maxFinite, 60),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              backgroundColor: changeKeeper == null
                                  ? Theme.of(context).splashColor
                                  : Theme.of(context).canvasColor,
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
                    }),
                  ],
                ),
                _setName(context, state),
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
                        translate.min_storage(
                          changeKeeper == null ? 32 : changeKeeper!.countGb,
                        ),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 14,
                        ),
                      ),
                    )),
                state.pathToKeeper.isNotEmpty || changeKeeper != null
                    ? maxSpace < 32
                        ? Padding(
                            padding: const EdgeInsets.only(left: 40, top: 8),
                            child: Container(
                              child: Text(
                                translate.not_exceed,
                                style: TextStyle(
                                  color: Theme.of(context).indicatorColor,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 40, top: 8),
                            child: Container(
                              child: Text(
                                translate.max_storage + translate.gb(maxSpace),
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          )
                    : Padding(
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
                            inactiveTrackColor: Theme.of(context).cardColor,
                            trackShape: RectangularSliderTrackShape(),
                            disabledInactiveTrackColor: Color(0xffF1F3F6),
                            disabledThumbColor: Color(0xffF1F3F6),
                            trackHeight: 8.0,
                            thumbColor: Theme.of(context).primaryColor,
                            overlayShape:
                                RoundSliderOverlayShape(overlayRadius: 0),
                            //thumbShape:
                            //RoundSliderThumbShape(enabledThumbRadius: 10),
                          ),
                          child: Slider(
                            activeColor: Theme.of(context).splashColor,
                            inactiveColor: Theme.of(context).cardColor,
                            min: changeKeeper == null
                                ? 32
                                : changeKeeper!.countGb.toDouble(),
                            max: maxSpace > 32 ? maxSpace.toDouble() : 180,
                            value: _currentSliderValue,
                            onChanged: maxSpace < 32
                                ? null
                                : (double value) {
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
                            color: state.pathToKeeper.isEmpty && maxSpace < 32
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              translate.gb(_currentSliderValue.toInt()),
                              style: TextStyle(
                                color:
                                    state.pathToKeeper.isEmpty && maxSpace < 32
                                        ? Theme.of(context).canvasColor
                                        : Theme.of(context).disabledColor,
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
                              if (state.pathToKeeper.isEmpty && maxSpace < 32) {
                              } else {
                                var minSpace = maxSpace > 32 ? 32 : 0;
                                setState(() {
                                  if (_currentSliderValue.toInt() > minSpace) {
                                    _currentSliderValue =
                                        _currentSliderValue - 1;
                                  }
                                });
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(double.maxFinite, 60),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      bottomLeft: Radius.circular(10.0))),
                              backgroundColor:
                                  state.pathToKeeper.isEmpty && maxSpace < 32
                                      ? Color(0xffF1F3F6)
                                      : Theme.of(context).cardColor,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.remove,
                                size: 15,
                                color:
                                    state.pathToKeeper.isEmpty && maxSpace < 32
                                        ? Theme.of(context).canvasColor
                                        : Theme.of(context).disabledColor,
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
                              if (state.pathToKeeper.isEmpty && maxSpace < 32) {
                              } else {
                                var max = maxSpace == 0 ? 180 : maxSpace;
                                setState(() {
                                  if (_currentSliderValue.toInt() < max) {
                                    _currentSliderValue =
                                        _currentSliderValue + 1;
                                  }
                                });
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(double.maxFinite, 60),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10.0),
                                      bottomRight: Radius.circular(10.0))),
                              backgroundColor:
                                  state.pathToKeeper.isEmpty && maxSpace < 32
                                      ? Color(0xffF1F3F6)
                                      : Theme.of(context).cardColor,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                size: 15,
                                color:
                                    state.pathToKeeper.isEmpty && maxSpace < 32
                                        ? Theme.of(context).canvasColor
                                        : Theme.of(context).disabledColor,
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
                        )),
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
                    child: BlocBuilder<SpaceBloc, SpaceState>(
                        builder: (context, state) {
                      return OutlinedButton(
                        onPressed: _isFieldsValid(state)
                            ? () async {
                                if (changeKeeper != null) {
                                  context.read<SpaceBloc>().add(ChangeKeeper(
                                      countGb: _currentSliderValue.toInt(),
                                      keeper: changeKeeper!));
                                  setState(() {
                                    index = 2;
                                    changeKeeper = null;
                                    myController.text = '';
                                    _currentSliderValue = 0;
                                  });
                                } else {
                                  context.read<SpaceBloc>().add(SaveDirPath(
                                        pathDir: dirPath,
                                        countGb: _currentSliderValue.toInt(),
                                      ));
                                  await context.read<SpaceBloc>().stream.first;
                                  setState(() {
                                    index = 2;
                                    _currentSliderValue = 32;
                                    myController.text = '';
                                  });
                                }
                              }
                            : null,
                        style: OutlinedButton.styleFrom(
                          minimumSize: Size(double.maxFinite, 60),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: _isFieldsValid(state)
                              ? Theme.of(context).splashColor
                              : Theme.of(context).canvasColor,
                        ),
                        child: Text(
                          changeKeeper == null
                              ? translate.save
                              : translate.change,
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
              ]);
        },
      ),
    ]);
  }

  bool _isFieldsValid(SpaceState state) {
    return state.name.valid &&
        state.name.value.isNotEmpty &&
        (state.pathToKeeper.isNotEmpty || changeKeeper != null);
  }

  _setName(BuildContext context, SpaceState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
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
        state.name.valid || state.name.value.isEmpty
            ? SizedBox(
                height: 15,
              )
            : Padding(
                padding: EdgeInsets.only(left: 40, top: 8, bottom: 5),
                child: Text(
                  translate.name_contain,
                  style: TextStyle(
                    color: Theme.of(context).indicatorColor,
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 14,
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(left: 40),
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

                  onChanged: (value) {
                    context
                        .read<SpaceBloc>()
                        .add(NameChanged(name: value, needValidation: true));
                  },
                  textAlignVertical: TextAlignVertical.bottom,
                  textAlign: TextAlign.start,
                  //autofocus: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 15, bottom: 21),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color: state.name.valid || state.name.value.isEmpty
                              ? Color(0xffE4E7ED)
                              : Theme.of(context).indicatorColor,
                          width: 0.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(
                          color: state.name.valid || state.name.value.isEmpty
                              ? Color(0xffE4E7ED)
                              : Theme.of(context).indicatorColor,
                          width: 0.0),
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
        )
      ],
    );
  }

  Widget folderList(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 40, right: 40, bottom: 30, top: 20.0),
      child: FolderList(),
    );
  }
}

class SpaceInheritedWidget extends InheritedWidget {
  final int index;
  final _SpaceSellPageState state;

  SpaceInheritedWidget({
    Key? key,
    required this.index,
    required this.state,
    required Widget child,
  }) : super(key: key, child: child);

  static SpaceInheritedWidget of(BuildContext context) {
    final SpaceInheritedWidget? result =
        context.dependOnInheritedWidgetOfExactType<SpaceInheritedWidget>();

    return result!;
  }

  @override
  bool updateShouldNotify(SpaceInheritedWidget old) => index != old.index;
}
