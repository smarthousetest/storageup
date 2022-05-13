import 'package:file_typification/file_typification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/generated/l10n.dart';
import 'package:upstorage_desktop/models/record.dart';
import 'package:upstorage_desktop/models/user.dart';
import 'package:upstorage_desktop/utilites/event_bus.dart';
import 'package:upstorage_desktop/utilites/extensions.dart';
import 'package:upstorage_desktop/utilites/injection.dart';
import 'package:upstorage_desktop/utilites/state_info_container.dart';

class MediaInfoView extends StatefulWidget {
  final Record? record;
  final User? user;
  final GlobalKey? key;
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();
  MediaInfoView({this.record, required this.user, required this.key});
}

class _ButtonTemplateState extends State<MediaInfoView> {
  S translate = getIt<S>();
  var setNull;

  Widget build(BuildContext context) {
    var type = FileAttribute().getFilesType(widget.record!.name!.toLowerCase());

    return Padding(
        padding: const EdgeInsets.only(right: 30, top: 30, bottom: 30, left: 0),
        child: Container(
            width: 320,
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
            child: ListView(controller: ScrollController(), children: [
              Padding(
                  padding: EdgeInsets.only(right: 17, top: 17),
                  child: Align(
                      alignment: Alignment.topRight,
                      child: GestureDetector(
                        onTap: () {
                          StateInfoContainer.of(context)?.setInfoRecord(null);
                        },
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Container(
                            child:
                                SvgPicture.asset('assets/file_page/close.svg'),
                          ),
                        ),
                      ))),
              Padding(
                  padding: const EdgeInsets.only(
                      right: 30.0, left: 30, bottom: 30, top: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                height: 46,
                                width: 46,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(23),
                                  child: widget.user.image,
                                ),
                              ),
                            ),
                            Container(
                              constraints: BoxConstraints(maxWidth: 120),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: Text(
                                      widget.user?.fullName ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color:
                                            Theme.of(context).bottomAppBarColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    widget.user?.email ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(30),
                          child: Divider(
                            height: 1,
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
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
                              child: widget.record is Record && type != 'image'
                                  ? type.isNotEmpty
                                      ? Image.asset(
                                          'assets/file_icons/$type.png',
                                          fit: BoxFit.contain,
                                        )
                                      : Image.asset(
                                          'assets/file_icons/files.png',
                                          fit: BoxFit.contain,
                                        )
                                  : type == 'image'
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Image.network(
                                            (widget.record as Record)
                                                .thumbnail!
                                                .first
                                                .publicUrl!,
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                      : Image.asset(
                                          'assets/file_icons/folder.png',
                                          fit: BoxFit.contain,
                                        ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: Center(
                            child: Text(
                              widget.record?.name ?? '',
                              maxLines: 1,
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
                          padding:
                              const EdgeInsets.only(left: 0, top: 25, right: 0),
                          child: Container(
                            width: 260,
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                        fileSize(
                                            widget.record?.size, translate, 1),
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
                                        widget.record is Record
                                            ? widget.record!.extension
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
                                          widget.record is Record
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
                                              widget.record!.createdAt!),
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
                                              widget.record!.updatedAt!),
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
                                          widget.record?.updatedBy ?? '',
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
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 0, top: 25, bottom: 30),
                          child: Container(
                            height: 42,
                            width: 260,
                            child: OutlinedButton(
                              onPressed: () {
                                eventBusMediaOpen.fire(MediaInfoView);
                              },
                              style: OutlinedButton.styleFrom(
                                minimumSize: Size(double.maxFinite, 60),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: Theme.of(context).splashColor,
                              ),
                              child: Text(
                                translate.open,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontFamily: kNormalTextFontFamily,
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ])),
            ])));
  }
}
