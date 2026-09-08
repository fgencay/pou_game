import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../widgets/game_button.dart';
import '../widgets/room_screen_shell.dart';

class KitchenScreen extends StatelessWidget {
  const KitchenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RoomScreenShell(
      title: 'Kitchen',
      accentColor: GameColors.sun,
      child: GameButton.home(context),
    );
  }
}
