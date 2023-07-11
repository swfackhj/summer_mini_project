import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_game/components/enemy.dart';
import 'package:flame_game/main.dart';

enum BombState { alive, dead }

class Bomb extends PositionComponent with HasGameRef, CollisionCallbacks {
  late final BombComponent bombComponent;
  double time = 0;

  Bomb({super.position})
      : super(size: Vector2(100, 100), anchor: Anchor.center) {
    var bombImage = Flame.images.fromCache("Bomb.png");
    var boomImage = Flame.images.fromCache("Boom.png");

    var bulletComponent = SpriteComponent.fromImage(bombImage,
        size: Vector2(25, 25),
        srcPosition: Vector2(0, 0),
        srcSize: Vector2(512, 512));

    List<Sprite> spritesBomb = [
      Sprite(bombImage, srcPosition: Vector2(0, 0), srcSize: Vector2(512, 512))
    ];

    List<Sprite> spritesBoom = [
      Sprite(boomImage,
          srcPosition: Vector2(122.75, 0), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(245.5, 0), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(368.25, 0), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(491, 0), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(613.75, 0), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(736.5, 0), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(859.25, 0), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(0, 114.4), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(122.75, 114.4), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(245.5, 114.4), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(368.25, 114.4), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(491, 114.4), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(613.75, 114.4), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(736.5, 114.4), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(859.25, 114.4), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(0, 228.8), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(122.75, 228.8), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(245.5, 228.8), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(368.25, 228.8), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(491, 228.8), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(613.75, 228.8), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(736.5, 228.8), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(859.25, 228.8), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(0, 343.2), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(122.75, 343.2), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(245.5, 343.2), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(368.25, 343.2), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(491, 343.2), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(613.75, 343.2), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(736.5, 343.2), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(859.25, 343.2), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(0, 457.6), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(122.75, 457.6), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(245.5, 457.6), srcSize: Vector2(122.75, 114.4)),
      Sprite(boomImage,
          srcPosition: Vector2(368.25, 457.6), srcSize: Vector2(122.75, 114.4)),
    ];

    var animatedBomb = SpriteAnimation.spriteList(spritesBomb, stepTime: 0.15);
    var animatedBoom =
        SpriteAnimation.spriteList(spritesBoom, stepTime: 0.01, loop: false);
    animatedBoom.onComplete = () => destroy();

    bombComponent = BombComponent<BombState>(
        {BombState.alive: animatedBomb, BombState.dead: animatedBoom});
    bombComponent.current = BombState.alive;
    add(bombComponent);
  }

  @override
  void onMount() {
    super.onMount();
    final shape = CircleHitbox.relative(
      0.8,
      parentSize: size,
      position: size / 2,
      anchor: Anchor.center,
    );
    add(shape);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
    time += dt * 5;

    if (bombComponent.current == BombState.dead) return;

    const radians = 60 * pi / 180;
    var xValue = 15 * cos(radians);
    var yValue = 15 * sin(radians);

    position.x += xValue * time;
    position.y += -1 * yValue * time + 9.81 * time * time / 2;

    // 스크린 범위 밖으로 나가면 객체 제거
    if (position.y > Singleton().screenSize!.y) {
      removeFromParent();
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is Enemy) {
      bombComponent.current = BombState.dead;
    }
  }

  void destroy() {
    removeFromParent();
  }
}

class BombComponent<T> extends SpriteAnimationGroupComponent<T> {
  BombComponent(Map<T, SpriteAnimation> bombAnimationMap)
      : super(size: Vector2(25, 25), animations: bombAnimationMap);

  @override
  void update(double dt) {
    super.update(dt);
  }

  void playerUpdate(BombState bombState) {
    current = bombState as T?;
  }
}
