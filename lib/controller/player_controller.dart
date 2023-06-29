import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:rive/components.dart';
import 'package:rive/rive.dart';

class PlayerController extends GetxController {
  SMITrigger? fire;
  SMIBool? right;
  Node? node;
  double rotation = 0;
  bool firing = false;
  bool isShooted = false;
  double x = 0;
  double y = 0;

  void playerInit(Artboard board) {
    final cont = StateMachineController.fromArtboard(board, 'State Machine 1',
        onStateChange: onChange);
    board.addController(cont!);
    board.forEachComponent((p0) {
      // print(p0.name);
      if (p0.name == 'canon') {
        node = p0 as Node;
        node!.rotation = 0;
        // print(shape.rotation);
      }
    });
    fire = cont.findInput<bool>('fire') as SMITrigger;
    right = cont.findInput<bool>('facingRight') as SMIBool;
    rotate(3.14);
  }

  void shoot() async {
    isShooted = true;
    update();
  }

  void onChange(String machineName, String stateName) {
    firing = stateName == 'fire';
    update();
  }

  void setValue(double val) {
    node!.rotation = val;
    update();
  }

  void trigger() {
    fire?.value = true;
    Future.delayed(
        const Duration(milliseconds: 100), () => fire?.value = false);
    update();
  }

  void turn() {
    right?.value = !right!.value;
    update();
  }

  void rotate(double rotation) {
    this.rotation = rotation;
    var val = rotation;
    if (rotation > 3.14 / 2) {
      val = 3.14 - rotation;
      if (!right!.value) {
        turn();
      }
    } else if (right!.value) {
      turn();
    }

    setValue(val);
    update();
  }

  void setPosition(double x, double y) {
    print(x);
    print(y);
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
}
