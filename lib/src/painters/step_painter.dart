import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StepPainter extends CustomPainter {
  /// Starting point of the line
  final Offset p1;

  /// Ending point of the line
  final Offset p2;

  /// Paint object to define the appearance of the line
  final Paint stepPaint;

  /// Boolean to indicate if the step is active
  final bool isActive;

  StepPainter({
    required this.p1,
    required this.p2,
    required this.stepPaint,

    /// Default value of isActive is false
    this.isActive = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    /// Draws a line from p1 to p2 using stepPaint
    canvas.drawLine(p1, p2, stepPaint);
  }

  @override
  bool shouldRepaint(StepPainter oldDelegate) {
    /// Returns true if any of the properties have changed
    return oldDelegate.p1 != p1 ||
        oldDelegate.p2 != p2 ||
        oldDelegate.isActive != isActive;
  }

  @override
  bool shouldRebuildSemantics(StepPainter oldDelegate) => false;
}
