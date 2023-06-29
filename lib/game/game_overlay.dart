import 'package:flame/game.dart';
import 'package:flame_game/controller/player_controller.dart';
import 'package:flame_game/game/score_display.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

class GameOverlay extends StatefulWidget {
  final Game game;

  const GameOverlay(this.game, {super.key});

  @override
  State<GameOverlay> createState() => _GameOverlayState();
}

class _GameOverlayState extends State<GameOverlay> {
  final playerController = Get.put(PlayerController());
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScoreDisplay(game: widget.game),
              ElevatedButton(
                onPressed: () {
                  playerController.shoot();
                  // (widget.game as MyGame).pauseAndresumeGame();
                },
                child: const Icon(
                  Icons.pause,
                  size: 30,
                ),
              ),
            ],
          ),
        ));
  }
}
