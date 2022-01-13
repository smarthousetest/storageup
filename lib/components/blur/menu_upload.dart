import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/models/enums.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

class BlurMenuUpload extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();

  BlurMenuUpload();
}

class _ButtonTemplateState extends State<BlurMenuUpload> {
  S translate = getIt<S>();
  Future<List<String?>?> getFilesPaths() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    if (result != null) {
      List<String?> filePaths = result.paths;
      return filePaths;
    } else {
      return null;
    }
  }

  Future<String?> getDirPath() async {
    String? result = await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      return result;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                width: 475,
                height: 379,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 445,
                      height: 379,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 30),
                          child: Center(
                            child: Text(
                              translate.upload_to_files,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: kNormalTextFontFamily,
                                color: Theme.of(context).focusColor,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, top: 27),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  List<String?>? list = await getFilesPaths();
                                  print(list);
                                  Navigator.pop(
                                      context,
                                      AddMenuResult(
                                        action: UserAction.uploadFiles,
                                        result: list,
                                      ));
                                },
                                child: Column(
                                  children: [
                                    MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: SvgPicture.asset(
                                        'assets/file_page/upload_file.svg',
                                        height: 64,
                                        width: 64,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      translate.upload_files,
                                      style: TextStyle(
                                        fontFamily: kNormalTextFontFamily,
                                        fontSize: 14,
                                        color: Theme.of(context).disabledColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 28.0),
                                child: GestureDetector(
                                  child: Column(
                                    children: [
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: SvgPicture.asset(
                                          'assets/file_page/create_dir.svg',
                                          height: 64,
                                          width: 64,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        translate.create_a_folder,
                                        style: TextStyle(
                                          fontFamily: kNormalTextFontFamily,
                                          fontSize: 14,
                                          color:
                                              Theme.of(context).disabledColor,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 28.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        print(await getDirPath());
                                      },
                                      child: MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: SvgPicture.asset(
                                          'assets/file_page/upload_dir.svg',
                                          height: 64,
                                          width: 64,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      translate.upload_folder,
                                      style: TextStyle(
                                        fontFamily: kNormalTextFontFamily,
                                        fontSize: 14,
                                        color: Theme.of(context).disabledColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 27),
                          child: Divider(
                            height: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, left: 30),
                          child: Center(
                            child: Text(
                              translate.upload_to_media,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: kNormalTextFontFamily,
                                color: Theme.of(context).focusColor,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, top: 27),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      MouseRegion(
                                        cursor: SystemMouseCursors.click,
                                        child: SvgPicture.asset(
                                          'assets/file_page/upload_mediaa.svg',
                                          height: 64,
                                          width: 64,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        translate.upload_media,
                                        style: TextStyle(
                                          fontFamily: kNormalTextFontFamily,
                                          fontSize: 14,
                                          color:
                                              Theme.of(context).disabledColor,
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Column(
                                      children: [
                                        MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: SvgPicture.asset(
                                            'assets/file_page/create_album.svg',
                                            height: 64,
                                            width: 64,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          translate.create_album,
                                          style: TextStyle(
                                            fontFamily: kNormalTextFontFamily,
                                            fontSize: 14,
                                            color:
                                                Theme.of(context).disabledColor,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Align(
                        alignment: FractionalOffset.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, right: 15),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child:
                                SvgPicture.asset("assets/file_page/close.svg"),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

class AddMenuResult {
  UserAction action;
  List<String?>? result;

  AddMenuResult({
    required this.action,
    this.result,
  });
}
