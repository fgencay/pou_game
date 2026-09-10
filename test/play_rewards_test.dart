import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tetris_engine/tetris_engine.dart';
import 'package:pou_game/core/config/game_assets.dart';
import 'package:pou_game/presentation/screens/home_screen.dart';
import 'package:pou_game/features/economy/models/play_session.dart';
import 'package:pou_game/features/economy/models/player_progress.dart';
import 'package:pou_game/presentation/screens/tetris_screen.dart';

void main() {
  test(
    'only cleared lines award coins; claim is once and energy is not repeated',
    () {
      final session = PlaySession();
      var energy = 0.0;
      for (var i = 0; i < 60; i++) {
        final reward = session.tick();
        expect(reward.coins, 0);
        expect(reward.xp, 0);
        energy += reward.energy;
      }
      expect(session.coins, 0);
      session.clearLines(1);
      session.clearLines(4);
      expect(session.coins, 25);
      expect(energy, closeTo(2, 0.0001));
      final reward = session.claim();
      expect(reward.coins, 25);
      expect(reward.xp, 24);
      expect(reward.energy, 0);
      expect(session.claim().coins, 0);
      expect(session.claim().xp, 0);
      expect(session.tick().energy, 0);
      expect(const PlayerProgress(xp: 98).earnXp(2).level, 2);
      expect(const PlayerProgress(xp: 1700).nextLevelXp, 2050);
    },
  );

  testWidgets(
    'no rewards before collection; game over shows results and Home gets them once',
    (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomeScreen(playerProgress: PlayerProgress(xp: 98)),
        ),
      );
      await tester.pump();
      await tester.tap(
        find.image(const AssetImage(GameAssets.joystickNavigationButton)),
      );
      await tester.pump(const Duration(milliseconds: 400));
      await tester.tap(find.text('Tetris'));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump();
      final game = tester.widget<TetrisBoard>(find.byType(TetrisBoard)).game;
      game.onLinesCleared!(2);
      await tester.pump(const Duration(seconds: 10));
      expect(find.textContaining('XP'), findsNothing);
      for (
        var i = 0;
        i < 100 && game.state.status == TetrisGameStatus.playing;
        i++
      ) {
        game.hardDrop();
      }
      await tester.pump();
      expect(find.text('Results'), findsOneWidget);
      expect(find.text('10 coins'), findsOneWidget);
      expect(find.text('4 XP'), findsOneWidget);
      await tester.pump(const Duration(seconds: 10));
      expect(find.text('4 XP'), findsOneWidget);
      await tester.tap(find.text('Collect'));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump();
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('260'), findsNWidgets(2));
      expect(find.text('2'), findsNWidgets(2));
      await tester.tap(find.byKey(const ValueKey('pet-level-button')));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Total XP: 102'), findsOneWidget);
      expect(find.text('2 / 150 XP'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );

  testWidgets(
    'pause and background stop energy; restart requires collection and resets pending rewards',
    (tester) async {
      var coins = 0;
      var xp = 0;
      var energy = 0.0;
      await tester.pumpWidget(
        MaterialApp(
          home: TetrisScreen(
            onReward: (reward) {
              coins += reward.coins;
              xp += reward.xp;
              energy += reward.energy;
            },
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 10));
      expect(coins, 0);
      expect(xp, 0);
      expect(energy, closeTo(1 / 3, 0.0001));
      await tester.tap(find.byTooltip('Pause'));
      await tester.pump(const Duration(seconds: 10));
      expect(energy, closeTo(1 / 3, 0.0001));
      await tester.tap(find.text('Resume'));
      await tester.pump(const Duration(seconds: 5));
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      await tester.pump(const Duration(seconds: 5));
      expect(energy, closeTo(0.5, 0.0001));
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      await tester.tap(find.byTooltip('Restart'));
      await tester.pump();
      expect(find.text('6 XP'), findsOneWidget);
      expect(xp, 0);
      await tester.tap(find.text('Collect'));
      await tester.pump();
      expect(xp, 6);
      await tester.pump(const Duration(seconds: 5));
      await tester.tap(find.byTooltip('Restart'));
      await tester.pump();
      expect(find.text('2 XP'), findsOneWidget);
      await tester.tap(find.text('Collect'));
      await tester.pump();
      expect(xp, 8);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 10));
      expect(xp, 8);
    },
  );
}
