import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MyProgressBar extends StatefulWidget {
  final double percent;
  final Color color;
  final Color bgColor;

  @override
  _MyProgressIndicator createState() => new _MyProgressIndicator();

  MyProgressBar({
    required this.percent,
    required this.color,
    required this.bgColor,
  });
}

class _MyProgressIndicator extends State<MyProgressBar> {
  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      //leaner progress bar
      //width for progress bar
      animation: true,
      //animation to show progress at first
      animationDuration: 1000,
      lineHeight: 8.0,
      //height of progress bar
      // leading: Padding( //prefix content
      //   padding: EdgeInsets.only(right:15),
      //   child:Text("0 %"), //left content
      // ),
      // trailing: Padding( //sufix content
      //   padding: EdgeInsets.only(left:15),
      //   child:Text("100 %"), //right content
      // ),
      percent: widget.percent / 100,
      barRadius: Radius.circular(24),
      // 30/100 = 0.3
      // center: Text(widget.percent.toString() + "%"),
      //linearStrokeCap: LinearStrokeCap.roundAll,
      //make round cap at start and end both
      progressColor: widget.color,
      //percentage progress bar color
      backgroundColor: widget.bgColor, //background progressbar color
    );
  }
}
