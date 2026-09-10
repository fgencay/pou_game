import 'package:flutter/material.dart';

class RoomNavigation extends StatelessWidget {
  const RoomNavigation({
    super.key,
    required this.roomName,
    this.onPrevious,
    this.onNext,
  });
  final String roomName;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: SizedBox(
          height: 48,
          child: Row(
            children: [
              _RoomArrow(forward: false, onPressed: onPrevious),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 44,
                  alignment: Alignment.center,
                  decoration: _surface(28),
                  child: Text(
                    roomName,
                    style: const TextStyle(
                      color: Color(0xFF73513E),
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0,
                      shadows: [
                        Shadow(color: Colors.white, offset: Offset(0, 1)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _RoomArrow(forward: true, onPressed: onNext),
            ],
          ),
        ),
      ),
    );
  }
}

BoxDecoration _surface(double radius) => BoxDecoration(
  gradient: const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFF5E8), Color(0xFFF4D7C4)],
  ),
  borderRadius: BorderRadius.circular(radius),
  border: Border.all(color: const Color(0xFFB58874), width: 2.5),
  boxShadow: const [
    BoxShadow(color: Color(0x3373513E), offset: Offset(0, 3), blurRadius: 3),
  ],
);

class _RoomArrow extends StatefulWidget {
  const _RoomArrow({required this.forward, this.onPressed});
  final VoidCallback? onPressed;

  final bool forward;

  @override
  State<_RoomArrow> createState() => _RoomArrowState();
}

class _RoomArrowState extends State<_RoomArrow> {
  bool _pressed = false;

  void _setPressed(bool value) => setState(() => _pressed = value);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.forward ? 'Next room' : 'Previous room',
      child: GestureDetector(
        onTap: widget.onPressed ?? () {},
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        child: AnimatedScale(
          scale: _pressed ? 0.94 : 1,
          duration: const Duration(milliseconds: 100),
          child: Container(
            width: 48,
            height: 48,
            decoration: _surface(18),
            child: Icon(
              widget.forward
                  ? Icons.chevron_right_rounded
                  : Icons.chevron_left_rounded,
              color: const Color(0xFF73513E),
              size: 38,
            ),
          ),
        ),
      ),
    );
  }
}
