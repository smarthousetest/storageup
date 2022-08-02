import 'package:cpp_native/models/folder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storageup/components/custom_button_template.dart';
import 'package:storageup/components/custom_progress_bar.dart';
import 'package:storageup/components/custom_round_graph.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/pages/info/info_bloc.dart';
import 'package:storageup/pages/info/info_event.dart';
import 'package:storageup/pages/info/info_state.dart';
import 'package:storageup/utilities/event_bus.dart';
import 'package:storageup/utilities/extensions.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/state_containers/state_container.dart';

import '../../constants.dart';
import '../../models/user.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => new _InfoPageState();

  InfoPage();
}

class _InfoPageState extends State<InfoPage> {
  ChosenPage choosedPage = ChosenPage.home;
  bool youRenting = false;
  bool lease = false;
  double? _searchFieldWidth;
  final double _rowSpasing = 20.0;
  final double _rowPadding = 30.0;

  void changePage(ChosenPage newPage) {
    setState(() {
      choosedPage = newPage;
    });
  }

  S translate = getIt<S>();

  bool _canShowClose = true;

  void hideWidget() {
    setState(() {
      _canShowClose = !_canShowClose;
    });
  }

  void _setWidthSearchFields(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    _searchFieldWidth =
        width - _rowSpasing * 3 - 30 * 2 - _rowPadding * 2 - 274 - 320;
  }

  @override
  Widget build(BuildContext context) {
    _setWidthSearchFields(context);
    return BlocProvider(
      create: (context) => InfoBloc()..add(InfoPageOpened()),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _mainFields(context),
          (MediaQuery.of(context).size.width > 1380)
              ? _rightInfoWidget(context)
              : Container(),
        ],
      ),
    );
  }

  Padding _rightInfoWidget(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 30, top: 30, bottom: 30),
        child: Container(
          width: 320,
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
          child: Padding(
            padding: const EdgeInsets.all(29.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _userRow(context),
                Padding(
                  padding: const EdgeInsets.all(30),
                  child: Divider(
                    height: 1,
                    color: Theme.of(context).dividerColor,
                  ),
                ),
                Text(
                  'Используемое пространство',
                  style: TextStyle(
                    color: Theme.of(context).disabledColor,
                    fontSize: 14,
                    fontFamily: kNormalTextFontFamily,
                  ),
                ),
                _filledGbCount(context),
                _progressBar(context),
                _progressDescription(context),
                _canShowClose ? _changeSubscriptionWidget(context) : Container()
              ],
            ),
          ),
        ));
  }

  _userRow(BuildContext context) {
    return BlocBuilder<InfoBloc, InfoState>(builder: (context, state) {
      return state.valueNotifier != null
          ? ValueListenableBuilder<User?>(
              valueListenable: state.valueNotifier!,
              builder: (context, value, _) {
                return Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Container(
                        height: 46,
                        // width: 46,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(23),
                          child: GestureDetector(
                              onTap: () {
                                StateContainer.of(context)
                                    .changePage(ChosenPage.settings);
                              },
                              child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: value.image)),
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              value?.firstName ??
                                  value?.email?.split('@').first ??
                                  'Name',
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              })
          : Container();
    });
  }

  Widget _filledGbCount(BuildContext context) {
    return BlocBuilder<InfoBloc, InfoState>(
      builder: (context, state) {
        // var filesFolderSize = state.rootFolders?.folders
        //         ?.firstWhere((folder) => folder.name == 'Files')
        //         .size ??
        //     0;
        // var mediaFolderSize = state.rootFolders?.folders
        //         ?.firstWhere((folder) => folder.name == 'Media')
        //         .size ??
        //     0;
        //var allSpaceGb = state.packetInfo?.filledSpace ?? 0;
        //var allFolderSize = state.rootFolders?.size ?? 0;

        var currenSub = state.sub?.tariff?.spaceGb ?? 0;
        return state.filesRootNotifier != null
            ? ValueListenableBuilder<Folder?>(
                valueListenable: state.filesRootNotifier!,
                builder: (context, value, _) {
                  var filesSize = value?.size ?? 0;
                  return state.mediaRootNotifier != null
                      ? ValueListenableBuilder<Folder?>(
                          valueListenable: state.mediaRootNotifier!,
                          builder: (context, value, _) {
                            var mediaSize = value?.size ?? 0;
                            var allSize = filesSize + mediaSize;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '${fileSize(allSize, translate, 0)}',
                                  style: TextStyle(
                                    color: Theme.of(context).bottomAppBarColor,
                                    fontSize: 28,
                                    fontFamily: kNormalTextFontFamily,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 11, right: 11, top: 10),
                                  child: Text(
                                    'из',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Theme.of(context).shadowColor,
                                      fontSize: 24,
                                      fontFamily: kNormalTextFontFamily,
                                    ),
                                  ),
                                ),
                                Text(
                                  translate.gb(currenSub),
                                  style: TextStyle(
                                    color: Theme.of(context).shadowColor,
                                    fontSize: 28,
                                    fontFamily: kNormalTextFontFamily,
                                  ),
                                ),
                              ],
                            );
                          })
                      : Container();
                })
            : Container();
      },
    );
  }

  Widget _progressDescription(BuildContext context) {
    return BlocBuilder<InfoBloc, InfoState>(
      builder: (context, state) {
        var filesFolder = state.folder?.records?.length ?? 0;

        // var sizeFolder = state.folder?.size ?? 0;

        // var mediaFolder = state.rootFolders?.folders
        //     ?.firstWhere((folder) => folder.name == 'Media')
        //     .records
        //     ?.length;

        // var countMediaFolderPhoto = state.allMediaFolders
        //         ?.firstWhere((element) => element.name == "Фото")
        //         .records
        //         ?.length ??
        //     0;

        // var countMediaFolderVideo = state.allMediaFolders
        //         ?.firstWhere((element) => element.name == "Видео")
        //         .records
        //         ?.length ??
        //     0;
        return state.filesRootNotifier != null
            ? ValueListenableBuilder<Folder?>(
                valueListenable: state.filesRootNotifier!,
                builder: (context, value, _) {
                  var countFilesFolderRecords = value?.records?.length;

                  return state.mediaRootNotifier != null
                      ? ValueListenableBuilder<Folder?>(
                          valueListenable: state.mediaRootNotifier!,
                          builder: (context, value, _) {
                            var countMediaFolderRecords = value?.folders
                                ?.firstWhere(
                                    (element) => element.name == "Фото")
                                .records
                                ?.length;
                            return Expanded(
                              child: ListView(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        StateContainer.of(context)
                                            .changePage(ChosenPage.file);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                        padding: EdgeInsets.zero,
                                        shadowColor:
                                            Color.fromARGB(5, 0, 0, 0), //
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: SvgPicture.asset(
                                                'assets/home_page/file.svg',
                                                // height: 46,
                                                // width: 46,
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                child: Text(
                                                  translate.files,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .disabledColor,
                                                    fontFamily:
                                                        kNormalTextFontFamily,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                //"${(filesFolder?.records?.length ?? 0)} файлов",
                                                "${(countFilesFolderRecords)} файлов",
                                                //"${(filesFolder)}",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .shadowColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        StateContainer.of(context)
                                            .changePage(ChosenPage.media);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Theme.of(context).primaryColor,
                                        padding: EdgeInsets.zero,
                                        shadowColor: Color.fromARGB(5, 0, 0, 0),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Container(
                                              height: 46,
                                              width: 46,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: SvgPicture.asset(
                                                  'assets/home_page/foto_r.svg'),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                child: Text(
                                                  translate.photos,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .disabledColor,
                                                    fontFamily:
                                                        kNormalTextFontFamily,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "${(countMediaFolderRecords)} файлов",
                                                // 's',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .shadowColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        StateContainer.of(context)
                                            .changePage(ChosenPage.media);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Theme.of(context).primaryColor,
                                        padding: EdgeInsets.zero,
                                        shadowColor: Color.fromARGB(5, 0, 0, 0),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10),
                                            child: Container(
                                              height: 46,
                                              width: 46,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: SvgPicture.asset(
                                                  'assets/home_page/video_r.svg'),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 5),
                                                child: Text(
                                                  translate.video,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Theme.of(context)
                                                        .disabledColor,
                                                    fontFamily:
                                                        kNormalTextFontFamily,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "${(countMediaFolderRecords)} файлов",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .shadowColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
                      : Container();
                })
            : Container();
      },
    );
  }

  Padding _progressBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: BlocBuilder<InfoBloc, InfoState>(builder: (context, state) {
        return state.filesRootNotifier != null
            ? ValueListenableBuilder<Folder?>(
                valueListenable: state.filesRootNotifier!,
                builder: (context, value, _) {
                  var currentSubSpace = state.sub?.tariff?.spaceGb ?? 0;
                  var filesSpaceGb = value?.size ?? 0;
                  var e;

                  e = (filesSpaceGb * (0.000000001));

                  double percentFiles =
                      ((e / currentSubSpace) * 100).toDouble();
                  if (percentFiles.isNaN) {
                    percentFiles = 0;
                  }
                  return state.mediaRootNotifier != null
                      ? ValueListenableBuilder<Folder?>(
                          valueListenable: state.mediaRootNotifier!,
                          builder: (context, value, _) {
                            var mediaSpaceGb = value?.size ?? 0;
                            var x = (mediaSpaceGb * (0.000000001));
                            double percentMedia =
                                ((x / currentSubSpace) * 100).toDouble() +
                                    percentFiles;
                            if (percentFiles.isNaN) {
                              percentFiles = 0;
                            }
                            return SizedBox(
                              height: 10,
                              child: Stack(
                                children: [
                                  // MyProgressBar(
                                  //   percent: 75,
                                  //   color: Color(0xffFFD75E),
                                  //   bgColor: Theme.of(context).cardColor,
                                  // ),
                                  // MyProgressBar(
                                  //   percent: 50,
                                  //   color: Color(0xffFF847E),
                                  //   bgColor: Theme.of(context).cardColor,

                                  //   ///
                                  // ),
                                  MyProgressBar(
                                    percent: percentMedia,
                                    color: Color(0xff59D7AB),
                                    bgColor: Color.fromARGB(0, 0, 0, 0),
                                  ),
                                  MyProgressBar(
                                    percent: percentFiles.ceilToDouble(),
                                    color: Color(0xff868FFF),
                                    bgColor: Theme.of(context).cardColor,

                                    ///
                                  ),
                                ],
                              ),
                            );
                          })
                      : Container();
                },
              )
            : Container();
      }),
    );
  }

  Widget _changeSubscriptionWidget(BuildContext context) {
    return Align(
      alignment: FractionalOffset.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(right: 0, left: 0),
        child: SizedBox(
          height: 199,
          width: 280,
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Color.fromARGB(25, 23, 69, 139),
                    blurRadius: 4,
                    offset: Offset(1, 4))
              ],
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: hideWidget,
                  child: Align(
                    alignment: FractionalOffset.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10, right: 10),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: SvgPicture.asset("assets/file_page/close.svg"),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 7),
                  child: Text(
                    translate.not_space,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    translate.more_space,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 14, fontFamily: kNormalTextFontFamily),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 23),
                  child: Container(
                    height: 42,
                    width: 230,
                    child: OutlinedButton(
                      onPressed: () {
                        StateContainer.of(context)
                            .changePage(ChosenPage.finance);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.maxFinite, 60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        backgroundColor: Theme.of(context).splashColor,
                      ),
                      child: Text(
                        translate.go_to,
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
          ),
        ),
      ),
    );
  }

  Widget _mainFields(BuildContext context) {
    return Expanded(
      child: Container(
        // width: MediaQuery.of(context).size.,
        padding: EdgeInsets.only(left: 30, top: 30, right: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 46,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 0),
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
                                        "assets/file_page/search.svg")),
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
                  (MediaQuery.of(context).size.width < 1380)
                      ? Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 30, left: 20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(23.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      StateContainer.of(context)
                                          .changePage(ChosenPage.settings);
                                    },
                                    child: BlocBuilder<InfoBloc, InfoState>(
                                        builder: (context, state) {
                                      return state.valueNotifier != null
                                          ? ValueListenableBuilder<User?>(
                                              valueListenable:
                                                  state.valueNotifier!,
                                              builder: (context, value, _) {
                                                return MouseRegion(
                                                  cursor:
                                                      SystemMouseCursors.click,
                                                  child: value.image,
                                                );
                                              })
                                          : Container();
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container()
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ListView(
                    controller: ScrollController(),
                    children: [
                      youRenting
                          ? SizedBox(
                              height: 465,
                              // width: 726,
                              child: Container(
                                constraints: BoxConstraints(minHeight: 466),
                                /*MediaQuery.of(context).size.height -
                                    HEIGHT_TOP_FIND_BLOCK -
                                    PADDING_SIZE -
                                    PADDING_SIZE -
                                    HEIGHT_BOTTOM_BLOCK,*/
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
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 19, 40, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 24,
                                        child: Text(
                                          "Вы сдаёте",
                                          style: TextStyle(
                                            color: Theme.of(context).focusColor,
                                            fontSize: 20,
                                            fontFamily: kNormalTextFontFamily,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Divider(
                                          height: 1,
                                          color: Theme.of(context).dividerColor,
                                        ),
                                      ),
                                      SizedBox(height: 23),
                                      Expanded(
                                        flex: 376,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    MyProgressIndicator(
                                                      percent: 70.0,
                                                      color: Color(0xff868FFF),
                                                      radius: 120,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 24),
                                                      child: Container(
                                                        height: 17,
                                                        child: Text(
                                                          'Места на вашем устройстве арендовано',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor,
                                                            fontFamily:
                                                                kNormalTextFontFamily,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 20),
                                                      child: Container(
                                                        width: 200,
                                                        child: Divider(
                                                          height: 1,
                                                          color:
                                                              Theme.of(context)
                                                                  .dividerColor,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 20),
                                                      child: Container(
                                                        height: 49,
                                                        child: Text(
                                                          "50 ₽",
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .splashColor,
                                                            fontSize: 36,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: Container(
                                                        height: 17,
                                                        child: Text(
                                                          "Ежедневный доход",
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .focusColor,
                                                            fontSize: 14,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          0, 30, 0, 32),
                                                      child: ElevatedButton(
                                                        onPressed: () {},
                                                        child: Text(
                                                          'Увеличить',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                kNormalTextFontFamily,
                                                            fontSize: 14,
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor,
                                                          ),
                                                        ),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fixedSize:
                                                              Size(200, 42),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    MyProgressIndicator(
                                                      percent: 35.0,
                                                      color: Color(0xff59D7AB),
                                                      // цвет индикатора
                                                      radius: 120,
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 24),
                                                      child: Container(
                                                        height: 17,
                                                        child: Text(
                                                            'Арендованого места заполнено',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .disabledColor,
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  kNormalTextFontFamily,
                                                            )),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 20),
                                                      child: Container(
                                                        width: 200,
                                                        child: Divider(
                                                          height: 1,
                                                          color:
                                                              Theme.of(context)
                                                                  .dividerColor,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 20),
                                                      child: Container(
                                                        height: 49,
                                                        child: Text(
                                                          "3000 ₽",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .splashColor,
                                                            fontSize: 36,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5),
                                                      child: Container(
                                                        height: 17,
                                                        child: Text(
                                                          "Ваш баланс",
                                                          style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .focusColor,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          0, 30, 0, 32),
                                                      child: ElevatedButton(
                                                        onPressed: () {},
                                                        child: Text(
                                                          'Оплатить',
                                                          style: TextStyle(
                                                            fontFamily:
                                                                kNormalTextFontFamily,
                                                            fontSize: 14,
                                                            color: Theme.of(
                                                                    context)
                                                                .disabledColor,
                                                          ),
                                                        ),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          primary:
                                                              Theme.of(context)
                                                                  .primaryColor,
                                                          fixedSize:
                                                              Size(200, 42),
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : youRent(context),
                      lease
                          ? SizedBox(
                              height: 372,
                              // width: 726,
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
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(40, 20, 40, 0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Вы арендуете',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(context).focusColor,
                                          fontFamily: kNormalTextFontFamily,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 20),
                                        child: Divider(
                                          height: 1,
                                          color: Theme.of(context).dividerColor,
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Пространство заполнено на: ',
                                            style: TextStyle(
                                              fontFamily: 'Lato',
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .disabledColor,
                                            ),
                                          ),
                                          Text(
                                            '45%',
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 25, 0, 10),
                                        child: MyProgressBar(
                                          bgColor: Theme.of(context).cardColor,
                                          color: Color(0xff868FFF),
                                          percent: 42,
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '0%',
                                            style: TextStyle(
                                              fontFamily: kNormalTextFontFamily,
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                            ),
                                          ),
                                          Expanded(
                                              flex: 291,
                                              child: Container(
                                                height: 14,
                                              )),
                                          Text(
                                            '50%',
                                            style: TextStyle(
                                              fontFamily: kNormalTextFontFamily,
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                            ),
                                          ),
                                          Expanded(
                                              flex: 277,
                                              child: Container(
                                                height: 14,
                                              )),
                                          Text(
                                            '100%',
                                            style: TextStyle(
                                              fontFamily: kNormalTextFontFamily,
                                              fontSize: 12,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 30),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    '300ГБ',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          kNormalTextFontFamily,
                                                      fontSize: 36,
                                                      color: Theme.of(context)
                                                          .splashColor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 11,
                                                  ),
                                                  Text(
                                                    'Используемое место',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          kNormalTextFontFamily,
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                          .focusColor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                      'Увеличить',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            kNormalTextFontFamily,
                                                        fontSize: 14,
                                                        color: Theme.of(context)
                                                            .disabledColor,
                                                      ),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Theme.of(context)
                                                          .primaryColor,
                                                      fixedSize: Size(200, 46),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    '17.17.21',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          kNormalTextFontFamily,
                                                      fontSize: 36,
                                                      color: Theme.of(context)
                                                          .splashColor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 11,
                                                  ),
                                                  Text(
                                                    'Следущий платёж',
                                                    style: TextStyle(
                                                      fontFamily:
                                                          kNormalTextFontFamily,
                                                      fontSize: 14,
                                                      color: Theme.of(context)
                                                          .focusColor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {},
                                                    child: Text(
                                                      'Оплатить',
                                                      style: TextStyle(
                                                        fontFamily:
                                                            kNormalTextFontFamily,
                                                        fontSize: 14,
                                                        color: Theme.of(context)
                                                            .disabledColor,
                                                      ),
                                                    ),
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      primary: Theme.of(context)
                                                          .primaryColor,
                                                      fixedSize: Size(200, 46),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : youLease(context)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget youRent(BuildContext context) {
    return Container(
      height: 419,
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 19),
          child: Container(
            height: 24,
            child: Text(
              translate.you_turn_in,
              style: TextStyle(
                color: Theme.of(context).focusColor,
                fontSize: 20,
                fontFamily: kNormalTextFontFamily,
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 40, top: 20, right: 40),
          child: Divider(
            height: 1,
            color: Theme.of(context).dividerColor,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40, top: 30),
          child: Container(
            height: 42,
            width: 200,
            child: OutlinedButton(
              onPressed: () {
                StateContainer.of(context).changePage(ChosenPage.sell_space);
              },
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.maxFinite, 60),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                backgroundColor: Theme.of(context).splashColor,
              ),
              child: Text(
                translate.rent,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: kNormalTextFontFamily,
                  fontSize: 17,
                ),
              ),
            ),
          ),
        ),
        Stack(children: [
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Container(
              height: 226,
              width: 726,
              child: Image.asset(
                'assets/file_page/background.png',
              ),
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 75, right: 0),
              child: Container(
                width: 389,
                height: 198,
                child: Image.asset(
                  'assets/file_page/blocks.png',
                ),
              ),
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0, left: 59),
                child: Container(
                  child: SvgPicture.asset(
                    'assets/file_page/badges.svg',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 64, left: 27),
                child: Container(
                  height: 207,
                  width: 194,
                  child: Image.asset(
                    'assets/file_page/manInfo.png',
                  ),
                ),
              ),
            ],
          ),
        ]),
      ]),
    );
  }

  Widget youLease(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 30),
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
        child: SizedBox(
          height: 422,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(top: 19, left: 40),
              child: Text(
                translate.you_rent,
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).focusColor,
                  fontFamily: kNormalTextFontFamily,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 40, top: 20, right: 40),
              child: Divider(
                height: 1,
                color: Theme.of(context).dividerColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, top: 30),
              child: Container(
                height: 42,
                width: 200,
                child: OutlinedButton(
                  onPressed: () async {
                    eventBusForUpload.fire(InfoPage);
                  },
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.maxFinite, 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Theme.of(context).splashColor,
                  ),
                  child: Text(
                    translate.upload,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontFamily: kNormalTextFontFamily,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
            Stack(children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 100),
                  child: Container(
                    child: SvgPicture.asset(
                      'assets/file_page/badgesLease.svg',
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  height: 226,
                  width: 726,
                  child: Image.asset(
                    'assets/file_page/background.png',
                  ),
                ),
              ),
              Align(
                alignment: FractionalOffset.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 100),
                  child: Container(
                    height: 273,
                    width: 300,
                    child: Image.asset(
                      'assets/file_page/manLease.png',
                    ),
                  ),
                ),
              ),
            ])
          ]),
        ),
      ),
    );
  }
}
