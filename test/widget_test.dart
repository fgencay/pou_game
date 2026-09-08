import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pou_game/app/app.dart';

void main() {
  testWidgets('opens home screen first', (WidgetTester tester) async {
    await tester.pumpWidget(const PouGameApp());
    await tester.pump();

    expect(find.text('Pou Game'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(
      find.byWidgetPredicate((widget) => widget is GameWidget),
      findsOneWidget,
    );
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('navigates from home to each room and back', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PouGameApp());
    await tester.pump();

    const roomNames = [
      'Kitchen',
      'Bathroom',
      'Bedroom',
      'Game Room',
      'Shop',
      'Wardrobe',
    ];

    for (final roomName in roomNames) {
      await tester.tap(find.text(roomName));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('$roomName placeholder'), findsOneWidget);

      await tester.tap(find.text('Home'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Pou Game'), findsOneWidget);
      expect(find.text(roomName), findsOneWidget);
    }
  });
}
