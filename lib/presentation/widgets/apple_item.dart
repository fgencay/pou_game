import 'package:flutter/material.dart';

import '../../core/config/game_assets.dart';

class AppleItem extends StatelessWidget {
  const AppleItem({super.key, required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Image.asset(
        GameAssets.apple,
        fit: BoxFit.contain,
        semanticLabel: 'Apple',
      ),
    );
  }
}
