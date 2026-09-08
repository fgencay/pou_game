import 'package:flame/game.dart';

import 'components/pet_component.dart';

class PetGame extends FlameGame {
  late final PetComponent _pet;

  @override
  Future<void> onLoad() async {
    _pet = PetComponent();
    await add(_pet);
    _centerPet();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    if (isLoaded) {
      _centerPet();
    }
  }

  void _centerPet() {
    _pet.position = size / 2;
  }
}
