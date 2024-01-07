import 'dart:async';

import 'package:doodle_dash/game/doodle_dash.dart';
import 'package:doodle_dash/game/sprites/platform.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
// import 'package:flutter/src/services/raw_keyboard.dart';

enum DashDirection {left, right}

class Player extends SpriteGroupComponent<DashDirection> with HasGameRef<DoodleDash>, KeyboardHandler, CollisionCallbacks{
  Player({super.position}): super(
    size: Vector2.all(100),
    anchor: Anchor.center,
    priority: 1
  );

  final Vector2 velocity = Vector2.zero();

  // parameter for defining if player moves right or left
  int _hAxisInput = 0;

  final double _moveAxisSpeed = 200;
  final double _gravity =3;
  final double _jumpSpeed = 300;

  @override
  FutureOr<void> onLoad() async{
    await super.onLoad();
    await add(RectangleHitbox());
    final leftDash = await game.loadSprite('player_left.png');
    final rightDash = await game.loadSprite('player_right.png');

    sprites = <DashDirection, Sprite>{
      DashDirection.left : leftDash,
      DashDirection.right: rightDash
    };

    current = DashDirection.right;
  }

  @override
  void update(double dt) {
    velocity.x = _hAxisInput * _moveAxisSpeed;
    velocity.y += _gravity;

    if (position.x < size.x  / 2){
      position.x = game.size.x + size.x + 10;
    }
    if (position.x > game.size.x + size.x + 10){
      position.x = size.x / 2;
    }
    position += velocity * dt;
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _hAxisInput = 0;
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)){
      current = DashDirection.left;
      _hAxisInput--;
    }

    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)){
      current = DashDirection.right;
      _hAxisInput++;
    }
    return true;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Platform){
      bool isMovingDown = velocity.y > 0;
      bool isCollisionVertically = (intersectionPoints.first.y - intersectionPoints.last.y).abs() < 5;

      if (isMovingDown && isCollisionVertically){
        jump();
      }
    }
    super.onCollision(intersectionPoints, other);
  }

  void jump(){
    velocity.y =-_jumpSpeed;
  }

  void megaJump(){
    velocity.y = -_jumpSpeed * 1.5;
  }

  bool get isMovingDown => velocity.y > 0;


}