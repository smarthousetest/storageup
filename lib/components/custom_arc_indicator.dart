import 'package:flutter/material.dart';
import 'dart:math' as math;

class ArcIndicator extends CustomPainter {
  final bool isBackGround;
  final Color color;
  final double value;
  ArcIndicator(
      {required this.isBackGround, required this.color, required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTRB(0, 0, 140, 140);
    final startAngle = -math.pi;
    final sweepAngle = value != null ? value : -math.pi;
    final useCenter = false;
    final paint = Paint()
      ..strokeCap = StrokeCap.round
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    if (isBackGround) {}

    canvas.drawArc(rect, startAngle, sweepAngle, useCenter, paint);
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
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    final curvedAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    animation =
        Tween<double>(begin: 0.0, end: widget.value).animate(curvedAnimation)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
          size: Size(140, 140),
          painter: ArcIndicator(
              isBackGround: false,
              color: Theme.of(context).errorColor,
              value: animation.value)),
    );
  }
}
