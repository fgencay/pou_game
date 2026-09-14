import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../core/config/game_assets.dart';
import '../../features/pet/models/pet_type.dart';
import '../widgets/circular_character_carousel.dart';
import 'home_screen.dart';

class CharacterSelectionScreen extends StatefulWidget {
  const CharacterSelectionScreen({
    super.key,
    this.initialPet = PetType.cat,
    this.onPetSelected,
  });

  final PetType initialPet;
  final ValueChanged<PetType>? onPetSelected;

  @override
  State<CharacterSelectionScreen> createState() =>
      _CharacterSelectionScreenState();
}

class _CharacterSelectionScreenState extends State<CharacterSelectionScreen> {
  final GlobalKey<CircularCharacterCarouselState> _carouselKey = GlobalKey();
  late PetType _selectedPet = widget.initialPet;

  void _onPetChanged(PetType pet) {
    if (_selectedPet != pet) {
      setState(() {
        _selectedPet = pet;
      });
    }
  }

  void _startGame() {
    widget.onPetSelected?.call(_selectedPet);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => HomeScreen(initialPet: _selectedPet),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final carouselHeight = (screenHeight * 0.42).clamp(240.0, 360.0);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Image.asset(
            GameAssets.homeRoomBackground,
            fit: BoxFit.cover,
          ),
          // Soft ambient tint
          DecoratedBox(
            decoration: BoxDecoration(
              color: GameColors.sky.withValues(alpha: 0.12),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: GameSpacing.md,
                vertical: GameSpacing.sm,
              ),
              child: Column(
                children: [
                  const SizedBox(height: GameSpacing.lg),
                  // Header Title
                  const _OutlinedHeaderTitle(text: 'CHOOSE YOUR PET'),
                  const SizedBox(height: 6),
                  const Text(
                    'Swipe to spin & choose your starter pet!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B4E3D),
                    ),
                  ),
                  const Spacer(flex: 3),
                  // 3D Circular Character Carousel
                  CircularCharacterCarousel(
                    key: _carouselKey,
                    pets: PetType.values,
                    selectedPet: _selectedPet,
                    onPetChanged: _onPetChanged,
                    height: carouselHeight,
                  ),
                  const SizedBox(height: GameSpacing.md),
                  // Character Name Badge
                  _SelectedPetBadge(pet: _selectedPet),
                  const Spacer(flex: 2),
                  // Start Game Button
                  _StartGameButton(
                    onPressed: _startGame,
                  ),
                  const SizedBox(height: GameSpacing.lg),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OutlinedHeaderTitle extends StatelessWidget {
  const _OutlinedHeaderTitle({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    const baseStyle = TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w900,
      letterSpacing: 1.5,
      shadows: [
        Shadow(
          color: Color(0x77000000),
          offset: Offset(0, 3),
          blurRadius: 4,
        ),
      ],
    );

    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: baseStyle.copyWith(
            foreground: ui.Paint()
              ..style = ui.PaintingStyle.stroke
              ..strokeWidth = 5
              ..color = const Color(0xFF4B3D39),
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: baseStyle.copyWith(color: const Color(0xFFFFFAEB)),
        ),
      ],
    );
  }
}

class _SelectedPetBadge extends StatelessWidget {
  const _SelectedPetBadge({required this.pet});
  final PetType pet;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Container(
            key: ValueKey(pet),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7ED),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF8C644E), width: 2.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Text(
              pet.label,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: Color(0xFF4B3D39),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F5E9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF4CAF50), width: 1.5),
          ),
          child: const Text(
            '✨ Free Starter Pet',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),
        ),
      ],
    );
  }
}

class _StartGameButton extends StatelessWidget {
  const _StartGameButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF5ED45A),
          foregroundColor: Colors.white,
          elevation: 6,
          shadowColor: const Color(0x882E7D32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: const BorderSide(color: Color(0xFF2E7D32), width: 2.5),
          ),
        ),
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.play_arrow_rounded, size: 28),
              SizedBox(width: 4),
              Text(
                'START GAME',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
