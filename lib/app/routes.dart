class AppRoutes {
  const AppRoutes._();

  static const home = '/';
  static const kitchen = '/kitchen';
  static const bathroom = '/bathroom';
  static const bedroom = '/bedroom';
  static const gameRoom = '/game-room';
  static const shop = '/shop';
  static const wardrobe = '/wardrobe';
}

class RoomDestination {
  const RoomDestination({required this.label, required this.route});

  final String label;
  final String route;
}

const roomDestinations = [
  RoomDestination(label: 'Kitchen', route: AppRoutes.kitchen),
  RoomDestination(label: 'Bathroom', route: AppRoutes.bathroom),
  RoomDestination(label: 'Bedroom', route: AppRoutes.bedroom),
  RoomDestination(label: 'Game Room', route: AppRoutes.gameRoom),
  RoomDestination(label: 'Shop', route: AppRoutes.shop),
  RoomDestination(label: 'Wardrobe', route: AppRoutes.wardrobe),
];
