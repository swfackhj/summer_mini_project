import 'package:flame/experimental.dart';
import 'package:flame/game.dart';
import 'package:flame_game/components/player.dart';
import 'package:flame_game/components/my_world.dart';
import 'package:flame_game/controller/player_controller.dart';
import 'package:flame_game/main.dart';
import 'package:flame_game/managers/enemy_manager.dart';
import 'package:flame_game/managers/game_manager.dart';
import 'package:flame_game/managers/item_manager.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:rive/components.dart';

class MyGame extends FlameGame
    with HasTappableComponents, HasDraggableComponents, HasCollisionDetection {
  late MyWorld _world;
  late Player _player;
  final GameManager _gameManager = GameManager();
  late EnemyManager _enemyManager;
  late ItemManager _itemManager;

  MyGame();

  GameManager get gameManager => _gameManager;

  late RiveComponent playerComponent;

  final playerController = Get.put(PlayerController());

  @override
  onLoad() async {
    await super.onLoad();

    Singleton().screenSize = size;
    _world = MyWorld();

    add(_world);
    add(_gameManager);

    overlays.add('gameOverlay');
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (_gameManager.currentState == GameState.gameOver) {
      return;
    }

    if (_gameManager.currentState == GameState.intro ||
        _gameManager.currentState == GameState.pause) {
      overlays.add('mainMenuOverlay');
      return;
    }
  }

  void _initializeGameStart() async {
    // 하단 중앙에 위치
    _enemyManager = EnemyManager();
    _itemManager = ItemManager();

    Artboard playerArtboard =
        await loadArtboard(RiveFile.asset('images/tank.riv'));
    final controller = StateMachineController.fromArtboard(
        playerArtboard, 'State Machine 1',
        onStateChange: playerController.onChange);

    playerArtboard.addController(controller!);
    playerArtboard.forEachComponent((p0) {
      if (p0.name == 'canon') {
        playerController.node = p0 as Node;
        playerController.node!.rotation = 0;
      }
      playerController.fire = controller.findInput<bool>('fire') as SMITrigger;
      playerController.right =
          controller.findInput<bool>('facingRight') as SMIBool;
    });

    Player playerComponent = Player(playerArtboard: playerArtboard);
    playerController.setPosition(playerComponent.x, playerComponent.y);
    playerController.rotate(3.14);
    add(playerComponent);
  }

  void startGame() {
    _initializeGameStart();
    _gameManager.changeState(GameState.playing);
    overlays.remove('mainMenuOverlay');
  }

  void pauseAndresumeGame() {
    if (_gameManager.currentState == GameState.playing) {
      pauseEngine();
      overlays.add('mainMenuOverlay');
      _gameManager.changeState(GameState.pause);
    } else if (_gameManager.currentState == GameState.pause) {
      overlays.remove('mainMenuOverlay');
      resumeEngine();
      _gameManager.changeState(GameState.playing);
    }
  }

  void gameOver({bool isLastBoss = false}) {
    if (isLastBoss) {
      _player.removeFromParent();
    }
    _enemyManager.destroy();
    _itemManager.destroy();
    _gameManager.reset();
    _gameManager.changeState(GameState.gameOver);
    overlays.add('gameOverOverlay');
  }

  // 게임오버 이후 다시시작
  void reStartGame() {
    _initializeGameStart();
    _gameManager.changeState(GameState.playing);
    overlays.remove('gameOverOverlay');
  }

  void onChange(String machineName, String stateName) {
    stateName == 'fire';
  }
}
