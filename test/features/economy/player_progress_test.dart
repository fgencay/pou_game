import 'package:flutter_test/flutter_test.dart';
import 'package:pou_game/core/config/game_config.dart';
import 'package:pou_game/features/economy/models/player_progress.dart';

void main() {
  group('PlayerProgress', () {
    test('starts at level one with default XP', () {
      const progress = PlayerProgress();

      expect(progress.xp, GameConfig.defaultXp);
      expect(progress.level, 1);
      expect(progress.nextLevelXp, 100);
    });

    test('calculates level from configured XP thresholds', () {
      expect(const PlayerProgress(xp: 99).level, 1);
      expect(const PlayerProgress(xp: 100).level, 2);
      expect(const PlayerProgress(xp: 250).level, 3);
      expect(const PlayerProgress(xp: 1000).level, 6);
    });
  });
}
