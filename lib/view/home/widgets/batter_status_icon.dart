import 'package:flutter/material.dart';

class TriangleIcon extends StatelessWidget {
  final double percentage;

  const TriangleIcon({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(30, 30), // Adjust size as needed
      painter: TrianglePainter(percentage: percentage),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final double percentage;

  TrianglePainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final fillPaint = Paint()
      ..color = Colors.black // Fill color
      ..style = PaintingStyle.fill;
    final greyPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.fill;

    // Calculate the filled height based on percentage
    final double fillHeight = size.height * (percentage / 100);

    // Draw the filled part shifted to the left
    final fillPath = Path()
      ..moveTo(0, size.height) // Bottom-right vertex
      ..lineTo(fillHeight, size.height) // Bottom-left vertex, shifted left
      ..lineTo(fillHeight,
          size.height - fillHeight) // Top-right vertex, adjusted height
      ..close();
    canvas.drawPath(fillPath, fillPaint);
    final greyPath = Path()
      ..moveTo(size.width, 0) // Bottom-right vertex
      ..lineTo(size.width, size.height) // Bottom-left vertex, shifted left
      ..lineTo(fillHeight, size.height)
      ..lineTo(fillHeight, size.height - fillHeight)
      ..close();
    canvas.drawPath(greyPath, greyPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
