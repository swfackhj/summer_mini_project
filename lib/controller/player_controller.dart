import 'package:flame_game/components/player.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:rive/rive.dart';

class PlayerController extends GetxController {
  Player? playerComponent;
  SMITrigger? fire;
  SMIBool? forward;
  SMIBool? moving;
  SMINumber? rot;
  bool firing = false;
  bool isShooted = false;
  bool isMoved = false;
  double x = 0;
  double y = 0;
  double beforeX = 0;

  void setPlayer(Player playerComponent) {
    this.playerComponent = playerComponent;
    update();
  }

  void playerInit(Artboard board) {
    final cont = StateMachineController.fromArtboard(board, 'State Machine 1',
        onStateChange: onChange);
    board.addController(cont!);
  }

  void shoot() async {
    isShooted = true;
    fire?.fire();
    update();
  }

  void onChange(String machineName, String stateName) {
    firing = stateName == 'fire';
    update();
  }

  void trigger() {
    fire?.value = true;
    Future.delayed(
        const Duration(milliseconds: 100), () => fire?.value = false);
    update();
  }

  void turn() {
    forward?.value = !forward!.value;
    update();
  }

  Future<void> rotate(double rotation) async {
    final step = (rotation-rot!.value)/50.0;
    for(int i = 0; i<50; i++){
      rot!.value = rot!.value+step;
      await Future.delayed(const Duration(milliseconds: 10));
    }
    update();
  }

  void setPosition(double x, double y) {
    this.x = x;
    this.y = y;
    update();
  }

  double value() {
    return 0.1;
  }

  void setIsShooted(bool isShooted) {
    this.isShooted = isShooted;
    update();
  }

  void setIsMoved(bool isMoved) {
    moving?.value = true;
    forward?.value = false;
    this.isMoved = isMoved;
    update();
  }

  void setBeforeX(double beforeX) {
    this.beforeX = beforeX;
  }

  void move() {
    if (playerComponent!.position.x - beforeX > 100) {
      moving?.value = false;
      return;
    }

    playerComponent!.position.x += 1;

    update();
  }
}
