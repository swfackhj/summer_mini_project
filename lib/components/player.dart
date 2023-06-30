import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_game/components/bullet.dart';
import 'package:flame_game/controller/player_controller.dart';
import 'package:flame_game/game/my_game.dart';
import 'package:flame_game/main.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:get/instance_manager.dart';

enum PlayerDirection { go, left, right, boom }

class Player extends RiveComponent
    with DragCallbacks, CollisionCallbacks, HasGameRef<MyGame> {
  final Artboard playerArtboard;
  late final RiveComponent _playerComponent;
  final bool _isDragging = false;

  final playerController = Get.put(PlayerController());

  Player({required this.playerArtboard})
      : super(
            artboard: playerArtboard,
            size: Vector2.all(200),
            position: Vector2(Singleton().screenSize!.x * 0.1 - 200,
                Singleton().screenSize!.y - 140));

  double bulletTime = 0;

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
  void update(double dt) {
    super.update(dt);

    if (playerController.isMoved == true) {
      playerController.move();
    }

    if (playerController.isShooted == true) {
      Bullet bullet = Bullet(rad: 2)
        // Bullet의 사이즈 설정
        ..size = Vector2(19, 25)
        // Bullet의 위치 설정
        ..position = Vector2(
            Singleton().screenSize!.x * 0.1, Singleton().screenSize!.y - 140)
        // Bullet의 기준점 설정
        ..anchor = Anchor.center;
      gameRef.add(bullet);
      playerController.setIsShooted(false);
    }
  }

  void playerUpdate(PlayerDirection playerDirection) {}

  void setPosition(Vector2 position) {
    _playerComponent.position = position;
  }

  void destroy() {
    removeFromParent();
  }
}

class PlayerComponent<T> extends SpriteAnimationGroupComponent<T> {
  PlayerComponent(Map<T, SpriteAnimation> playerAnimationMap)
      : super(size: Vector2(40, 40), animations: playerAnimationMap);

  @override
  void update(double dt) {
    super.update(dt);
  }

  void playerUpdate(PlayerDirection playerDirection) {
    current = playerDirection as T?;
  }
}
