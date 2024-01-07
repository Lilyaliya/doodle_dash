import 'dart:async';

import 'package:doodle_dash/game/platform_manager.dart';
import 'package:doodle_dash/game/sprites/player.dart';
import 'package:doodle_dash/game/world.dart' as c_world;
// import 'package:flame/camera.dart';
import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class DoodleDash extends FlameGame
    with HasKeyboardHandlerComponents, HasCollisionDetection {
  DoodleDash({
    super.children,
  });

  final PlatformManager platformManager =
      PlatformManager(maxVerticalDistancetoNextPlatform: 350);
  final c_world.World _world = c_world.World();
  Player dash = Player();
  // bottom border for window
  late double temp;
  bool moveDownTrigger = false;
  int screenBufferSpace = 100;

  @override
  FutureOr<void> onLoad() async {
    await add(_world);
    dash.position = Vector2((_world.size.x - dash.size.x) / 2,
        (_world.size.y + screenBufferSpace) + dash.size.y);
    await world.add(dash);
    await world.add(platformManager);
    camera.setBounds(Rectangle.fromLTRB(
        0, 0, _world.size.x, _world.size.y + screenBufferSpace));
    temp = _world.size.y;
    // temp  = 0;
    dash.megaJump();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (dash.isMovingDown) {
      debugPrint('ima going down');
      if (!moveDownTrigger) {
        temp = dash.position.y;
      }
      moveDownTrigger = true;
      camera.setBounds(Rectangle.fromLTRB(
          0,
          dash.position.y - screenBufferSpace,
          camera.viewport.size.x,
          dash.position.y + _world.size.y / 2));
    }

    var isInTopHalfOfScreen = dash.position.y <= (_world.size.y / 2);

    if (!dash.isMovingDown && isInTopHalfOfScreen) {
      moveDownTrigger = false;
      camera.setBounds(Rectangle.fromLTRB(
          0,
          dash.position.y - screenBufferSpace,
          camera.viewport.size.x,
          dash.position.y + _world.size.y / 2));
      camera.follow(dash);
    }

    // if (dash.position.y >
    //     camera.viewport.position.y +
    //         _world.size.y +
    //         dash.size.y +
    //         screenBufferSpace) {
    //   onLose();
    // }
    debugPrint(dash.position.y.toString());
    if (dash.position.y > camera.viewport.position.y + temp + 3 * dash.size.y + screenBufferSpace){
      onLose();
    }
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
