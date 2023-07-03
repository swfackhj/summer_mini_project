import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame_game/components/enemy.dart';
import 'package:flame_game/game/my_game.dart';

final Random _rand = Random();

class EnemyManager extends Component with HasGameRef<MyGame> {
  late Timer _enemyTimer;
  final Random _random = Random();
  bool isBossDisplay = false;

  EnemyManager() : super() {
    _enemyTimer = Timer(1, onTick: _enemyTick, repeat: true);
  }

  @override
  void onMount() {
    super.onMount();
    _enemyTimer.start();
  }

  @override
  void onRemove() {
    super.onRemove();
    _enemyTimer.stop();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _enemyTimer.update(dt);
  }

  void _enemyTick() {
    if (gameRef.buildContext == null) return;

    // 0 ~ 1 사이 난수 생성 * 스크린 너비
    // 스크린 너비 사이즈 만큼 랜덤 X 위치
    Vector2 position = Vector2(_random.nextDouble() * gameRef.size.x, 0);

    int currentScore = gameRef.gameManager.score.value;
    int level = 1;
    if (isBossDisplay) {
      // 레벨5 boss는 1개만 나오도록 처리
      // boss는 출현시 나머지 적 레벨별로 랜덤 출현
      level = _random.nextInt(3) + 1;
    } else {
      level = getLevel(currentScore);
    }

    // 해당 level에 맞는 랜덤 enumy 추출
    late Enemy enemy;
    switch (level) {
    }

    // Enemy 컴포넌트가 화면안에 유지 되도록 고정
  }

  void reset() {
    _enemyTimer.start();
  }

  int getLevel(int score) {
    int level = 1;

    if (score > 40) {
      level = 5;
    } else if (score > 30) {
      level = 4;
    } else if (score > 20) {
      level = 3;
    } else if (score > 10) {
      level = 2;
    }

    //return 5; // 해당 Level 바로 테스트
    return level;
  }

  void destroy() {
    _enemyTimer.stop();
    removeFromParent();
  }
}
