import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MyProgressBar extends StatefulWidget {
  final double percent;
  final String text;
  final Color color;

  @override
  _MyProgressIndicator createState() => new _MyProgressIndicator();

  MyProgressBar(
      {required this.percent, required this.text, required this.color});
}

class _MyProgressIndicator extends State<MyProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          children: <Widget>[
            Container(

              child: LinearPercentIndicator( //leaner progress bar
                width: 210, //width for progress bar
                animation: true, //animation to show progress at first
                animationDuration: 1000,
                lineHeight: 10.0,
                //height of progress bar
                // leading: Padding( //prefix content
                //   padding: EdgeInsets.only(right:15),
                //   child:Text("0 %"), //left content
                // ),
                // trailing: Padding( //sufix content
                //   padding: EdgeInsets.only(left:15),
                //   child:Text("100 %"), //right content
                // ),
                percent: widget.percent / 100, // 30/100 = 0.3
                // center: Text(widget.percent.toString() + "%"),
                linearStrokeCap: LinearStrokeCap.roundAll, //make round cap at start and end both
                progressColor: widget.color, //percentage progress bar color
                backgroundColor: Color(0xffF7F9FB),  //background progressbar color
              ),
            )
          ],
        ));
  }
}
