import 'package:flame_game/controller/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class CodingWidget extends StatelessWidget {
  final playerController = Get.put(PlayerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              playerController.shoot();
            },
            child: const Text('shoot')),
      ),
    );
  }
}
