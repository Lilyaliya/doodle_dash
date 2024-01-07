import 'dart:math';

import 'package:doodle_dash/game/doodle_dash.dart';
import 'package:doodle_dash/game/sprites/platform.dart';
import 'package:flame/components.dart';

class PlatformManager extends Component with HasGameRef<DoodleDash> {
  PlatformManager({required this.maxVerticalDistancetoNextPlatform}) : super();

  final Random random = Random();
  final List<Platform> platforms = [];
  final double maxVerticalDistancetoNextPlatform;
  final double minVerticalDistanceToNextPlatform = 200;
  @override
  void onMount() {
    var currentY = game.size.y - (random.nextInt(game.size.y.floor()) / 3);
    for (var i = 0; i < 9; i++) {
      if (i != 0) {
        currentY = _generateNextY();
      }
      platforms.add(Platform(
          position: Vector2(
              random.nextInt(game.size.x.floor()).toDouble(), currentY)));
    }

    for (var tile in platforms) {
      add(tile);
    }
    super.onMount();
  }

  double _generateNextY() {
    final currentHighestPlatformY = platforms.last.center.y;
    final distanceToNextY = minVerticalDistanceToNextPlatform.toInt() +
        random
            .nextInt((maxVerticalDistancetoNextPlatform -
                    minVerticalDistanceToNextPlatform)
                .floor())
            .toDouble();

    return currentHighestPlatformY - distanceToNextY;
  }

  @override
  void update(double dt) {
    final topOfLowestPlatform = platforms.first.position.y;
    final screenBottom = gameRef.dash.position.y + (gameRef.size.x / 2) + gameRef.screenBufferSpace;
    if (topOfLowestPlatform > screenBottom){
      var newPlatY = _generateNextY();
      var newPlatX = random.nextInt(gameRef.size.x.floor() - 60).toDouble();

      final newPlat = Platform(position: Vector2(newPlatX, newPlatY));
      add(newPlat);
      platforms.add(newPlat);
      // final lowestPlat = platforms.removeAt(0);
      // lowestPlat.removeFromParent();
    }
    super.update(dt);
  }
}
