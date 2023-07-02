import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:rive/rive.dart';

class MyGame extends FlameGame with HasCollisionDetection {
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

  void initializeGameStart() async {
    // 하단 중앙에 위치
    Artboard playerArtboard =
        await loadArtboard(RiveFile.asset('images/tank.riv'));
    final controller = StateMachineController.fromArtboard(
        playerArtboard, 'State Machine 1',
        onStateChange: playerController.onChange);

    playerArtboard.addController(controller!);
    playerController.fire = controller.findInput<bool>('fire') as SMITrigger;
    playerController.forward = controller.findInput<bool>('forward') as SMIBool;
    playerController.moving = controller.findInput<bool>('moving') as SMIBool;
    playerController.rot = controller.findInput<double>('rotation') as SMINumber;

    Player playerComponent = Player(
        playerArtboard: playerArtboard,
        vector2: Vector2(Singleton().screenSize!.x * 0.1 - 200,
            Singleton().screenSize!.y - 140));
    playerController.setBeforeX(playerComponent.x);
    playerController.setPlayer(playerComponent);
    playerController.setPosition(playerComponent.x, playerComponent.y);
    playerController.rotate(180);
    playerController.moving?.value = false;
    playerController.forward?.value = true;

    playerComponent.position.x += 100;
    add(playerController.playerComponent!);

    _enemyManager = EnemyManager();
    _itemManager = ItemManager();
  }

  void startGame() {
    initializeGameStart();
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
    } else if (_gameManager.currentState == GameState.singOut) {
      overlays.remove('mainMenuOverlay');
      resumeEngine();
      _gameManager.changeState(GameState.playing);
    }
  }

  void singOut() async {
    await FirebaseAuth.instance.signOut();
    playerController.playerComponent!.destroy();
    _enemyManager.destroy();
    _itemManager.destroy();
    _gameManager.reset();
    overlays.remove('mainMenuOverlay');
    overlays.add('mainMenuOverlay');
    _gameManager.changeState(GameState.singOut);
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
    initializeGameStart();
    _gameManager.changeState(GameState.playing);
    overlays.remove('gameOverOverlay');
  }

  void onChange(String machineName, String stateName) {
    stateName == 'fire';
  }
}
