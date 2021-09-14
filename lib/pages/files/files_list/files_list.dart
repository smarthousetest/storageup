import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/constants.dart';
import 'package:upstorage_desktop/pages/home/home_view.dart';

class FilesList extends StatefulWidget {
  @override
  _ButtonTemplateState createState() => new _ButtonTemplateState();

  FilesList();
}

class _ButtonTemplateState extends State<FilesList> {
  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(
      color: Theme.of(context).textTheme.subtitle1?.color,
      fontSize: 14,
      fontWeight: FontWeight.w700,
      fontFamily: kNormalTextFontFamily,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  'Name',
                  style: style,
                ),
              ),
              Expanded(
                child: Text(
                  'Type',
                  style: style,
                ),
              ),
              Expanded(
                child: Text(
                  'Date',
                  style: style,
                ),
              ),
              Expanded(
                child: Text(
                  'Size',
                  style: style,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Divider(
            height: 1,
            color: Theme.of(context).cardColor,
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              Container(
                color: Colors.amber,
                height: 100,
                width: 20,
              ),
              Container(
                color: Colors.blue,
                height: 100,
                width: 20,
              ),
              Container(
                color: Colors.amber,
                height: 100,
                width: 20,
              ),
              Container(
                color: Colors.blue,
                height: 100,
                width: 20,
              ),
              Container(
                color: Colors.amber,
                height: 100,
                width: 20,
              ),
              Container(
                color: Colors.blue,
                height: 100,
                width: 20,
              ),
            ],
          ),
          // child: ListView.builder(
          //     scrollDirection: Axis.vertical,
          //     shrinkWrap: true,
          //     itemCount: 10,
          //     itemBuilder: (BuildContext context, int position) {
          //       return ElevatedButton(
          //         onPressed: () {},
          //         child: Container(
          //           child: Row(
          //             children: [Text('text')],
          //           ),
          //         ),
          //       );
          //     }),
        ),
      ],
    );
  }
}
