import 'package:flutter/material.dart';

import '../../core/config/game_assets.dart';
import '../../features/pet/models/pet_inventory.dart';
import '../../features/pet/models/pet_type.dart';

class PetShopDialog extends StatelessWidget {
  const PetShopDialog({
    super.key,
    required this.coins,
    required this.inventory,
  });

  final int coins;
  final PetInventory inventory;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFFFF0E5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFFB58874), width: 2),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Pet Shop',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(GameAssets.coinIcon, width: 28, height: 28),
                  const SizedBox(width: 6),
                  Text(
                    '$coins',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  for (final pet in PetType.values)
                    SizedBox(
                      width: 130,
                      child: Column(
                        children: [
                          SizedBox.square(
                            dimension: 84,
                            child: Image.asset(
                              pet.imageAssetPath,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            pet.label,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          if (!inventory.isOwned(pet))
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  GameAssets.coinIcon,
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${pet.price}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          else
                            Text(
                              inventory.isEquipped(pet) ? 'Equipped' : 'Owned',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: inventory.isEquipped(pet)
                                    ? const Color(0xFF2E7D32)
                                    : const Color(0xFF666666),
                              ),
                            ),
                          const SizedBox(height: 6),
                          if (inventory.isEquipped(pet))
                            ElevatedButton(
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF81C784),
                              ),
                              child: const Text('Equipped'),
                            )
                          else if (inventory.isOwned(pet))
                            OutlinedButton(
                              key: ValueKey('select-${pet.id}'),
                              onPressed: () => Navigator.pop(context, pet),
                              child: const Text('Select'),
                            )
                          else
                            Column(
                              children: [
                                OutlinedButton(
                                  key: ValueKey('buy-${pet.id}'),
                                  onPressed: coins >= pet.price
                                      ? () => Navigator.pop(context, pet)
                                      : null,
                                  child: const Text('Buy'),
                                ),
                                if (coins < pet.price)
                                  const Text(
                                    'Not enough coins',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFFA33E3E),
                                    ),
                                  ),
                              ],
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
