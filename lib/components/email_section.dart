import 'package:flame_game/controller/user_controller.dart';
import 'package:flame_game/styles/title_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailSection extends StatelessWidget {
  EmailSection({super.key});

  final screenSize = Get.context!.mediaQuerySize;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(builder: (userController) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('이메일', style: titleStyle),
          SizedBox(height: screenSize.height * 0.01),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: screenSize.height * 0.05,
                  child: TextField(
                    controller: userController.emailController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(),
                        hintText: '이메일을 입력해주세요',
                        hintStyle: TextStyle(fontSize: 12.0)),
                    style: const TextStyle(fontSize: 12.0),
                    cursorColor: Colors.black,
                  ),
                ),
              ),
            ],
          )
        ],
      );
    });
  }
}
