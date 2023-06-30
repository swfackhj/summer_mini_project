import 'dart:math';

import 'package:flame_game/components/player.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:rive/components.dart';
import 'package:rive/rive.dart';

class PlayerController extends GetxController {
  Player? playerComponent;
  SMITrigger? fire;
  SMIBool? right;
  Node? node;
  double rotation = 0;
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

  void shoot() async {
    isShooted = true;
    fire?.fire();
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
    if (rotation > pi / 2) {
      val = pi - rotation;
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
    this.isMoved = isMoved;
    update();
  }

  void setBeforeX(double beforeX) {
    this.beforeX = beforeX;
  }

  void move() {
    if (playerComponent!.position.x - beforeX > 100) {
      return;
    }

    playerComponent!.position.x += 1;

    update();
  }
}
