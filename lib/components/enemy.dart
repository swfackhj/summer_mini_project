import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_game/components/bullet.dart';
import 'package:flame_game/game/my_game.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:rive/rive.dart';

class Enemy extends RiveComponent with CollisionCallbacks, HasGameRef<MyGame> {
  final Artboard enemyArtboard;
  Vector2 vector2;
  late final RiveComponent _playerComponent;

  Enemy({required this.enemyArtboard, required this.vector2})
      : super(
            artboard: enemyArtboard, size: Vector2.all(200), position: vector2);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = true;
  }

  @override
  void onMount() {
    super.onMount();

    final shape = CircleHitbox.relative(
      0.4,
      parentSize: size / 2,
      position: size / 2,
      anchor: Anchor.center,
    );

    add(shape);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is Bullet) {
      print('hitted');
    }
  }

  void setPosition(Vector2 position) {
    _playerComponent.position = position;
  }

  void destroy() {
    removeFromParent();
  }
}
