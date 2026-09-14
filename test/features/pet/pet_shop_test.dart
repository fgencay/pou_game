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

  test('PetInventory buying panda for 200 coins deducts coins and equips panda', () {
    final inventory = PetInventory();
    final purchases = FoodPurchase(); // 250 coins
    expect(
      inventory.buy(PetType.panda, purchases.coins, purchases.spendCoins),
      isTrue,
    );
    expect(purchases.coins, 50);
    expect(inventory.isOwned(PetType.panda), isTrue);
    expect(inventory.isEquipped(PetType.panda), isTrue);
  });

  test('PetInventory buying rabbit for 200 coins deducts coins and equips rabbit', () {
    final inventory = PetInventory();
    final purchases = FoodPurchase(); // 250 coins
    expect(
      inventory.buy(PetType.rabbit, purchases.coins, purchases.spendCoins),
      isTrue,
    );
    expect(purchases.coins, 50);
    expect(inventory.isOwned(PetType.rabbit), isTrue);
    expect(inventory.isEquipped(PetType.rabbit), isTrue);
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

  testWidgets('PetShopDialog displays Rabbit and Panda with correct image paths', (
    tester,
  ) async {
    final inventory = PetInventory();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PetShopDialog(
            coins: 500,
            inventory: inventory,
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Rabbit'), findsOneWidget);
    expect(find.text('Panda'), findsOneWidget);
    expect(
      find.image(const AssetImage('assets/images/pets/cat/rabbit_idle.png')),
      findsOneWidget,
    );
    expect(
      find.image(const AssetImage('assets/images/pets/cat/panda_idle.png')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('buy-rabbit')), findsOneWidget);
    expect(find.byKey(const ValueKey('buy-panda')), findsOneWidget);
  });
}
