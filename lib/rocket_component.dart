import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';
import 'package:moonlander/main.dart';

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
    with HasHitboxes, Collidable, HasGameRef<MoonlanderGame> {
  /// Create a new Rocket component at the given [position].
  RocketComponent({
    required Vector2 position,
    required Vector2 size,
    required this.joystick,
  }) : super(position: position, size: size, animations: {});

  final JoystickComponent joystick;

  var _heading = RocketHeading.idle;
  final _speed = 10;
  final _animationSpeed = .1;
  var _animationTime = 0.0;
  final _velocity = Vector2.zero();
  final _gravity = Vector2(0, 1);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    const stepTime = .3;
    final textureSize = Vector2(16, 24);
    const frameCount = 2;
    final idle = await gameRef.loadSpriteAnimation(
      'ship_animation_idle.png',
      SpriteAnimationData.sequenced(
        amount: frameCount,
        stepTime: stepTime,
        textureSize: textureSize,
      ),
    );
    final left = await gameRef.loadSpriteAnimation(
      'ship_animation_left.png',
      SpriteAnimationData.sequenced(
        amount: frameCount,
        stepTime: stepTime,
        textureSize: textureSize,
      ),
    );
    final right = await gameRef.loadSpriteAnimation(
      'ship_animation_right.png',
      SpriteAnimationData.sequenced(
        amount: frameCount,
        stepTime: stepTime,
        textureSize: textureSize,
      ),
    );
    final farRight = await gameRef.loadSpriteAnimation(
      'ship_animation_far_right.png',
      SpriteAnimationData.sequenced(
        amount: frameCount,
        stepTime: stepTime,
        textureSize: textureSize,
      ),
    );
    final farLeft = await gameRef.loadSpriteAnimation(
      'ship_animation_far_left.png',
      SpriteAnimationData.sequenced(
        amount: frameCount,
        stepTime: stepTime,
        textureSize: textureSize,
      ),
    );
    animations = {
      RocketState.idle: idle,
      RocketState.left: left,
      RocketState.right: right,
      RocketState.farLeft: farLeft,
      RocketState.farRight: farRight
    };
    current = RocketState.idle;
    addHitbox(HitboxRectangle());
  }

  void _setAnimationState() {
    switch (_heading) {
      case RocketHeading.idle:
        if (current != RocketState.idle) {
          if (current == RocketState.farLeft) {
            current = RocketState.left;
            angle = radians(-7.5);
          } else if (current == RocketState.farRight) {
            current = RocketState.right;
            angle = radians(7.5);
          } else {
            current = RocketState.idle;
            angle = radians(0);
          }
        }
        break;
      case RocketHeading.left:
        if (current != RocketState.farLeft) {
          if (current == RocketState.farRight) {
            current = RocketState.right;
            angle = radians(7.5);
          } else if (current == RocketState.right) {
            current = RocketState.idle;
            angle = radians(0);
          } else if (current == RocketState.idle) {
            current = RocketState.left;
            angle = radians(-7.5);
          } else {
            current = RocketState.farLeft;
            angle = radians(-15);
          }
        }
        break;
      case RocketHeading.right:
        if (current != RocketState.farRight) {
          if (current == RocketState.farLeft) {
            current = RocketState.left;
            angle = radians(-7.5);
          } else if (current == RocketState.left) {
            current = RocketState.idle;
            angle = radians(0);
          } else if (current == RocketState.idle) {
            current = RocketState.right;
            angle = radians(7.5);
          } else {
            current = RocketState.farRight;
            angle = radians(15);
          }
        }
        break;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (joystick.direction == JoystickDirection.left &&
        _heading != RocketHeading.left) {
      _heading = RocketHeading.left;
      _animationTime = 0;
    } else if (joystick.direction == JoystickDirection.right &&
        _heading != RocketHeading.right) {
      _heading = RocketHeading.right;
      _animationTime = 0;
    } else if (joystick.direction == JoystickDirection.idle &&
        _heading != RocketHeading.idle) {
      _heading = RocketHeading.idle;
      _animationTime = 0;
    }

    _updateVelocity(dt);
    position.add(_velocity);
    _animationTime += dt;
    if (_animationTime >= _animationSpeed) {
      _setAnimationState();
      _animationTime = 0;
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (gameRef.debugMode) {
      debugTextPaint.render(canvas, 'V:$_velocity', Vector2(size.x, 0));
    }
  }

  void _updateVelocity(double dt) {
    if (!joystick.delta.isZero()) {
      _velocity.add(joystick.delta.normalized() * (_speed * dt));
    }

    _velocity
      ..add(_gravity.normalized() * dt)
      ..clampScalar(-10, 10);
  }
}
