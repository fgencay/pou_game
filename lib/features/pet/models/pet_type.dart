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
  ),
  cat2(
    id: 'cat2',
    label: 'Ginger Cat',
    price: 200,
    idleAsset: GameAssets.cat2Idle,
    blinkAsset: GameAssets.cat2Blink,
    happyAsset: GameAssets.cat2Happy,
    eatingAsset: GameAssets.cat2Eating,
    sadAsset: GameAssets.cat2Sad,
    happyAudio: GameAssets.cat2HappyAudio,
  ),
  dog2(
    id: 'dog2',
    label: 'Spaniel Dog',
    price: 200,
    idleAsset: GameAssets.dog2Idle,
    blinkAsset: GameAssets.dog2Blink,
    happyAsset: GameAssets.dog2Happy,
    eatingAsset: GameAssets.dog2Eating,
    sadAsset: GameAssets.dog2Sad,
    happyAudio: GameAssets.dog2HappyAudio,
  ),
  leon(
    id: 'leon',
    label: 'Leon',
    price: 250,
    idleAsset: GameAssets.leonIdle,
    blinkAsset: GameAssets.leonBlink,
    happyAsset: GameAssets.leonHappy,
    eatingAsset: GameAssets.leonEating,
    sadAsset: GameAssets.leonSad,
    happyAudio: GameAssets.leonHappyAudio,
  ),
  duck(
    id: 'duck',
    label: 'Duck',
    price: 250,
    idleAsset: GameAssets.duckIdle,
    blinkAsset: GameAssets.duckBlink,
    happyAsset: GameAssets.duckHappy,
    eatingAsset: GameAssets.duckEating,
    sadAsset: GameAssets.duckSad,
    happyAudio: GameAssets.duckHappyAudio,
  ),
  parrot(
    id: 'parrot',
    label: 'Parrot',
    price: 250,
    idleAsset: GameAssets.parrotIdle,
    blinkAsset: GameAssets.parrotBlink,
    happyAsset: GameAssets.parrotHappy,
    eatingAsset: GameAssets.parrotEating,
    sadAsset: GameAssets.parrotSad,
    happyAudio: GameAssets.parrotHappyAudio,
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
