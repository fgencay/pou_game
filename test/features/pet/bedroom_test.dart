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
}
