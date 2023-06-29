import 'dart:math';

import 'package:flame_game/controller/player_controller.dart';
import 'package:flame_game/flowChart/flutter_flow_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CodeController extends GetxController{
  final dashboard = Dashboard();

  final startElement = StartElement();
  final endElement = EndElement();

  RxBool isRunning = false.obs;

  @override
  void onInit() {
    super.onInit();
    dashboard.addElement(startElement);
    dashboard.addElement(endElement);
  }

  void onLongPressed(BuildContext context, Offset offset, FlowElement element){
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, offset.dy),
        color: Colors.transparent,
        elevation: 0,
        items: [
          PopupMenuItem(
            child: FloatingActionButton(
              mini: true,
              child: const Icon(Icons.delete),
              onPressed: (){
                dashboard.removeElement(element);
                Navigator.pop(context);
              },
            ),
          )
        ]
    );
  }

  void onPressed(BuildContext context, Offset offset, FlowElement element){
    if(element is AlgorithmFlowElement){
      element.onTap?.call(context,offset);
    }
  }

  void runFlow(){
    print("============");
    _loop(startElement);
  }

  void _loop(AlgorithmFlowElement element) async {
    print(element.text);
    await element.callback?.call(dashboard);
    await Future.delayed(const Duration(milliseconds: 600));
    for(var nextE in dashboard.getNextOf(element)){
      _loop(nextE);
    }
  }

  void addFire(){
    final ee = ActionElement(
      callback: (_) async {
        Get.find<PlayerController>().shoot();
        await Future.delayed(const Duration(milliseconds: 500));
      },
      text: 'Fire'
    );
    dashboard.addElement(ee);
  }

  void addMoveRight(){
    final ee = ActionElement(
      callback: (_){
        Get.find<PlayerController>().x += 10;
        Get.find<PlayerController>().update();
      },
      text: 'Move Right'
    );
    dashboard.addElement(ee);
  }

  void addRotateUp(){
    final ee = ActionElement(
        callback: (_){
          Get.find<PlayerController>().rotate(pi - pi/4);
        },
        text: 'Rotate Up'
    );
    dashboard.addElement(ee);
  }
}