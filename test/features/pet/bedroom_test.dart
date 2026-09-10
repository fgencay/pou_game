import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pou_game/core/config/game_assets.dart';
import 'package:pou_game/features/pet/domain/pet_stat_decay.dart';
import 'package:pou_game/features/pet/models/pet_stats.dart';
import 'package:pou_game/presentation/screens/home_screen.dart';

void main() {
  test('PetStatDecay rest restores energy to 100', () {
    const rules = PetStatDecay();
    final tiredStats = PetStats(energy: 15);
    expect(tiredStats.energy, 15);
    final restedStats = rules.rest(tiredStats);
    expect(restedStats.energy, 100);
  });

  test('PetStatDecay updateTime gradually restores energy when sleeping', () {
    const rules = PetStatDecay();
    final tiredStats = PetStats(energy: 50);
    final nextStats = rules.updateTime(tiredStats, 1.0, isSleeping: true);
    expect(nextStats.energy, 62.0);
  });

  test('PetStatDecay updateTime decays energy when awake', () {
    const rules = PetStatDecay();
    final fullStats = PetStats(energy: 100);
    final nextStats = rules.updateTime(fullStats, 1.0, isSleeping: false);
    expect(nextStats.energy, lessThan(100.0));
  });

  testWidgets('can navigate to Bedroom and see lamp icon on bottom right', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen(initialRoom: PetRoom.bedroom)),
    );
    await tester.pump();

    expect(find.text('Bedroom'), findsWidgets);
    expect(
      find.image(const AssetImage(GameAssets.lampNavigationButton)),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping lamp in bedroom toggles sleep background and back', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen(initialRoom: PetRoom.bedroom)),
    );
    await tester.pump();

    expect(
      find.image(const AssetImage(GameAssets.bedroomRoomBackground)),
      findsOneWidget,
    );

    await tester.tap(find.image(const AssetImage(GameAssets.lampNavigationButton)));
    await tester.pump();

    expect(
      find.image(const AssetImage(GameAssets.bedroomSleepBackground)),
      findsOneWidget,
    );
    expect(find.text('Z z z . . .'), findsWidgets);

    await tester.tap(find.image(const AssetImage(GameAssets.lampNavigationButton)));
    await tester.pump();

    expect(
      find.image(const AssetImage(GameAssets.bedroomRoomBackground)),
      findsOneWidget,
    );
    expect(find.text('Z z z . . .'), findsNothing);
  });
}
