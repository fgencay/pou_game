import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pou_game/presentation/screens/flappy_cube_screen.dart';
import 'package:pou_game/presentation/screens/game_room_screen.dart';

void main() {
  testWidgets('FlappyCubeScreen opens, jump button works, and finish collects rewards', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: FlappyCubeScreen()),
    );
    await tester.pump();

    expect(find.text('Flappy Cube'), findsOneWidget);
    expect(find.text('Score 0'), findsOneWidget);

    // Tap game area to jump
    await tester.tap(find.byKey(const ValueKey('flappy-game-board')));
    await tester.pump();

    // Pause game
    await tester.tap(find.byTooltip('Pause'));
    await tester.pump();
    expect(find.text('PAUSED'), findsOneWidget);

    // Resume game
    await tester.tap(find.byTooltip('Resume'));
    await tester.pump();
    expect(find.text('PAUSED'), findsNothing);

    // Restart game -> opens results
    await tester.tap(find.byTooltip('Restart'));
    await tester.pump();
    expect(find.text('Results'), findsOneWidget);
    expect(find.text('Play Again'), findsOneWidget);

    // Collect rewards
    await tester.tap(find.text('Collect'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(tester.takeException(), isNull);
  });

  testWidgets('GameRoomScreen shows both Tetris and Flappy Cube options', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(home: GameRoomScreen()),
    );
    await tester.pump();

    expect(find.text('Games'), findsOneWidget);
    expect(find.text('Tetris'), findsOneWidget);
    expect(find.text('Flappy Cube'), findsOneWidget);
  });
}
