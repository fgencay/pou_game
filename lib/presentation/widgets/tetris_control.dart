import 'package:flutter/material.dart';

class TetrisControl extends StatelessWidget {
  const TetrisControl({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.accent = false,
  });
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;
  final bool accent;

  @override
  Widget build(BuildContext context) => Container(
    width: 48,
    height: 52,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [
        BoxShadow(
          color: Color(0x5573513E),
          offset: Offset(0, 3),
          blurRadius: 2,
        ),
      ],
    ),
    child: IconButton(
      tooltip: label,
      onPressed: onPressed,
      icon: Icon(icon, size: 28),
      style: ButtonStyle(
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        side: const WidgetStatePropertyAll(
          BorderSide(color: Color(0xFFB58874), width: 2),
        ),
        foregroundColor: const WidgetStatePropertyAll(Color(0xFF73513E)),
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.pressed)
              ? const Color(0xFFDABBAA)
              : states.contains(WidgetState.disabled)
              ? const Color(0xFFD8D2CD)
              : accent
              ? const Color(0xFFBADED2)
              : const Color(0xFFFFEFDC),
        ),
      ),
    ),
  );
}
