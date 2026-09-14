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
                  const Spacer(flex: 2),
                  // Header Title in Upper-Middle
                  const _OutlinedHeaderTitle(text: 'CHOOSE YOUR PET'),
                  const Spacer(flex: 1),
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
                  const SizedBox(height: GameSpacing.md),
                  // Start Game Button directly below name badge
                  _StartGameButton(
                    onPressed: _startGame,
                  ),
                  const Spacer(flex: 2),
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
      fontSize: 28,
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
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) {
        return ScaleTransition(scale: animation, child: child);
      },
      child: Container(
        key: ValueKey(pet),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
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
    );
  }
}

class _StartGameButton extends StatelessWidget {
  const _StartGameButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 228,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFFFB6C7), // Toz pembe açık
            Color(0xFFEE889E), // Toz pembe derin
          ],
        ),
        border: Border.all(
          color: const Color(0xFFFFF6EE), // Ekru çerçeve
          width: 2.8,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x448A3A50),
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          splashColor: const Color(0x33FFFFFF),
          highlightColor: const Color(0x22FFFFFF),
          onTap: onPressed,
          child: const Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.play_arrow_rounded,
                      size: 28,
                      color: Color(0xFFFFFDF8),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'START GAME',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: Color(0xFFFFFDF8), // Ekru
                        shadows: [
                          Shadow(
                            color: Color(0x446B2236),
                            offset: Offset(0, 1.5),
                            blurRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
