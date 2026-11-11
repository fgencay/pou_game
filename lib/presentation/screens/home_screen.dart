import 'dart:async';
import 'dart:ui' as ui;
import 'package:audioplayers/audioplayers.dart';
import 'package:video_player/video_player.dart';
import '../widgets/pet_progress_dialog.dart';
import '../../features/economy/models/play_session.dart';
import 'game_room_screen.dart';
import 'tetris_screen.dart';
import 'flappy_cube_screen.dart';
import '../../features/pet/models/pet_inventory.dart';
import '../../features/pet/models/pet_type.dart';
import '../widgets/pet_shop_dialog.dart';

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

enum PetRoom { home, kitchen, bathroom, bedroom }

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.playerProgress = const PlayerProgress(),
    this.initialRoom = PetRoom.home,
    this.initialPet = PetType.cat,
  });
  final PlayerProgress playerProgress;
  final PetRoom initialRoom;
  final PetType initialPet;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FoodPurchase _purchases = FoodPurchase();
  late final PetInventory _petInventory = PetInventory(
    ownedPets: {widget.initialPet},
    activePet: widget.initialPet,
  );
  late PlayerProgress _progress = widget.playerProgress;
  late final PetGame _game = PetGame(
    onTimeElapsed: _updateStatsOverTime,
    initialPet: widget.initialPet,
  );
  final GlobalKey _petPanelKey = GlobalKey();
  static const _statRules = PetStatDecay();
  PetStats petStats = PetStats();
  late PetRoom _room = widget.initialRoom;
  bool _isSleeping = false;
  bool _isPlayingToiletVideo = false;
  bool get _isKitchen => _room == PetRoom.kitchen;
  bool get _isBathroom => _room == PetRoom.bathroom;
  bool get _isBedroom => _room == PetRoom.bedroom;

  bool get _isPetSad {
    final health = (petStats.hunger + petStats.energy + petStats.cleanliness) / 3;
    return petStats.hunger <= 65.0 ||
        health <= 65.0 ||
        petStats.cleanliness <= 65.0 ||
        petStats.energy <= 65.0;
  }

  void _syncPetSadState() {
    _game.setSad(_isPetSad);
  }

  @override
  void initState() {
    super.initState();
    _syncPetSadState();
  }

  void _setRoom(PetRoom newRoom) {
    setState(() {
      _room = newRoom;
      _isSleeping = false;
      _isPlayingToiletVideo = false;
    });
    _game.setPetVisible(true);
  }

  String get _roomBackground {
    switch (_room) {
      case PetRoom.kitchen:
        return GameAssets.kitchenRoomBackground;
      case PetRoom.bathroom:
        return GameAssets.bathroomRoomBackground;
      case PetRoom.bedroom:
        if (_isSleeping) {
          switch (_petInventory.activePet) {
            case PetType.dog:
              return GameAssets.bedroomSleepDogBackground;
            case PetType.bird:
              return GameAssets.bedroomSleepBirdBackground;
            case PetType.panda:
              return GameAssets.bedroomSleepPandaBackground;
            case PetType.rabbit:
              return GameAssets.bedroomSleepRabbitBackground;
            case PetType.cat2:
              return GameAssets.bedroomSleepCat2Background;
            case PetType.dog2:
              return GameAssets.bedroomSleepDog2Background;
            case PetType.leon:
              return GameAssets.bedroomSleepLeonBackground;
            case PetType.duck:
              return GameAssets.bedroomSleepDuckBackground;
            case PetType.parrot:
              return GameAssets.bedroomSleepParrotBackground;
            case PetType.cat:
              return GameAssets.bedroomSleepBackground;
          }
        }
        return GameAssets.bedroomRoomBackground;
      case PetRoom.home:
        return GameAssets.homeRoomBackground;
    }
  }

  String get _toiletVideoAsset {
    switch (_petInventory.activePet) {
      case PetType.dog:
        return GameAssets.dogToiletVideo;
      case PetType.bird:
        return GameAssets.birdToiletVideo;
      case PetType.panda:
        return GameAssets.pandaToiletVideo;
      case PetType.rabbit:
        return GameAssets.rabbitToiletVideo;
      case PetType.cat2:
        return GameAssets.cat2ToiletVideo;
      case PetType.dog2:
        return GameAssets.dog2ToiletVideo;
      case PetType.leon:
        return GameAssets.leonToiletVideo;
      case PetType.duck:
        return GameAssets.duckToiletVideo;
      case PetType.parrot:
        return GameAssets.parrotToiletVideo;
      case PetType.cat:
        return GameAssets.catToiletVideo;
    }
  }

  String get _roomName {
    switch (_room) {
      case PetRoom.kitchen:
        return 'Kitchen';
      case PetRoom.bathroom:
        return 'Bathroom';
      case PetRoom.bedroom:
        return 'Bedroom';
      case PetRoom.home:
        return 'Home';
    }
  }

  VoidCallback? get _onPreviousRoom {
    switch (_room) {
      case PetRoom.home:
        return null;
      case PetRoom.kitchen:
        return () => _setRoom(PetRoom.home);
      case PetRoom.bathroom:
        return () => _setRoom(PetRoom.kitchen);
      case PetRoom.bedroom:
        return () => _setRoom(PetRoom.bathroom);
    }
  }

  VoidCallback? get _onNextRoom {
    switch (_room) {
      case PetRoom.home:
        return () => _setRoom(PetRoom.kitchen);
      case PetRoom.kitchen:
        return () => _setRoom(PetRoom.bathroom);
      case PetRoom.bathroom:
        return () => _setRoom(PetRoom.bedroom);
      case PetRoom.bedroom:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomNavigationHeight = _bottomNavigationHeight(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            _roomBackground,
            fit: BoxFit.cover,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: GameColors.sky.withValues(alpha: 0.08),
            ),
          ),
          if (_isPlayingToiletVideo)
            Positioned.fill(
              child: _ToiletVideoOverlay(
                videoAssetPath: _toiletVideoAsset,
                onStarted: _onToiletVideoStarted,
                onFinished: _onToiletVideoFinished,
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
                        roomName: _roomName,
                        onPrevious: _onPreviousRoom,
                        onNext: _onNextRoom,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isSleeping)
            Positioned(
              top: MediaQuery.paddingOf(context).top + 185,
              left: 0,
              right: 0,
              child: const IgnorePointer(
                child: Center(
                  child: _SleepingZzzWidget(),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _BottomNavigationOverlay(
              height: bottomNavigationHeight,
              room: _room,
              food: _purchases.selected,
              onFridgePressed: _openFridge,
              onGamesPressed: _openGames,
              onToiletPressed: _cleanPet,
              onLampPressed: _sleepPet,
              onShopPressed: _openPetShop,
              foodCount: _purchases.quantity(_purchases.selected),
              onFoodDropped: _feedAt,
            ),
          ),
        ],
      ),
    );
  }

  void _updateStatsOverTime(double seconds) {
    if (!mounted) return;
    final next = _statRules.updateTime(
      petStats,
      seconds,
      isSleeping: _isSleeping,
    );
    if (next != petStats) {
      setState(() => petStats = next);
      _syncPetSadState();
    }
  }

  void _cleanPet() {
    setState(() {
      _isPlayingToiletVideo = true;
    });
  }

  void _onToiletVideoStarted() {
    if (!mounted) return;
    _game.setPetVisible(false);
  }

  void _onToiletVideoFinished() {
    if (!mounted) return;
    setState(() {
      _isPlayingToiletVideo = false;
      petStats = _statRules.clean(petStats);
      _progress = _progress.earnXp(25);
    });
    _syncPetSadState();
    _game.setPetVisible(true);
  }

  void _sleepPet() {
    setState(() {
      _isSleeping = !_isSleeping;
    });
    _game.setPetVisible(!_isSleeping);
  }

  void _feedAt(Food food, Offset globalPoint) {
    final box = _petPanelKey.currentContext?.findRenderObject();
    if (!_isKitchen ||
        box is! RenderBox ||
        !_game.canFeedAt(box.globalToLocal(globalPoint))) {
      return;
    }
    if (!_purchases.consume(food)) return;
    final fillAmount = (food.price * 0.8).clamp(20.0, 35.0);
    setState(() => petStats = _statRules.feed(petStats, amount: fillAmount));
    _syncPetSadState();
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
    _syncPetSadState();
  }

  Future<void> _openGames() async {
    _game.pauseEngine();
    try {
      final play = await showDialog<dynamic>(
        context: context,
        builder: (_) => const GameRoomScreen(),
      );
      if (play != null && mounted) {
        if (play == MiniGameType.flappyCube) {
          await Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (_) => FlappyCubeScreen(
                initialEnergy: petStats.energy,
                onReward: _applyPlayReward,
              ),
            ),
          );
        } else {
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
      }
    } finally {
      if (mounted) _game.resumeEngine();
    }
  }

  Future<void> _openFridge() async {
    final food = await showDialog<Food>(
      context: context,
      builder: (_) => FridgeShop(
        coins: _purchases.coins,
        level: _progress.level,
      ),
    );
    if (!mounted || food == null) return;
    setState(() {
      _purchases.buy(food, playerLevel: _progress.level);
    });
  }

  Future<void> _openPetShop() async {
    _game.pauseEngine();
    try {
      final pet = await showDialog<PetType>(
        context: context,
        builder: (_) => PetShopDialog(
          coins: _purchases.coins,
          inventory: _petInventory,
        ),
      );
      if (!mounted || pet == null) return;

      if (!_petInventory.isOwned(pet)) {
        if (_purchases.coins >= pet.price) {
          setState(() {
            _petInventory.buy(pet, _purchases.coins, (price) {
              _purchases.spendCoins(price);
            });
          });
          _game.setPetType(pet);
          _syncPetSadState();
        }
      } else {
        setState(() {
          _petInventory.select(pet);
        });
        _game.setPetType(pet);
        _syncPetSadState();
      }
    } finally {
      if (mounted) _game.resumeEngine();
    }
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
        (stats.hunger + stats.energy + stats.cleanliness) / 3;

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
    required this.room,
    required this.food,
    required this.onFridgePressed,
    required this.onGamesPressed,
    required this.onToiletPressed,
    required this.onLampPressed,
    required this.onShopPressed,
    required this.foodCount,
    required this.onFoodDropped,
  });
  final PetRoom room;
  final Food food;
  final VoidCallback onFridgePressed;
  final VoidCallback onGamesPressed;
  final VoidCallback onToiletPressed;
  final VoidCallback onLampPressed;
  final VoidCallback onShopPressed;
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
            if (room == PetRoom.kitchen)
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
            else if (room == PetRoom.home)
              _NavigationImageItem(
                assetPath: GameAssets.joystickNavigationButton,
                label: 'Games',
                iconSize: iconSize,
                labelSize: labelSize,
                onPressed: onGamesPressed,
              )
            else
              SizedBox(width: iconSize + 28),
            if (room == PetRoom.kitchen)
              _NavigationImageItem(
                assetPath: GameAssets.fridgeIcon,
                label: 'Fridge',
                iconSize: iconSize,
                labelSize: labelSize,
                onPressed: onFridgePressed,
              )
            else if (room == PetRoom.bathroom)
              _NavigationImageItem(
                assetPath: GameAssets.toiletNavigationButton,
                label: 'Bathroom',
                iconSize: iconSize,
                labelSize: labelSize,
                onPressed: onToiletPressed,
              )
            else if (room == PetRoom.bedroom)
              _NavigationImageItem(
                assetPath: GameAssets.lampNavigationButton,
                label: 'Bedroom',
                iconSize: iconSize,
                labelSize: labelSize,
                onPressed: onLampPressed,
              )
            else
              _NavigationImageItem(
                assetPath: GameAssets.shopNavigationButton,
                label: 'Shop',
                iconSize: iconSize,
                labelSize: labelSize,
                onPressed: onShopPressed,
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

class _SleepingZzzWidget extends StatefulWidget {
  const _SleepingZzzWidget();

  @override
  State<_SleepingZzzWidget> createState() => _SleepingZzzWidgetState();
}

class _SleepingZzzWidgetState extends State<_SleepingZzzWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  late final Animation<double> _scaleAnimation = Tween<double>(
    begin: 0.95,
    end: 1.15,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  late final Animation<double> _offsetAnimation = Tween<double>(
    begin: 0.0,
    end: -10.0,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _offsetAnimation.value),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  'Z z z . . .',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    foreground: ui.Paint()
                      ..style = ui.PaintingStyle.stroke
                      ..strokeWidth = 3.5
                      ..color = const Color(0xFF1E1B4B),
                  ),
                ),
                const Text(
                  'Z z z . . .',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: Color(0xFFFFE066),
                    shadows: [
                      Shadow(
                        color: Color(0xFFFFB13B),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ToiletVideoOverlay extends StatefulWidget {
  const _ToiletVideoOverlay({
    required this.videoAssetPath,
    required this.onFinished,
    this.onStarted,
  });

  final String videoAssetPath;
  final VoidCallback onFinished;
  final VoidCallback? onStarted;

  @override
  State<_ToiletVideoOverlay> createState() => _ToiletVideoOverlayState();
}

class _ToiletVideoOverlayState extends State<_ToiletVideoOverlay> {
  VideoPlayerController? _controller;
  AudioPlayer? _sifonAudioPlayer;
  Timer? _durationTimer;
  Timer? _sifonTimer;
  bool _initialized = false;
  bool _finishedCalled = false;
  bool _sifonTriggered = false;

  @override
  void initState() {
    super.initState();
    _startPlayback();
  }

  void _startPlayback() async {
    try {
      final controller = VideoPlayerController.asset(widget.videoAssetPath);
      _controller = controller;
      await controller.initialize();
      if (!mounted) {
        controller.dispose();
        return;
      }

      await controller.setVolume(0.0);
      await controller.setLooping(false);
      controller.addListener(_onVideoTick);

      setState(() {
        _initialized = true;
      });

      await controller.play();
      widget.onStarted?.call();

      final videoDuration = controller.value.duration;
      final totalDuration = (videoDuration > Duration.zero)
          ? videoDuration
          : const Duration(seconds: 6);

      // Schedule sifon flush sound in the final portion of animation
      final sifonLeadTime = totalDuration.inMilliseconds > 7000
          ? const Duration(seconds: 4)
          : Duration(milliseconds: (totalDuration.inMilliseconds * 0.45).round());
      final sifonDelay = totalDuration - sifonLeadTime;

      if (sifonDelay > Duration.zero) {
        _sifonTimer = Timer(sifonDelay, () {
          if (mounted && !_sifonTriggered) {
            _playSifonSound();
          }
        });
      } else {
        _playSifonSound();
      }

      // Hard completion timer based on actual video duration
      _durationTimer = Timer(totalDuration, () {
        if (mounted) _callFinished();
      });
    } catch (_) {
      _callFinished();
    }
  }

  void _onVideoTick() {
    if (!mounted || _finishedCalled || _controller == null) return;
    final value = _controller!.value;
    if (!value.isInitialized) return;

    final position = value.position;
    final duration = value.duration;

    // Trigger completion if player is done or reached end
    if (value.isCompleted ||
        (duration > Duration.zero && position >= duration) ||
        (!value.isPlaying &&
            duration > Duration.zero &&
            position >= duration - const Duration(milliseconds: 250))) {
      _callFinished();
    }
  }

  void _playSifonSound() {
    if (_sifonTriggered || !mounted) return;
    _sifonTriggered = true;
    try {
      final player = AudioPlayer();
      _sifonAudioPlayer = player;
      player.play(AssetSource('audio/${GameAssets.sifonAudio}'));
      Timer(const Duration(seconds: 3), () {
        try {
          player.stop();
          player.dispose();
        } catch (_) {}
        if (_sifonAudioPlayer == player) {
          _sifonAudioPlayer = null;
        }
      });
    } catch (_) {}
  }

  void _callFinished() {
    if (_finishedCalled) return;
    _finishedCalled = true;

    _durationTimer?.cancel();
    _sifonTimer?.cancel();
    _controller?.removeListener(_onVideoTick);

    if (mounted) {
      widget.onFinished();
    }
  }

  @override
  void dispose() {
    _finishedCalled = true;
    _durationTimer?.cancel();
    _sifonTimer?.cancel();

    final player = _sifonAudioPlayer;
    _sifonAudioPlayer = null;
    if (player != null) {
      try {
        player.stop();
        player.dispose();
      } catch (_) {}
    }

    final controller = _controller;
    _controller = null;
    if (controller != null) {
      controller.removeListener(_onVideoTick);
      try {
        controller.pause();
        controller.dispose();
      } catch (_) {}
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (!_initialized || controller == null) {
      return const SizedBox.expand();
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        if (_initialized) _callFinished();
      },
      child: SizedBox.expand(
        child: ColoredBox(
          color: Colors.black,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          ),
        ),
      ),
    );
  }
}
