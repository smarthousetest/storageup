import 'dart:io';
import 'dart:ui';

import 'package:cpp_native/models/base_object.dart';
import 'package:cpp_native/models/folder.dart';
import 'package:cpp_native/models/record.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:storageup/components/media/media_viewer.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/pages/media/media_open/media_open_bloc.dart';
import 'package:storageup/pages/media/media_open/media_open_event.dart';
import 'package:storageup/pages/media/media_open/media_open_state.dart';
import 'package:storageup/utilities/injection.dart';

class Positions {
  int last;
  int current;

  Positions({this.last = 0, this.current = 0});
}

class MediaOpenPage extends StatefulWidget {
  MediaOpenPage({
    Key? key,
    required this.arguments,
  }) : super(key: key);
  final MediaOpenPageArgs arguments;

  @override
  _MediaOpenPageState createState() => _MediaOpenPageState();
}

class _MediaOpenPageState extends State<MediaOpenPage> {
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MediaOpenBloc>()
        ..add(MediaOpenPageOpened(
            choosedFolder: (widget.arguments.selectedFolder as Folder).copyWith(
                records: (widget.arguments.selectedFolder as Folder)
                        .records
                        ?.reversed
                        .toList() ??
                    []),
            choosedMedia: widget.arguments.selectedMedia)),
      child: Material(
        color: Colors.transparent,
        child: Stack(children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 5,
                sigmaY: 5,
              ),
              child: Container(
                color: Colors.black.withAlpha(85),
              ),
            ),
          ),
          Container(
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),
                      BlocBuilder<MediaOpenBloc, MediaOpenState>(
                        builder: (context, state) {
                          return Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                state.choosedMedia.name ?? '',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
                                  fontFamily: kNormalTextFontFamily,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      BlocBuilder<MediaOpenBloc, MediaOpenState>(
                        builder: (context, state) {
                          BaseObject choosedMedia = state.choosedMedia;

                          if (choosedMedia is! Record) {
                            return Spacer();
                          }

                          return Expanded(
                            child: Row(
                              children: [
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: SvgPicture.asset(
                                          'assets/options/share.svg',
                                          color: Colors.white,
                                          height: 24,
                                          width: 24,
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: SvgPicture.asset(
                                          'assets/options/folder.svg',
                                          color: Colors.white,
                                          height: 24,
                                          width: 24,
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                        onTap: () async {
                                          String? filePath = await FilePicker
                                              .platform
                                              .saveFile(
                                                  fileName:
                                                      state.choosedMedia.name);

                                          if (filePath != null) {
                                            String? choosedMediaPath =
                                                (state.choosedMedia as Record)
                                                    .path;

                                            if (choosedMediaPath != null) {
                                              File(choosedMediaPath)
                                                  .copy(filePath);
                                            }
                                          }
                                        },
                                        child: SvgPicture.asset(
                                          'assets/options/download.svg',
                                          color: Colors.white,
                                          height: 24,
                                          width: 24,
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: SvgPicture.asset(
                                          'assets/file_page/like.svg',
                                          color: choosedMedia.favorite
                                              ? Color(0xFFFF847E)
                                              : Colors.white,
                                          height: 24,
                                          width: 24,
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: SvgPicture.asset(
                                          'assets/options/info.svg',
                                          color: Colors.white,
                                          height: 24,
                                          width: 24,
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: SvgPicture.asset(
                                          'assets/options/trash.svg',
                                          color: Color(0xFFFF847E),
                                          height: 24,
                                          width: 24,
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 50),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: SvgPicture.asset(
                                            'assets/options/close.svg')),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
                MediaViewer(),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class MediaOpenPageArgs {
  List<BaseObject> media;
  BaseObject selectedMedia;
  BaseObject? selectedFolder;

  MediaOpenPageArgs({
    required this.media,
    required this.selectedMedia,
    this.selectedFolder,
  });
}

class NoColorOverscrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
