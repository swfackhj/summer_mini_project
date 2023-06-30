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
              controller: uiController.vert.value,
              child: SingleChildScrollView(
                controller: uiController.hori.value,
                scrollDirection: Axis.horizontal,
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
            )
          ),
          Obx(()=> uiController.addOn.value? Positioned(
            top: 0,
            right: 0,
            child: SizedBox(
              width: 100,
              child: Column(
                children: [
                  const SizedBox(height: 10,),
                  ElevatedButton(onPressed: codeController.addFire, child: const Text('fire')),
                  const SizedBox(height: 10,),
                  ElevatedButton(onPressed: codeController.addMoveRight, child: const Text('move right')),
                  const SizedBox(height: 10,),
                  ElevatedButton(onPressed: codeController.addRotateUp, child: const Text('rotate up')),
                  const SizedBox(height: 10,),
                  ElevatedButton(onPressed: codeController.addRotateDown, child: const Text('rotate down')),
                  const SizedBox(height: 10,),
                  ElevatedButton(onPressed: codeController.addCanonValue, child: const Text('value')),
                  const SizedBox(height: 10,),
                  ElevatedButton(onPressed: codeController.addVal2, child: const Text('value2')),
                  const SizedBox(height: 10,),
                  ElevatedButton(onPressed: codeController.addVal3, child: const Text('value3')),
                  const SizedBox(height: 10,),
                  ElevatedButton(onPressed: codeController.addValueCondition, child: const Text('condition')),
                  const SizedBox(height: 10,),
                  ElevatedButton(onPressed: codeController.addData, child: const Text('operation')),
                  const SizedBox(height: 10,),
                  ElevatedButton(onPressed: codeController.addPrint, child: const Text('print')),
                ],
              ),
            ),
          ): const Positioned.fill(child: SizedBox())),
          Positioned(
            bottom: 15,
            left: 15,
            child: Obx(()=>FloatingActionButton(
              onPressed: codeController.isRunning.value ? null : () => codeController.runFlow(),
              backgroundColor: codeController.isRunning.value ? Colors.grey : Colors.blue,
              child: const Icon(Icons.play_arrow),
            )),
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
