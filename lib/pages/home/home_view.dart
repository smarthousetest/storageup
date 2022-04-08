import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:formz/formz.dart';
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
import 'package:upstorage_desktop/utilites/event_bus.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/state_container.dart';
import 'package:upstorage_desktop/utilites/state_info_container.dart';
import 'package:upstorage_desktop/utilites/state_sorted_container.dart';

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
                    translate.good,
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
    finincePage = FinancePage();
    settingsPage = SettingsPage();
    mediaPage = StateInfoContainer(child: MediaPage());
    super.initState();
  }

  late Widget infoPage;
  late Widget filePage;
  late Widget likePage;
  late Widget spaceSellPage;
  late Widget finincePage;
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
        return finincePage;
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
      Padding(
        padding: const EdgeInsets.only(top: 25, right: 75),
        child: Column(
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 40),
                  child: SvgPicture.asset('assets/file_page/word.svg'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14, top: 20),
                  child: Text(
                    "Доклад",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 17,
                        fontFamily: kNormalTextFontFamily),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 40),
                  child: SvgPicture.asset('assets/file_page/word.svg'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14, top: 20),
                  child: Text(
                    "Документ",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 17,
                        fontFamily: kNormalTextFontFamily),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 40),
                  child: SvgPicture.asset('assets/file_page/pdf.svg'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14, top: 20),
                  child: Text(
                    "Иллюстрация",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 17,
                        fontFamily: kNormalTextFontFamily),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (!isEventBusInited) {
            isEventBusInited = true;
            eventBusForUpload.on().listen((event) {
              var result = showDialog(
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
                  var result = showDialog(
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
              var str = await showDialog(
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
        onTap: () async {},
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
