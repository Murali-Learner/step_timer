import 'package:flutter/material.dart';
import 'package:step_timer/src/utils/constants.dart';

class NumberPainter extends CustomPainter {
  final Offset p1;
  final int stepIndex;
  final TextPainter textPainter;
  final bool isActive;

  NumberPainter({
    required this.p1,
    required this.stepIndex,
    required this.textPainter,
    this.isActive = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Adjust offset distance to sync with step indicator
    const double offsetDistance = 15.0;
    Offset offset =
        Offset.fromDirection(p1.direction, p1.distance + offsetDistance);

    canvas.save();
    // Translate to the offset position
    canvas.translate(offset.dx, offset.dy);

    // Rotate the canvas to align the text upright
    double angle = p1.direction + (Constants.PI / 2);

    canvas.rotate(angle);

    // Center the text horizontally and vertically
    textPainter.layout();
    double textWidth = textPainter.width / 2;
    double textHeight = textPainter.height / 2;
    textPainter.paint(canvas, Offset(-textWidth, -textHeight));

    canvas.restore();
  }

  @override
  bool shouldRepaint(NumberPainter oldDelegate) {
    return oldDelegate.p1 != p1 ||
        oldDelegate.isActive != isActive ||
        oldDelegate.stepIndex != stepIndex;
  }

  @override
  bool shouldRebuildSemantics(NumberPainter oldDelegate) => false;
}
