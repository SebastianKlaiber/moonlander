import 'dart:async';

import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:moonlander/rocket_component.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Flame.device.setLandscape();

  final game = MoonlanderGame();

  runApp(GameWidget(game: game));
}

class MoonlanderGame extends FlameGame with HasCollidables {
  @override
  Future<void>? onLoad() {
    unawaited(add(RocketComponent(position: size / 2, size: Vector2.all(20))));

    return super.onLoad();
  }
}
