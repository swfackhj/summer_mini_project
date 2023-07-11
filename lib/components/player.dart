import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:flame_game/components/bullet.dart';
import 'package:flame_game/controller/player_controller.dart';
import 'package:flame_game/game/my_game.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:get/instance_manager.dart';
import 'package:rive/rive.dart';

class Player extends RiveComponent
    with DragCallbacks, CollisionCallbacks, HasGameRef<MyGame> {
  final Artboard playerArtboard;
  Vector2 vector2;
  late final RiveComponent _playerComponent;

  final playerController = Get.put(PlayerController());

  Player({required this.playerArtboard, required this.vector2})
      : super(
            artboard: playerArtboard,
            size: Vector2.all(200),
            position: vector2);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    debugMode = true;
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
  void update(double dt) {
    super.update(dt);

    if (playerController.isMoved == true) {
      playerController.move();
    }

    if (playerController.isShooted == true) {
      final rad = dt / 180 * pi;
      Bullet bullet = Bullet()
        // Bullet의 사이즈 설정
        ..size = Vector2(19, 25)
        // Bullet의 위치 설정
        ..position = Vector2(
            playerController.playerComponent!.x + 175 * cos(rad),
            playerController.playerComponent!.y + 80 - 350 * sin(rad))
        // Bullet의 기준점 설정
        ..anchor = Anchor.center;
      gameRef.add(bullet);
      print(cos(180));
      playerController.rotate(180 - 30);
      playerController.setIsShooted(false);
    }
  }

  void setPosition(Vector2 position) {
    _playerComponent.position = position;
  }

  void destroy() {
    removeFromParent();
  }
}
