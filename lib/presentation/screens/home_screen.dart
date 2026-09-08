import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../widgets/game_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [GameColors.sky, GameColors.grass],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(GameSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Pou Game', style: GameTextStyles.title),
                const SizedBox(height: GameSpacing.sm),
                const Text('Home', style: GameTextStyles.body),
                const Spacer(),
                const _PetRoomPlaceholder(),
                const Spacer(),
                Wrap(
                  spacing: GameSpacing.sm,
                  runSpacing: GameSpacing.sm,
                  children: [
                    for (final destination in roomDestinations)
                      GameButton(
                        label: destination.label,
                        onPressed: () {
                          Navigator.of(context).pushNamed(destination.route);
                        },
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PetRoomPlaceholder extends StatelessWidget {
  const _PetRoomPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          color: GameColors.panel.withValues(alpha: 0.86),
          border: Border.all(color: GameColors.ink, width: 3),
          borderRadius: BorderRadius.circular(GameRadius.lg),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              offset: Offset(0, 8),
              blurRadius: 0,
            ),
          ],
        ),
        alignment: Alignment.center,
        child: const Text(
          'Pet area',
          style: GameTextStyles.roomTitle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
