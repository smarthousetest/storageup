import 'dart:ui';

import 'package:cpp_native/models/base_object.dart';
import 'package:cpp_native/models/folder.dart';
import 'package:cpp_native/models/record.dart';
import 'package:file_typification/file_typification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:storageup/constants.dart';
import 'package:storageup/generated/l10n.dart';
import 'package:storageup/utilities/extensions.dart';
import 'package:storageup/utilities/injection.dart';

class ShortFileInfo extends StatefulWidget {
  final BaseObject? object;

  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();

  ShortFileInfo({
    required this.object,
  });
}

class _ButtonTemplateState extends State<ShortFileInfo> {
  S translate = getIt<S>();
  var setNull;
  bool open = true;

  String getRecordViewedDate() {
    BaseObject? object = widget.object;
    if (object is Record) {
      DateTime? accessDate = object.accessDate;

      if (accessDate is DateTime) {
        return DateFormat('dd.MM.yyyy').format(accessDate);
      }
    }

    return translate.never;
  }

  Widget build(BuildContext context) {
    var type = FileAttribute().getFilesType(widget.object!.name!.toLowerCase());

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 0.1,
                sigmaY: 0.1,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: Colors.transparent.withAlpha(0),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 22, right: 10, bottom: 22),
            child: Align(
              alignment: FractionalOffset.centerRight,
              child: Container(
                width: 320,
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
                child: ListView(
                  controller: ScrollController(),
                  children: [
                    Padding(
                        padding: EdgeInsets.only(right: 17, top: 17),
                        child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: Container(
                                  child: SvgPicture.asset(
                                      'assets/file_page/close.svg'),
                                ),
                              ),
                            ))),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 30.0,
                        left: 30,
                        bottom: 30,
                        top: 5,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Center(
                              child: Text(
                                translate.properties,
                                style: TextStyle(
                                  color: Theme.of(context).focusColor,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Center(
                              child: Container(
                                width: 150,
                                height: 150,
                                child:
                                    widget.object is Record && type != 'image'
                                        ? type.isNotEmpty
                                            ? Image.asset(
                                                'assets/file_icons/$type.png',
                                                fit: BoxFit.contain,
                                              )
                                            : Image.asset(
                                                'assets/file_icons/files.png',
                                                fit: BoxFit.contain,
                                              )
                                        : widget.object is Folder
                                            ? Image.asset(
                                                'assets/file_icons/folder.png',
                                                fit: BoxFit.contain,
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  (widget.object as Record)
                                                      .thumbnail!
                                                      .first
                                                      .publicUrl!,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: Center(
                              child: Text(
                                widget.object?.name ?? '',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Theme.of(context).disabledColor,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 0,
                              top: 25,
                              right: 0,
                            ),
                            child: Container(
                              width: 260,
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        translate.size,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground,
                                          fontFamily: kNormalTextFontFamily,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 100,
                                        child: Container(),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          fileSize(widget.object?.size,
                                              translate, 1),
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            fontFamily: kNormalTextFontFamily,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 18),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          translate.type,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            fontFamily: kNormalTextFontFamily,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 100,
                                          child: Container(),
                                        ),
                                        Text(
                                          widget.object is Record
                                              ? widget.object?.extension
                                                      ?.toUpperCase() ??
                                                  ''
                                              : translate.foldr,
                                          // type.isEmpty
                                          //     ? translate.foldr
                                          //     : type.toUpperCase(),
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            fontFamily: kNormalTextFontFamily,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 18),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          translate.format,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            fontFamily: kNormalTextFontFamily,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 100,
                                          child: Container(),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            widget.object is Record
                                                ? type.toUpperCase()
                                                : translate.foldr,
                                            //textAlign: TextAlign.end,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              fontFamily: kNormalTextFontFamily,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 18),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          translate.created,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            fontFamily: kNormalTextFontFamily,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 100,
                                          child: Container(),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            DateFormat('dd.MM.yyyy').format(
                                                widget.object!.createdAt!),
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              fontFamily: kNormalTextFontFamily,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 18),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          translate.changed,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            fontFamily: kNormalTextFontFamily,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 100,
                                          child: Container(),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            DateFormat('dd.MM.yyyy').format(
                                                widget.object!.updatedAt!),
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              fontFamily: kNormalTextFontFamily,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (widget.object is Record)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 18),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            translate.viewed,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              fontFamily: kNormalTextFontFamily,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Expanded(
                                            flex: 100,
                                            child: Container(),
                                          ),
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              getRecordViewedDate(),
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onBackground,
                                                fontFamily:
                                                    kNormalTextFontFamily,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 18),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          translate.location,
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onBackground,
                                            fontFamily: kNormalTextFontFamily,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Expanded(
                                          flex: 100,
                                          child: Container(),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "папка «Документы»",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              fontFamily: kNormalTextFontFamily,
                                              fontSize: 14,
                                            ),
                                          ),
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
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
