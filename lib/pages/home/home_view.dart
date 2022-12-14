import 'dart:io';

import 'package:cpp_native/models/record.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:file_typification/file_typification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formz/formz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:os_specification/os_specification.dart';
import 'package:storageup/components/blur/add_folder.dart';
import 'package:storageup/components/blur/create_album.dart';
import 'package:storageup/components/blur/custom_error_popup.dart';
import 'package:storageup/components/blur/exit.dart';
import 'package:storageup/components/blur/menu_upload.dart';
import 'package:storageup/components/custom_button_template.dart';
import 'package:storageup/components/home/download_info_widget.dart';
import 'package:storageup/components/home/upload_info_widget.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/pages/files/file_view.dart';
import 'package:storageup/pages/files/move_files/move_files_view.dart';
import 'package:storageup/pages/finance/finance_view.dart';
import 'package:storageup/pages/home/home_event.dart';
import 'package:storageup/pages/info/info_view.dart';
import 'package:storageup/pages/media/media_view.dart';
import 'package:storageup/pages/sell_space/space_view.dart';
import 'package:storageup/pages/settings/settings_view.dart';
import 'package:storageup/utilities/event_bus.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:storageup/utilities/state_containers/state_container.dart';
import 'package:storageup/utilities/state_containers/state_sorted_container.dart';
import 'package:web_socket_channel/io.dart';
import 'package:window_size/window_size.dart';

import 'home_bloc.dart';
import 'home_state.dart';

class HomePage extends StatefulWidget {
  static const route = "home_page";

  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  S translate = getIt<S>();

  void changePage(ChosenPage newPage) {
    StateContainer.of(context).changePage(newPage);
  }

  bool isEventBusInited = false;

  bool setSize = false;

  void setSizeWindow() {
    var height = 540.0;
    var width = 960.0;

    DesktopWindow.setMinWindowSize(Size(width, height));

    DesktopWindow.resetMaxWindowSize();

    if (Platform.isLinux) {
      setWindowMinSize(Size(width, height));
      setWindowMaxSize(Size(double.infinity, double.infinity));
    }
  }

  Widget getPage() {
    return IndexedStack(
      index: getIndexPage(),
      children: [
        InfoPage(),
        StateSortedContainer(child: FilePage()),
        SpaceSellPage(),
        FinancePage(),
        SettingsPage(),
        MediaPage(),
      ],
    );
  }

  int getIndexPage() {
    switch (StateContainer.of(context).choosedPage) {
      case ChosenPage.home:
        return 0;
      case ChosenPage.file:
        return 1;
      case ChosenPage.sell_space:
        return 2;
      case ChosenPage.finance:
        return 3;
      case ChosenPage.settings:
        return 4;
      case ChosenPage.media:
        return 5;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (setSize == false) {
      setSizeWindow();
      setSize = true;
    }

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: BlocProvider(
        create: (context) => HomeBloc()..add(HomePageOpened()),
        child: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) async {
            if (StateContainer.of(context).isPopUpShowing == false) {
              if (state.status == FormzStatus.submissionFailure) {
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
              } else if (state.status == FormzStatus.submissionCanceled) {
                StateContainer.of(context).changeIsPopUpShowing(true);
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return BlurCustomErrorPopUp(
                        middleText: translate.no_internet);
                  },
                );
                StateContainer.of(context).changeIsPopUpShowing(false);
              } else if (state.status == FormzStatus.invalid) {
                StateContainer.of(context).changeIsPopUpShowing(true);
                await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return BlurCustomErrorPopUp(
                        middleText: translate.wrong_path);
                  },
                );
                StateContainer.of(context).changeIsPopUpShowing(false);
              }
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 274,
                margin: const EdgeInsets.only(left: 30, top: 30, bottom: 30),
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
                child:
                    BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 47, 30),
                        child: SvgPicture.asset(
                          'assets/home_page/storage_title.svg',
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          controller: ScrollController(),
                          children: [
                            _downloadButton(context),
                            ..._customMenuItem(),
                            ..._leftButtonsItem()
                          ],
                        ),
                      ),
                      _logout(),
                      (state.upToDateVersion != state.version)
                          ? (state.upToDateVersion != null)
                              ? _update()
                              : Container()
                          : Container(),
                    ],
                  );
                }),
              ),
              Expanded(
                child: Stack(
                  children: [
                    getPage(),
                    BlocBuilder<HomeBloc, HomeState>(
                      builder: (context, state) {
                        return _buildProgressBars(state);
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBars(HomeState state) {
    if (!state.uploadInfo.isUploading && !state.downloadInfo.isDownloading) {
      return SizedBox.shrink();
    }

    return Positioned(
      right: 30,
      bottom: 20,
      child: Column(
        children: [
          DownloadInfoWidget(
            downloadInfo: state.downloadInfo,
            translate: translate,
          ),
          if (state.downloadInfo.isDownloading && state.uploadInfo.isUploading)
            SizedBox(
              height: 20,
            ),
          UploadInfoWidget(
            uploadInfo: state.uploadInfo,
            translate: translate,
          ),
        ],
      ),
    );
  }

  List<CustomMenuButton> _customMenuItem() {
    return [
      CustomMenuButton(
        icon: "assets/home_page/home.svg",
        title: translate.home,
        page: ChosenPage.home,
        onTap: () {
          changePage(ChosenPage.home);
          getIndexPage();
        },
      ),
      CustomMenuButton(
        icon: "assets/home_page/files.svg",
        title: translate.files,
        page: ChosenPage.file,
        onTap: () {
          changePage(ChosenPage.file);
          getIndexPage();
        },
      ),
      CustomMenuButton(
        icon: "assets/home_page/media.svg",
        title: translate.media,
        page: ChosenPage.media,
        onTap: () {
          changePage(ChosenPage.media);
          getIndexPage();
        },
      ),
      // CustomMenuButton(
      //   icon: "assets/home_page/like.svg",
      //   title: "??????????????????",
      //   page: ChoosedPage.like,
      //   onTap: () {
      //     changePage(ChoosedPage.like);
      //   },
      // ),
      CustomMenuButton(
        icon: "assets/home_page/sell_space.svg",
        title: translate.sell_space,
        page: ChosenPage.sell_space,
        onTap: () {
          changePage(ChosenPage.sell_space);
          getIndexPage();
        },
      ),
      CustomMenuButton(
        icon: "assets/home_page/finance.svg",
        title: translate.finance,
        page: ChosenPage.finance,
        onTap: () {
          changePage(ChosenPage.finance);
          getIndexPage();
        },
      ),
      CustomMenuButton(
        icon: "assets/home_page/gear.svg",
        title: translate.settings,
        page: ChosenPage.settings,
        onTap: () {
          changePage(ChosenPage.settings);
          getIndexPage();
        },
      ),
    ];
  }

  Widget _downloadButton(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (!isEventBusInited) {
          isEventBusInited = true;
          eventBusForUpload.on().listen((event) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return BlurMenuUpload();
              },
            ).then((result) {
              if (result is AddMenuResult) {
                _processUserAction(context, result);
              }
            });
          });
        }

        return Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, bottom: 30),
          child: Container(
            height: 42,
            width: 214,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return BlurMenuUpload();
                  },
                ).then((result) {
                  if (result is AddMenuResult) {
                    _processUserAction(context, result);
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).splashColor,
                side: BorderSide(
                  style: BorderStyle.solid,
                  color: Theme.of(context).splashColor,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Image.asset(
                      'assets/file_page/plus.png',
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    translate.upload,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 17,
                      fontFamily: kNormalTextFontFamily,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _leftButtonsItem() {
    return [
      Padding(
        padding: const EdgeInsets.only(left: 30, top: 30, right: 30),
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
      BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        return state.objectsValueListenable != null &&
                state.objectsValueListenable!.value.values.isNotEmpty
            ? latestFile(context)
            : Container();
      }),
    ];
  }

  Widget latestFile(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text(
                translate.latest_file,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  fontFamily: kNormalTextFontFamily,
                ),
              ),
            ),
            Container(
              width: 250,
              child: Padding(
                padding: const EdgeInsets.only(left: 40.0),
                child: ValueListenableBuilder<Box<Record>>(
                    valueListenable:
                        Hive.box<Record>('latestFileBox').listenable(),
                    builder: (context, box, widget) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...box.values.toList().take(3).map((e) => MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                  onTap: () {
                                    print(e.name);
                                    context
                                        .read<HomeBloc>()
                                        .add(FileTapped(record: e));
                                  },
                                  child: LatestFileView(object: e)))),
                        ],
                      );
                    }),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _logout() {
    return Align(
      alignment: FractionalOffset.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(top: 30, left: 40, bottom: 30),
        child: Container(
          height: 24,
          child: GestureDetector(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BlurExit();
                },
              );
            },
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: RichText(
                text: TextSpan(
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontSize: 17,
                      fontFamily: kNormalTextFontFamily,
                    ),
                    children: [
                      WidgetSpan(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Image.asset('assets/home_page/exit.png'),
                        ),
                      ),
                      TextSpan(
                        text: translate.exit,
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _update() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
        color: Theme.of(context).dividerColor,
      ),
      height: 50,
      width: 274,
      child: GestureDetector(
        onTap: () async {
          var os = OsSpecifications.getOs();
          if (os.isProcessRunning("ups_update.exe") != 1) {
            os.startProcess(Processes.updater, true);
            await Future.delayed(Duration(microseconds: 300));
          }
          for (int i = 0; i < 100; i++) {
            try {
              var channel = IOWebSocketChannel.connect('ws://localhost:4000');
              channel.sink.add('update');
              await channel.sink.close();
              await Future.delayed(Duration(milliseconds: 300));
              exit(0);
            } catch (e) {
              print(e);
            }
          }
        },
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Align(
            alignment: Alignment.center,
            child: RichText(
              text: TextSpan(
                  style: TextStyle(
                    color: Theme.of(context).splashColor,
                    fontSize: 17,
                    fontFamily: kNormalTextFontFamily,
                  ),
                  children: [
                    WidgetSpan(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 9),
                        child: SvgPicture.asset('assets/home_page/update.svg'),
                      ),
                    ),
                    TextSpan(
                      text: translate.install_update,
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  void _processUserAction(
    BuildContext context,
    AddMenuResult userAction,
  ) async {
    switch (userAction.action) {
      case UserAction.createFolder:
        var name = await showDialog<String?>(
            context: context,
            builder: (BuildContext context) {
              return BlurAddFolder();
            });
        if (name != null && name.isNotEmpty) {
          // userAction = AddMenuResult(
          //   action: userAction.action,
          //   result: [name],
          // );
          final folderId = StateContainer.of(context).chosenFilesFolderId;

          context.read<HomeBloc>().add(HomeUserActionChosen(
                action: userAction.action,
                values: [name],
                folderId: folderId,
              ));
        }
        break;
      case UserAction.createAlbum:
        var name = await showDialog<String?>(
            context: context,
            builder: (BuildContext context) {
              return BlurCreateAlbum();
            });
        if (name != null && name.isNotEmpty) {
          // userAction = AddMenuResult(
          //   action: userAction.action,
          //   result: [name],
          // );

          context.read<HomeBloc>().add(HomeUserActionChosen(
                action: userAction.action,
                values: [name],
                folderId: null,
              ));
        }
        break;

      case UserAction.uploadFiles:
        var result = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return MoveFileView(null, UserAction.uploadFiles);
          },
        );

        if (result != null) {
          final folder = result;
          changePage(ChosenPage.file);
          context.read<HomeBloc>().add(
                HomeUserActionChosen(
                  action: userAction.action,
                  values: userAction.result,
                  folderId: folder.id,
                ),
              );
        }
        break;
      case UserAction.uploadMedia:
        final folderId = StateContainer.of(context).choosedMediaFolderId;
        changePage(ChosenPage.media);
        context.read<HomeBloc>().add(
              HomeUserActionChosen(
                action: userAction.action,
                values: userAction.result,
                folderId: folderId,
              ),
            );
        break;
      default:
        context.read<HomeBloc>().add(
              HomeUserActionChosen(
                action: userAction.action,
                values: userAction.result,
              ),
            );
    }
  }
}

class LatestFileView extends StatelessWidget {
  const LatestFileView({Key? key, required this.object}) : super(key: key);
  final Record object;

  @override
  Widget build(BuildContext context) {
    String? type = '';
    var record = object;
    // var isFile = true;
    type = FileAttribute().getFilesType(record.name!.toLowerCase());
    return LayoutBuilder(
      builder: (context, constrains) => Padding(
        padding: const EdgeInsets.only(top: 23.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 24,
                  width: 24,
                  child: Image.asset(
                    type!.isNotEmpty
                        ? 'assets/file_icons/${type}_s.png'
                        : 'assets/file_icons/unexpected_s.png',
                    fit: BoxFit.contain,
                    height: 24,
                    width: 24,
                  ),
                ),
                ..._uploadProgress(record.loadPercent),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Container(
                constraints: BoxConstraints(maxWidth: 160.0),
                child: Text(
                  record.name ?? '',
                  maxLines: 1,
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: kNormalTextFontFamily,
                    fontSize: 17,
                    color: Theme.of(context).colorScheme.onBackground,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _uploadProgress(double? progress) {
    List<Widget> indicators = [Container()];
    if (progress != null) {
      print('creating indicators with progress: $progress');
      indicators = [
        Visibility(
          child: CircularProgressIndicator(
            value: progress / 100,
          ),
        ),
        CupertinoActivityIndicator(),
      ];
    }

    return indicators;
  }
}
