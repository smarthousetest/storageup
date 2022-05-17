import 'dart:io';
import 'package:desktop_window/desktop_window.dart';
import 'package:file_typification/file_typification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formz/formz.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:upstorage_desktop/components/blur/add_folder.dart';
import 'package:upstorage_desktop/components/blur/create_album.dart';
import 'package:upstorage_desktop/components/blur/exit.dart';
import 'package:upstorage_desktop/components/blur/menu_upload.dart';
import 'package:upstorage_desktop/components/custom_button_template.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/pages/finance/finance_view.dart';
import 'package:upstorage_desktop/pages/home/home_event.dart';
import 'package:upstorage_desktop/pages/like/like_view.dart';
import 'package:upstorage_desktop/pages/files/file_view.dart';
import 'package:upstorage_desktop/pages/info/info_view.dart';
import 'package:upstorage_desktop/pages/media/media_view.dart';
import 'package:upstorage_desktop/pages/sell_space/space_view.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/pages/settings/settings_view.dart';
import 'package:upstorage_desktop/utilites/autoupload/models/latest_file.dart';
import 'package:upstorage_desktop/utilites/event_bus.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/state_container.dart';
import 'package:upstorage_desktop/utilites/state_info_container.dart';
import 'package:upstorage_desktop/utilites/state_sorted_container.dart';
import 'package:web_socket_channel/io.dart';
import 'home_bloc.dart';
import 'home_state.dart';

enum Blur {
  rename,
  delete,
  create_album,
  menu_upload,
  three_directory,
  none,
}

class HomePage extends StatefulWidget {
  static const route = "home_page";

  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ChoosedPage choosedPage = ChoosedPage.home;
  Blur blurItem = Blur.rename;

  S translate = getIt<S>();

  void changePage(ChoosedPage newPage) {
    StateContainer.of(context).changePage(newPage);
  }

  bool isEventBusInited = false;

  bool setSize = false;

  void setSizeWindow() {
    var height = 540.0;
    var width = 960.0;

    DesktopWindow.setMinWindowSize(Size(width, height));

    DesktopWindow.resetMaxWindowSize();
  }

  void _showErrorDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text(
              translate.something_goes_wrong,
              textAlign: TextAlign.center,
              softWrap: true,
              style: TextStyle(
                fontSize: 20,
                fontFamily: kNormalTextFontFamily,
                color: Theme.of(context).focusColor,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    left: 200, right: 200, top: 30, bottom: 10),
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  child: Text(
                    translate.ok,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16,
                      fontFamily: kNormalTextFontFamily,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: // _form.currentState.validate()
                        Theme.of(context).splashColor,

                    // Theme.of(context).primaryColor,
                    fixedSize: Size(100, 42),
                    elevation: 0,
                    side: BorderSide(
                        style: BorderStyle.solid,
                        color: Theme.of(context).splashColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    infoPage = InfoPage();
    filePage =
        StateInfoContainer(child: StateSortedContainer(child: FilePage()));
    likePage = LikePage();
    spaceSellPage = SpaceSellPage();
    financePage = FinancePage();
    settingsPage = SettingsPage();
    mediaPage = StateInfoContainer(child: MediaPage());
    super.initState();
  }

  late Widget infoPage;
  late Widget filePage;
  late Widget likePage;
  late Widget spaceSellPage;
  late Widget financePage;
  late Widget settingsPage;
  late Widget mediaPage;

  Widget getPage() {
    switch (StateContainer.of(context).choosedPage) {
      case ChoosedPage.home:
        return infoPage;
      case ChoosedPage.file:
        return filePage;
      case ChoosedPage.like:
        return likePage;
      case ChoosedPage.sell_space:
        return spaceSellPage;
      case ChoosedPage.finance:
        return financePage;
      case ChoosedPage.settings:
        return settingsPage;
      case ChoosedPage.media:
        return mediaPage;
      default:
        return infoPage;
    }
  }

  // Widget getBlurItem() {
  //   switch (blurItem) {
  //     case Blur.none:
  //       return Container();
  //     case Blur.rename:
  //       return BlurRename(
  //           //blur_item: blur_item,
  //           );
  //     // case Blur.delete:
  //     //   return BlurDelete(
  //     //     blurItem: blurItem,
  //     //   );
  //     // case Blur.create_album:
  //     //   return BlurCreateAlbum(blur_item: blur_item,);
  //     // case Blur.menu_upload:
  //     //   return BlurMenuUpload(blur_item: blur_item,);
  //     // case Blur.three_directory:
  //     //   return BlurCreateThreeDirectory(blur_item: blur_item,);
  //     default:
  //       return Container();
  //   }
  // }

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
          listener: (context, state) {
            // TODO: implement listener
            if (state.status == FormzStatus.submissionFailure) {
              _showErrorDialog();
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
                        offset: Offset(1, 4))
                  ],
                ),
                child:
                    BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 30, 47, 15),
                        child: SvgPicture.asset(
                          'assets/home_page/storage_title.svg',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30, 15, 30, 25),
                        child: SvgPicture.asset(
                          'assets/home_page/separator.svg',
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          controller: ScrollController(),
                          children: leftButtonsItem(),
                        ),
                      ),
                      _logout(),
                      state.upToDateVersion != state.version
                          ? _update()
                          : Container(),
                    ],
                  );
                }),
              ),
              getPage(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> leftButtonsItem() {
    return [
      CustomMenuButton(
        icon: "assets/home_page/home.svg",
        title: translate.home,
        page: ChoosedPage.home,
        onTap: () {
          changePage(ChoosedPage.home);
        },
      ),
      CustomMenuButton(
        icon: "assets/home_page/files.svg",
        title: translate.files,
        page: ChoosedPage.file,
        onTap: () {
          changePage(ChoosedPage.file);
        },
      ),
      CustomMenuButton(
        icon: "assets/home_page/media.svg",
        title: translate.media,
        page: ChoosedPage.media,
        onTap: () {
          changePage(ChoosedPage.media);
        },
      ),
      // CustomMenuButton(
      //   icon: "assets/home_page/like.svg",
      //   title: "Избранное",
      //   page: ChoosedPage.like,
      //   onTap: () {
      //     changePage(ChoosedPage.like);
      //   },
      // ),
      CustomMenuButton(
        icon: "assets/home_page/sell_space.svg",
        title: translate.sell_space,
        page: ChoosedPage.sell_space,
        onTap: () {
          changePage(ChoosedPage.sell_space);
        },
      ),
      CustomMenuButton(
        icon: "assets/home_page/finance.svg",
        title: translate.finance,
        page: ChoosedPage.finance,
        onTap: () {
          changePage(ChoosedPage.finance);
        },
      ),
      CustomMenuButton(
        icon: "assets/home_page/gear.svg",
        title: translate.settings,
        page: ChoosedPage.settings,
        onTap: () {
          changePage(ChoosedPage.settings);
        },
      ),
      // CustomMenuButton(
      //   icon: "assets/home_page/trash.svg",
      //   title: "Корзина",
      //   page: ChoosedPage.trash,
      //   onTap: () {},
      // ),
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
      BlocBuilder<HomeBloc, HomeState>(
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
            padding: const EdgeInsets.only(top: 30, left: 30, right: 30),
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

                  // if (result is AddMenuResult) {
                  //   _processUserAction(context, result);
                  // }
                  /*FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any, allowMultiple: true);
                    List<String?> list = result!.paths;*/

                  // var systemTempDir = Directory.current;
                  // await for (var entity in systemTempDir.list(recursive: true, followLinks: false,)) {
                  //   print(entity.path);
                  // }
                },
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
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
                  children: [
                    Text(
                      translate.add,
                      style: TextStyle(
                        color: Theme.of(context).splashColor,
                        fontSize: 17,
                        fontFamily: kNormalTextFontFamily,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Image.asset('assets/file_page/plus.png'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
                child: ValueListenableBuilder<Box<LatestFile>>(
                    valueListenable:
                        Hive.box<LatestFile>('latestFileBox').listenable(),
                    builder: (context, box, widget) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...box.values
                              .toList()
                              .reversed
                              .map((e) => MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                      onTap: () {
                                        print(e.latestFile.name);
                                        context.read<HomeBloc>().add(
                                            FileTapped(record: e.latestFile));
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
          width: 93,
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
            bottomLeft: Radius.circular(10.0)),
        color: Theme.of(context).dividerColor,
      ),
      height: 50,
      width: 274,
      child: GestureDetector(
        onTap: () async {
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
          final folderId = StateContainer.of(context).choosedFilesFolderId;

          var page = StateContainer.of(context).choosedPage;

          context.read<HomeBloc>().add(HomeUserActionChoosed(
                action: userAction.action,
                values: [name],
                folderId: folderId,
                choosedPage: page,
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

          final folderId = StateContainer.of(context).choosedMediaFolderId;
          var page = StateContainer.of(context).choosedPage;

          context.read<HomeBloc>().add(HomeUserActionChoosed(
                action: userAction.action,
                values: [name],
                folderId: folderId,
                choosedPage: page,
              ));
        }
        break;

      case UserAction.uploadFiles:
        final folderId = StateContainer.of(context).choosedFilesFolderId;
        context.read<HomeBloc>().add(
              HomeUserActionChoosed(
                action: userAction.action,
                values: userAction.result,
                folderId: folderId,
              ),
            );
        break;
      case UserAction.uploadMedia:
        final folderId = StateContainer.of(context).choosedMediaFolderId;
        context.read<HomeBloc>().add(
              HomeUserActionChoosed(
                action: userAction.action,
                values: userAction.result,
                folderId: folderId,
              ),
            );
        break;
      default:
        context.read<HomeBloc>().add(
              HomeUserActionChoosed(
                action: userAction.action,
                values: userAction.result,
              ),
            );
    }
  }
}

class LatestFileView extends StatelessWidget {
  const LatestFileView({Key? key, required this.object}) : super(key: key);
  final LatestFile object;
  @override
  Widget build(BuildContext context) {
    String? type = '';
    var record = object.latestFile;
    var isFile = true;
    type = FileAttribute().getFilesType(record.name!.toLowerCase());
    return LayoutBuilder(
      builder: (context, constrains) => Padding(
        padding: const EdgeInsets.only(top: 23.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                ..._uploadProgress(isFile ? record.loadPercent : null),
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
                      overflow: TextOverflow.ellipsis),
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
