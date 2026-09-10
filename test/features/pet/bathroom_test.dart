import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pou_game/core/config/game_assets.dart';
import 'package:pou_game/features/pet/domain/pet_stat_decay.dart';
import 'package:pou_game/features/pet/models/pet_stats.dart';
import 'package:pou_game/presentation/screens/home_screen.dart';

void main() {
  test('PetStatDecay clean resets cleanliness to 100', () {
    const rules = PetStatDecay();
    final dirtyStats = PetStats(cleanliness: 20);
    expect(dirtyStats.cleanliness, 20);
    final cleanedStats = rules.clean(dirtyStats);
    expect(cleanedStats.cleanliness, 100);
  });

  testWidgets('can navigate to Bathroom and see toilet icon', (tester) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen(initialRoom: PetRoom.bathroom)),
    );
    await tester.pump();

    expect(find.text('Bathroom'), findsWidgets);
    expect(
      find.image(const AssetImage(GameAssets.toiletNavigationButton)),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
