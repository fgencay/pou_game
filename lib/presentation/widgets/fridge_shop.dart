import 'package:flutter/material.dart';

import '../../core/config/game_assets.dart';
import '../../features/economy/models/food_purchase.dart';
import 'food_item.dart';

class FridgeShop extends StatelessWidget {
  const FridgeShop({super.key, required this.coins, this.level = 1});
  final int coins;
  final int level;

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
                  for (final food in Food.values) ...[
                    () {
                      final isUnlocked = level >= food.requiredLevel;
                      final canAfford = coins >= food.price;
                      final canBuy = isUnlocked && canAfford;

                      return SizedBox(
                        width: 104,
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                FoodItem(food: food, size: 76),
                                if (!isUnlocked)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.lock,
                                          size: 10,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          'Lvl ${food.requiredLevel}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            Text(
                              food.label,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isUnlocked
                                    ? Colors.black
                                    : Colors.grey.shade600,
                              ),
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
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isUnlocked
                                        ? Colors.black
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            OutlinedButton(
                              key: ValueKey('buy-${food.name}'),
                              onPressed: canBuy
                                  ? () => Navigator.pop(context, food)
                                  : null,
                              child: const Text('Buy'),
                            ),
                            if (!isUnlocked)
                              Text(
                                'Lvl ${food.requiredLevel} Required',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF8B5E3C),
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            else if (!canAfford)
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
                      );
                    }(),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
