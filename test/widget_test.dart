import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pou_game/main.dart';

void main() {
  testWidgets('shows the startup screen', (WidgetTester tester) async {
    await tester.pumpWidget(const PouGameApp());

    expect(find.text('Pou Game'), findsOneWidget);
    expect(find.text('Phase 0 ready'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsNothing);
  });
}
