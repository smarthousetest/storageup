import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:storageup/components/blur/custom_error_popup.dart';
import 'package:storageup/components/custom_button_template.dart';
import 'package:storageup/components/user_info.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/models/download_location.dart';
import 'package:storageup/models/user.dart';
import 'package:storageup/pages/sell_space/folder_list/folder_list_bloc.dart';
import 'package:storageup/pages/sell_space/folder_list/folder_list_event.dart';
import 'package:storageup/pages/sell_space/folder_list/folder_list_view.dart';
import 'package:storageup/pages/sell_space/space_bloc.dart';
import 'package:storageup/pages/sell_space/space_event.dart';
import 'package:storageup/pages/sell_space/space_state.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/state_containers/state_container.dart';

class SpaceSellPage extends StatefulWidget {
  static const route = "sell_space_page";

  @override
  _SpaceSellPageState createState() => _SpaceSellPageState();

  SpaceSellPage();
}

class _SpaceSellPageState extends State<SpaceSellPage> {
  double? _searchFieldWidth;

  var index = 0;
  S translate = getIt<S>();
  String dirPath = '';
  double _currentSliderValue = 32;
  double maxSpace = 0;
  int countGbSpace = 0;
  final double _rowPadding = 30.0;
  GlobalKey nameWidthKey = GlobalKey();
  final myController = TextEditingController();
  bool canSave = true;
  int countOfNotSameName = 0;
  String? dropdownValue;
  DownloadLocation? changeKeeper;
  bool needToCheck = true;
  bool firstOpen = true;

  void _setWidthSearchFields(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    _searchFieldWidth = width - _rowPadding * 4 - 274 - 222;
  }

  changePageIndexChangeKeeper(
      int newIndex, DownloadLocation keeper, maxCountOfGb) {
    setState(() {
      index = newIndex;
      changeKeeper = keeper;
      myController.text = keeper.name;
      _currentSliderValue = changeKeeper!.countGb.toDouble();
      maxSpace = maxCountOfGb;
    });
  }

  changePageIndex(int newIndex) {
    setState(() {
      index = newIndex;
    });
  }

  Widget build(BuildContext context) {
    _setWidthSearchFields(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => SpaceBloc()
              ..add(SpacePageOpened())
              ..add(SendKeeperVersion())),
        BlocProvider(
            create: (context) => FolderListBloc()..add(FolderListPageOpened()))
      ],
      child: BlocListener<SpaceBloc, SpaceState>(
        listener: (context, state) async {
          if (StateContainer.of(context).isPopUpShowing == false) {
            if (state.statusHttpRequest == FormzStatus.submissionCanceled) {
              canSave = true;
              StateContainer.of(context).changeIsPopUpShowing(true);
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BlurCustomErrorPopUp(
                    middleText: translate.internal_server_error,
                  );
                },
              );
              StateContainer.of(context).changeIsPopUpShowing(false);
            } else if (state.statusHttpRequest ==
                FormzStatus.submissionFailure) {
              canSave = true;
              StateContainer.of(context).changeIsPopUpShowing(true);
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BlurCustomErrorPopUp(
                      middleText: translate.no_internet);
                },
              );
              StateContainer.of(context).changeIsPopUpShowing(false);
              changePageIndex(3);
            } else if (state.statusHttpRequest ==
                FormzStatus.submissionSuccess) {
              canSave = true;
              if (index == 3) {
                changePageIndex(0);
              }
            } else if (state.statusHttpRequest == FormzStatus.valid) {
              canSave = true;
              if (index == 3) {
                changePageIndex(0);
              }
            }
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
                                  return UserInfo(
                                    user: value,
                                    isExtended:
                                        MediaQuery.of(context).size.width > 965,
                                    padding: EdgeInsets.only(right: 20),
                                    textInfoConstraints: BoxConstraints(
                                        maxWidth: 95, minWidth: 50),
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
                                  Platform.isWindows
                                      ? addSpaceWindows(context, changeKeeper)
                                      : addSpace(context, changeKeeper),
                                  fl,
                                  rentingAPlaceNoInternet(context)
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
            )
          ],
        ),
      ),
    );
  }

  Widget _title(BuildContext context, SpaceState state) {
    if (index == 1) {
      return Row(children: [
        GestureDetector(
          onTap: () {
            setState(() {
              index = 0;
              changeKeeper = null;
              myController.clear();
              _currentSliderValue = 32;
              firstOpen = true;
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
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
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
          Expanded(
            flex: 100,
            child: Container(),
          ),
          GestureDetector(
            onTap: (() {
              context.read<FolderListBloc>().add(GetKeeperInfo());
            }),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                width: 128,
                height: 34,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/file_page/update.svg',
                      color: Theme.of(context).splashColor,
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        translate.update,
                        maxLines: 1,
                        style: TextStyle(
                          color: Theme.of(context).splashColor,
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            height: 30,
            width: 142,
            child: OutlinedButton(
              onPressed: () {
                if (index != 3) {
                  setState(() {
                    index = 1;
                    print(index);
                  });
                }
              },
              style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.maxFinite, 60),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  backgroundColor: index != 3
                      ? Theme.of(context).splashColor
                      : Theme.of(context).canvasColor),
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
    } else if (index == 3) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        mainAxisAlignment: MainAxisAlignment.start,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
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
          Expanded(
            flex: 100,
            child: Container(),
          ),
          GestureDetector(
            onTap: (() async {
              context.read<SpaceBloc>().add(UpdateKeepersList());
            }),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                width: 128,
                height: 34,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/file_page/update.svg',
                      color: Theme.of(context).splashColor,
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        translate.update,
                        maxLines: 1,
                        style: TextStyle(
                          color: Theme.of(context).splashColor,
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            height: 30,
            width: 142,
            child: OutlinedButton(
              onPressed: () {
                if (index != 3) {
                  setState(() {
                    index = 1;
                    print(index);
                  });
                }
              },
              style: OutlinedButton.styleFrom(
                  minimumSize: Size(double.maxFinite, 60),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  backgroundColor: index != 3
                      ? Theme.of(context).splashColor
                      : Theme.of(context).canvasColor),
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
    return ListView(
      controller: ScrollController(),
      children: [
        Column(
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
                      firstOpen = true;
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
          ],
        ),
      ],
    );
  }

  Widget rentingAPlaceNoInternet(BuildContext context) {
    return ListView(controller: ScrollController(), children: [
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Padding(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
            ),
          ),
        ),
        Container(
            child: Image.asset("assets/space_sell/sell_space_no_internet.png")),
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 30),
          child: Container(
            child: Text(
              translate.sell_space_no_internet_part_1,
              style: TextStyle(
                color: Theme.of(context).textTheme.subtitle1?.color,
                fontFamily: kNormalTextFontFamily,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 15),
          child: Container(
            child: Text(
              translate.sell_space_no_internet_part_2,
              style: TextStyle(
                color: Theme.of(context).textTheme.subtitle1?.color,
                fontFamily: kNormalTextFontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ]),
    ]);
  }

  Widget addSpace(BuildContext context, DownloadLocation? changeKepper) {
    return ListView(
      controller: ScrollController(),
      children: [
        BlocBuilder<SpaceBloc, SpaceState>(
          builder: (context, state) {
            if (firstOpen == true) {
              context.read<SpaceBloc>().add(UpdateKeepersList());
              firstOpen = false;
            }
            if (changeKeeper != null && needToCheck == true) {
              needToCheck = false;
              context
                  .read<SpaceBloc>()
                  .add(GetPathToKeeper(pathForChange: changeKepper?.dirPath));
            }
            maxSpace = (state.availableSpace / GB).roundToDouble();
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
                                  borderRadius: BorderRadius.circular(10),
                                ),
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
                      },
                    ),
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
                      ),
                    ),
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
                  ),
                ),
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
                                translate.max_storage +
                                    translate.gb(
                                      maxSpace.toInt(),
                                    ),
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
                          ),
                          child: Slider(
                            activeColor: Theme.of(context).splashColor,
                            inactiveColor: Theme.of(context).cardColor,
                            min: changeKeeper == null
                                ? 32
                                : changeKeeper!.countGb.roundToDouble(),
                            max: changeKeeper == null
                                ? maxSpace > 32
                                    ? maxSpace.roundToDouble()
                                    : 180
                                : maxSpace.roundToDouble(),
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
                    Stack(
                      children: [
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
                                  color: state.pathToKeeper.isEmpty &&
                                          maxSpace < 32
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
                                if (state.pathToKeeper.isEmpty &&
                                    maxSpace < 32) {
                                } else {
                                  var minSpace = maxSpace > 32 ? 32 : 0;
                                  setState(() {
                                    if (changeKeeper == null) {
                                      if (_currentSliderValue.toInt() >
                                          minSpace) {
                                        _currentSliderValue =
                                            _currentSliderValue - 1;
                                      }
                                    } else {
                                      if (_currentSliderValue.toInt() >
                                          changeKeeper!.countGb) {
                                        _currentSliderValue =
                                            _currentSliderValue.toInt() - 1;
                                      }
                                    }
                                  });
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(double.maxFinite, 60),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                ),
                                backgroundColor:
                                    state.pathToKeeper.isEmpty && maxSpace < 32
                                        ? Color(0xffF1F3F6)
                                        : Theme.of(context).cardColor,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.remove,
                                  size: 15,
                                  color: state.pathToKeeper.isEmpty &&
                                          maxSpace < 32
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
                                if (state.pathToKeeper.isEmpty &&
                                    maxSpace < 32) {
                                } else {
                                  var max = maxSpace == 0 ? 180 : maxSpace;
                                  setState(() {
                                    if (_currentSliderValue.toInt() < max) {
                                      _currentSliderValue =
                                          _currentSliderValue.toInt() + 1;
                                    }
                                  });
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(double.maxFinite, 60),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                                backgroundColor:
                                    state.pathToKeeper.isEmpty && maxSpace < 32
                                        ? Color(0xffF1F3F6)
                                        : Theme.of(context).cardColor,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  size: 15,
                                  color: state.pathToKeeper.isEmpty &&
                                          maxSpace < 32
                                      ? Theme.of(context).canvasColor
                                      : Theme.of(context).disabledColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
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
                  ),
                ),
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
                  ),
                ),
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
                                      myController.text = '';
                                      _currentSliderValue = 32;
                                      changeKeeper = null;
                                      needToCheck = true;
                                    });
                                  } else {
                                    context
                                        .read<SpaceBloc>()
                                        .add(UpdateKeepersList());
                                    countOfNotSameName = 0;
                                    for (var keeper in state.keeper) {
                                      if (state.name.value != keeper.name) {
                                        countOfNotSameName =
                                            countOfNotSameName + 1;
                                      }
                                    }
                                    if (countOfNotSameName ==
                                        state.keeper.length) {
                                      canSave = true;
                                    } else {
                                      canSave = false;
                                    }
                                    if (canSave == true) {
                                      context.read<SpaceBloc>().add(
                                            SaveDirPath(
                                              pathDir: dirPath,
                                              countGb:
                                                  _currentSliderValue.toInt(),
                                            ),
                                          );
                                      await context
                                          .read<SpaceBloc>()
                                          .stream
                                          .first;
                                      setState(() {
                                        index = 2;
                                        _currentSliderValue = 32;
                                        myController.text = '';
                                      });
                                      canSave = false;
                                    } else {
                                      canSave = false;
                                      if (StateContainer.of(context)
                                              .isErrorPopUpShowing ==
                                          false) {
                                        await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return BlurCustomErrorPopUp(
                                                middleText: translate
                                                    .keeper_name_are_the_same);
                                          },
                                        );
                                        StateContainer.of(context)
                                            .changeIsPopUpShowing(false);
                                      }
                                      ;
                                    }
                                  }
                                }
                              : null,
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.maxFinite, 60),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: _isFieldsValid(state) && canSave
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
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget addSpaceWindows(BuildContext context, DownloadLocation? changeKepper) {
    return ListView(
      controller: ScrollController(),
      children: [
        BlocBuilder<SpaceBloc, SpaceState>(
          builder: (context, state) {
            if (firstOpen == true) {
              context.read<SpaceBloc>().add(UpdateKeepersList());
              context.read<SpaceBloc>().add(GetAlreadyUsedDisk());
              firstOpen = false;
            }
            if (changeKeeper != null && needToCheck == true) {
              needToCheck = false;
              context
                  .read<SpaceBloc>()
                  .add(GetPathToKeeper(pathForChange: changeKepper?.dirPath));
              context
                  .read<SpaceBloc>()
                  .add(NameChanged(name: changeKeeper!.name));
            }
            var maxSpace = (state.availableSpace / GB).round();
            print(maxSpace);
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
                  child: Row(
                    children: [
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
                    ],
                  ),
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
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color(0xffE4E7ED),
                          ),
                        ),
                        child: new BlocBuilder<SpaceBloc, SpaceState>(
                          builder: (context, state) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                  focusColor: Theme.of(context).primaryColor,
                                  hoverColor: Theme.of(context).dividerColor),
                              child: changeKeeper == null
                                  ? DropdownButton<String>(
                                      dropdownColor:
                                          Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                      hint: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          translate.not_selected,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .disabledColor),
                                        ),
                                      ),
                                      value: dropdownValue,
                                      underline: Container(
                                        height: 0,
                                      ),
                                      isExpanded: true,
                                      icon: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: SvgPicture.asset(
                                            "assets/file_page/array_down.svg"),
                                      ),
                                      elevation: 16,
                                      style: TextStyle(
                                          color:
                                              Theme.of(context).disabledColor),
                                      onChanged: (String? selectedDisk) {
                                        setState(() {
                                          dropdownValue = selectedDisk ?? '';
                                          context.read<SpaceBloc>().add(
                                              GetDiskToKeeper(
                                                  selectedDisk:
                                                      dropdownValue?.trim()));
                                        });
                                      },
                                      items: state.diskList
                                          .map<DropdownMenuItem<String>>(
                                              (String disk) {
                                        return DropdownMenuItem<String>(
                                          value: disk,
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 15),
                                            child: Text(disk),
                                          ),
                                        );
                                      }).toList(),
                                    )
                                  : Container(
                                      height: 42,
                                      width: 350,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: Color(0xffE4E7ED),
                                        ),
                                      ),
                                      child: BlocBuilder<SpaceBloc, SpaceState>(
                                        builder: (context, state) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              left: 15,
                                              top: 11,
                                            ),
                                            child: Text(
                                              changeKeeper!.dirPath,
                                              maxLines: 1,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .disabledColor),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                            );
                          },
                        ),
                      ),
                    ),
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
                      ),
                    ),
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
                  ),
                ),
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
                                translate.max_storage +
                                    translate.gb(
                                      maxSpace.toInt(),
                                    ),
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
                          ),
                          child: Slider(
                            activeColor: Theme.of(context).splashColor,
                            inactiveColor: Theme.of(context).cardColor,
                            min: changeKeeper == null
                                ? 32
                                : changeKeeper!.countGb.roundToDouble(),
                            max: changeKeeper == null
                                ? maxSpace > 32
                                    ? maxSpace.roundToDouble()
                                    : 180
                                : maxSpace.roundToDouble(),
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
                    Stack(
                      children: [
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
                                  color: state.pathToKeeper.isEmpty &&
                                          maxSpace < 32
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
                                if (state.pathToKeeper.isEmpty &&
                                    maxSpace < 32) {
                                } else {
                                  var minSpace = maxSpace > 32 ? 32 : 0;
                                  setState(() {
                                    if (changeKeeper == null) {
                                      if (_currentSliderValue.toInt() >
                                          minSpace) {
                                        _currentSliderValue =
                                            _currentSliderValue - 1;
                                      }
                                    } else {
                                      if (_currentSliderValue.toInt() >
                                          changeKeeper!.countGb) {
                                        _currentSliderValue =
                                            _currentSliderValue.toInt() - 1;
                                      }
                                    }
                                  });
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(double.maxFinite, 60),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  ),
                                ),
                                backgroundColor:
                                    state.pathToKeeper.isEmpty && maxSpace < 32
                                        ? Color(0xffF1F3F6)
                                        : Theme.of(context).cardColor,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.remove,
                                  size: 15,
                                  color: state.pathToKeeper.isEmpty &&
                                          maxSpace < 32
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
                                if (state.pathToKeeper.isEmpty &&
                                    maxSpace < 32) {
                                } else {
                                  var max = maxSpace == 0 ? 180 : maxSpace;
                                  setState(() {
                                    if (_currentSliderValue.toInt() < max) {
                                      _currentSliderValue =
                                          _currentSliderValue.toInt() + 1;
                                    }
                                  });
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(double.maxFinite, 60),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  ),
                                ),
                                backgroundColor:
                                    state.pathToKeeper.isEmpty && maxSpace < 32
                                        ? Color(0xffF1F3F6)
                                        : Theme.of(context).cardColor,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.add,
                                  size: 15,
                                  color: state.pathToKeeper.isEmpty &&
                                          maxSpace < 32
                                      ? Theme.of(context).canvasColor
                                      : Theme.of(context).disabledColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
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
                  ),
                ),
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
                  ),
                ),
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
                                      myController.text = '';
                                      _currentSliderValue = 32;
                                      changeKeeper = null;
                                      needToCheck = true;
                                    });
                                  } else if (maxSpace > 32) {
                                    firstOpen = true;
                                    countOfNotSameName = 0;
                                    for (var keeper in state.keeper) {
                                      if (state.name.value != keeper.name) {
                                        countOfNotSameName =
                                            countOfNotSameName + 1;
                                      }
                                    }
                                    if (countOfNotSameName ==
                                            state.keeper.length &&
                                        dropdownValue != null) {
                                      canSave = true;
                                    } else {
                                      canSave = false;
                                    }
                                    if (canSave == true) {
                                      context.read<SpaceBloc>().add(SaveDirPath(
                                            pathDir: dropdownValue ?? '',
                                            countGb:
                                                _currentSliderValue.toInt(),
                                          ));
                                      await context
                                          .read<SpaceBloc>()
                                          .stream
                                          .first;
                                      setState(() {
                                        index = 2;
                                        canSave = false;
                                        dropdownValue = null;
                                      });
                                      context
                                          .read<FolderListBloc>()
                                          .add(FolderListPageOpened());
                                      var bloc = context.read<FolderListBloc>();
                                      await Future.delayed(
                                          Duration(seconds: 4));
                                      bloc.add(FolderListPageOpened());
                                    } else {
                                      canSave = false;
                                      if (StateContainer.of(context)
                                              .isErrorPopUpShowing ==
                                          false) {
                                        await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return BlurCustomErrorPopUp(
                                                middleText: translate
                                                    .keeper_name_are_the_same,
                                              );
                                            });
                                        StateContainer.of(context)
                                            .changeIsPopUpShowing(false);
                                      }
                                      ;
                                    }
                                  }
                                }
                              : null,
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.maxFinite, 60),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: _isFieldsValid(state) &&
                                    canSave &&
                                    maxSpace > 32
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
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
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
          child: Row(
            children: [
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
            ],
          ),
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
            child: BlocBuilder<SpaceBloc, SpaceState>(
              builder: (context, state) {
                return TextField(
                  controller: myController,
                  onChanged: (value) {
                    context
                        .read<SpaceBloc>()
                        .add(NameChanged(name: value, needValidation: true));
                    canSave = true;
                  },
                  textAlignVertical: TextAlignVertical.bottom,
                  textAlign: TextAlign.start,
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
