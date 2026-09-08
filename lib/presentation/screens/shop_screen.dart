import 'package:flutter/material.dart';

import '../widgets/game_button.dart';
import '../widgets/room_screen_shell.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoomScreenShell(
      title: 'Shop',
      accentColor: const Color(0xFFFFA69E),
      child: GameButton.home(context),
    );
  }
}
