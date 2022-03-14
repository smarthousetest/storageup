import 'dart:developer';

import 'package:cpp_native/file_typification/file_typification.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/models/record.dart';
import 'package:upstorage_desktop/pages/files/opened_folder/opened_folder_state.dart';
import 'package:upstorage_desktop/pages/files/opened_folder/opened_folder_view.dart';
import 'package:upstorage_desktop/pages/media/media_cubit.dart';
import 'package:upstorage_desktop/pages/media/media_state.dart';
import 'package:upstorage_desktop/utilites/extensions.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/utilites/state_container.dart';

class MediaPage extends StatefulWidget {
  @override
  _MediaPageState createState() => new _MediaPageState();

  MediaPage();
}

List<Widget> dirsList = [];

class _MediaPageState extends State<MediaPage> {
  bool ifGrid = true;
  S translate = getIt<S>();
  var _folderButtonSize = 140;
  var _folderListScrollController = ScrollController(keepScrollOffset: false);

  @override
  Widget build(BuildContext context) {
    // if (dirs_list.isEmpty) _init(context);
    return BlocProvider<MediaCubit>(
      create: (_) => MediaCubit()..init(),
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, top: 30, right: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
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
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color:
                                              Color.fromARGB(25, 23, 69, 139),
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
                      child: BlocBuilder<MediaCubit, MediaState>(
                          builder: (context, state) {
                        return Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 20, left: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(23.0),
                                child: state.user.image,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Text(
                                    state.user?.fullName ?? '',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color:
                                          Theme.of(context).bottomAppBarColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  state.user?.email ?? '',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Theme.of(context).bottomAppBarColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
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
                                  onPressed: () {
                                    _folderListScrollController.animateTo(
                                        _folderListScrollController.offset -
                                            _folderButtonSize,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  },
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
                                    onPressed: () {
                                      _folderListScrollController.animateTo(
                                          _folderListScrollController.offset +
                                              _folderButtonSize,
                                          duration: Duration(milliseconds: 500),
                                          curve: Curves.ease);
                                    },
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
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: BlocBuilder<MediaCubit, MediaState>(
                              builder: (context, state) {
                                return ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  controller: _folderListScrollController,
                                  children: [
                                    ...state.albums
                                        .map(
                                          (album) => _folderIcon(
                                            album,
                                            isChoosed: album.id ==
                                                state.currentFolder.id,
                                            blocContext: context,
                                          ),
                                        )
                                        .toList(),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
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
                              BlocBuilder<MediaCubit, MediaState>(
                                builder: (context, state) {
                                  return Container(
                                    child: Text(
                                      state.currentFolder.name ?? ':(',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Theme.of(context).focusColor,
                                        fontFamily: kNormalTextFontFamily,
                                        fontSize: 20,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Expanded(
                                flex: 821,
                                child: Container(),
                              ),
                              BlocBuilder<MediaCubit, MediaState>(
                                  builder: (context, state) {
                                return IconButton(
                                  padding: EdgeInsets.zero,
                                  iconSize: 30,
                                  onPressed: () {
                                    context
                                        .read<MediaCubit>()
                                        .changeRepresentation(
                                            FilesRepresentation.table);
                                  },
                                  icon: SvgPicture.asset(
                                      'assets/file_page/list.svg',
                                      color: state.representation ==
                                              FilesRepresentation.table
                                          ? Theme.of(context).splashColor
                                          : Theme.of(context)
                                              .toggleButtonsTheme
                                              .color),
                                );
                              }),
                              BlocBuilder<MediaCubit, MediaState>(
                                builder: (context, state) {
                                  return IconButton(
                                    iconSize: 30,
                                    onPressed: () {
                                      context
                                          .read<MediaCubit>()
                                          .changeRepresentation(
                                              FilesRepresentation.grid);
                                    },
                                    icon: SvgPicture.asset(
                                        'assets/file_page/block.svg',
                                        // width: 30,
                                        // height: 30,
                                        //colorBlendMode: BlendMode.softLight,
                                        color: state.representation ==
                                                FilesRepresentation.grid
                                            ? Theme.of(context).splashColor
                                            : Theme.of(context)
                                                .toggleButtonsTheme
                                                .color),
                                  );
                                },
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
                        BlocBuilder<MediaCubit, MediaState>(
                          builder: (context, state) {
                            return Expanded(
                              child: state.representation ==
                                      FilesRepresentation.grid
                                  ? _filesGrid()
                                  : _filesList(context, state),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _folderIcon(
    Folder album, {
    required bool isChoosed,
    required BuildContext blocContext,
  }) {
    Color activeColor;
    String icon = 'album';
    if (album.id == '-1') {
      activeColor = Color(0xFF868FFF);
    } else if (album.name == translate.photos) {
      activeColor = Color(0xFF59D7AB);
      icon = 'photo';
    } else if (album.name == translate.video) {
      activeColor = Color(0xFFFF847E);
      icon = 'video';
    } else {
      activeColor = Color(0xFFFF94E1);
    }
    return Padding(
      padding: const EdgeInsets.only(right: 13),
      child: GestureDetector(
        onTap: () {
          print('folder tapped: ${album.name}');
          blocContext.read<MediaCubit>().changeFolder(album);

          final mediaAlbumId = album.id == '-1' ? null : album.id;
          StateContainer.of(context).changeChoosedMediaFolderId(mediaAlbumId);

          log('${StateContainer.of(context).choosedMediaFolderId}');
        },
        child: Container(
          width: _folderButtonSize.toDouble(),
          height: _folderButtonSize.toDouble(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 2,
              color: isChoosed
                  ? activeColor
                  : Theme.of(context).buttonTheme.colorScheme!.primary,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SvgPicture.asset(
                  'assets/file_page/${icon}_icon.svg',
                  color: activeColor,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, top: 14),
                child: Text(
                  album.name ?? ':(',
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: TextStyle(
                    color: Theme.of(context).disabledColor,
                    fontSize: 16,
                    fontFamily: kNormalTextFontFamily,
                    height: 1.1,
                  ),
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filesGrid() {
    return BlocBuilder<MediaCubit, MediaState>(
      buildWhen: (previous, current) {
        var needToUpdate =
            previous.currentFolderRecords != current.currentFolderRecords;
        return needToUpdate;
      },
      builder: (blocContext, state) {
        return LayoutBuilder(builder: (context, constrains) {
          print('min width ${constrains.smallest.width}');

          return Container(
            // padding: EdgeInsets.symmetric(horizontal: 40),
            child: GridView.builder(
              itemCount: state.currentFolderRecords.length,
              shrinkWrap: true,
              controller: ScrollController(),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: constrains.smallest.width ~/ 100,
                crossAxisSpacing: 30,
                childAspectRatio: (1.1 / 1.50),
                mainAxisSpacing: 35,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    blocContext
                        .read<MediaCubit>()
                        .fileTapped(state.currentFolderRecords[index]);
                  },
                  child: MediaGridElement(
                    record: state.currentFolderRecords[index],
                  ),
                );
              },
            ),
          );
        });
      },
    );
  }

  Widget _filesList(BuildContext context, MediaState state) {
    TextStyle style = TextStyle(
      color: Theme.of(context).textTheme.subtitle1?.color,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      fontFamily: kNormalTextFontFamily,
    );
    TextStyle cellTextStyle = TextStyle(
      color: Theme.of(context).textTheme.subtitle1?.color,
      fontSize: 14,
      fontFamily: kNormalTextFontFamily,
    );

    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        controller: ScrollController(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: DataTable(
              columnSpacing: 25,
              showCheckboxColumn: false,
              columns: [
                DataColumn(
                  label: Container(
                    width: constraints.maxWidth * 0.5,
                    child: Text(
                      translate.name,
                      style: style,
                    ),
                  ),
                ),
                DataColumn(
                  label: Container(
                    width: constraints.maxWidth * 0.06,
                    child: Text(
                      translate.format,
                      style: style,
                    ),
                  ),
                ),
                DataColumn(
                  label: Container(
                    width: constraints.maxWidth * 0.05,
                    child: Text(
                      translate.date,
                      style: style,
                    ),
                  ),
                ),
                DataColumn(
                  label: Container(
                    width: constraints.maxWidth * 0.06,
                    child: Text(
                      translate.size,
                      style: style,
                    ),
                  ),
                ),
                DataColumn(
                  label: Container(
                    width: constraints.maxWidth * 0.001,
                    child: SizedBox(
                      width: constraints.maxWidth * 0.001,
                    ),
                  ),
                ),
              ],
              rows: state.currentFolderRecords.map((e) {
                String? type = '';
                bool isFile = false;

                var record = e;
                isFile = true;
                if (record.thumbnail != null && record.thumbnail!.isNotEmpty) {
                  type =
                      FileAttribute().getFilesType(record.name!.toLowerCase());
                }

                return DataRow.byIndex(
                  index: state.currentFolderRecords.indexOf(e),
                  color: MaterialStateProperty.resolveWith<Color?>((states) {
                    print(states.toList().toString());
                    if (states.contains(MaterialState.focused)) {
                      return Theme.of(context).splashColor;
                    }
                    return null;
                  }),
                  cells: [
                    DataCell(
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            type.isNotEmpty
                                ? 'assets/file_icons/${type}_s.png'
                                : 'assets/file_icons/unexpected_s.png',
                            fit: BoxFit.contain,
                            height: 24,
                            width: 24,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Text(
                              e.name ?? '',
                              style: cellTextStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Spacer(),
                          BlocBuilder<MediaCubit, MediaState>(
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: () {
                                  context.read<MediaCubit>().setFavorite(e);
                                },
                                child: Image.asset(
                                  e.favorite
                                      ? 'assets/file_page/favorite.png'
                                      : 'assets/file_page/not_favorite.png',
                                  height: 18,
                                  width: 18,
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    DataCell(
                      Text(
                        type.isEmpty ? translate.foldr : type.toUpperCase(),
                        style: cellTextStyle,
                      ),
                    ),
                    DataCell(
                      Text(
                        DateFormat('dd.MM.yyyy').format(e.createdAt!),
                        style: cellTextStyle,
                      ),
                    ),
                    DataCell(
                      Text(
                        filesize(e.size, translate, 1),
                        style: cellTextStyle,
                      ),
                    ),
                    DataCell(
                      Theme(
                        data: Theme.of(context).copyWith(
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        ),
                        child: CustomPopupMenu(
                          pressType: PressType.singleClick,
                          barrierColor: Colors.transparent,
                          showArrow: false,
                          horizontalMargin: 110,
                          verticalMargin: 0,
                          menuBuilder: () {
                            return FilesPopupMenuActions(
                              theme: Theme.of(context),
                              translate: translate,
                              onTap: (action) {
                                context.read<MediaCubit>();
                              },
                            );
                          },
                          child: Container(
                            height: 30,
                            width: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/file_page/three_dots.svg',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      );
    });
  }
}

class MediaGridElement extends StatelessWidget {
  final Record record;

  const MediaGridElement({Key? key, required this.record}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var imageUrl = record.thumbnail!.first.publicUrl!;
    Widget image;
    if (imageUrl.isURL()) {
      image = Image.network(
        record.thumbnail!.first.publicUrl!,
      );
    } else {
      image = Image.asset(
        'assets/file_icons/image_default.png',
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: image,
            ),
            ..._uploadProgress(record.loadPercent),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          record.name ?? ':(',
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).disabledColor,
            fontFamily: kNormalTextFontFamily,
            fontSize: 14,
            height: 1.1,
          ),
        ),
      ],
    );
  }

  List<Widget> _uploadProgress(double? progress) {
    List<Widget> indicators = [];
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
