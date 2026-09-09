import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pou_game/app/app.dart';
import 'package:pou_game/core/config/game_assets.dart';

void main() {
  testWidgets('opens home screen with the pet game area', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PouGameApp());
    await tester.pump();

    expect(
      find.byWidgetPredicate((widget) => widget is GameWidget),
      findsOneWidget,
    );
    expect(find.text('Pou Game'), findsNothing);
    expect(find.text('Home'), findsNothing);
    expect(find.image(const AssetImage(GameAssets.coinIcon)), findsOneWidget);
    expect(find.image(const AssetImage(GameAssets.hungerIcon)), findsOneWidget);
    expect(find.image(const AssetImage(GameAssets.healthIcon)), findsOneWidget);
    expect(find.image(const AssetImage(GameAssets.toiletIcon)), findsOneWidget);
    expect(find.image(const AssetImage(GameAssets.energyIcon)), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('shows bottom image navigation panel', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PouGameApp());
    await tester.pump();

    expect(
      find.image(const AssetImage(GameAssets.joystickNavigationButton)),
      findsOneWidget,
    );
    expect(
      find.image(const AssetImage(GameAssets.shopNavigationButton)),
      findsOneWidget,
    );
    expect(find.text('Games'), findsNWidgets(2));
    expect(find.text('Shop'), findsNWidgets(2));
    expect(find.text('Kitchen'), findsNothing);
    expect(find.text('Bathroom'), findsNothing);
    expect(find.text('Bedroom'), findsNothing);
    expect(find.text('Game Room'), findsNothing);
    expect(find.text('Wardrobe'), findsNothing);
  });
}
