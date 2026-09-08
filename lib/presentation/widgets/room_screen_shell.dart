import 'package:flutter/material.dart';

import '../../app/theme.dart';

class RoomScreenShell extends StatelessWidget {
  const RoomScreenShell({
    required this.title,
    required this.accentColor,
    required this.child,
    super.key,
  });

  final String title;
  final Color accentColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(color: accentColor.withValues(alpha: 0.34)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(GameSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: GameTextStyles.roomTitle),
                const SizedBox(height: GameSpacing.lg),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: GameColors.panel.withValues(alpha: 0.82),
                      border: Border.all(color: GameColors.ink, width: 3),
                      borderRadius: BorderRadius.circular(GameRadius.lg),
                    ),
                    child: Text(
                      '$title placeholder',
                      style: GameTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const SizedBox(height: GameSpacing.lg),
                Align(alignment: Alignment.centerLeft, child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
