import 'dart:async';

import 'package:doodle_dash/game/doodle_dash.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Platform extends SpriteComponent with HasGameRef<DoodleDash>, CollisionCallbacks{
  final hitbox = RectangleHitbox();

  Platform({
    super.position
  }): super(
    size: Vector2.all(50),
    priority: 2
  );

  @override
  FutureOr<void> onLoad() async{
    await super.onLoad();
    sprite = await gameRef.loadSprite('platform.png');
    await add(hitbox);
  }
}