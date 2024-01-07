import 'dart:async';

import 'package:doodle_dash/game/doodle_dash.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

class World extends ParallaxComponent<DoodleDash>{
  @override
  FutureOr<void> onLoad() async{
    
    parallax = await game.loadParallax([
      ParallaxImageData('SpaceBackground.png')
    ]);
  }
}