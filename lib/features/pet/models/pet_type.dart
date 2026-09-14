import '../../../core/config/game_assets.dart';

enum PetType {
  cat(
    id: 'cat',
    label: 'Cat',
    price: 150,
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
  ),
  bird(
    id: 'bird',
    label: 'Bird',
    price: 250,
    idleAsset: GameAssets.birdIdle,
    blinkAsset: GameAssets.birdBlink,
    happyAsset: GameAssets.birdHappy,
    eatingAsset: GameAssets.birdEating,
    sadAsset: GameAssets.birdSad,
    happyAudio: GameAssets.birdHappyAudio,
  ),
  panda(
    id: 'panda',
    label: 'Panda',
    price: 200,
    idleAsset: GameAssets.pandaIdle,
    blinkAsset: GameAssets.pandaBlink,
    happyAsset: GameAssets.pandaHappy,
    eatingAsset: GameAssets.pandaEating,
    sadAsset: GameAssets.pandaSad,
    happyAudio: GameAssets.pandaHappyAudio,
  ),
  rabbit(
    id: 'rabbit',
    label: 'Rabbit',
    price: 200,
    idleAsset: GameAssets.rabbitIdle,
    blinkAsset: GameAssets.rabbitBlink,
    happyAsset: GameAssets.rabbitHappy,
    eatingAsset: GameAssets.rabbitEating,
    sadAsset: GameAssets.rabbitSad,
    happyAudio: GameAssets.rabbitHappyAudio,
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
