import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';

class RocketComponent extends PositionComponent with HasHitboxes, Collidable {
  /// Create a new Rocket component at the given [position].
  RocketComponent({
    required Vector2 position,
    required Vector2 size,
  }) : super(position: position, size: size);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addHitbox(HitboxRectangle());
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Temporary render item
    renderHitboxes(canvas, paint: Paint()..color = Colors.white);
  }
}
