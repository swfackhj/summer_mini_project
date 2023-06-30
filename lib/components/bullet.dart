import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_game/components/enemy.dart';
import 'package:flame_game/controller/player_controller.dart';
import 'package:get/get.dart';

class Bullet extends PositionComponent with CollisionCallbacks {
  final double _speed = 500;

  double time = 0;
  double rad;

  final controller = Get.put(PlayerController());

  Bullet({required this.rad}) {
    var bulletsSprites = Flame.images.fromCache("Bullets.png");
    var bullet02 = SpriteComponent.fromImage(bulletsSprites,
        srcPosition: Vector2(12, 0), srcSize: Vector2(11, 11));

    bullet02.position = Vector2(6, 0);

    add(bullet02);
  }

  @override
  void onMount() {
    super.onMount();

    // player 객체 사이즈의 반지름 0.8배 작은 원형 히트박스 추가
    final shape = CircleHitbox.relative(
      0.8,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(shape);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Enemy 충돌시
    if (other is Enemy) {
      destroy();
    }
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
    if (position.y < 0) {
      removeFromParent();
    }
  }

  void destroy() {
    removeFromParent();
  }
}
