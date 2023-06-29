import 'package:flame_game/game/my_game.dart';
import 'package:flame_game/managers/game_manager.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';

class MainMenuOverlay extends StatefulWidget {
  final Game game;

  const MainMenuOverlay(this.game, {super.key});

  @override
  State<MainMenuOverlay> createState() => _MainMenuOverlayState();
}

class _MainMenuOverlayState extends State<MainMenuOverlay> {
  @override
  Widget build(BuildContext context) {
    MyGame game = widget.game as MyGame;

    return LayoutBuilder(builder: (_, constraints) {
      late String buttonStr;
      late double backOpacity;
      if (game.gameManager.currentState == GameState.intro) {
        backOpacity = 1;
        buttonStr = '시작하기';
      } else if (game.gameManager.currentState == GameState.pause) {
        backOpacity = 0.8;
        buttonStr = '계속하기';
      }

      return Material(
          child: Container(
        color: Colors.black,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Text(
                  'Fortress Game',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 50,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 100,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (game.gameManager.currentState == GameState.intro) {
                        game.startGame();
                      } else if (game.gameManager.currentState ==
                          GameState.pause) {
                        game.pauseAndresumeGame();
                      }
                    },
                    child: Text(
                      buttonStr,
                      style: const TextStyle(fontSize: 15),
                    )),
              ],
            ),
          ),
        ),
      ));
    });
  }
}
