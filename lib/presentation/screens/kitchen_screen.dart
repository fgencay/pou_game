import 'package:flutter/material.dart';

import 'home_screen.dart';

class KitchenScreen extends StatelessWidget {
  const KitchenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreen(initialRoom: PetRoom.kitchen);
  }
}
