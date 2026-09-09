import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../core/config/game_assets.dart';
import 'components/pet_component.dart';

class PetGame extends FlameGame {
  late final PetComponent _pet;

  @override
  Color backgroundColor() => const Color(0x00000000);

  @override
  Future<void> onLoad() async {
    final catIdleImage = await images.load(GameAssets.catIdle);
    final catBlinkImage = await images.load(GameAssets.catBlink);
    final catHappyImage = await images.load(GameAssets.catHappy);

    _pet = PetComponent(
      sprites: {
        CatVisualState.idle: Sprite(catIdleImage),
        CatVisualState.blink: Sprite(catBlinkImage),
        CatVisualState.happy: Sprite(catHappyImage),
      },
      sourceSize: Vector2(
        catIdleImage.width.toDouble(),
        catIdleImage.height.toDouble(),
      ),
    );

    await add(_pet);
    _layoutPet();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    if (isLoaded) {
      _layoutPet();
    }
  }

  void _layoutPet() {
    final targetHeight = (size.y * 0.62).clamp(140.0, 320.0);
    _pet.resizeToHeight(targetHeight);
    _pet.position = Vector2(size.x / 2, size.y * 0.68);
  }
}
