import 'dart:ui';

import 'package:cpp_native/models/folder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storageup/components/blur/add_folder.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/models/enums.dart';
import 'package:storageup/pages/files/move_files/move_cubit.dart';
import 'package:storageup/pages/files/move_files/move_state.dart';
import 'package:storageup/utilities/injection.dart';
import 'package:tree_view/tree_view.dart';

class MoveFileView extends StatefulWidget {
  final List<Folder>? folders;
  final UserAction action;

  @override
  _MoveFileState createState() => new _MoveFileState();

  MoveFileView(
    this.folders,
    this.action,
  );
}

class _MoveFileState extends State<MoveFileView> {
  S translate = getIt<S>();

  bool folderExpand = true;
  bool hintColor = true;
  final TextEditingController _searchingFieldController =
      TextEditingController();

  Folder? moveToFolder;
  List<Folder>? listFolder = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MoveCubit()..init(),
      child: BlocBuilder<MoveCubit, MoveState>(
        builder: (context, state) {
          listFolder = state.folders.reversed.toList();
          return Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 5,
                      sigmaY: 5,
                    ),
                    child: Container(
                      color: Colors.black.withAlpha(25),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 700,
                    height: 530,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(50, 30, 0, 20),
                          child: Container(
                            width: 600,
                            height: 480,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.action == UserAction.moveFiles
                                      ? translate.where_move
                                      : translate.where_download,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: kNormalTextFontFamily,
                                    color: Theme.of(context).focusColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0),
                                  child: Container(
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                      border:
                                          Border.all(color: Color(0xffE4E7ED)),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Align(
                                            alignment:
                                                FractionalOffset.centerLeft,
                                            child: Container(
                                                width: 16,
                                                height: 16,
                                                child: SvgPicture.asset(
                                                    "assets/file_page/search.svg")),
                                          ),
                                        ),
                                        Container(
                                          width: 560,
                                          child: TextField(
                                            //autofocus: true,
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: Theme.of(context)
                                                  .disabledColor,
                                            ),
                                            onChanged: (value) {
                                              context
                                                  .read<MoveCubit>()
                                                  .mapSortedFieldChanged(
                                                      _searchingFieldController
                                                          .value.text);
                                            },
                                            controller:
                                                _searchingFieldController,
                                            decoration:
                                                InputDecoration.collapsed(
                                              hintText: translate.search,
                                              hintStyle: TextStyle(
                                                fontSize: 14.0,
                                                color: Theme.of(context)
                                                    .disabledColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 25, bottom: 10),
                                  child: Text(
                                    translate.files,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: kNormalTextFontFamily,
                                      color: Theme.of(context).disabledColor,
                                    ),
                                  ),
                                ),
                                Divider(
                                  color: Theme.of(context).dividerColor,
                                  height: 1,
                                ),
                                _allFolders(context),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, bottom: 10),
                                  child: Divider(
                                    color: Theme.of(context).dividerColor,
                                    height: 1,
                                  ),
                                ),
                                BlocBuilder<MoveCubit, MoveState>(
                                  builder: (context, state) {
                                    return GestureDetector(
                                      onTap: () async {
                                        var name = await showDialog<String?>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return BlurAddFolder();
                                            });
                                        if (name != null) {
                                          await context
                                              .read<MoveCubit>()
                                              .createFolder(name, moveToFolder,
                                                  widget.folders);
                                        }
                                        setState(() {
                                          listFolder =
                                              state.folders.reversed.toList();
                                        });
                                      },
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8),
                                              child: Image.asset(
                                                'assets/file_page/plus.png',
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                              ),
                                            ),
                                            Text(
                                              translate.create,
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                                fontSize: 17,
                                                fontFamily:
                                                    kNormalTextFontFamily,
                                                height: 1.1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  translate.cancel,
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .disabledColor,
                                                    fontSize: 17,
                                                    fontFamily:
                                                        kNormalTextFontFamily,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Theme.of(context)
                                                      .cardColor,
                                                  fixedSize: Size(130, 42),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  if (moveToFolder == null) {
                                                    var rootFolder =
                                                        state.currentFolder;
                                                    Navigator.pop(
                                                        context, rootFolder);
                                                  } else {
                                                    Navigator.pop(
                                                        context, moveToFolder);
                                                  }
                                                },
                                                child: Text(
                                                  widget.action ==
                                                          UserAction.moveFiles
                                                      ? translate.move
                                                      : translate.upload,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontFamily:
                                                        kNormalTextFontFamily,
                                                  ),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  primary: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  fixedSize: Size(155, 42),
                                                  elevation: 0,
                                                  side: BorderSide(
                                                    style: BorderStyle.solid,
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                            width: 50,
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.only(right: 30, top: 30),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: SvgPicture.asset(
                                      'assets/file_page/close.svg')),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _allFolders(
    BuildContext context,
  ) {
    return Container(
      height: 240,
      width: 600,
      child: BlocBuilder<MoveCubit, MoveState>(
        builder: (context, state) {
          return TreeView(
            startExpanded: true,
            children: _getChildList(
              listFolder: listFolder!,
              state: state,
              context: context,
            ),
            // itemCount: listFolder?.length,
            // itemBuilder: (context, index) {
            //   return _folder(context, listFolder?[index]);
            // }
          );
        },
      ),
    );
  }

  List<Widget> _getChildList({
    required List<Folder> listFolder,
    required MoveState state,
    required BuildContext context,
    double leftOffset = 0,
  }) {
    return listFolder.map(
      (folder) {
        return TreeViewChild(
          parent: _folder(
            context,
            folder,
            leftOffset,
          ),
          startExpanded: true,
          onTap: () async {
            await context
                .read<MoveCubit>()
                .getFolderById(folder, widget.folders);
          },
          children: _getChildList(
            listFolder: state.childFolders[folder.id]?.reversed.toList() ?? [],
            state: state,
            context: context,
            leftOffset: leftOffset + 15,
          ),
        );
      },
    ).toList();
  }

  Widget _folder(
    BuildContext context,
    Folder? folder,
    double leftOffset,
  ) {
    return BlocBuilder<MoveCubit, MoveState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () async {
            setState(() {
              moveToFolder = folder;
            });
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              padding: EdgeInsets.only(left: leftOffset),
              height: 40,
              decoration: BoxDecoration(
                color: moveToFolder != folder
                    ? Theme.of(context).primaryColor
                    : Theme.of(context).dividerColor,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 10),
                    child: state.childFolders[folder?.id] == null
                        ? SvgPicture.asset('assets/file_page/arrow_right.svg')
                        : SvgPicture.asset('assets/file_page/arrow_down.svg'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Image.asset(
                      'assets/file_icons/folder.png',
                      width: 24,
                      height: 20,
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxWidth: 120),
                    child: Text(
                      folder?.parentFolder != 'root'
                          ? folder?.name ?? 'name'
                          : translate.all_files,
                      style: TextStyle(
                        fontFamily: kNormalTextFontFamily,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
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
}
