import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/components/blur/add_folder.dart';
import 'package:upstorage_desktop/components/dir_button_template.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/pages/files/opened_folder/opened_folder_view.dart';
import 'files_list/files_list.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'file_bloc.dart';
import 'file_state.dart';
import 'file_event.dart';
import 'package:upstorage_desktop/utilites/extensions.dart';

class FilePage extends StatefulWidget {
  @override
  _FilePageState createState() => new _FilePageState();
  var index = 0;
  FilePage();
}

class _FilePageState extends State<FilePage> {
  bool ifGrid = true;
  S translate = getIt<S>();

  List<Widget> _opendedFolders = [];

  @override
  void initState() {
    _opendedFolders.add(
      Column(
        children: [_recentFiles()],
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (dirs_list.isEmpty) _init(context);
    return BlocProvider(
      create: (context) => getIt<FilesBloc>()..add(FilesPageOpened()),
      child: Expanded(
        child: Container(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 30, top: 30, right: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 46,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                                          color:
                                              Color.fromARGB(25, 23, 69, 139),
                                          blurRadius: 4,
                                          offset: Offset(1, 4))
                                    ],
                                  ),
                                  child: Padding(
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
                                ),
                              ),
                            ),
                            Container(
                              width: 46,
                              child: Row(
                                children: [
                                  Expanded(
                                    //child: Padding(
                                    //padding: const EdgeInsets.only(right: 30),
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color:
                                                Theme.of(context).primaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: Color.fromARGB(
                                                      25, 23, 69, 139),
                                                  blurRadius: 4,
                                                  offset: Offset(1, 4))
                                            ]),
                                        child: Center(
                                          child: SvgPicture.asset(
                                              "assets/file_page/settings.svg"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: BlocBuilder<FilesBloc, FilesState>(
                                builder: (context, state) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10, left: 20),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(23.0),
                                          child: state.user.image,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            state.user?.fullName ?? '',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Theme.of(context)
                                                  .bottomAppBarColor,
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
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: IndexedStack(
                          index: widget.index,
                          children: [
                            // _recentFiles(context),
                            // openFolder(context)
                            ..._opendedFolders
                            // Column(
                            //   children: [openFolder(context)],
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //PropertiesView(),
            ],
          ),
        ),
      ),
    );
  }

  void _push(Widget child) {
    setState(() {
      _opendedFolders.add(child);
      widget.index++;
    });
  }

  void _pop() {
    setState(() {
      if (_opendedFolders.length != 1) {
        _opendedFolders.removeLast();
        widget.index--;
      }
    });
  }

  Widget _recentFiles() {
    return Expanded(child: BlocBuilder<FilesBloc, FilesState>(
      builder: (context, state) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30, bottom: 30),
              child: Container(
                height: 224,
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
                  padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 30,
                        child: Row(
                          children: [
                            Text(
                              translate.folder_dir,
                              style: TextStyle(
                                color: Theme.of(context).focusColor,
                                fontSize: 20,
                                fontFamily: kNormalTextFontFamily,
                              ),
                            ),
                            Expanded(
                              flex: 861,
                              child: SizedBox(),
                            ),
                            Container(
                              width: 30,
                              height: 30,
                              child: RawMaterialButton(
                                onPressed: () {},
                                fillColor: Theme.of(context).primaryColor,
                                child: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: Theme.of(context).splashColor,
                                  size: 20.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15),
                              child: Container(
                                width: 30,
                                height: 30,
                                child: RawMaterialButton(
                                  onPressed: () {},
                                  fillColor: Theme.of(context).primaryColor,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: Theme.of(context).splashColor,
                                    size: 20.0,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _foldersSection(context)
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30, right: 0),
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
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 20, 30, 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              child: Text(
                                translate.recent,
                                style: TextStyle(
                                  color: Theme.of(context).focusColor,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 821,
                              child: Container(),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 30,
                              onPressed: () {
                                setState(() {
                                  ifGrid = false;
                                });
                                print('ifGrid is $ifGrid');
                              },
                              icon: SvgPicture.asset(
                                  'assets/file_page/list.svg',
                                  // icon: Image.asset('assets/file_page/list.png',
                                  // fit: BoxFit.contain,
                                  // width: 30,
                                  // height: 30,
                                  color: ifGrid
                                      ? Theme.of(context)
                                          .toggleButtonsTheme
                                          .color
                                      : Theme.of(context).splashColor),
                            ),
                            IconButton(
                              iconSize: 30,
                              onPressed: () {
                                setState(() {
                                  ifGrid = true;
                                });
                                print('ifGrid is ');
                              },
                              icon: SvgPicture.asset(
                                  'assets/file_page/block.svg',
                                  // width: 30,
                                  // height: 30,
                                  //colorBlendMode: BlendMode.softLight,
                                  color: ifGrid
                                      ? Theme.of(context).splashColor
                                      : Theme.of(context)
                                          .toggleButtonsTheme
                                          .color),
                            ),
                          ],
                        ),
                      ),
                      ifGrid
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Divider(
                                height: 1,
                                color: Theme.of(context).dividerColor,
                              ),
                            )
                          : Container(),
                      Expanded(
                        child: ifGrid ? _filesGrid(context) : FilesList(),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    ));
  }

  Widget _foldersSection(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Expanded(
      child: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 31),
                  child: Container(
                    width: 130,
                    height: 130,
                    child: BlocBuilder<FilesBloc, FilesState>(
                      builder: (context, state) {
                        return Listener(
                          child: OutlinedButton(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  child: SvgPicture.asset(
                                    'assets/home_page/add_folder.svg',
                                    height: 46,
                                    width: 46,
                                  ),
                                ),
                                Text(
                                  translate.create_a_folder,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: kNormalTextFontFamily,
                                    color: Theme.of(context).disabledColor,
                                  ),
                                ),
                              ],
                            ),
                            onPressed: () async {
                              var str = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return BlurAddFolder();
                                },
                              );
                              print(str);
                              if (str is String)
                                context.read<FilesBloc>().add(FileAddFolder(
                                    name: str,
                                    parentFolderId: state.currentFolder?.id));
                            },
                            style: OutlinedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  width: 2,
                                  color: Theme.of(context).dividerColor,
                                ),
                              ),
                              elevation: 0,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                _expandedSection(theme),
              ])),
    );
  }

  Widget _expandedSection(ThemeData theme) {
    return Container(
      child: BlocBuilder<FilesBloc, FilesState>(
        builder: (context, state) {
          if (state.currentFolder != null) {
            var folders =
                state.allFiles.where((item) => item is Folder).toList();
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: folders.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return CustomDirButton(
                    name: translate.all_files,
                    readonly: true,
                    description: translate.count_of_files(
                        state.currentFolder?.records?.length ?? 0),
                    onTap: () {
                      _push(OpenedFolderView(
                          currentFolder: state.currentFolder!,
                          previousFolders: [],
                          pop: _pop,
                          push: _push));
                    },
                  );
                } else {
                  var folder = folders[index - 1] as Folder;
                  return CustomDirButton(
                    name: folder.name!,
                    readonly: false,
                    description:
                        translate.count_of_files(folder.records?.length ?? 0),
                    onTap: () {
                      setState(() {
                        widget.index = 1;
                        print(index - 1);
                      });
                    },
                  );
                }
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _filesGrid(BuildContext context) {
    // var path = '';
    // var dir = Directory(path);
    // var isExist = dir.existsSync();

    return LayoutBuilder(builder: (context, constrains) {
      var crossAxisCount = constrains.minWidth ~/ 160;
      return GridView.count(
        crossAxisCount: crossAxisCount,
        padding: EdgeInsets.fromLTRB(40, 20, 40, 20),
        crossAxisSpacing: 56,
        children: List.generate(17, (index) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: constrains.minWidth / crossAxisCount,
                height: constrains.minWidth / crossAxisCount * 1.3,
                color: Theme.of(context).primaryColor,
                child: Column(
                  children: [
                    ClipRRect(
                      child: Image.asset('assets/test_img/1.jpg'),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Text(
                        '1.jpg',
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
                          fontSize: 14,
                          fontFamily: kNormalTextFontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    });
  }

  Widget openFolder(BuildContext context) {
    return Expanded(
      child: BlocBuilder<FilesBloc, FilesState>(builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 30, top: 30),
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
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 20, 30, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.index = 0;
                            });
                          },
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Text(
                              translate.files + " / ",
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                                fontFamily: kNormalTextFontFamily,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        state.currentFolder?.name ?? "",
                        style: TextStyle(
                          color: Theme.of(context).focusColor,
                          fontFamily: kNormalTextFontFamily,
                          fontSize: 20,
                        ),
                      ),
                      Expanded(
                        flex: 821,
                        child: Container(),
                      ),
                      IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 30,
                        onPressed: () {
                          setState(() {
                            ifGrid = false;
                          });
                          print('ifGrid is $ifGrid');
                        },
                        icon: SvgPicture.asset('assets/file_page/list.svg',
                            color: ifGrid
                                ? Theme.of(context).toggleButtonsTheme.color
                                : Theme.of(context).splashColor),
                      ),
                      IconButton(
                        iconSize: 30,
                        onPressed: () {
                          setState(() {
                            ifGrid = true;
                          });
                          print('ifGrid is $ifGrid');
                        },
                        icon: SvgPicture.asset('assets/file_page/block.svg',
                            color: ifGrid
                                ? Theme.of(context).splashColor
                                : Theme.of(context).toggleButtonsTheme.color),
                      ),
                    ],
                  ),
                ),
                ifGrid
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Divider(
                          height: 1,
                          color: Theme.of(context).dividerColor,
                        ),
                      )
                    : Container(),
                Expanded(
                  child: ifGrid ? _filesGrid(context) : FilesList(),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
