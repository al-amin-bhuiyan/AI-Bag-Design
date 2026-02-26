import 'dart:ui';

import 'package:flutter/material.dart';

/// DottedBorder - Custom widget to create a dotted/dashed border
/// Follows OOP principles with encapsulation and composition
class DottedBorder extends StatelessWidget {
  final Widget child;
  final double borderWidth;
  final Color borderColor;
  final double radius;

  const DottedBorder({
    super.key,
    required this.child,
    this.borderWidth = 1.5,
    this.borderColor = Colors.black,
    this.radius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DottedBorderPainter(
        borderWidth: borderWidth,
        borderColor: borderColor,
        radius: radius,
      ),
      child: child,
    );
  }
}

/// DottedBorderPainter - Custom painter for creating dotted borders
/// Implements CustomPainter with dash path effect
class DottedBorderPainter extends CustomPainter {
  final double borderWidth;
  final Color borderColor;
  final double radius;

  DottedBorderPainter({
    required this.borderWidth,
    required this.borderColor,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    // Create a dashed path effect
    final double dashWidth = 4.0;
    final double dashSpace = 4.0;
    
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final RRect roundedRect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(radius),
    );

    // Draw the rounded rectangle with dashed border
    Path path = Path()..addRRect(roundedRect);
    
    // Calculate the path metrics to draw dashes
    PathMetrics pathMetrics = path.computeMetrics();
    
    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      bool draw = true;
      
      while (distance < pathMetric.length) {
        final double length = draw ? dashWidth : dashSpace;
        
        if (distance + length > pathMetric.length) {
          if (draw) {
            final Path extractPath = pathMetric.extractPath(
              distance,
              pathMetric.length,
            );
            canvas.drawPath(extractPath, paint);
          }
          break;
        }
        
        if (draw) {
          final Path extractPath = pathMetric.extractPath(
            distance,
            distance + length,
          );
          canvas.drawPath(extractPath, paint);
        }
        
        distance += length;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(DottedBorderPainter oldDelegate) {
    return oldDelegate.borderWidth != borderWidth ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.radius != radius;
  }
}
