import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:upstorage_desktop/constants.dart';

class SpaceSellPage extends StatefulWidget {
  @override
  _SpaceSellPageState createState() => _SpaceSellPageState();
  SpaceSellPage();
}

class _SpaceSellPageState extends State<SpaceSellPage> {
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(30),
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
        ),
        //child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        //         Container(
        // child: Row(
        //   children: [
        //     Expanded(
        //       child: Container(
        //         decoration: BoxDecoration(
        //           color: Theme.of(context).primaryColor,
        //           borderRadius: BorderRadius.circular(10),
        //           boxShadow: <BoxShadow>[
        //             BoxShadow(
        //                 color: Color.fromARGB(25, 23, 69, 139),
        //                 blurRadius: 4,
        //                 offset: Offset(1, 4))
        //           ],
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
        //         ),
      ),
    );
  }
}
