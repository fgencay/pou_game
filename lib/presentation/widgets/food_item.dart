import 'package:flutter/material.dart';

import '../../features/economy/models/food_purchase.dart';

class FoodItem extends StatelessWidget {
  const FoodItem({super.key, required this.food, required this.size});
  final Food food;
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: food.asset != null
        ? Image.asset(
            food.asset!,
            fit: BoxFit.contain,
            semanticLabel: food.label,
          )
        : Icon(
            food.icon,
            size: size * 0.85,
            color: food.color,
            semanticLabel: food.label,
          ),
  );
}
