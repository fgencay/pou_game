import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';

class GameButton extends StatelessWidget {
  const GameButton({required this.label, required this.onPressed, super.key});

  factory GameButton.home(BuildContext context) {
    return GameButton(
      label: 'Home',
      onPressed: () {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
      },
    );
  }

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.symmetric(
          horizontal: GameSpacing.md,
          vertical: GameSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: GameColors.sun,
          border: Border.all(color: GameColors.ink, width: 2),
          borderRadius: BorderRadius.circular(GameRadius.md),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              offset: Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Text(
          label,
          style: GameTextStyles.button,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
