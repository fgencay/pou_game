import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../core/config/game_assets.dart';
import 'components/pet_component.dart';

class PetGame extends FlameGame {
  PetGame({this.onTimeElapsed});
  final void Function(double seconds)? onTimeElapsed;
  double _elapsed = 0;
  late final PetComponent _pet;

  bool canFeedAt(Offset point) {
    if (!isLoaded) return false;
    final local = Vector2(point.dx, point.dy) - _pet.position + _pet.size / 2;
    return _pet.containsLocalPoint(local);
  }

  void reactToFood() {
    if (isLoaded) _pet.showHappy();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    if (_elapsed >= 1) {
      final elapsed = _elapsed;
      _elapsed = 0;
      onTimeElapsed?.call(elapsed);
    }
  }

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
