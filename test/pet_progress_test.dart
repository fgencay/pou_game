import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pou_game/features/economy/models/player_progress.dart';
import 'package:pou_game/presentation/screens/home_screen.dart';

void main() {
  test(
    'level progress uses current level thresholds and resets at level up',
    () {
      const halfway = PlayerProgress(xp: 175);
      expect(halfway.level, 2);
      expect(halfway.xpInLevel, 75);
      expect(halfway.xpForLevel, 150);
      expect(halfway.levelProgress, 0.5);
      final next = halfway.earnXp(75);
      expect(next.level, 3);
      expect(next.xp, 250);
      expect(next.levelProgress, 0);
      expect(next.xpRemaining, 200);
      expect(const PlayerProgress(xp: 1525).levelProgress, 0.5);
    },
  );

  testWidgets('level icon opens general pet progress without layout overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(playerProgress: PlayerProgress(xp: 175)),
      ),
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('pet-level-button')));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Pet level'), findsOneWidget);
    expect(find.text('Level 2'), findsOneWidget);
    expect(find.text('75 / 150 XP'), findsOneWidget);
    expect(find.text('Total XP: 175'), findsOneWidget);
    expect(
      tester
          .widget<FractionallySizedBox>(
            find.byKey(const ValueKey('pet-xp-fill')),
          )
          .widthFactor,
      0.5,
    );
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip('Close'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Home'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
