import 'package:flutter/material.dart';
import '../../core/config/game_assets.dart';
import '../../features/economy/models/player_progress.dart';

class PetProgressDialog extends StatelessWidget {
  const PetProgressDialog({super.key, required this.progress});
  final PlayerProgress progress;

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: const Color(0xFFFFF0E5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: const BorderSide(color: Color(0xFFB58874), width: 2),
    ),
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Pet level',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                  ),
                ),
                IconButton(
                  tooltip: 'Close',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Image.asset(GameAssets.levelIcon, width: 84, height: 72),
            Text(
              'Level ${progress.level}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Color(0xFF73513E),
              ),
            ),
            const SizedBox(height: 16),
            Semantics(
              label: 'Level progress',
              value: '${(progress.levelProgress * 100).round()}%',
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFFE1C9BC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFB58874), width: 2),
                ),
                padding: const EdgeInsets.all(2),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    key: const ValueKey('pet-xp-fill'),
                    widthFactor: progress.levelProgress,
                    heightFactor: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFF78BC9B),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${progress.xpInLevel} / ${progress.xpForLevel} XP',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text('${progress.xpRemaining} XP to level ${progress.level + 1}'),
            const SizedBox(height: 4),
            Text('Total XP: ${progress.xp}'),
          ],
        ),
      ),
    ),
  );
}
