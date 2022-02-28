import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/components/custom_button_template.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/pages/sell_space/folder_list/folder_list.dart';
import 'package:upstorage_desktop/pages/sell_space/space_bloc.dart';
import 'package:upstorage_desktop/pages/sell_space/space_state.dart';
import 'package:upstorage_desktop/pages/sell_space/space_event.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/download_location.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:upstorage_desktop/utilites/extensions.dart';
import 'package:upstorage_desktop/utilites/state_container.dart';
import 'folder_list/keeper_info.dart';

class SpaceSellPage extends StatefulWidget {
// final List<DownloadLocation> locationsInfo;

  @override
  _SpaceSellPageState createState() => _SpaceSellPageState();
  SpaceSellPage();
}

class _SpaceSellPageState extends State<SpaceSellPage> {
  Future<String?> getFilesPaths() async {
    String? result = await FilePicker.platform.getDirectoryPath();

    return result;
  }

  //final List<DownloadLocation> locationsInfo;
  var index = 0;
  double _currentSliderValue = 32;
  S translate = getIt<S>();
  String list = "";
  String dirPath = '';
  int countGbSpace = 0;

  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => SpaceBloc()..add(SpacePageOpened()),
        child: Expanded(
            // Padding(
            //   padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
            //   child:
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
                child: Container(
                  height: 46,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 30),
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
                          ),
                        ),
                      ),
                      Container(
                        child: BlocBuilder<SpaceBloc, SpaceState>(
                            builder: (context, state) {
                          return Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  right: 20,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    StateContainer.of(context)
                                        .changePage(ChoosedPage.settings);
                                  },
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(23.0),
                                      child: Container(child: state.user.image),
                                    ),
                                  ),
                                ),
                              ),
                              (MediaQuery.of(context).size.width > 965)
                                  ? Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            state.user?.firstName ?? '',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Theme.of(context)
                                                  .bottomAppBarColor,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          state.user?.email ?? '',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .bottomAppBarColor,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: BlocBuilder<SpaceBloc, SpaceState>(
                    builder: (context, state) {
                  var locInfo = state.locationsInfo;
                  var notEmptyInfo;
                  if (locInfo != null) {
                    notEmptyInfo = locInfo;
                  }
                  return IndexedStack(
                    index: index,
                    children: [
                      notEmptyInfo.isEmpty
                          ? Column(
                              children: [rentingAPlace(context)],
                            )
                          : folderList(context),
                      Column(
                        children: [addSpace(context)],
                      ),
                      Column(
                        children: [folderList(context)],
                      )
                    ],
                  );
                }),
              )
            ])));
  }

  Widget rentingAPlace(BuildContext context) {
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
                  offset: Offset(1, 4))
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
                        print(index);
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
          ]),
        ),
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
                  offset: Offset(1, 4))
            ],
          ),
          child: ListView(controller: ScrollController(), children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(left: 40, top: 20),
                child: Row(children: [
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
                ]),
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
                          border: Border.all(color: Color(0xffE4E7ED))),
                      child: BlocBuilder<SpaceBloc, SpaceState>(
                          builder: (context, state) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 15, top: 11),
                          child: Text(
                            list,
                            maxLines: 1,
                            style: TextStyle(
                                color: Theme.of(context).disabledColor),
                          ),
                        );
                      }),
                    ),
                  ),
                  BlocBuilder<SpaceBloc, SpaceState>(builder: (context, state) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      child: Container(
                        height: 42,
                        width: 200,
                        child: OutlinedButton(
                          onPressed: () async {
                            String? path = await getFilesPaths();
                            print(path);
                            setState(() {
                              if (path != null) {
                                dirPath = path;

                                list = path;
                              }
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.maxFinite, 60),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
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
                  }),
                ],
              ),
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
                  )),
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
                  )),
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
                          overlayShape:
                              RoundSliderOverlayShape(overlayRadius: 0),
                          //thumbShape:
                          //RoundSliderThumbShape(enabledThumbRadius: 10),
                        ),
                        child: Slider(
                          min: 32,
                          max: 180,
                          value: _currentSliderValue,
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value;
                            });
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
                            _currentSliderValue.toInt().toString() + " ГБ",
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0))),
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
                            setState(() {
                              if (_currentSliderValue < 180) {
                                _currentSliderValue = _currentSliderValue + 1;
                              }
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: Size(double.maxFinite, 60),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0))),
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
                    DownloadLocation locationsInfo;
                    return OutlinedButton(
                      onPressed: () {
                        if (list.isEmpty) {
                          print('path null');
                        } else {
                          setState(() {
                            countGbSpace = _currentSliderValue.toInt();
                            context.read<SpaceBloc>().add(SaveDirPath(
                                pathDir: dirPath, countGb: countGbSpace));
                            index = 2;

                            //context.read<SpaceBloc>().add(RunSoft());
                          });
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.maxFinite, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: list.isEmpty
                            ? Theme.of(context).canvasColor
                            : Theme.of(context).splashColor,
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

  Widget folderList(BuildContext context) {
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              children: [
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
                Expanded(
                  flex: 100,
                  child: Container(),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 40, top: 20),
                  child: Container(
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
                ),
              ],
            ),
            Expanded(child:
                BlocBuilder<SpaceBloc, SpaceState>(builder: (context, state) {
              return Column(
                children: [
                  FolderList(
                    state.locationsInfo,
                  )
                ],
              );
            }))
          ]),
        ),
      ),
    );
  }
}
