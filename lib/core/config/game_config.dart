class GameConfig {
  const GameConfig._();

  static const minStat = 0.0;
  static const maxStat = 100.0;

  static const defaultHunger = maxStat;
  static const defaultEnergy = maxStat;
  static const defaultHappiness = maxStat;
  static const defaultCleanliness = maxStat;

  static const hungerDecayPerMinute = 0.45;
  static const energyDecayPerMinute = 0.18;
  static const happinessDecayPerMinute = 0.12;
  static const cleanlinessDecayPerMinute = 0.16;

  static const hungryThreshold = 35.0;
  static const tiredThreshold = 30.0;
  static const unhappyThreshold = 35.0;
  static const dirtyThreshold = 35.0;
}
