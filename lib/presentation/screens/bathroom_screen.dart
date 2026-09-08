import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../widgets/game_button.dart';
import '../widgets/room_screen_shell.dart';

class BathroomScreen extends StatelessWidget {
  const BathroomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoomScreenShell(
      title: 'Bathroom',
      accentColor: GameColors.sky,
      child: GameButton.home(context),
    );
  }
}
