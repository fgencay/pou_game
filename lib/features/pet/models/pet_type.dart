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
    sadAsset: GameAssets.catSad,
    happyAudio: GameAssets.catHappyAudio,
  ),
  dog(
    id: 'dog',
    label: 'Dog',
    price: 150,
    idleAsset: GameAssets.dogIdle,
    blinkAsset: GameAssets.dogBlink,
    happyAsset: GameAssets.dogHappy,
    eatingAsset: GameAssets.dogEating,
    sadAsset: GameAssets.dogSad,
    happyAudio: GameAssets.dogHappyAudio,
  );

  const PetType({
    required this.id,
    required this.label,
    required this.price,
    required this.idleAsset,
    required this.blinkAsset,
    required this.happyAsset,
    required this.eatingAsset,
    required this.sadAsset,
    required this.happyAudio,
  });

  final String id;
  final String label;
  final int price;
  final String idleAsset;
  final String blinkAsset;
  final String happyAsset;
  final String eatingAsset;
  final String sadAsset;
  final String happyAudio;

  String get imageAssetPath => 'assets/images/$idleAsset';
}
