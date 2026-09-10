import 'pet_type.dart';

class PetInventory {
  PetInventory({
    Set<PetType>? ownedPets,
    PetType activePet = PetType.cat,
  })  : _ownedPets = ownedPets ?? {PetType.cat},
        _activePet = activePet;

  final Set<PetType> _ownedPets;
  PetType _activePet;

  Set<PetType> get ownedPets => Set.unmodifiable(_ownedPets);
  PetType get activePet => _activePet;

  bool isOwned(PetType pet) => _ownedPets.contains(pet);
  bool isEquipped(PetType pet) => _activePet == pet;

  void select(PetType pet) {
    if (isOwned(pet)) {
      _activePet = pet;
    }
  }

  bool buy(PetType pet, int coins, void Function(int price) onDeductCoins) {
    if (isOwned(pet)) {
      select(pet);
      return true;
    }
    if (coins < pet.price) return false;
    onDeductCoins(pet.price);
    _ownedPets.add(pet);
    _activePet = pet;
    return true;
  }
}
