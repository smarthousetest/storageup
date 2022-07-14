import 'package:flutter/material.dart';
import 'dart:math' as math;

class _ValidateKeeperArcIndicator extends CustomPainter {
  final bool isBackGround;
  final Color color;
  final double? value;

  _ValidateKeeperArcIndicator({
    required this.isBackGround,
    required this.color,
    required this.value,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const arcCenter = Offset(65, 65);
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

class ValidateKeeperProgressIndicator extends StatefulWidget {
  final double value;

  ValidateKeeperProgressIndicator({required this.value, Key? key})
      : super(key: key);

  @override
  _CircularArc createState() => _CircularArc();
}

class _CircularArc extends State<ValidateKeeperProgressIndicator>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  //final double value;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
    );
    final curvedAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOutCubic,
    );

    animation =
        Tween<double>(begin: 0.0, end: widget.value).animate(curvedAnimation)
          ..addListener(() {
            setState(() {});
          });
  }

  Widget _validationTimeLeft(double value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FractionallySizedBox(
            widthFactor: 1,
            child: Text(
              '${value.ceil()}%',
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Theme.of(context).splashColor, fontSize: 26),
            )),
        FractionallySizedBox(
            widthFactor: 1,
            child: Text(
              'Проверено',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).textTheme.subtitle1?.color,
              ),
            )),
      ],
    );
  }

  Color _colorIndicator(double value) {
    return Theme.of(context).splashColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 65,
      child: Stack(
        children: [
          CustomPaint(
            painter: _ValidateKeeperArcIndicator(
              isBackGround: false,
              color: Theme.of(context).canvasColor,
              value: (100 * 3.14 * 2) / 100,
            ),
          ),
          CustomPaint(
            painter: _ValidateKeeperArcIndicator(
              isBackGround: false,
              color: _colorIndicator(widget.value),
              value: (widget.value * 3.14 * 2) / 100,
            ),
          ),
          Align(
            alignment: FractionalOffset.center,
            child: _validationTimeLeft(widget.value),
          ),
        ],
      ),
    );
  }
}
