import 'package:flame/components.dart';
import 'package:flame_game/components/background.dart';
import 'package:flame_game/game/my_game.dart';

class MyWorld extends Component with HasGameRef<MyGame> {
  late Background _background;

  @override
  Future<void> onLoad() async {
    var background = gameRef.images.fromCache("Backgrounds.png");
    _background = Background(background, Vector2(0, -gameRef.size.y));
    add(_background);
  }
}
