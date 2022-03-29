import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/models/base_object.dart';

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
  MediaOpenPageArgs arguments;
  @override
  _MediaOpenPageState createState() => _MediaOpenPageState();
}

class _MediaOpenPageState extends State<MediaOpenPage> {
  Widget build(BuildContext context) {
    return Material(
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
                    Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.arguments.selectedMedia.name ?? '',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontFamily: kNormalTextFontFamily),
                        )),
                    Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 61.0),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child:
                                  SvgPicture.asset('assets/options/close.svg')),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              mainSection(context),
              Container(
                height: 125,
              )
            ],
          ),
        )
      ]),
    );
  }

  mainSection(BuildContext context) {
    return Expanded(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
                onTap: () {},
                child: SvgPicture.asset('assets/options/arrow_left.svg')),
          ),
        ),
        Spacer(),
        Center(child: Text(widget.arguments.selectedMedia.id)),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 30.0),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
                onTap: () {},
                child: SvgPicture.asset('assets/options/arrow_right.svg')),
          ),
        ),
      ],
    ));
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
