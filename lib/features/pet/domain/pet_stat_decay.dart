import '../../../core/config/game_config.dart';
import '../models/pet_stats.dart';

class PetStatDecay {
  const PetStatDecay();

  PetStats applyHunger(PetStats stats, double seconds) {
    if (seconds <= 0) return stats;
    return stats.copyWith(
      hunger: stats.hunger - GameConfig.hungerDecayPerMinute * seconds / 60,
    );
  }

  PetStats feed(PetStats stats) => stats.copyWith(hunger: GameConfig.maxStat);

  PetStats apply(PetStats currentStats, Duration elapsed) {
    if (elapsed <= Duration.zero) {
      return currentStats;
    }

    final elapsedMinutes =
        elapsed.inMilliseconds / Duration.millisecondsPerMinute;

    return currentStats.copyWith(
      hunger:
          currentStats.hunger -
          (GameConfig.hungerDecayPerMinute * elapsedMinutes),
      energy:
          currentStats.energy -
          (GameConfig.energyDecayPerMinute * elapsedMinutes),
      happiness:
          currentStats.happiness -
          (GameConfig.happinessDecayPerMinute * elapsedMinutes),
      cleanliness:
          currentStats.cleanliness -
          (GameConfig.cleanlinessDecayPerMinute * elapsedMinutes),
    );
  }
}
