import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MyProgressIndicator extends StatefulWidget {
  final double percent;
  final Color color;
  final double radius;

  @override
  _MyProgressIndicator createState() => new _MyProgressIndicator();

  MyProgressIndicator({
    required this.percent,
    required this.color,
    required this.radius,
  });
}

class _MyProgressIndicator extends State<MyProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: CircularPercentIndicator(
        //circular progress indicator
        radius: widget.radius,
        //radius for circle
        lineWidth: 8.0,
        //width of circle line
        animation: true,
        //animate when it shows progress indicator first
        percent: widget.percent / 100,
        //vercentage value: 0.6 for 60% (60/100 = 0.6)
        center: Text(
          widget.percent.toString() + '%',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xff5F5F5F),
            fontWeight: FontWeight.normal,
            fontSize: 20.0,
          ),
        ),
        //center text, you can set Icon as well
        backgroundColor: Color(0xffF7F9FB),
        //backround of progress bar
        circularStrokeCap: CircularStrokeCap.round,
        //corner shape of progress bar at start/end
        progressColor: widget.color, //progress bar color
      ),
    );
  }
}
