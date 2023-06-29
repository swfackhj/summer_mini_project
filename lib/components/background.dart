import 'package:flame/components.dart';
import 'package:flame/image_composition.dart';
import 'package:flame_game/main.dart';

class Background extends PositionComponent {
  late final BackgroundComponent _background;

  double get backgroundX => _background.x;
  double get backgroundY => _background.y;

  Background(Image spriteImg, Vector2 postion) {
    _background = BackgroundComponent(spriteImg, Vector2(0, 0),
        Vector2(Singleton().screenSize!.x * 0.7, 512), postion);
    add(_background);
  }

  void setPositionBGImg01(double x, double y) {
    _background.position.x = x;
    _background.position.y = y;
  }
}

class BackgroundComponent extends SpriteComponent {
  BackgroundComponent(Image backgroundImag, Vector2 srcPosition,
      Vector2 srcSize, Vector2 postion)
      : super.fromImage(backgroundImag,
            srcPosition: srcPosition,
            srcSize: srcSize,
            position: postion,
            // 배경 이미지 사이즈를 전체 화면 세로 사이즈의 두배로 설정
            size: Vector2(
                Singleton().screenSize!.x, Singleton().screenSize!.y * 2));
}
