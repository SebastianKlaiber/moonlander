import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum RocketState {
  /// Rocket is idle.
  idle,

  /// Rocket is slightly to the left.
  left,

  /// Rocket is slightly to the right.
  right,

  /// Rocket is to the far left.
  farLeft,

  /// Rocket is to the far right.
  farRight,
}

enum RocketHeading {
  /// Rocket is heading to the left.
  left,

  /// Rocket is heading to the right.
  right,

  /// Rocket is idle.
  idle,
}

class RocketComponent extends SpriteAnimationGroupComponent<RocketState>
    with HasHitboxes, Collidable, KeyboardHandler {
  /// Create a new Rocket component at the given [position].
  RocketComponent({
    required Vector2 position,
    required Vector2 size,
    required Map<RocketState, SpriteAnimation> animation,
  }) : super(position: position, size: size, animations: animation);

  var _heading = RocketHeading.idle;
  final _speed = 10;
  final _animationSpeed = .1;
  var _animationTime = 0.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    current = RocketState.idle;
    addHitbox(HitboxRectangle());
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is RawKeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
        _heading = RocketHeading.left;
      } else if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
        _heading = RocketHeading.right;
      } else {
        _heading = RocketHeading.idle;
      }
    }
    return true;
  }

  void _setAnimationState() {
    switch (_heading) {
      case RocketHeading.idle:
        if (current != RocketState.idle) {
          if (current == RocketState.farLeft) {
            current = RocketState.left;
          } else if (current == RocketState.farRight) {
            current = RocketState.right;
          } else {
            current = RocketState.idle;
          }
        }
        break;
      case RocketHeading.left:
        if (current != RocketState.farLeft) {
          if (current == RocketState.farRight) {
            current = RocketState.right;
          } else if (current == RocketState.right) {
            current = RocketState.idle;
          } else if (current == RocketState.idle) {
            current = RocketState.left;
          } else {
            current = RocketState.farLeft;
          }
        }
        break;
      case RocketHeading.right:
        if (current != RocketState.farRight) {
          if (current == RocketState.farLeft) {
            current = RocketState.left;
          } else if (current == RocketState.left) {
            current = RocketState.idle;
          } else if (current == RocketState.idle) {
            current = RocketState.right;
          } else {
            current = RocketState.farRight;
          }
        }
        break;
    }
  }

  @override
  void update(double dt) {
    position.y += _speed * dt;
    _animationTime += dt;
    if (_animationTime >= _animationSpeed) {
      _setAnimationState();
      _animationTime = 0;
    }

    super.update(dt);
  }
}
