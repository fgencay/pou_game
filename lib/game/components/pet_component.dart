import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import '../../core/config/game_assets.dart';

const _blinkDuration = 0.18;
const _happyDuration = 1.45;
const _eatingDuration = 0.8;
const _blinkDelays = [2.8, 4.1, 3.4, 5.0];

enum CatVisualState { idle, blink, happy, eating }

class PetComponent extends SpriteComponent with TapCallbacks, DragCallbacks {
  PetComponent({
    required Map<CatVisualState, Sprite> sprites,
    required Vector2 sourceSize,
  }) : _sprites = sprites,
       _sourceSize = sourceSize,
       super(
         sprite: sprites[CatVisualState.idle],
         size: sourceSize,
         anchor: Anchor.center,
         autoResize: false,
       );

  final Map<CatVisualState, Sprite> _sprites;
  final Vector2 _sourceSize;
  CatVisualState _visualState = CatVisualState.idle;
  double _blinkTimer = _blinkDelays.first;
  double _happyTimer = 0;
  double _eatingTimer = 0;
  int _blinkDelayIndex = 0;
  bool isVisible = true;

  CatVisualState get visualState => _visualState;

  @override
  void render(Canvas canvas) {
    if (!isVisible) return;
    super.render(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_visualState == CatVisualState.eating) {
      _eatingTimer -= dt;
      if (_eatingTimer <= 0) {
        showHappy();
      }
      return;
    }

    if (_visualState == CatVisualState.happy) {
      _happyTimer -= dt;
      if (_happyTimer <= 0) {
        _setVisualState(CatVisualState.idle);
        _scheduleNextBlink();
      }
      return;
    }

    _blinkTimer -= dt;
    if (_visualState == CatVisualState.blink) {
      if (_blinkTimer <= 0) {
        _setVisualState(CatVisualState.idle);
        _scheduleNextBlink();
      }
      return;
    }

    if (_blinkTimer <= 0) {
      _setVisualState(CatVisualState.blink);
      _blinkTimer = _blinkDuration;
    }
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    if (!isVisible) return false;

    final left = size.x * 0.16;
    final right = size.x * 0.84;
    final top = size.y * 0.18;
    final bottom = size.y * 0.9;

    return point.x >= left &&
        point.x <= right &&
        point.y >= top &&
        point.y <= bottom;
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    showHappy();
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    showHappy();
  }

  void resizeToHeight(double height) {
    final aspectRatio = _sourceSize.x / _sourceSize.y;
    size = Vector2(height * aspectRatio, height);
  }

  void showHappy() {
    _happyTimer = _happyDuration;
    _setVisualState(CatVisualState.happy);
  }

  void showEatingThenHappy() {
    _eatingTimer = _eatingDuration;
    _setVisualState(CatVisualState.eating);
    _playEatingSound();
  }

  void _playEatingSound() {
    try {
      final player = AudioPlayer();
      player.play(AssetSource('audio/eat.mp3'));
    } catch (_) {}
  }

  void updatePetType({
    required Map<CatVisualState, Sprite> sprites,
    required Vector2 sourceSize,
  }) {
    _sprites.clear();
    _sprites.addAll(sprites);
    _sourceSize.setFrom(sourceSize);
    _setVisualState(CatVisualState.idle);
    resizeToHeight(size.y);
  }

  void _scheduleNextBlink() {
    _blinkDelayIndex = (_blinkDelayIndex + 1) % _blinkDelays.length;
    _blinkTimer = _blinkDelays[_blinkDelayIndex];
  }

  void _setVisualState(CatVisualState state) {
    _visualState = state;
    sprite = _sprites[state];
  }
}
