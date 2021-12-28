import 'package:flutter/material.dart';
import 'constants.dart';

class BlueCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width + 2;

    Path ovalPath = Path();
    ovalPath.moveTo(0, height * 3 / 4);
    ovalPath.quadraticBezierTo(
        width * 1 / 2, height * 2 / 3, width, height * 3 / 4);
    ovalPath.quadraticBezierTo(width, height, width, height);
    ovalPath.quadraticBezierTo(width, height, 0, height);

    Paint bluePaint = Paint();
    bluePaint.color = COLOR_BLUE;
    canvas.drawPath(ovalPath, bluePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
