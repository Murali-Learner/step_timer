import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:step_timer/src/utils/constants.dart';

class ArrowPainter extends CustomPainter {
  final Offset p1;
  final Offset p2;
  final double angle;
  final Color indicatorColor;

  ArrowPainter({
    required this.p1,
    required this.p2,
    required this.angle,
    required this.indicatorColor,
  });

  Offset calculateNewOffset(
      Offset currentOffset, double angleRadians, double distance) {
    // Calculate the new x and y coordinates
    double newX = currentOffset.dx + distance * cos(angleRadians);
    double newY = currentOffset.dy + distance * sin(angleRadians);

    return Offset(newX, newY);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final arrowPaint = Paint()
      ..color = indicatorColor
      ..strokeWidth = 2;

    /// Calculate the direction of the triangle
    double angle = math.atan2(p2.dy - p1.dy, p2.dx - p1.dx);

    /// Calculate the points of the triangle
    Offset p3 = Offset(
      p2.dx + (15 + 10) * math.cos(angle - Constants.PI / 6),
      p2.dy + (15 + 10) * math.sin(angle - Constants.PI / 6),
    );
    Offset p4 = Offset(
      p2.dx + (15 + 10) * math.cos(angle + Constants.PI / 6),
      p2.dy + (15 + 10) * math.sin(angle + Constants.PI / 6),
    );

    canvas.drawLine(
      Offset(
        p2.dx + 15 * math.cos(angle),
        p2.dy + 15 * math.sin(angle),
      ),
      Offset(p3.dx, p3.dy),
      arrowPaint,
    );
    canvas.drawLine(
      Offset(
        p2.dx + 15 * math.cos(angle),
        p2.dy + 15 * math.sin(angle),
      ),
      Offset(p4.dx, p4.dy),
      arrowPaint,
    );
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) {
    return oldDelegate.p1 != p1 ||
        oldDelegate.angle != angle ||
        oldDelegate.indicatorColor != indicatorColor;
  }

  @override
  bool shouldRebuildSemantics(ArrowPainter oldDelegate) => false;
}
