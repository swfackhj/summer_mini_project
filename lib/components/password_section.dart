import 'package:flame_game/controller/user_controller.dart';
import 'package:flame_game/styles/title_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PasswordSection extends StatelessWidget {
  PasswordSection({super.key});

  final screenSize = Get.context!.mediaQuerySize;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (userController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '비밀번호',
            style: titleStyle,
          ),
          SizedBox(height: screenSize.height * 0.01),
          SizedBox(
            height: screenSize.height * 0.05,
            child: TextField(
              controller: userController.passwordController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  hintText: '비밀번호를 입력해주세요',
                  hintStyle: TextStyle(fontSize: 12.0)),
              obscureText: true,
              cursorColor: Colors.black,
            ),
          )
        ],
      );
    });
  }
}
