import '../../../core/config/game_config.dart';

class PlayerProgress {
  const PlayerProgress({this.xp = GameConfig.defaultXp});

  final int xp;

  int get level {
    var currentLevel = 1;

    for (var index = 0; index < GameConfig.levelXpThresholds.length; index++) {
      if (xp >= GameConfig.levelXpThresholds[index]) {
        currentLevel = index + 1;
      }
    }

    if (xp >= GameConfig.levelXpThresholds.last) {
      return GameConfig.levelXpThresholds.length +
          (xp - GameConfig.levelXpThresholds.last) ~/
              GameConfig.extraLevelXpStep;
    }
    return currentLevel;
  }

  int get nextLevelXp {
    final nextIndex = level;
    if (nextIndex >= GameConfig.levelXpThresholds.length) {
      return GameConfig.levelXpThresholds.last +
          (level - GameConfig.levelXpThresholds.length + 1) *
              GameConfig.extraLevelXpStep;
    }

    return GameConfig.levelXpThresholds[nextIndex];
  }

  int get currentLevelXp {
    if (level <= GameConfig.levelXpThresholds.length) {
      return GameConfig.levelXpThresholds[level - 1];
    }
    return GameConfig.levelXpThresholds.last +
        (level - GameConfig.levelXpThresholds.length) *
            GameConfig.extraLevelXpStep;
  }

  int get xpInLevel => xp - currentLevelXp;
  int get xpForLevel => nextLevelXp - currentLevelXp;
  int get xpRemaining => nextLevelXp - xp;
  double get levelProgress => (xpInLevel / xpForLevel).clamp(0.0, 1.0);

  PlayerProgress earnXp(int amount) {
    if (amount < 0) throw ArgumentError.value(amount, 'amount');
    return copyWith(xp: xp + amount);
  }

  PlayerProgress copyWith({int? xp}) {
    return PlayerProgress(xp: xp ?? this.xp);
  }
}
