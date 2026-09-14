import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import '../../features/pet/models/pet_type.dart';

class CircularCharacterCarousel extends StatefulWidget {
  const CircularCharacterCarousel({
    super.key,
    required this.pets,
    required this.selectedPet,
    required this.onPetChanged,
    this.height = 320,
  });

  final List<PetType> pets;
  final PetType selectedPet;
  final ValueChanged<PetType> onPetChanged;
  final double height;

  @override
  State<CircularCharacterCarousel> createState() =>
      CircularCharacterCarouselState();
}

class CircularCharacterCarouselState extends State<CircularCharacterCarousel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  Animation<double>? _angleAnimation;
  double _currentAngle = 0.0;
  int _selectedIndex = 0;

  int get petCount => widget.pets.length;
  double get _angleStep => 2 * math.pi / math.max(1, petCount);

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.pets.indexOf(widget.selectedPet);
    if (_selectedIndex < 0) _selectedIndex = 0;
    _currentAngle = -_selectedIndex * _angleStep;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addListener(() {
        if (mounted && _angleAnimation != null) {
          setState(() {
            _currentAngle = _angleAnimation!.value;
          });
        }
      });
  }

  @override
  void didUpdateWidget(covariant CircularCharacterCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedPet != oldWidget.selectedPet) {
      final index = widget.pets.indexOf(widget.selectedPet);
      if (index >= 0 && index != _selectedIndex) {
        _animateToIndex(index);
      }
    }
  }

  @override
  void dispose() {
    _animController.stop();
    _animController.dispose();
    super.dispose();
  }

  void rotatePrevious() {
    final nextIndex = (_selectedIndex - 1 + petCount) % petCount;
    _animateToIndex(nextIndex);
  }

  void rotateNext() {
    final nextIndex = (_selectedIndex + 1) % petCount;
    _animateToIndex(nextIndex);
  }

  void _animateToIndex(int index) {
    _animController.stop();
    _selectedIndex = index;

    final targetAngle = -index * _angleStep;
    final diff = _normalizeAngle(targetAngle - _currentAngle);
    final start = _currentAngle;
    final end = _currentAngle + diff;

    _angleAnimation = Tween<double>(
      begin: start,
      end: end,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));

    _animController.forward(from: 0.0).then((_) {
      if (!mounted) return;
      _currentAngle = _normalizeAngle(end);
      widget.onPetChanged(widget.pets[_selectedIndex]);
    });
  }

  double _normalizeAngle(double angle) {
    var a = angle % (2 * math.pi);
    if (a > math.pi) a -= 2 * math.pi;
    if (a < -math.pi) a += 2 * math.pi;
    return a;
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details, double radiusX) {
    _animController.stop();
    setState(() {
      _currentAngle += details.primaryDelta! / (radiusX * 1.05);
    });
  }

  void _onHorizontalDragEnd(DragEndDetails details, double radiusX) {
    final velocity = details.primaryVelocity ?? 0.0;
    final momentum = -velocity / 1200.0;
    final estimatedAngle = _currentAngle + momentum * _angleStep;

    var nearestIndex = (-estimatedAngle / _angleStep).round() % petCount;
    if (nearestIndex < 0) nearestIndex += petCount;

    _animateToIndex(nearestIndex);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = widget.height;
        final centerX = width / 2;
        final centerY = height * 0.52;
        final radiusX = (width * 0.38).clamp(90.0, 160.0);
        final verticalArc = (height * 0.08).clamp(12.0, 30.0);
        final basePetSize = (height * 0.54).clamp(140.0, 240.0);

        final items = <_CarouselItemData>[];
        for (var i = 0; i < petCount; i++) {
          final pet = widget.pets[i];
          final angle = i * _angleStep + _currentAngle;
          final deltaAngle = _normalizeAngle(angle);

          final z = math.cos(deltaAngle);
          final sinA = math.sin(deltaAngle);

          final x = centerX + radiusX * sinA;
          final y = centerY + verticalArc * (1 - z) * 0.65;
          final depthFactor = ((z + 1) / 2).clamp(0.0, 1.0);

          final scale = ui.lerpDouble(0.60, 1.15, depthFactor)!;
          final opacity = ui.lerpDouble(0.40, 1.0, depthFactor)!.clamp(0.0, 1.0);

          items.add(_CarouselItemData(
            index: i,
            pet: pet,
            x: x,
            y: y,
            z: z,
            scale: scale,
            opacity: opacity,
          ));
        }

        items.sort((a, b) => a.z.compareTo(b.z));

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onHorizontalDragUpdate: (d) => _onHorizontalDragUpdate(d, radiusX),
          onHorizontalDragEnd: (d) => _onHorizontalDragEnd(d, radiusX),
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                for (final item in items)
                  Positioned(
                    left: item.x - (basePetSize * item.scale) / 2,
                    top: item.y - (basePetSize * item.scale) / 2,
                    child: _CarouselPetWidget(
                      pet: item.pet,
                      scale: item.scale,
                      opacity: item.opacity,
                      size: basePetSize,
                      isFront: item.index == _selectedIndex,
                      onTap: () {
                        if (item.index != _selectedIndex) {
                          _animateToIndex(item.index);
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CarouselItemData {
  _CarouselItemData({
    required this.index,
    required this.pet,
    required this.x,
    required this.y,
    required this.z,
    required this.scale,
    required this.opacity,
  });

  final int index;
  final PetType pet;
  final double x;
  final double y;
  final double z;
  final double scale;
  final double opacity;
}

class _CarouselPetWidget extends StatelessWidget {
  const _CarouselPetWidget({
    required this.pet,
    required this.scale,
    required this.opacity,
    required this.size,
    required this.isFront,
    required this.onTap,
  });

  final PetType pet;
  final double scale;
  final double opacity;
  final double size;
  final bool isFront;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final petDimension = size * scale;

    return Semantics(
      button: true,
      label: pet.label,
      selected: isFront,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Opacity(
          opacity: opacity,
          child: SizedBox(
            width: petDimension,
            height: petDimension,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  bottom: petDimension * 0.04,
                  child: Container(
                    width: petDimension * 0.65,
                    height: petDimension * 0.12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.elliptical(
                          petDimension * 0.65,
                          petDimension * 0.12,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3E2B20).withValues(
                            alpha: (0.28 * opacity).clamp(0.0, 1.0),
                          ),
                          blurRadius: 10 * scale,
                          spreadRadius: 2 * scale,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Image.asset(
                    pet.imageAssetPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
