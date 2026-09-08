import '../../../core/config/game_config.dart';
import '../models/pet_stats.dart';

class PetStatDecay {
  const PetStatDecay();

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
