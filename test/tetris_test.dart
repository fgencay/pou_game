import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pou_game/app/app.dart';
import 'package:pou_game/core/config/game_assets.dart';
import 'package:tetris_engine/tetris_engine.dart';

void main() {
  testWidgets('Games opens Tetris, controls work, and Back returns home', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const PouGameApp());
    await tester.pump();
    await tester.tap(
      find.image(const AssetImage(GameAssets.joystickNavigationButton)),
    );
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    expect(find.byType(Dialog), findsOneWidget);
    await tester.tap(find.text('Tetris'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();
    final game = tester.widget<TetrisBoard>(find.byType(TetrisBoard)).game;
    final initialColumn = game.state.activePiece!.position.col;
    await tester.tap(find.byTooltip('Move left'));
    expect(game.state.activePiece!.position.col, initialColumn - 1);
    await tester.tap(find.byTooltip('Drop'));
    expect(game.state.scoreState.score, greaterThan(0));
    await tester.tap(find.byTooltip('Pause'));
    await tester.pump();
    expect(game.state.status, TetrisGameStatus.paused);
    await tester.tap(find.text('Resume'));
    await tester.pump();
    expect(game.state.status, TetrisGameStatus.playing);
    await tester.tap(find.byTooltip('Restart'));
    await tester.pump();
    expect(find.text('Results'), findsOneWidget);
    await tester.tap(find.text('Collect'));
    await tester.pump();
    expect(game.state.scoreState.score, 0);
    expect(tester.takeException(), isNull);
    await tester.tap(find.byTooltip('Back').last);
    await tester.pump();
    await tester.tap(find.text('Collect'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump();

    expect(find.text('Home'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
