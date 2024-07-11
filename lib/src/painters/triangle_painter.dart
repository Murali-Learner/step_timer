import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:step_timer/src/utils/constants.dart';

class TrianglePainter extends CustomPainter {
  /// Starting point of the line
  final Offset p1;

  /// Ending point of the line
  final Offset p2;

  /// Color of the triangle indicator
  final Color indicatorColor;

  /// Gap between the end of the line and the triangle
  final double indicatorGap;

  /// Size of the triangle indicator
  final double indicatorSize;

  TrianglePainter({
    required this.p1,
    required this.p2,

    /// Default gap is 5.0
    this.indicatorGap = 5.0,

    /// Default size is 10.0
    this.indicatorSize = 10.0,

    /// Default color is green
    this.indicatorColor = Colors.green,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();

    /// Calculate the direction of the triangle
    double angle = math.atan2(p2.dy - p1.dy, p2.dx - p1.dx);

    /// Calculate the points of the triangle
    Offset p3 = Offset(
      p2.dx +
          (indicatorSize + indicatorGap) * math.cos(angle - Constants.PI / 6),
      p2.dy +
          (indicatorSize + indicatorGap) * math.sin(angle - Constants.PI / 6),
    );
    Offset p4 = Offset(
      p2.dx +
          (indicatorSize + indicatorGap) * math.cos(angle + Constants.PI / 6),
      p2.dy +
          (indicatorSize + indicatorGap) * math.sin(angle + Constants.PI / 6),
    );

    /// Move to the starting point of the triangle
    path.moveTo(
      p2.dx + indicatorGap * math.cos(angle),
      p2.dy + indicatorGap * math.sin(angle),
    );
    path.lineTo(p3.dx, p3.dy);

    /// Draw line to p3
    path.lineTo(p4.dx, p4.dy);

    /// Draw line to p4
    path.close();

    /// Close the path

    canvas.drawPath(path, Paint()..color = indicatorColor);

    /// Draw the triangle path
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return true;

    /// Always repaint
    /// return oldDelegate.p1 != p1 || oldDelegate.p2 != p2; // Uncomment to repaint only when p1 or p2 changes
  }

  @override
  bool shouldRebuildSemantics(TrianglePainter oldDelegate) => false;

  /// No semantic changes
}
