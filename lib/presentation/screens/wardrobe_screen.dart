import 'package:flutter/material.dart';

import '../widgets/game_button.dart';
import '../widgets/room_screen_shell.dart';

class WardrobeScreen extends StatelessWidget {
  const WardrobeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoomScreenShell(
      title: 'Wardrobe',
      accentColor: const Color(0xFFB8C0FF),
      child: GameButton.home(context),
    );
  }
}
