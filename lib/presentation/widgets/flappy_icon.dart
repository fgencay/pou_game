import 'package:flutter/material.dart';

class FlappyIcon extends StatelessWidget {
  const FlappyIcon({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.square(
        dimension: 88,
        child: CustomPaint(painter: _FlappyIconPainter()),
      );
}

class _FlappyIconPainter extends CustomPainter {
  const _FlappyIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Draw background pipe (green column)
    final pipePaint = Paint()..color = const Color(0xFF66BB6A);
    final pipeBorderPaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    // Top pipe
    final topPipeRect = Rect.fromLTWH(w * 0.55, 0, w * 0.28, h * 0.35);
    final topPipeRRect = RRect.fromRectAndCorners(
      topPipeRect,
      bottomLeft: const Radius.circular(4),
      bottomRight: const Radius.circular(4),
    );
    canvas.drawRRect(topPipeRRect, pipePaint);
    canvas.drawRRect(topPipeRRect, pipeBorderPaint);

    // Bottom pipe
    final bottomPipeRect = Rect.fromLTWH(w * 0.55, h * 0.65, w * 0.28, h * 0.35);
    final bottomPipeRRect = RRect.fromRectAndCorners(
      bottomPipeRect,
      topLeft: const Radius.circular(4),
      topRight: const Radius.circular(4),
    );
    canvas.drawRRect(bottomPipeRRect, pipePaint);
    canvas.drawRRect(bottomPipeRRect, pipeBorderPaint);

    // Draw Flappy Cube (yellow rounded box)
    final cubeRect = Rect.fromLTWH(w * 0.12, h * 0.38, w * 0.38, h * 0.38);
    final cubeRRect = RRect.fromRectAndRadius(cubeRect, const Radius.circular(8));

    final cubePaint = Paint()..color = const Color(0xFFFFCA28);
    final cubeBorderPaint = Paint()
      ..color = const Color(0xFFE65100)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawRRect(cubeRRect, cubePaint);
    canvas.drawRRect(cubeRRect, cubeBorderPaint);

    // Eye
    final eyePaint = Paint()..color = Colors.white;
    final pupilPaint = Paint()..color = Colors.black;
    final eyeCenter = Offset(cubeRect.left + cubeRect.width * 0.72, cubeRect.top + cubeRect.height * 0.32);
    canvas.drawCircle(eyeCenter, 5, eyePaint);
    canvas.drawCircle(eyeCenter + const Offset(1, 0), 2.5, pupilPaint);

    // Wing
    final wingPath = Path()
      ..moveTo(cubeRect.left + cubeRect.width * 0.15, cubeRect.top + cubeRect.height * 0.5)
      ..quadraticBezierTo(
        cubeRect.left - cubeRect.width * 0.1,
        cubeRect.top + cubeRect.height * 0.7,
        cubeRect.left + cubeRect.width * 0.35,
        cubeRect.top + cubeRect.height * 0.75,
      );
    canvas.drawPath(wingPath, Paint()..color = const Color(0xFFFF9800));
    canvas.drawPath(wingPath, cubeBorderPaint);
  }

  @override
  bool shouldRepaint(covariant _FlappyIconPainter oldDelegate) => false;
}
