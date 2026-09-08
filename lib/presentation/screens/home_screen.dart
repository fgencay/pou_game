import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../game/pet_game.dart';
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
                const SizedBox(height: GameSpacing.lg),
                const Expanded(child: _PetGamePanel()),
                const SizedBox(height: GameSpacing.lg),
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

class _PetGamePanel extends StatelessWidget {
  const _PetGamePanel();

  @override
  Widget build(BuildContext context) {
    return Container(
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
      clipBehavior: Clip.antiAlias,
      child: GameWidget(
        game: PetGame(),
        backgroundBuilder: (_) => const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFFFF7D6), Color(0xFFEAF7FF)],
            ),
          ),
        ),
      ),
    );
  }
}
