import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pou_game/core/config/game_assets.dart';
import 'package:pou_game/features/economy/models/food_purchase.dart';
import 'package:pou_game/presentation/screens/home_screen.dart';
import 'package:pou_game/presentation/widgets/food_item.dart';

void main() {
  test(
    'purchases debit once, select food, and preserve purchased quantities',
    () {
      final purchases = FoodPurchase();
      expect(purchases.buy(Food.fish), isTrue);
      expect(purchases.coins, 225);
      expect(purchases.selected, Food.fish);
      expect(purchases.buy(Food.apple), isTrue);
      expect(purchases.coins, 215);
      expect(purchases.selected, Food.apple);
      expect(purchases.quantity(Food.fish), 1);
      expect(purchases.quantity(Food.apple), 1);
    },
  );

  test('cannot buy level locked food if player level is lower than required level', () {
    final purchases = FoodPurchase();
    expect(purchases.buy(Food.burger, playerLevel: 1), isFalse);
    expect(purchases.coins, 250);
    expect(purchases.quantity(Food.burger), 0);

    expect(purchases.buy(Food.burger, playerLevel: 5), isTrue);
    expect(purchases.coins, 215);
    expect(purchases.quantity(Food.burger), 1);
  });

  test('can buy burger and deduct correct coin amount', () {
    final purchases = FoodPurchase();
    expect(purchases.buy(Food.burger), isTrue);
    expect(purchases.coins, 215);
    expect(purchases.selected, Food.burger);
    expect(purchases.quantity(Food.burger), 1);
  });


  test('insufficient funds never change balance, selection or quantities', () {
    final purchases = FoodPurchase();
    for (var i = 0; i < 10; i++) {
      expect(purchases.buy(Food.fish), isTrue);
    }
    expect(purchases.coins, 0);
    expect(purchases.buy(Food.apple), isFalse);
    expect(purchases.coins, 0);
    expect(purchases.selected, Food.fish);
    expect(purchases.quantity(Food.apple), 0);
    expect(purchases.quantity(Food.fish), 10);
  });

  testWidgets(
    'fridge purchases replace Kitchen food and retain coins across rooms',
    (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        const MaterialApp(home: HomeScreen(initialRoom: PetRoom.kitchen)),
      );
      await tester.pump();
      await tester.tap(find.image(const AssetImage(GameAssets.fridgeIcon)));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.ensureVisible(find.byKey(const ValueKey('buy-fish')));
      await tester.tap(find.byKey(const ValueKey('buy-fish')));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('225'), findsNWidgets(2));
      expect(tester.widget<FoodItem>(find.byType(FoodItem)).food, Food.fish);
      await tester.tap(find.image(const AssetImage(GameAssets.fridgeIcon)));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.ensureVisible(find.byKey(const ValueKey('buy-apple')));
      await tester.tap(find.byKey(const ValueKey('buy-apple')));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('215'), findsNWidgets(2));
      expect(tester.widget<FoodItem>(find.byType(FoodItem)).food, Food.apple);
      await tester.tap(find.byIcon(Icons.chevron_left_rounded));
      await tester.pump();
      expect(find.text('215'), findsNWidgets(2));
      await tester.tap(find.byIcon(Icons.chevron_right_rounded));
      await tester.pump();
      expect(tester.widget<FoodItem>(find.byType(FoodItem)).food, Food.apple);
      expect(tester.takeException(), isNull);
    },
  );
}
