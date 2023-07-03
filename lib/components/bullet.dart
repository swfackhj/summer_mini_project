import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_game/components/player.dart';
import 'package:flame_game/controller/player_controller.dart';
import 'package:flame_game/game/my_game.dart';
import 'package:flame_game/main.dart';
import 'package:get/get.dart';

class Bullet extends PositionComponent
    with CollisionCallbacks, HasGameRef<MyGame> {
  double time = 0;
  double rad;

  final controller = Get.put(PlayerController());

  Bullet({required this.rad}) {

    debugMode = true;
    var bulletsSprites = Flame.images.fromCache("Bomb.png");
    var bulletComponent = SpriteComponent.fromImage(bulletsSprites,
        size: Vector2(25, 25),
        srcPosition: Vector2(3, 10),
        srcSize: Vector2(512, 512));

    bulletComponent.position = Vector2(0, 0);

    add(bulletComponent);
  }
  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    print(other);
    if (other.runtimeType == Bullet) {
      print('bullet');
    } else if (other.runtimeType == Player) {
      print('player');
    }
  }

  @override
  void onMount() {
    super.onMount();

    // player 객체 사이즈의 반지름 0.8배 작은 원형 히트박스 추가
    final shape = CircleHitbox.relative(
      2,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(shape);
  }

  @override
  void update(double dt) {
    super.update(dt);
    time += dt;

    var xValue = 30 * cos(rad);
    var yValue = 30 * sin(rad) - 9.8 * time;

    position.x -= xValue * time;
    position.y -= (yValue * time - 0.5 * 9.8 * time * time);

    // 스크린 범위 밖으로 나가면 객체 제거
    if (position.y > Singleton().screenSize!.y) {
      removeFromParent();
    }
  }

  void destroy() {
    removeFromParent();
  }
}
