import 'package:flutter/material.dart';

class PuzzlePiecePainter extends CustomPainter {
  final bool hasTopBulgeOut;
  final bool hasTopBulgeIn;
  final bool hasBottomBulgeOut;
  final bool hasBottomBulgeIn;
  final bool hasLeftBulgeOut;
  final bool hasLeftBulgeIn;
  final bool hasRightBulgeOut;
  final bool hasRightBulgeIn;
  final Color? borderColor;
  final double? borderWidth;
  final Color? fillColor;

  // Bulge customization parameters
  final double bulgeDepth;
  final double bulgeStartFraction;
  final double bulgeEndFraction;
  final double controlPointStartFraction;
  final double controlPointEndFraction;

  PuzzlePiecePainter({
    required this.hasTopBulgeOut,
    required this.hasTopBulgeIn,
    required this.hasBottomBulgeOut,
    required this.hasBottomBulgeIn,
    required this.hasLeftBulgeOut,
    required this.hasLeftBulgeIn,
    required this.hasRightBulgeOut,
    required this.hasRightBulgeIn,
    this.borderColor,
    this.borderWidth,
    this.fillColor,
    this.bulgeDepth = 0.29,
    this.bulgeStartFraction = 0.34,
    this.bulgeEndFraction = 0.64,
    this.controlPointStartFraction = 0.3,
    this.controlPointEndFraction = 0.71,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final actualBulgeDepth = w * bulgeDepth;

    final path = Path();
    path.moveTo(0, 0);

    // Top edge
    if (hasTopBulgeOut) {
      path.lineTo(w * bulgeStartFraction, 0);
      path.cubicTo(
          w * controlPointStartFraction, -actualBulgeDepth,
          w * controlPointEndFraction, -actualBulgeDepth,
          w * bulgeEndFraction, 0
      );
    } else if (hasTopBulgeIn) {
      path.lineTo(w * bulgeStartFraction, 0);
      path.cubicTo(
          w * controlPointStartFraction, actualBulgeDepth,
          w * controlPointEndFraction, actualBulgeDepth,
          w * bulgeEndFraction, 0
      );
    }

    path.lineTo(w, 0);

    // Right edge
    if (hasRightBulgeOut) {
      path.lineTo(w, h * bulgeStartFraction);
      path.cubicTo(
          w + actualBulgeDepth, h * controlPointStartFraction,
          w + actualBulgeDepth, h * controlPointEndFraction,
          w, h * bulgeEndFraction
      );
    } else if (hasRightBulgeIn) {
      path.lineTo(w, h * bulgeStartFraction);
      path.cubicTo(
          w - actualBulgeDepth, h * controlPointStartFraction,
          w - actualBulgeDepth, h * controlPointEndFraction,
          w, h * bulgeEndFraction
      );
    }

    path.lineTo(w, h);

    // Bottom edge
    if (hasBottomBulgeOut) {
      path.lineTo(w * bulgeEndFraction, h);
      path.cubicTo(
          w * controlPointEndFraction, h + actualBulgeDepth,
          w * controlPointStartFraction, h + actualBulgeDepth,
          w * bulgeStartFraction, h
      );
    } else if (hasBottomBulgeIn) {
      path.lineTo(w * bulgeEndFraction, h);
      path.cubicTo(
          w * controlPointEndFraction, h - actualBulgeDepth,
          w * controlPointStartFraction, h - actualBulgeDepth,
          w * bulgeStartFraction, h
      );
    }

    path.lineTo(0, h);

    // Left edge
    if (hasLeftBulgeOut) {
      path.lineTo(0, h * bulgeEndFraction);
      path.cubicTo(
          -actualBulgeDepth, h * controlPointEndFraction,
          -actualBulgeDepth, h * controlPointStartFraction,
          0, h * bulgeStartFraction
      );
    } else if (hasLeftBulgeIn) {
      path.lineTo(0, h * bulgeEndFraction);
      path.cubicTo(
          actualBulgeDepth, h * controlPointEndFraction,
          actualBulgeDepth, h * controlPointStartFraction,
          0, h * bulgeStartFraction
      );
    }

    path.close();

    // Fill
    if (fillColor != null) {
      final fillPaint = Paint()
        ..color = fillColor!
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);
    }

    // Border
    if (borderColor != null && borderWidth != null) {
      final borderPaint = Paint()
        ..color = borderColor!
        ..strokeWidth = borderWidth!
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round;
      canvas.drawPath(path, borderPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
