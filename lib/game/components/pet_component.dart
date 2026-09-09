import 'package:flame/components.dart';

class PetComponent extends SpriteComponent {
  PetComponent({required super.sprite, required Vector2 sourceSize})
    : _sourceSize = sourceSize,
      super(size: sourceSize, anchor: Anchor.center);

  final Vector2 _sourceSize;

  void resizeToHeight(double height) {
    final aspectRatio = _sourceSize.x / _sourceSize.y;
    size = Vector2(height * aspectRatio, height);
  }
}
