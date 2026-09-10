import '../../../core/config/game_assets.dart';

enum PetType {
  cat(
    id: 'cat',
    label: 'Cat',
    price: 0,
    idleAsset: GameAssets.catIdle,
    blinkAsset: GameAssets.catBlink,
    happyAsset: GameAssets.catHappy,
    eatingAsset: GameAssets.catEating,
  ),
  dog(
    id: 'dog',
    label: 'Dog',
    price: 150,
    idleAsset: GameAssets.dogIdle,
    blinkAsset: GameAssets.dogBlink,
    happyAsset: GameAssets.dogHappy,
    eatingAsset: GameAssets.dogEating,
  );

  const PetType({
    required this.id,
    required this.label,
    required this.price,
    required this.idleAsset,
    required this.blinkAsset,
    required this.happyAsset,
    required this.eatingAsset,
  });

  final String id;
  final String label;
  final int price;
  final String idleAsset;
  final String blinkAsset;
  final String happyAsset;
  final String eatingAsset;

  String get imageAssetPath => 'assets/images/$idleAsset';
}
