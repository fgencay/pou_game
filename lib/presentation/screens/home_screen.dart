import 'dart:ui' as ui;
import '../widgets/pet_progress_dialog.dart';
import '../../features/economy/models/play_session.dart';
import 'game_room_screen.dart';
import 'tetris_screen.dart';

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/config/game_assets.dart';
import '../../core/config/game_config.dart';
import '../../features/economy/models/player_progress.dart';
import '../../features/pet/models/pet_stats.dart';
import '../../game/pet_game.dart';
import '../widgets/room_navigation.dart';
import '../widgets/draggable_food_item.dart';
import '../../features/pet/domain/pet_stat_decay.dart';
import '../widgets/fridge_shop.dart';
import '../../features/economy/models/food_purchase.dart';

enum PetRoom { home, kitchen }

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.playerProgress = const PlayerProgress(),
    this.initialRoom = PetRoom.home,
  });
  final PlayerProgress playerProgress;

  final PetRoom initialRoom;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FoodPurchase _purchases = FoodPurchase();
  late PlayerProgress _progress = widget.playerProgress;
  late final PetGame _game = PetGame(onTimeElapsed: _decayHunger);
  final GlobalKey _petPanelKey = GlobalKey();
  static const _statRules = PetStatDecay();
  PetStats petStats = PetStats();
  late PetRoom _room = widget.initialRoom;
  bool get _isKitchen => _room == PetRoom.kitchen;

  @override
  Widget build(BuildContext context) {
    final bottomNavigationHeight = _bottomNavigationHeight(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            _isKitchen
                ? GameAssets.kitchenRoomBackground
                : GameAssets.homeRoomBackground,
            fit: BoxFit.cover,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: GameColors.sky.withValues(alpha: 0.08),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                GameSpacing.lg,
                GameSpacing.lg,
                GameSpacing.lg,
                bottomNavigationHeight + GameSpacing.md,
              ),
              child: _PetGamePanel(key: _petPanelKey, game: _game),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: GameSpacing.sm,
                  right: GameSpacing.sm,
                  top: GameSpacing.xs,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _TopHud(
                      coinAmount: _purchases.coins,
                      stats: petStats,
                      level: _progress.level,
                      onLevelPressed: _openProgress,
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: RoomNavigation(
                        roomName: _isKitchen ? 'Kitchen' : 'Home',
                        onPrevious: _isKitchen
                            ? () => setState(() => _room = PetRoom.home)
                            : null,
                        onNext: _isKitchen
                            ? null
                            : () => setState(() => _room = PetRoom.kitchen),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _BottomNavigationOverlay(
              height: bottomNavigationHeight,
              isKitchen: _isKitchen,
              food: _purchases.selected,
              onFridgePressed: _openFridge,
              onGamesPressed: _openGames,
              foodCount: _purchases.quantity(_purchases.selected),
              onFoodDropped: _feedAt,
            ),
          ),
        ],
      ),
    );
  }

  void _decayHunger(double seconds) {
    if (!mounted) return;
    final next = _statRules.applyHunger(petStats, seconds);
    if (next != petStats) setState(() => petStats = next);
  }

  void _feedAt(Food food, Offset globalPoint) {
    final box = _petPanelKey.currentContext?.findRenderObject();
    if (!_isKitchen ||
        box is! RenderBox ||
        !_game.canFeedAt(box.globalToLocal(globalPoint))) {
      return;
    }
    if (!_purchases.consume(food)) return;
    setState(() => petStats = _statRules.feed(petStats));
    _game.reactToFood();
  }

  void _openProgress() {
    showDialog<void>(
      context: context,
      builder: (_) => PetProgressDialog(progress: _progress),
    );
  }

  void _applyPlayReward(PlayReward reward) {
    if (!mounted) return;
    setState(() {
      _purchases.earnCoins(reward.coins);
      _progress = _progress.earnXp(reward.xp);
      petStats = petStats.copyWith(energy: petStats.energy - reward.energy);
    });
  }

  Future<void> _openGames() async {
    _game.pauseEngine();
    try {
      final play = await showDialog<bool>(
        context: context,
        builder: (_) => const GameRoomScreen(),
      );
      if (play == true && mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (_) => TetrisScreen(
              initialEnergy: petStats.energy,
              onReward: _applyPlayReward,
            ),
          ),
        );
      }
    } finally {
      if (mounted) _game.resumeEngine();
    }
  }

  Future<void> _openFridge() async {
    final food = await showDialog<Food>(
      context: context,
      builder: (_) => FridgeShop(coins: _purchases.coins),
    );
    if (!mounted || food == null) return;
    setState(() {
      _purchases.buy(food);
    });
  }

  double _bottomNavigationHeight(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return (size.height * 0.2).clamp(136.0, 190.0);
  }
}

class _TopHud extends StatelessWidget {
  const _TopHud({
    required this.coinAmount,
    required this.stats,
    required this.level,
    required this.onLevelPressed,
  });

  final int coinAmount;
  final VoidCallback onLevelPressed;
  final int level;
  final PetStats stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CoinCounter(amount: coinAmount),
        const SizedBox(width: GameSpacing.xs),
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.topCenter,
            child: _StatHud(stats: stats),
          ),
        ),
        const SizedBox(width: GameSpacing.xs),
        Semantics(
          button: true,
          label: 'Pet level',
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            key: const ValueKey('pet-level-button'),
            onTap: onLevelPressed,
            child: _LevelCounter(level: level),
          ),
        ),
      ],
    );
  }
}

class _CoinCounter extends StatelessWidget {
  const _CoinCounter({required this.amount});

  final int amount;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final iconSize = (screenWidth * 0.13).clamp(42.0, 62.0);
    final fontSize = (screenWidth * 0.056).clamp(18.0, 26.0);
    final text = amount.toString();

    return SizedBox(
      width: iconSize * 0.58 + fontSize * 2,
      height: iconSize + fontSize * 0.35,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            GameAssets.coinIcon,
            width: iconSize,
            height: iconSize,
            fit: BoxFit.contain,
          ),
          Positioned(
            left: iconSize * 0.58,
            top: iconSize * 0.48,
            child: _OutlinedAmountText(text: text, fontSize: fontSize),
          ),
        ],
      ),
    );
  }
}

class _LevelCounter extends StatelessWidget {
  const _LevelCounter({required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    // Compensate for the wider transparent margins in the level PNG.
    final iconSize = (screenWidth * 0.13).clamp(42.0, 62.0) * 1.3;
    final fontSize = (screenWidth * 0.07).clamp(22.0, 32.0);

    return SizedBox.square(
      dimension: iconSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: Image.asset(GameAssets.levelIcon)),
          Transform.translate(
            offset: Offset(0, iconSize * -0.03),
            child: _OutlinedAmountText(
              text: level.toString(),
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatHud extends StatelessWidget {
  const _StatHud({required this.stats});

  final PetStats stats;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final iconSize = (screenWidth * 0.145).clamp(46.0, 66.0);
    final health =
        (stats.hunger + stats.energy + stats.happiness + stats.cleanliness) / 4;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StatStatusIcon(
          assetPath: GameAssets.hungerIcon,
          value: stats.hunger,
          iconSize: iconSize,
        ),
        const SizedBox(width: 1),
        _StatStatusIcon(
          assetPath: GameAssets.healthIcon,
          value: health,
          iconSize: iconSize,
        ),
        const SizedBox(width: 1),
        _StatStatusIcon(
          assetPath: GameAssets.toiletIcon,
          value: stats.cleanliness,
          iconSize: iconSize,
        ),
        const SizedBox(width: 1),
        _StatStatusIcon(
          assetPath: GameAssets.energyIcon,
          value: stats.energy,
          iconSize: iconSize,
        ),
      ],
    );
  }
}

class _StatStatusIcon extends StatelessWidget {
  const _StatStatusIcon({
    required this.assetPath,
    required this.value,
    required this.iconSize,
  });

  final String assetPath;
  final double value;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final fill =
        ((value - GameConfig.minStat) /
                (GameConfig.maxStat - GameConfig.minStat))
            .clamp(0.0, 1.0)
            .toDouble();

    return SizedBox.square(
      dimension: iconSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(child: Image.asset(assetPath, fit: BoxFit.contain)),
          Positioned(
            left: iconSize * 0.11,
            right: iconSize * 0.11,
            bottom: iconSize * 0.06,
            child: _StatFillBar(
              fill: fill,
              color: _statFillColor(fill),
              height: iconSize * 0.12,
            ),
          ),
        ],
      ),
    );
  }

  Color _statFillColor(double fill) {
    if (fill <= 0.3) {
      return const Color(0xFFE84A4A);
    }
    if (fill <= 0.65) {
      return const Color(0xFFFFB13B);
    }
    return const Color(0xFF5ED45A);
  }
}

class _StatFillBar extends StatelessWidget {
  const _StatFillBar({
    required this.fill,
    required this.color,
    required this.height,
  });

  final double fill;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xAA5A4845),
          borderRadius: BorderRadius.circular(99),
          border: Border.all(color: const Color(0xCCFFFFFF), width: 1.2),
        ),
        child: Padding(
          padding: EdgeInsets.all(height * 0.16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: fill,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(99),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x55FFFFFF),
                      offset: Offset(0, -1),
                      blurRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlinedAmountText extends StatelessWidget {
  const _OutlinedAmountText({required this.text, required this.fontSize});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      letterSpacing: 0,
      height: 0.95,
      shadows: const [
        Shadow(color: Color(0x99000000), offset: Offset(0, 2), blurRadius: 2),
      ],
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: baseStyle.copyWith(
            foreground: ui.Paint()
              ..style = ui.PaintingStyle.stroke
              ..strokeWidth = 5
              ..color = const Color(0xFF4B3D39),
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: baseStyle.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}

class _BottomNavigationOverlay extends StatelessWidget {
  const _BottomNavigationOverlay({
    required this.height,
    required this.isKitchen,
    required this.food,
    required this.onFridgePressed,
    required this.onGamesPressed,
    required this.foodCount,
    required this.onFoodDropped,
  });
  final bool isKitchen;
  final Food food;
  final VoidCallback onFridgePressed;
  final VoidCallback onGamesPressed;
  final int foodCount;
  final void Function(Food, Offset) onFoodDropped;

  final double height;

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.paddingOf(context).bottom;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final availableHeight = height - GameSpacing.sm;
    final labelSize = (screenWidth * 0.055).clamp(18.0, 25.0);
    final labelHeight = labelSize + 8;
    final widthBasedIconSize = (screenWidth * 0.26).clamp(86.0, 124.0);
    final heightBasedIconSize = availableHeight - labelHeight - GameSpacing.xs;
    final iconSize = widthBasedIconSize < heightBasedIconSize
        ? widthBasedIconSize
        : heightBasedIconSize;

    return SizedBox(
      height: height + safeBottom,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          GameSpacing.xs,
          0,
          GameSpacing.xs,
          safeBottom + GameSpacing.sm,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (isKitchen)
              SizedBox(
                width: iconSize + 28,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DraggableFoodItem(
                      food: food,
                      size: iconSize,
                      count: foodCount,
                      onDropped: onFoodDropped,
                    ),
                    SizedBox(height: 1 + labelHeight),
                  ],
                ),
              )
            else
              _NavigationImageItem(
                assetPath: GameAssets.joystickNavigationButton,
                label: 'Games',
                iconSize: iconSize,
                labelSize: labelSize,
                onPressed: onGamesPressed,
              ),
            _NavigationImageItem(
              assetPath: isKitchen
                  ? GameAssets.fridgeIcon
                  : GameAssets.shopNavigationButton,
              label: isKitchen ? 'Fridge' : 'Shop',
              iconSize: iconSize,
              labelSize: labelSize,
              onPressed: isKitchen ? onFridgePressed : () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _NavigationImageItem extends StatelessWidget {
  const _NavigationImageItem({
    required this.assetPath,
    required this.label,
    required this.iconSize,
    required this.labelSize,
    required this.onPressed,
  });

  final String assetPath;
  final String label;
  final double iconSize;
  final double labelSize;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onPressed,
        child: SizedBox(
          width: iconSize + 28,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox.square(
                dimension: iconSize,
                child: Image.asset(assetPath, fit: BoxFit.contain),
              ),
              const SizedBox(height: 1),
              _OutlinedGameLabel(text: label, fontSize: labelSize),
            ],
          ),
        ),
      ),
    );
  }
}

class _OutlinedGameLabel extends StatelessWidget {
  const _OutlinedGameLabel({required this.text, required this.fontSize});

  final String text;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final baseStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w900,
      letterSpacing: 0,
      height: 1,
      shadows: const [
        Shadow(color: Color(0x99000000), offset: Offset(0, 2), blurRadius: 2),
      ],
    );

    return SizedBox(
      height: fontSize + 8,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            text,
            textAlign: TextAlign.center,
            style: baseStyle.copyWith(
              foreground: ui.Paint()
                ..style = ui.PaintingStyle.stroke
                ..strokeWidth = 4.5
                ..color = const Color(0xFF3D312E),
            ),
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: baseStyle.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _PetGamePanel extends StatelessWidget {
  const _PetGamePanel({super.key, required this.game});
  final PetGame game;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(GameRadius.lg),
      child: GameWidget(
        game: game,
        backgroundBuilder: (_) => const SizedBox.expand(),
      ),
    );
  }
}
