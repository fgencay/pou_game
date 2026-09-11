import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pou_game/core/config/game_assets.dart';
import 'package:pou_game/features/economy/models/food_purchase.dart';
import 'package:pou_game/features/pet/domain/pet_stat_decay.dart';
import 'package:pou_game/features/pet/models/pet_stats.dart';
import 'package:pou_game/presentation/screens/home_screen.dart';
import 'package:pou_game/presentation/widgets/draggable_food_item.dart';

void main() {
  test(
    'food fills hunger without exceeding 100; time only decreases hunger',
    () {
      const rules = PetStatDecay();
      expect(rules.feed(PetStats(hunger: 20), amount: 25).hunger, 45);
      expect(rules.feed(PetStats(), amount: 25).hunger, 100);
      final after = rules.applyHunger(PetStats(), 60);
      expect(after.hunger, closeTo(99.55, 0.001));
      expect(after.energy, 100);
      expect(rules.applyHunger(after, 1000000).hunger, 0);
    },
  );

  test('eating consumes one purchased unit and cannot consume empty stock', () {
    final inventory = FoodPurchase();
    expect(inventory.consume(Food.apple), isFalse);
    inventory.buy(Food.apple);
    inventory.buy(Food.fish);
    expect(inventory.consume(Food.fish), isTrue);
    expect(inventory.quantity(Food.fish), 0);
    expect(inventory.selected, Food.apple);
    expect(inventory.consume(Food.fish), isFalse);
    expect(inventory.coins, 215);
  });

  testWidgets('food dropped outside returns; dropping on cat consumes it', (
    tester,
  ) async {
    final gameFinder = find.byWidgetPredicate((w) => w is GameWidget);
    await tester.runAsync(() async {
      await tester.pumpWidget(
        const MaterialApp(home: HomeScreen(initialRoom: PetRoom.kitchen)),
      );
      await tester.pump();
      final game = tester.widget<GameWidget>(gameFinder).game!;
      await Future<void>.sync(
        game.toBeLoaded,
      ).timeout(const Duration(seconds: 15));
    });
    await tester.pump();
    await tester.tap(find.image(const AssetImage(GameAssets.fridgeIcon)));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byKey(const ValueKey('buy-apple')));
    await tester.pump(const Duration(milliseconds: 300));
    final foodFinder = find.byType(DraggableFoodItem);
    final start = tester.getCenter(foodFinder);
    await tester.dragFrom(start, const Offset(0, -40));
    await tester.pump();
    expect(tester.widget<DraggableFoodItem>(foodFinder).count, 1);
    final rect = tester.getRect(gameFinder);
    final target = Offset(rect.center.dx, rect.top + rect.height * 0.68);
    await tester.dragFrom(
      tester.getCenter(foodFinder),
      target - tester.getCenter(foodFinder),
    );
    await tester.pump();
    expect(tester.widget<DraggableFoodItem>(foodFinder).count, 0);
    expect(tester.takeException(), isNull);
  });
}
