import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;


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
  final double value;
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

  SvgPicture _smail(double value) {
    if (value >= 0 && value <= 15) {
      return SvgPicture.asset(
        'assets/space_sell/smail_sad.svg',
      );
    } else if (value >= 15 && value <= 45) {
      return SvgPicture.asset(
        'assets/space_sell/smail_okey.svg',
      );
    } else if (value >= 45 && value <= 80) {
      return SvgPicture.asset(
        'assets/space_sell/smail_normal.svg',
      );
    } else if (value >= 80 && value <= 100) {
      return SvgPicture.asset(
        'assets/space_sell/smail_fun.svg',
      );
    }
    return SvgPicture.asset(
      'assets/space_sell/smail_normal.svg',
    );
  }

  Color _colorIndicator(double value) {
    if (value >= 0 && value <= 15) {
      return Color(0xFFFFD75E);
    } else if (value >= 15 && value <= 45) {
      return Color(0xFF59D7AB);
    } else if (value >= 45 && value <= 80) {
      return Theme.of(context).splashColor;
    } else if (value >= 80 && value <= 100) {
      return Color(0xFF868FFF);
    }
    return Theme.of(context).splashColor;
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
                  color: _colorIndicator(widget.value),
                  value: (widget.value * 3.14) / 100)),
          Align(
            alignment: FractionalOffset.center,
            child: _smail(widget.value),
          ),
        ],
      ),
    );
  }
}
