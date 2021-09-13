import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BlurMenuUpload extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();

  BlurMenuUpload();
}

class _ButtonTemplateState extends State<BlurMenuUpload> {

  Future<List<String?>?> getFilesPaths() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    if (result != null) {
      List<String?> file_paths = result.paths;
      return file_paths;
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
              width: 363,
              height: 287,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            List<String?>? list = await getFilesPaths();
                            print(list);
                          },
                          child: Column(
                            children: [
                              SizedBox(height: 30),
                              SvgPicture.asset(
                                'assets/file_page/upload_file.svg',
                                height: 64,
                                width: 64,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Загрузить файл',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 14,
                                  color: Color(0xff7D7D7D),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 45),
                        GestureDetector(
                          onTap: (){
                            print(getDirPath());
                          },
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                'assets/file_page/create_dir.svg',
                                height: 64,
                                width: 64,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Создать папку',
                                style: TextStyle(
                                  fontFamily: 'Lato',
                                  fontSize: 14,
                                  color: Color(0xff7D7D7D),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 44),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 30),
                            SvgPicture.asset(
                              'assets/file_page/upload_dir.svg',
                              height: 64,
                              width: 64,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Загрузить папку',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 14,
                                color: Color(0xff7D7D7D),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 45),
                        Column(
                          children: [
                            SvgPicture.asset(
                              'assets/file_page/create_album.svg',
                              height: 64,
                              width: 64,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Создать альбом',
                              style: TextStyle(
                                fontFamily: 'Lato',
                                fontSize: 14,
                                color: Color(0xff7D7D7D),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Color(0xff70BBF6),
                            size: 20,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

