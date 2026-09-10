import 'package:flutter/material.dart';
import '../../features/economy/models/food_purchase.dart';
import 'food_item.dart';

class DraggableFoodItem extends StatelessWidget {
  const DraggableFoodItem({
    super.key,
    required this.food,
    required this.size,
    required this.count,
    required this.onDropped,
  });
  final Food food;
  final double size;
  final int count;
  final void Function(Food, Offset) onDropped;

  @override
  Widget build(BuildContext context) {
    return Draggable<Food>(
      data: food,
      maxSimultaneousDrags: count > 0 ? 1 : 0,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      feedback: Transform.translate(
        offset: Offset(-size / 2, -size / 2),
        child: FoodItem(food: food, size: size),
      ),
      childWhenDragging: SizedBox.square(dimension: size),
      onDragEnd: (details) => onDropped(food, details.offset),
      child: Stack(
        children: [
          Opacity(
            opacity: count > 0 ? 1 : 0.3,
            child: FoodItem(food: food, size: size),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Text(
              'x$count',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black, blurRadius: 4)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
