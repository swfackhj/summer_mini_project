import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_game/components/email_section.dart';
import 'package:flame_game/components/password_section.dart';
import 'package:flame_game/controller/code_controller.dart';
import 'package:flame_game/controller/user_controller.dart';
import 'package:flame_game/game/my_game.dart';
import 'package:flame_game/managers/game_manager.dart';
import 'package:flame_game/styles/elevated_button_style.dart';
import 'package:flame_game/styles/title_style.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:get/get.dart';

class MainMenuOverlay extends StatefulWidget {
  final Game game;

  const MainMenuOverlay(this.game, {super.key});

  @override
  State<MainMenuOverlay> createState() => _MainMenuOverlayState();
}

class _MainMenuOverlayState extends State<MainMenuOverlay> {
  final codeController = Get.find<CodeController>();
  final userController = Get.put(UserController());
  final widthSize = Get.context!.mediaQuerySize.width * 0.7;
  final heightSize = Get.context!.mediaQuerySize.height;

  @override
  Widget build(BuildContext context) {
    MyGame game = widget.game as MyGame;

    return LayoutBuilder(builder: (_, constraints) {
      late String buttonStr;
      if (game.gameManager.currentState == GameState.intro ||
          game.gameManager.currentState == GameState.singOut) {
        buttonStr = '시작하기';
      } else if (game.gameManager.currentState == GameState.pause) {
        buttonStr = '계속하기';
      }

      return Material(
          child: Container(
        color: Colors.black,
        child: GetBuilder<UserController>(builder: (controller) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Fortress',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'MineCraft',
                        fontSize: 100,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  StreamBuilder(
                    stream: FirebaseAuth.instance.authStateChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  if (game.gameManager.currentState ==
                                          GameState.intro ||
                                      game.gameManager.currentState ==
                                          GameState.gameOver) {
                                    game.startGame();
                                  } else if (game.gameManager.currentState ==
                                      GameState.pause) {
                                    game.pauseAndresumeGame();
                                  } else if (game.gameManager.currentState ==
                                      GameState.singOut) {
                                    game.resumeEngine();
                                    game.startGame();
                                  }
                                },
                                child: Text(
                                  buttonStr,
                                  style: const TextStyle(fontSize: 15),
                                )),
                            SizedBox(height: heightSize * 0.01),
                            game.gameManager.currentState == GameState.pause
                                ? ElevatedButton(
                                    onPressed: () async {
                                      await codeController.dashboard
                                          .removeAllElements();
                                      game.singOut();
                                    },
                                    child: const Text(
                                      '로그아웃',
                                      style: TextStyle(fontSize: 15),
                                    ))
                                : Container()
                          ],
                        );
                      } else {
                        return logIn();
                      }
                    },
                  )
                ],
              ),
            ),
          );
        }),
      ));
    });
  }

  Widget logIn() {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      SizedBox(
        width: widthSize * 0.3,
        child: TextField(
          controller: userController.emailController,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(),
            label: Text('Email'),
            labelStyle: TextStyle(color: Colors.black),
          ),
          cursorColor: Colors.black,
        ),
      ),
      SizedBox(
        height: heightSize * 0.025,
      ),
      SizedBox(
        width: widthSize * 0.3,
        child: TextField(
          controller: userController.passwordController,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(),
            label: Text('Password'),
            labelStyle: TextStyle(color: Colors.black),
          ),
          cursorColor: Colors.black,
          obscureText: true,
        ),
      ),
      SizedBox(
        height: heightSize * 0.025,
      ),
      SizedBox(
        width: widthSize * 0.3,
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GestureDetector(
            onTap: () async {
              userController.signInWithEmail(
                  userController.emailController.text,
                  userController.passwordController.text);
              userController.emailController.clear();
              userController.passwordController.clear();
            },
            child: Container(
                alignment: Alignment.center,
                width: widthSize * 0.14,
                height: heightSize * 0.05,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white),
                child: const Text(
                  '로그인',
                  style: elevatedStyle,
                )),
          ),
          GestureDetector(
            onTap: () {
              Get.defaultDialog(
                  title: '회원가입',
                  titleStyle: titleStyle.copyWith(fontSize: 18.0),
                  content: Column(children: [
                    EmailSection(),
                    SizedBox(height: heightSize * 0.01),
                    PasswordSection()
                  ]),
                  textConfirm: '확인',
                  buttonColor: Colors.black,
                  confirmTextColor: Colors.white,
                  onConfirm: () {
                    userController.signUpWithEamil();
                    Get.back();
                  });
            },
            child: Container(
                alignment: Alignment.center,
                width: widthSize * 0.14,
                height: heightSize * 0.05,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black),
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white),
                child: const Text(
                  '회원가입',
                  style: elevatedStyle,
                )),
          )
        ]),
      )
    ]);
  }
}
