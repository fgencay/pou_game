import 'dart:ui' as ui;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/config/game_assets.dart';
import '../../core/config/game_config.dart';
import '../../features/pet/models/pet_stats.dart';
import '../../game/pet_game.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _startingCoinAmount = 250;

  @override
  Widget build(BuildContext context) {
    final bottomNavigationHeight = _bottomNavigationHeight(context);
    final petStats = PetStats();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(GameAssets.homeRoomBackground, fit: BoxFit.cover),
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
              child: const _PetGamePanel(),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: GameSpacing.sm,
                  top: GameSpacing.xs,
                ),
                child: _TopHud(
                  coinAmount: _startingCoinAmount,
                  stats: petStats,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _BottomNavigationOverlay(height: bottomNavigationHeight),
          ),
        ],
      ),
    );
  }

  double _bottomNavigationHeight(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return (size.height * 0.2).clamp(136.0, 190.0);
  }
}

class _TopHud extends StatelessWidget {
  const _TopHud({required this.coinAmount, required this.stats});

  final int coinAmount;
  final PetStats stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CoinCounter(amount: coinAmount),
        const SizedBox(width: GameSpacing.xs),
        _StatHud(stats: stats),
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
      width: iconSize + fontSize * 2.55,
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

class _StatHud extends StatelessWidget {
  const _StatHud({required this.stats});

  final PetStats stats;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final iconSize = (screenWidth * 0.125).clamp(42.0, 58.0);
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
  const _BottomNavigationOverlay({required this.height});

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
            _NavigationImageItem(
              assetPath: GameAssets.joystickNavigationButton,
              label: 'Games',
              iconSize: iconSize,
              labelSize: labelSize,
              onPressed: () {},
            ),
            _NavigationImageItem(
              assetPath: GameAssets.shopNavigationButton,
              label: 'Shop',
              iconSize: iconSize,
              labelSize: labelSize,
              onPressed: () {},
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
  const _PetGamePanel();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(GameRadius.lg),
      child: GameWidget(
        game: PetGame(),
        backgroundBuilder: (_) => const SizedBox.expand(),
      ),
    );
  }
}
