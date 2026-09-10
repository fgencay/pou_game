import 'package:flutter/material.dart';

import '../../core/config/game_assets.dart';
import '../../features/economy/models/food_purchase.dart';
import 'food_item.dart';

class FridgeShop extends StatelessWidget {
  const FridgeShop({super.key, required this.coins});
  final int coins;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFFFF0E5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFB58874), width: 2),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Fridge',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(GameAssets.coinIcon, width: 28, height: 28),
                  const SizedBox(width: 6),
                  Text(
                    '$coins',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  for (final food in Food.values)
                    SizedBox(
                      width: 104,
                      child: Column(
                        children: [
                          FoodItem(food: food, size: 76),
                          Text(
                            food.label,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                GameAssets.coinIcon,
                                width: 20,
                                height: 20,
                              ),
                              Text(
                                '${food.price}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          OutlinedButton(
                            key: ValueKey('buy-${food.name}'),
                            onPressed: coins >= food.price
                                ? () => Navigator.pop(context, food)
                                : null,
                            child: const Text('Buy'),
                          ),
                          if (coins < food.price)
                            const Text(
                              'Not enough coins',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFA33E3E),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
