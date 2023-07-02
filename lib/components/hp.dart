import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class HP extends SpriteAnimationComponent with HasGameRef, CollisionCallbacks {
  HP() : super(size: Vector2.all(100));

  late final SpriteAnimation _animation1;
  late final SpriteAnimation _animation2;
  late final SpriteAnimation _animation3;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadAnimations();
    animation = _animation1;
    // var spriteImage = await Flame.images.load('hp.png');
    // var spriteSheet =
    //     SpriteSheet(image: spriteImage, srcSize: Vector2(9000, 2000));

    // sprite = spriteSheet.getSprite(0, 0);
  }

  Future<void> _loadAnimations() async {
    final spriteSheet = SpriteSheet(
        image: await gameRef.images.load('explosion.png'),
        srcSize: Vector2(125, 114));

    _animation1 =
        spriteSheet.createAnimation(row: 0, stepTime: 0.5, from: 1, to: 2);

    _animation2 = spriteSheet.createAnimation(row: 1, stepTime: 0.15, to: 2);

    _animation3 = spriteSheet.createAnimation(row: 2, stepTime: 0.15, to: 2);
  }
}
