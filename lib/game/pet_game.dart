import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';

import '../core/config/game_assets.dart';
import '../features/pet/models/pet_type.dart';
import 'components/pet_component.dart';

class PetGame extends FlameGame {
  PetGame({this.onTimeElapsed, PetType initialPet = PetType.cat})
      : _currentPet = initialPet;

  final void Function(double seconds)? onTimeElapsed;
  double _elapsed = 0;
  late final PetComponent _pet;
  PetType _currentPet;
  final Map<PetType, Map<CatVisualState, Sprite>> _petSprites = {};

  bool canFeedAt(Offset point) {
    if (!isLoaded) return false;
    final local = Vector2(point.dx, point.dy) - _pet.position + _pet.size / 2;
    return _pet.containsLocalPoint(local);
  }

  void reactToFood() {
    if (isLoaded) _pet.showEatingThenHappy();
  }

  Future<void> setPetType(PetType petType) async {
    _currentPet = petType;
    if (!isLoaded) return;

    await _ensureSpritesLoaded(petType);
    final idleSprite = _petSprites[petType]![CatVisualState.idle]!;
    final sourceSize = Vector2(
      idleSprite.image.width.toDouble(),
      idleSprite.image.height.toDouble(),
    );

    _pet.updatePetType(
      sprites: Map.of(_petSprites[petType]!),
      sourceSize: sourceSize,
    );
    _layoutPet();
  }

  Future<void> _ensureSpritesLoaded(PetType petType) async {
    if (_petSprites.containsKey(petType)) return;

    final idleImage = await images.load(petType.idleAsset);
    final blinkImage = await images.load(petType.blinkAsset);
    final happyImage = await images.load(petType.happyAsset);
    final eatingImage = await images.load(petType.eatingAsset);

    _petSprites[petType] = {
      CatVisualState.idle: Sprite(idleImage),
      CatVisualState.blink: Sprite(blinkImage),
      CatVisualState.happy: Sprite(happyImage),
      CatVisualState.eating: Sprite(eatingImage),
    };
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
    await _ensureSpritesLoaded(_currentPet);

    final idleSprite = _petSprites[_currentPet]![CatVisualState.idle]!;
    final sourceSize = Vector2(
      idleSprite.image.width.toDouble(),
      idleSprite.image.height.toDouble(),
    );

    _pet = PetComponent(
      sprites: Map.of(_petSprites[_currentPet]!),
      sourceSize: sourceSize,
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
