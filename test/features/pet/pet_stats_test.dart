import 'package:flutter_test/flutter_test.dart';
import 'package:pou_game/core/config/game_config.dart';
import 'package:pou_game/features/pet/domain/pet_stat_decay.dart';
import 'package:pou_game/features/pet/models/pet_stats.dart';

void main() {
  group('PetStats', () {
    test('uses default stat values', () {
      final stats = PetStats();

      expect(stats.hunger, GameConfig.defaultHunger);
      expect(stats.energy, GameConfig.defaultEnergy);
      expect(stats.happiness, GameConfig.defaultHappiness);
      expect(stats.cleanliness, GameConfig.defaultCleanliness);
    });

    test('copyWith updates only provided values', () {
      final stats = PetStats();

      final updated = stats.copyWith(hunger: 42);

      expect(updated.hunger, 42);
      expect(updated.energy, stats.energy);
      expect(updated.happiness, stats.happiness);
      expect(updated.cleanliness, stats.cleanliness);
    });

    test('clamps values above the maximum stat', () {
      final stats = PetStats(
        hunger: 120,
        energy: 140,
        happiness: 160,
        cleanliness: 180,
      );

      expect(stats.hunger, GameConfig.maxStat);
      expect(stats.energy, GameConfig.maxStat);
      expect(stats.happiness, GameConfig.maxStat);
      expect(stats.cleanliness, GameConfig.maxStat);
    });

    test('clamps values below the minimum stat', () {
      final stats = PetStats(
        hunger: -20,
        energy: -40,
        happiness: -60,
        cleanliness: -80,
      );

      expect(stats.hunger, GameConfig.minStat);
      expect(stats.energy, GameConfig.minStat);
      expect(stats.happiness, GameConfig.minStat);
      expect(stats.cleanliness, GameConfig.minStat);
    });

    test('reports threshold states', () {
      final stats = PetStats(
        hunger: GameConfig.hungryThreshold,
        energy: GameConfig.tiredThreshold,
        happiness: GameConfig.unhappyThreshold,
        cleanliness: GameConfig.dirtyThreshold,
      );

      expect(stats.isHungry, isTrue);
      expect(stats.isTired, isTrue);
      expect(stats.isUnhappy, isTrue);
      expect(stats.isDirty, isTrue);
    });
  });

  group('PetStatDecay', () {
    const decay = PetStatDecay();

    test('does not change stats for Duration.zero', () {
      final stats = PetStats(
        hunger: 80,
        energy: 70,
        happiness: 60,
        cleanliness: 50,
      );

      final decayed = decay.apply(stats, Duration.zero);

      expect(decayed, stats);
    });

    test('applies decay for a specific duration', () {
      final stats = PetStats();

      final decayed = decay.apply(stats, const Duration(minutes: 10));

      expect(decayed.hunger, GameConfig.maxStat - 4.5);
      expect(decayed.energy, GameConfig.maxStat - 1.8);
      expect(decayed.happiness, GameConfig.maxStat - 1.2);
      expect(decayed.cleanliness, GameConfig.maxStat - 1.6);
    });

    test('does not let long duration decay drop values below zero', () {
      final stats = PetStats();

      final decayed = decay.apply(stats, const Duration(days: 30));

      expect(decayed.hunger, GameConfig.minStat);
      expect(decayed.energy, GameConfig.minStat);
      expect(decayed.happiness, GameConfig.minStat);
      expect(decayed.cleanliness, GameConfig.minStat);
    });
  });
}
