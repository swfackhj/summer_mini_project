import 'package:flame_game/controller/player_controller.dart';
import 'package:flame_game/flowChart/flutter_flow_chart.dart';
import 'package:flame_game/flowChart/src/elements/value_condition_element.dart';
import 'package:flame_game/flowChart/src/elements/value_element.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CodeController extends GetxController {
  final dashboard = Dashboard();

  late StartElement startElement;
  late EndElement endElement;

  RxBool isRunning = false.obs;

  @override
  void onInit() {
    super.onInit();

    endElement = EndElement(
      callback: (_){
        isRunning.value = false;
      }
    );

    startElement = StartElement(
      callback: (_){
        isRunning.value = true;
      }
    );

    dashboard.addElement(startElement);
    dashboard.addElement(endElement);
  }

  void resetDashboard(){
    dashboard.removeAllElements();
    dashboard.addElement(startElement);
    dashboard.addElement(endElement);
  }

  void onLongPressed(BuildContext context, Offset offset, FlowElement element) {
    showMenu(
        context: context,
        position:
            RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, offset.dy),
        color: Colors.transparent,
        elevation: 0,
        items: [
          PopupMenuItem(
            child: FloatingActionButton(
              mini: true,
              child: const Icon(Icons.delete),
              onPressed: () {
                dashboard.removeElement(element);
                Navigator.pop(context);
              },
            ),
          )
        ]);
  }

  void onPressed(BuildContext context, Offset offset, FlowElement element) {
    if (element is AlgorithmFlowElement) {
      element.onTap?.call(context, offset);
    }
  }

  void runFlow() {
    print("============");
    _loop(startElement);
  }

  void _loop(AlgorithmFlowElement element) async {
    print(element.text);
    await element.callback?.call(dashboard);
    await Future.delayed(const Duration(milliseconds: 600));
    for (var nextE in dashboard.getNextOf(element)) {
      _loop(nextE);
    }
  }

  void addFire() {
    final ee = ActionElement(
        callback: (_) async {
          Get.find<PlayerController>().shoot();
          await Future.delayed(const Duration(milliseconds: 500));
        },
        text: 'Fire');
    dashboard.addElement(ee);
  }

  void addMoveRight() {
    final ee = ActionElement(
        callback: (_) async {
          Get.find<PlayerController>().setBeforeX(
              Get.find<PlayerController>().playerComponent!.position.x);
          Get.find<PlayerController>().setIsMoved(true);
          await Future.delayed(const Duration(seconds: 1));
        },
        text: 'Move Right');
    dashboard.addElement(ee);
  }

  void addRotateUp() {
    final ee = ActionElement(
        callback: (_) async {
          await Get.find<PlayerController>().rotate(135);
        },
        text: 'Rotate Up');
    dashboard.addElement(ee);
  }

  void addRotateDown() {
    final ee = ActionElement(
        callback: (_) {
          Get.find<PlayerController>().rotate(180);
        },
        text: 'Rotate Down');
    dashboard.addElement(ee);
  }

  void addCanonValue(){
    final ee = ValueElement(
      valueKey: 'Canon'
    );
    dashboard.addElement(ee);
  }

  void addVal2(){
    final ee = ValueElement(
        valueKey: 'val2'
    );
    dashboard.addElement(ee);
  }

  void addVal3(){
    final ee = ValueElement(
        valueKey: 'val3'
    );
    dashboard.addElement(ee);
  }

  void addValueCondition(){
    final ee = ValueConditionElement(
      // boolFunc: (valueKey1, valueKey2){
      //   DataRepository.getData(valueKey);
      //   return true;
      // }
    );
    dashboard.addElement(ee);
  }

  void addData(){
    final ee = DataElement();
    dashboard.addElement(ee);
  }

  void addPrint(){
    final ee = ValueActionElement(
      text: 'print',
      callback: (valueKey){
        print(DataRepository.getData(valueKey));
      }
    );
    dashboard.addElement(ee);
  }
}
