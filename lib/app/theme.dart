import 'package:flutter/material.dart';

class PouGameTheme {
  const PouGameTheme._();

  static ThemeData get materialTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: GameColors.leaf),
      fontFamily: 'Arial',
      scaffoldBackgroundColor: GameColors.sky,
      useMaterial3: true,
    );
  }
}

class GameColors {
  const GameColors._();

  static const sky = Color(0xFFEAF7FF);
  static const grass = Color(0xFF8FD16A);
  static const leaf = Color(0xFF67B26F);
  static const sun = Color(0xFFFFD166);
  static const berry = Color(0xFFEF476F);
  static const ink = Color(0xFF213547);
  static const panel = Color(0xFFFFFFFF);
}

class GameSpacing {
  const GameSpacing._();

  static const xs = 6.0;
  static const sm = 10.0;
  static const md = 16.0;
  static const lg = 24.0;
  static const xl = 32.0;
}

class GameRadius {
  const GameRadius._();

  static const sm = 8.0;
  static const md = 14.0;
  static const lg = 22.0;
}

class GameTextStyles {
  const GameTextStyles._();

  static const title = TextStyle(
    color: GameColors.ink,
    fontSize: 32,
    fontWeight: FontWeight.w800,
  );

  static const roomTitle = TextStyle(
    color: GameColors.ink,
    fontSize: 28,
    fontWeight: FontWeight.w800,
  );

  static const button = TextStyle(
    color: GameColors.ink,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );

  static const body = TextStyle(
    color: GameColors.ink,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
}
