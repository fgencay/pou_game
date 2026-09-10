import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pou_game/app/app.dart';
import 'package:pou_game/features/economy/models/player_progress.dart';
import 'package:pou_game/presentation/screens/home_screen.dart';
import 'package:pou_game/core/config/game_assets.dart';

void main() {
  testWidgets('level follows XP and fits beside the HUD on a narrow screen', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(playerProgress: PlayerProgress(xp: 250)),
      ),
    );
    await tester.pump();

    expect(find.text('3'), findsNWidgets(2));
    final levelRect = tester.getRect(
      find.image(const AssetImage(GameAssets.levelIcon)),
    );
    final energyRect = tester.getRect(
      find.image(const AssetImage(GameAssets.energyIcon)),
    );
    final coinRect = tester.getRect(
      find.image(const AssetImage(GameAssets.coinIcon)),
    );
    expect(energyRect.right, lessThan(levelRect.left));
    expect(levelRect.top, closeTo(coinRect.top, 0.01));
    expect(levelRect.right, lessThanOrEqualTo(320));
    expect(tester.takeException(), isNull);
  });
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
    expect(find.text('Home'), findsOneWidget);
    final gameFinder = find.byWidgetPredicate((widget) => widget is GameWidget);
    final originalGame = tester.widget<GameWidget>(gameFinder).game;
    final originalRect = tester.getRect(gameFinder);
    final shopRect = tester.getRect(
      find.image(const AssetImage(GameAssets.shopNavigationButton)),
    );
    final gamesRect = tester.getRect(
      find.image(const AssetImage(GameAssets.joystickNavigationButton)),
    );
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pump(const Duration(milliseconds: 150));

    await tester.tap(find.byIcon(Icons.chevron_right_rounded));
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.text('Kitchen'), findsOneWidget);
    expect(
      find.image(const AssetImage(GameAssets.kitchenRoomBackground)),
      findsOneWidget,
    );
    expect(find.text('Games'), findsNothing);
    expect(find.text('Shop'), findsNothing);
    expect(find.text('Fridge'), findsNWidgets(2));
    expect(
      tester.getRect(find.image(const AssetImage(GameAssets.fridgeIcon))),
      shopRect,
    );
    expect(
      tester.getRect(find.image(const AssetImage(GameAssets.apple))),
      gamesRect,
    );
    expect(tester.widget<GameWidget>(gameFinder).game, same(originalGame));
    expect(tester.getRect(gameFinder), originalRect);

    await tester.tap(find.byIcon(Icons.chevron_right_rounded));
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.text('Bathroom'), findsWidgets);
    expect(
      find.image(const AssetImage(GameAssets.bathroomRoomBackground)),
      findsOneWidget,
    );
    expect(
      find.image(const AssetImage(GameAssets.toiletNavigationButton)),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.text('Kitchen'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pump(const Duration(milliseconds: 150));
    expect(find.text('Home'), findsOneWidget);
    expect(
      find.image(const AssetImage(GameAssets.homeRoomBackground)),
      findsOneWidget,
    );
    expect(find.image(const AssetImage(GameAssets.apple)), findsNothing);
    expect(tester.widget<GameWidget>(gameFinder).game, same(originalGame));
    expect(find.image(const AssetImage(GameAssets.coinIcon)), findsOneWidget);
    expect(find.image(const AssetImage(GameAssets.hungerIcon)), findsOneWidget);
    expect(find.image(const AssetImage(GameAssets.healthIcon)), findsOneWidget);
    expect(find.image(const AssetImage(GameAssets.toiletIcon)), findsOneWidget);
    expect(find.image(const AssetImage(GameAssets.energyIcon)), findsOneWidget);
    expect(find.image(const AssetImage(GameAssets.levelIcon)), findsOneWidget);
    expect(find.text('1'), findsNWidgets(2));
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
