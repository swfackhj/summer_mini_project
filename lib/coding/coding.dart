import 'package:flame_game/controller/code_controller.dart';
import 'package:flame_game/controller/code_ui_controller.dart';
import 'package:flame_game/controller/player_controller.dart';
import 'package:flame_game/flowChart/flutter_flow_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CodingWidget extends StatelessWidget {
  final playerController = Get.put(PlayerController());
  final codeController = Get.put(CodeController());
  final uiController = Get.put(CodeUIController());

  CodingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children:[
          Positioned.fill(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              controller: uiController.vert.value,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                controller: uiController.hori.value,
                child: SizedBox(
                  width: 1000,
                  height: 1000,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: FlowChart(
                          dashboard: codeController.dashboard,
                          onElementLongPressed: codeController.onLongPressed,
                          onElementPressed: codeController.onPressed,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Obx(()=> uiController.addOn.value? Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              width: 100,
              child: Column(
                children: [
                  ElevatedButton(onPressed: codeController.addFire, child: const Text('fire')),
                  const SizedBox(height: 10,),
                  ElevatedButton(onPressed: codeController.addMoveRight, child: const Text('move right')),
                  const SizedBox(height: 10,),
                  ElevatedButton(onPressed: codeController.addRotateUp, child: const Text('rotate up')),
                ],
              ),
            ),
          ): const Positioned.fill(child: SizedBox())),
          Positioned(
            bottom: 15,
            left: 15,
            child: FloatingActionButton(
              onPressed: (){
                codeController.runFlow();
              },
              child: const Icon(Icons.play_arrow),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          uiController.addOn.toggle();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
