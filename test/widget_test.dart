import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pou_game/app/app.dart';

void main() {
  testWidgets('opens home screen first', (WidgetTester tester) async {
    await tester.pumpWidget(const PouGameApp());

    expect(find.text('Pou Game'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('navigates from home to each room and back', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PouGameApp());

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
      await tester.pumpAndSettle();

      expect(find.text('$roomName placeholder'), findsOneWidget);

      await tester.tap(find.text('Home'));
      await tester.pumpAndSettle();

      expect(find.text('Pou Game'), findsOneWidget);
      expect(find.text(roomName), findsOneWidget);
    }
  });
}
