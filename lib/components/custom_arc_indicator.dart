import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;

import 'package:vector_math/vector_math.dart';

class ArcIndicator extends CustomPainter {
  final bool isBackGround;
  final Color color;
  final double? value;
  ArcIndicator(
      {required this.isBackGround, required this.color, required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    const arcCenter = Offset(57, 65);
    final arcRect = Rect.fromCircle(center: arcCenter, radius: 65);
    final startAngle = -math.pi;
    final sweepAngle = value != null ? value : math.pi;
    final useCenter = false;
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    if (isBackGround) {}
    // Offset startingPoint = Offset(0, size.height / 2);
    // Offset endingPoint = Offset(size.width, size.height / 2);

    // canvas.drawLine(startingPoint, endingPoint, paint);

    canvas.drawArc(arcRect, startAngle, sweepAngle!, useCenter, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CircularArc extends StatefulWidget {
  double value;
  CircularArc({required this.value, Key? key}) : super(key: key);

  @override
  _CircularArc createState() => _CircularArc();
}

class _CircularArc extends State<CircularArc>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  //final double value;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    final curvedAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic);

    animation =
        Tween<double>(begin: 0.0, end: widget.value).animate(curvedAnimation)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 75,
      child: Stack(
        children: [
          CustomPaint(
              //size: Size(100, 100),
              painter: ArcIndicator(
                  isBackGround: false,
                  color: Theme.of(context).canvasColor,
                  value: null)),
          CustomPaint(
              //size: Size(100, 100),
              painter: ArcIndicator(
                  isBackGround: false,
                  color: Theme.of(context).splashColor,
                  value: (widget.value * 3.14) / 100)),
          Align(
            alignment: FractionalOffset.center,
            child: SvgPicture.asset(
              'assets/space_sell/smail_fun.svg',
              // width: 70,
              // height: 56,
            ),
          ),
        ],
      ),
    );
  }
}
