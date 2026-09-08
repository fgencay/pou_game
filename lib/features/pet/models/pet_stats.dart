import '../../../core/config/game_config.dart';

class PetStats {
  PetStats({
    double hunger = GameConfig.defaultHunger,
    double energy = GameConfig.defaultEnergy,
    double happiness = GameConfig.defaultHappiness,
    double cleanliness = GameConfig.defaultCleanliness,
  }) : this._(
         hunger: hunger,
         energy: energy,
         happiness: happiness,
         cleanliness: cleanliness,
       );

  PetStats._({
    required double hunger,
    required double energy,
    required double happiness,
    required double cleanliness,
  }) : hunger = hunger.clamp(GameConfig.minStat, GameConfig.maxStat),
       energy = energy.clamp(GameConfig.minStat, GameConfig.maxStat),
       happiness = happiness.clamp(GameConfig.minStat, GameConfig.maxStat),
       cleanliness = cleanliness.clamp(GameConfig.minStat, GameConfig.maxStat);

  final double hunger;
  final double energy;
  final double happiness;
  final double cleanliness;

  bool get isHungry => hunger <= GameConfig.hungryThreshold;
  bool get isTired => energy <= GameConfig.tiredThreshold;
  bool get isUnhappy => happiness <= GameConfig.unhappyThreshold;
  bool get isDirty => cleanliness <= GameConfig.dirtyThreshold;

  PetStats copyWith({
    double? hunger,
    double? energy,
    double? happiness,
    double? cleanliness,
  }) {
    return PetStats(
      hunger: hunger ?? this.hunger,
      energy: energy ?? this.energy,
      happiness: happiness ?? this.happiness,
      cleanliness: cleanliness ?? this.cleanliness,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is PetStats &&
            hunger == other.hunger &&
            energy == other.energy &&
            happiness == other.happiness &&
            cleanliness == other.cleanliness;
  }

  @override
  int get hashCode {
    return Object.hash(hunger, energy, happiness, cleanliness);
  }
}
