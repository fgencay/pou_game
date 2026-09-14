import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pou_game/app/app.dart';
import 'package:pou_game/features/pet/models/pet_type.dart';
import 'package:pou_game/presentation/screens/character_selection_screen.dart';
import 'package:pou_game/presentation/screens/home_screen.dart';
import 'package:pou_game/presentation/widgets/circular_character_carousel.dart';

void main() {
  testWidgets('CharacterSelectionScreen displays all pet characters and start button', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: CharacterSelectionScreen(),
      ),
    );
    await tester.pump();

    expect(find.text('CHOOSE YOUR PET'), findsWidgets);
    expect(find.text('START GAME'), findsOneWidget);
    expect(find.byType(CircularCharacterCarousel), findsOneWidget);
    expect(find.text('Cat'), findsWidgets);
    expect(find.text('✨ Free Starter Pet'), findsOneWidget);
  });

  testWidgets('CircularCharacterCarousel can rotate to next and previous pet via chevron buttons', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: CharacterSelectionScreen(initialPet: PetType.cat),
      ),
    );
    await tester.pump();

    expect(find.text('Cat'), findsWidgets);

    // Tap Next Pet button
    await tester.tap(find.byTooltip('Next Pet'));
    await tester.pumpAndSettle();

    // Next pet (Dog) should now be selected and visible in badge
    expect(find.text('Dog'), findsWidgets);

    // Tap Previous Pet button
    await tester.tap(find.byTooltip('Previous Pet'));
    await tester.pumpAndSettle();

    // Cat should be selected again
    expect(find.text('Cat'), findsWidgets);
  });

  testWidgets('Dragging carousel rotates and snaps to nearest pet', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const MaterialApp(
        home: CharacterSelectionScreen(initialPet: PetType.cat),
      ),
    );
    await tester.pump();

    // Drag left to rotate clockwise to next pet
    await tester.drag(
      find.byType(CircularCharacterCarousel),
      const Offset(-200, 0),
    );
    await tester.pumpAndSettle();

    // Selection changed
    expect(find.text('Cat'), findsNothing);
  });

  testWidgets('Tapping Start Game launches HomeScreen with selected pet', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    PetType? selected;
    await tester.pumpWidget(
      MaterialApp(
        home: CharacterSelectionScreen(
          initialPet: PetType.dog,
          onPetSelected: (pet) => selected = pet,
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Dog'), findsWidgets);

    // Tap START GAME
    await tester.tap(find.text('START GAME'));
    await tester.pumpAndSettle();

    expect(selected, PetType.dog);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('PouGameApp starts on CharacterSelectionScreen by default', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const PouGameApp());
    await tester.pump();

    expect(find.byType(CharacterSelectionScreen), findsOneWidget);
    expect(find.text('CHOOSE YOUR PET'), findsWidgets);
  });
}
