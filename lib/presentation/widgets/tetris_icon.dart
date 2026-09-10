import 'package:flutter/material.dart';

class TetrisIcon extends StatelessWidget {
  const TetrisIcon({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.square(
    dimension: 88,
    child: CustomPaint(painter: _TetrisIconPainter()),
  );
}

class _TetrisIconPainter extends CustomPainter {
  const _TetrisIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const blocks = <(int, int, Color)>[
      (1, 0, Color(0xFFB47ADB)),
      (0, 1, Color(0xFFB47ADB)),
      (1, 1, Color(0xFFB47ADB)),
      (2, 1, Color(0xFFB47ADB)),
      (0, 2, Color(0xFF58B8CC)),
      (0, 3, Color(0xFF58B8CC)),
      (0, 4, Color(0xFF58B8CC)),
      (0, 5, Color(0xFF58B8CC)),
      (1, 4, Color(0xFFE9B64B)),
      (2, 4, Color(0xFFE9B64B)),
      (1, 5, Color(0xFFE9B64B)),
      (2, 5, Color(0xFFE9B64B)),
      (3, 3, Color(0xFFEA8B68)),
      (3, 4, Color(0xFFEA8B68)),
      (3, 5, Color(0xFFEA8B68)),
      (4, 5, Color(0xFFEA8B68)),
    ];
    final cell = size.height / 6;
    for (final block in blocks) {
      final rect = Rect.fromLTWH(
        cell / 2 + block.$1 * cell,
        block.$2 * cell,
        cell - 2,
        cell - 2,
      );
      final rounded = RRect.fromRectAndRadius(rect, const Radius.circular(2));
      canvas.drawRRect(rounded, Paint()..color = block.$3);
      canvas.drawRRect(
        rounded,
        Paint()
          ..color = const Color(0xFF73513E)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1,
      );
      canvas.drawLine(
        rect.topLeft + const Offset(2, 2),
        rect.topRight + const Offset(-2, 2),
        Paint()
          ..color = const Color(0x99FFFFFF)
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TetrisIconPainter oldDelegate) => false;
}
