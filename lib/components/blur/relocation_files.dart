import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/models/folder.dart';
import 'package:upstorage_desktop/utilites/controllers/files_controller.dart';
import 'package:upstorage_desktop/utilites/injection.dart';

class RelocationFiles extends StatefulWidget {
  // List<Folder>? folders;
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();
  RelocationFiles();
}

class _ButtonTemplateState extends State<RelocationFiles> {
  S translate = getIt<S>();

  bool canSave = false;
  bool hintColor = true;
  final TextEditingController _searchingFieldController =
      TextEditingController();
  var _filesController =
      getIt<FilesController>(instanceName: 'files_controller');
  Folder? moveToFolder;

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
              width: 700,
              height: 530,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(50, 30, 0, 30),
                    child: Container(
                      width: 600,
                      height: 470,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translate.where_move,
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
                                border: Border.all(color: Color(0xffE4E7ED)),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(9.0),
                                    child: Align(
                                      alignment: FractionalOffset.centerLeft,
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
                                        color: Theme.of(context).disabledColor,
                                      ),
                                      onChanged: (value) {},
                                      controller: _searchingFieldController,
                                      decoration: InputDecoration.collapsed(
                                        hintText: translate.search,
                                        hintStyle: TextStyle(
                                          fontSize: 14.0,
                                          color:
                                              Theme.of(context).disabledColor,
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
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Divider(
                              color: Theme.of(context).dividerColor,
                              height: 1,
                            ),
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child:
                                      Image.asset('assets/file_page/plus.png'),
                                ),
                                Text(
                                  translate.create,
                                  style: TextStyle(
                                    color: Theme.of(context).splashColor,
                                    fontSize: 17,
                                    fontFamily: kNormalTextFontFamily,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: Text(
                                            translate.cancel,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .disabledColor,
                                              fontSize: 17,
                                              fontFamily: kNormalTextFontFamily,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary:
                                                Theme.of(context).cardColor,
                                            fixedSize: Size(130, 42),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(
                                                context, moveToFolder);
                                          },
                                          child: Text(
                                            translate.move,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 17,
                                              fontFamily: kNormalTextFontFamily,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary:
                                                Theme.of(context).splashColor,
                                            fixedSize: Size(155, 42),
                                            elevation: 0,
                                            side: BorderSide(
                                              style: BorderStyle.solid,
                                              color:
                                                  Theme.of(context).splashColor,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                            child:
                                SvgPicture.asset('assets/file_page/close.svg')),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _allFolders(BuildContext context) {
    var rootFolders = _filesController.getFilesRootFolder;
    return Container(
      height: 240,
      width: 600,
      child: ListView.builder(
          itemCount: rootFolders?.folders?.length,
          itemBuilder: (context, index) {
            return _folder(context, rootFolders?.folders?[index]);
          }),
    );
  }

  Widget _folder(BuildContext context, Folder? folder) {
    return GestureDetector(
      onTap: () {
        setState(() {
          moveToFolder = folder;
        });
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          width: 600,
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
                child: SvgPicture.asset('assets/file_page/arrow_right.svg'),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Image.asset(
                  'assets/file_icons/folder.png',
                  width: 24,
                  height: 20,
                ),
              ),
              Text(folder?.name ?? 'Folder')
            ],
          ),
        ),
      ),
    );
  }
}
