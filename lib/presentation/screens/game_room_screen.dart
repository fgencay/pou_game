import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../widgets/game_button.dart';
import '../widgets/room_screen_shell.dart';

class GameRoomScreen extends StatelessWidget {
  const GameRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoomScreenShell(
      title: 'Game Room',
      accentColor: GameColors.berry,
      child: GameButton.home(context),
    );
  }
}
