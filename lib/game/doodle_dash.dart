import 'dart:async';

import 'package:doodle_dash/game/platform_manager.dart';
import 'package:doodle_dash/game/sprites/player.dart';
import 'package:doodle_dash/game/world.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class DoodleDash extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  DoodleDash({super.children});

  final PlatformManager platformManager =
      PlatformManager(maxVerticalDistancetoNextPlatform: 350);
  final World _world = World();
  Player dash = Player();

  int screenBufferSpace = 100;

  @override
  FutureOr<void> onLoad() async {
    await add(_world);
    dash.position = Vector2((_world.size.x - dash.size.x) / 2,
        (_world.size.y + screenBufferSpace) + dash.size.y);
    await world.add(dash);
    await world.add(platformManager);
    camera.setBounds(Rectangle.fromLTRB(0, -_world.size.y,
        camera.viewport.size.x, _world.size.y + screenBufferSpace));
    dash.megaJump();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (dash.isMovingDown) {
      debugPrint('ima going down');
      camera.setBounds(Rectangle.fromLTRB(
          0,
          camera.viewport.position.y - screenBufferSpace,
          // -100,
          camera.viewport.size.x,
          camera.viewport.position.y + _world.size.y));
    }

    // var isInTopHalfOfScreen = dash.position.y <= (_world.size.y / 2);
    if (!dash.isMovingDown
    // && isInTopHalfOfScreen
    ) {
      camera.follow(dash,);
      
      camera.setBounds(Rectangle.fromLTRB(
          0,
          camera.viewport.position.y- screenBufferSpace,
          camera.viewport.size.x,
          camera.viewport.position.y + _world.size.y));
    }

    if (dash.position.y > camera.viewport.position.y + _world.size.y + dash.size.y + screenBufferSpace){
      onLose();
    }
    // if (!camera.canSee(dash)) {
    //   onLose();
    // }
  }

  void onLose() {
    debugPrint('ooops! GAME OVER');
    pauseEngine();
  }

  @override
  Color backgroundColor() {
    return const Color.fromARGB(255, 4, 0, 10);
  }
}
