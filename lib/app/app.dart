import 'package:flutter/material.dart';

import '../presentation/screens/bathroom_screen.dart';
import '../presentation/screens/bedroom_screen.dart';
import '../presentation/screens/character_selection_screen.dart';
import '../presentation/screens/game_room_screen.dart';
import '../presentation/screens/home_screen.dart';
import '../presentation/screens/kitchen_screen.dart';
import '../presentation/screens/shop_screen.dart';
import '../presentation/screens/wardrobe_screen.dart';
import 'routes.dart';
import 'theme.dart';

class PouGameApp extends StatelessWidget {
  const PouGameApp({
    super.key,
    this.initialRoute = AppRoutes.selectCharacter,
  });

  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pou Game',
      debugShowCheckedModeBanner: false,
      theme: PouGameTheme.materialTheme,
      initialRoute: initialRoute,
      routes: {
        AppRoutes.selectCharacter: (_) => const CharacterSelectionScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.kitchen: (_) => const KitchenScreen(),
        AppRoutes.bathroom: (_) => const BathroomScreen(),
        AppRoutes.bedroom: (_) => const BedroomScreen(),
        AppRoutes.gameRoom: (_) => const GameRoomScreen(),
        AppRoutes.shop: (_) => const ShopScreen(),
        AppRoutes.wardrobe: (_) => const WardrobeScreen(),
      },
    );
  }
}
