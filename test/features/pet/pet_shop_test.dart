import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pou_game/core/config/game_assets.dart';
import 'package:pou_game/features/economy/models/food_purchase.dart';
import 'package:pou_game/features/pet/models/pet_inventory.dart';
import 'package:pou_game/features/pet/models/pet_type.dart';
import 'package:pou_game/presentation/screens/home_screen.dart';
import 'package:pou_game/presentation/widgets/pet_shop_dialog.dart';

void main() {
  test('PetInventory default cat is owned and equipped', () {
    final inventory = PetInventory();
    expect(inventory.isOwned(PetType.cat), isTrue);
    expect(inventory.isEquipped(PetType.cat), isTrue);
    expect(inventory.isOwned(PetType.dog), isFalse);
  });

  test('PetInventory buying dog deducts coins and equips dog', () {
    final inventory = PetInventory();
    final purchases = FoodPurchase(); // 250 coins
    expect(
      inventory.buy(PetType.dog, purchases.coins, purchases.spendCoins),
      isTrue,
    );
    expect(purchases.coins, 100);
    expect(inventory.isOwned(PetType.dog), isTrue);
    expect(inventory.isEquipped(PetType.dog), isTrue);
  });

  testWidgets('PetShopDialog displays Cat and Dog and allows buying Dog', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen(initialRoom: PetRoom.home)),
    );
    await tester.pump();

    await tester.tap(find.image(const AssetImage(GameAssets.shopNavigationButton)));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Pet Shop'), findsOneWidget);
    expect(find.text('Cat'), findsOneWidget);
    expect(find.text('Dog'), findsOneWidget);
    expect(find.byKey(const ValueKey('buy-dog')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('buy-dog')));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('100'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });
}
