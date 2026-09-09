import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../core/config/game_assets.dart';
import '../../game/pet_game.dart';
import '../widgets/game_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(GameAssets.homeRoomBackground, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              color: GameColors.sky.withValues(alpha: 0.12),
            ),
          ),
          SafeArea(
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
        ],
      ),
    );
  }
}

class _PetGamePanel extends StatelessWidget {
  const _PetGamePanel();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(GameRadius.lg),
      child: GameWidget(
        game: PetGame(),
        backgroundBuilder: (_) => const SizedBox.expand(),
      ),
    );
  }
}
