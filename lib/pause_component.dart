import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:moonlander/main.dart';

class PauseComponent extends SpriteComponent
    with Tappable, HasGameRef<MoonlanderGame> {
  PauseComponent({
    required Vector2 position,
    required Sprite sprite,
  }) : super(position: position, size: Vector2(50, 25), sprite: sprite);

  @override
  bool onTapDown(TapDownInfo info) {
    if (gameRef.overlays.isActive('pause')) {
      gameRef.overlays.remove('pause');
    } else {
      gameRef.overlays.add('pause');
    }

    return super.onTapDown(info);
  }
}
