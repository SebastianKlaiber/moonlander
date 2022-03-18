import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:moonlander/pause_component.dart';
import 'package:moonlander/pause_menu.dart';
import 'package:moonlander/rocket_component.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.device.setLandscape();

  final game = MoonlanderGame();

  runApp(
    MaterialApp(
      home: GameWidget(
        game: game,
        loadingBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorBuilder: (context, ex) {
          debugPrint(ex.toString());

          return const Center(
            child: Text('Sorry, something went wrong. Reload me'),
          );
        },
        overlayBuilderMap: {
          'pause': (context, MoonlanderGame game) => PauseMenu(game: game),
        },
      ),
    ),
  );
}

class MoonlanderGame extends FlameGame
    with
        HasCollidables,
        HasTappables,
        HasKeyboardHandlerComponents,
        HasDraggables {
  void onOverlayChanged() {
    if (overlays.isActive('pause')) {
      pauseEngine();
    } else {
      resumeEngine();
    }
  }

  @override
  bool get debugMode => kDebugMode;

  void restart() {}

  @override
  void onMount() {
    overlays.addListener(onOverlayChanged);
    super.onMount();
  }

  @override
  void onRemove() {
    overlays.removeListener(onOverlayChanged);
    super.onRemove();
  }

  @override
  Future<void>? onLoad() async {
    final image = await images.load('joystick.png');
    final sheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: 6,
      rows: 1,
    );
    final joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: sheet.getSpriteById(1),
        size: Vector2.all(100),
      ),
      background: SpriteComponent(
        sprite: sheet.getSpriteById(0),
        size: Vector2.all(150),
      ),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );
    unawaited(add(joystick));

    unawaited(
      add(
        RocketComponent(
          position: size / 2,
          size: Vector2(32, 48),
          joystick: joystick,
        ),
      ),
    );

    unawaited(
      add(
        PauseComponent(
          margin: const EdgeInsets.all(5),
          sprite: await Sprite.load('PauseButton.png'),
          spritePressed: await Sprite.load('PauseButtonInvert.png'),
          onPressed: () {
            if (overlays.isActive('pause')) {
              overlays.remove('pause');
            } else {
              overlays.add('pause');
            }
          },
        ),
      ),
    );

    overlays.addListener(onOverlayChanged);

    return super.onLoad();
  }
}
