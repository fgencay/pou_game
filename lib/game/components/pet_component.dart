import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

class PetComponent extends PositionComponent {
  PetComponent() : super(size: Vector2(140, 150), anchor: Anchor.center);

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final bodyPaint = Paint()..color = const Color(0xFF8FD16A);
    final shadowPaint = Paint()..color = const Color(0x33000000);
    final outlinePaint = Paint()
      ..color = const Color(0xFF213547)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    final eyePaint = Paint()..color = const Color(0xFF213547);
    final cheekPaint = Paint()..color = const Color(0x55EF476F);

    canvas.drawOval(Rect.fromLTWH(22, 130, 96, 16), shadowPaint);

    final bodyRect = Rect.fromLTWH(14, 8, size.x - 28, size.y - 16);
    canvas.drawOval(bodyRect, bodyPaint);
    canvas.drawOval(bodyRect, outlinePaint);

    canvas.drawCircle(const Offset(50, 62), 8, eyePaint);
    canvas.drawCircle(const Offset(90, 62), 8, eyePaint);
    canvas.drawCircle(const Offset(48, 88), 9, cheekPaint);
    canvas.drawCircle(const Offset(92, 88), 9, cheekPaint);

    canvas.drawArc(
      const Rect.fromLTWH(51, 72, 38, 30),
      0,
      math.pi,
      false,
      outlinePaint,
    );
  }
}
