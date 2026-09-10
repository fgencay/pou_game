import '../../../core/config/game_config.dart';

class PlayReward {
  const PlayReward({
    required this.coins,
    required this.xp,
    required this.energy,
  });
  final int coins;
  final int xp;
  final double energy;
}

class PlaySession {
  int _seconds = 0;
  int _lines = 0;
  bool _claimed = false;
  int get lines => _lines;
  int get coins => _lines * GameConfig.playCoinsPerLine;
  int get xp =>
      (_seconds ~/ GameConfig.playXpIntervalSeconds) *
      GameConfig.playXpPerInterval;

  void clearLines(int count) {
    if (count < 0) throw ArgumentError.value(count, 'count');
    if (!_claimed) _lines += count;
  }

  PlayReward tick() {
    if (_claimed) return const PlayReward(coins: 0, xp: 0, energy: 0);
    _seconds++;
    return const PlayReward(
      coins: 0,
      xp: 0,
      energy: GameConfig.playEnergyPerMinute / 60,
    );
  }

  PlayReward claim() {
    if (_claimed) return const PlayReward(coins: 0, xp: 0, energy: 0);
    _claimed = true;
    return PlayReward(coins: coins, xp: xp, energy: 0);
  }
}
