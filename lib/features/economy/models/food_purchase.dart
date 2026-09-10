import 'package:flutter/material.dart';
import '../../../core/config/game_assets.dart';

enum Food {
  apple('Apple', 10, requiredLevel: 1, asset: GameAssets.apple),
  bread('Bread', 15, requiredLevel: 1, icon: Icons.bakery_dining, color: Color(0xFFC79047)),
  egg('Egg', 12, requiredLevel: 1, icon: Icons.egg_alt, color: Color(0xFFE7AD38)),
  cookie('Cookie', 18, requiredLevel: 2, icon: Icons.cookie, color: Color(0xFFA97852)),
  iceCream('Ice cream', 20, requiredLevel: 3, icon: Icons.icecream, color: Color(0xFFD586A3)),
  fish('Fish', 25, requiredLevel: 1, icon: Icons.set_meal, color: Color(0xFF529DA6)),
  pizza('Pizza', 30, requiredLevel: 4, icon: Icons.local_pizza, color: Color(0xFFD77339)),
  burger('Burger', 35, requiredLevel: 5, icon: Icons.lunch_dining, color: Color(0xFFD36224));

  const Food(
    this.label,
    this.price, {
    this.requiredLevel = 1,
    this.asset,
    this.icon,
    this.color,
  });
  final String label;
  final int price;
  final int requiredLevel;
  final String? asset;
  final IconData? icon;
  final Color? color;
}

class FoodPurchase {
  int _coins = 250;
  Food _selected = Food.apple;
  final Map<Food, int> _quantities = {};

  int get coins => _coins;
  Food get selected => _selected;
  int quantity(Food food) => _quantities[food] ?? 0;

  void earnCoins(int amount) {
    if (amount < 0) throw ArgumentError.value(amount, 'amount');
    _coins += amount;
  }

  bool spendCoins(int amount) {
    if (amount < 0) throw ArgumentError.value(amount, 'amount');
    if (_coins < amount) return false;
    _coins -= amount;
    return true;
  }

  bool consume(Food food) {
    if (quantity(food) <= 0) return false;
    _quantities[food] = quantity(food) - 1;
    if (quantity(_selected) == 0) {
      for (final candidate in Food.values) {
        if (quantity(candidate) > 0) {
          _selected = candidate;
          break;
        }
      }
    }
    return true;
  }

  bool buy(Food food, {int playerLevel = 100}) {
    if (playerLevel < food.requiredLevel) return false;
    if (_coins < food.price) return false;
    _coins -= food.price;
    _quantities[food] = quantity(food) + 1;
    _selected = food;
    return true;
  }
}
