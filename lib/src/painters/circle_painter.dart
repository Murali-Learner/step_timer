import 'package:flutter/material.dart';
import 'dart:math' as math;

class CirclePainter extends CustomPainter {
  final Offset p1;
  final double angle;
  final Color indicatorColor;
  final double indicatorGap = 10;
  final double indicatorSize = 15;

  CirclePainter({
    required this.p1,
    required this.angle,
    required this.indicatorColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final circlePaint = Paint()
      ..color = indicatorColor
      ..style = PaintingStyle.fill;
    final double increasedGap = indicatorGap + 15.0;
    // Calculate the position of the circle center just below the step line
    final double dx = -(increasedGap + indicatorSize / 2) * math.cos(angle);
    final double dy = -(increasedGap + indicatorSize / 2) * math.sin(angle);
    final Offset circleCenter = p1.translate(dx, dy);

    // Draw the circle
    canvas.drawCircle(circleCenter, indicatorSize / 2, circlePaint);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.p1 != p1 ||
        oldDelegate.angle != angle ||
        oldDelegate.indicatorColor != indicatorColor ||
        oldDelegate.indicatorGap != indicatorGap ||
        oldDelegate.indicatorSize != indicatorSize;
  }

  @override
  bool shouldRebuildSemantics(CirclePainter oldDelegate) => false;
}
