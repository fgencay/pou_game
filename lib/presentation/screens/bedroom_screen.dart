import 'package:flutter/material.dart';

import '../widgets/game_button.dart';
import '../widgets/room_screen_shell.dart';

class BedroomScreen extends StatelessWidget {
  const BedroomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoomScreenShell(
      title: 'Bedroom',
      accentColor: const Color(0xFFA8DADC),
      child: GameButton.home(context),
    );
  }
}
