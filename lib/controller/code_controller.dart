import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flame_game/controller/player_controller.dart';
import 'package:flame_game/flowChart/flutter_flow_chart.dart';
import 'package:flame_game/flowChart/src/elements/value_condition_element.dart';
import 'package:flame_game/flowChart/src/elements/value_element.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CodeController extends GetxController {
  var dashboard = Dashboard();

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

  void addFire({String? id}) {
    final ee = ActionElement(
        callback: functions['Fire'],
        text: 'Fire');
    if(id!=null) ee.setId(id);
    dashboard.addElement(ee);
  }

  void addMoveRight({String? id}) {
    final ee = ActionElement(
        callback: functions['Move Right'],
        text: 'Move Right');
    if(id!=null) ee.setId(id);
    dashboard.addElement(ee);
  }

  void addRotateUp({String? id}) {
    final ee = ActionElement(
        callback: functions['Rotate Up'],
        text: 'Rotate Up');
    if(id!=null) ee.setId(id);
    dashboard.addElement(ee);
  }

  void addRotateDown({String? id}) {
    final ee = ActionElement(
        callback: functions['Rotate Down'],
        text: 'Rotate Down');
    if(id!=null) ee.setId(id);
    dashboard.addElement(ee);
  }

  void addCanonValue({String? id}){
    final ee = ValueElement(
      valueKey: 'Canon'
    );
    if(id!=null) ee.setId(id);
    dashboard.addElement(ee);
  }

  void addVal2({String? id}){
    final ee = ValueElement(
        valueKey: 'val2'
    );
    if(id!=null) ee.setId(id);
    dashboard.addElement(ee);
  }

  void addVal3({String? id}){
    final ee = ValueElement(
        valueKey: 'val3'
    );
    if(id!=null) ee.setId(id);
    dashboard.addElement(ee);
  }

  void addValueCondition({String? id}){
    final ee = ValueConditionElement(
      // boolFunc: (valueKey1, valueKey2){
      //   DataRepository.getData(valueKey);
      //   return true;
      // }
    );
    if(id!=null) ee.setId(id);
    dashboard.addElement(ee);
  }

  void addData({String? id}){
    final ee = DataElement();
    if(id!=null) ee.setId(id);
    dashboard.addElement(ee);
  }

  void addPrint({String? id}){
    final ee = ValueActionElement(
      text: 'print',
      callback: functions['print']
    );
    if(id!=null) ee.setId(id);
    dashboard.addElement(ee);
  }

  static Map<String,dynamic Function(dynamic)> functions = {
    'Fire': (_) async {
      Get.find<PlayerController>().shoot();
      await Future.delayed(const Duration(milliseconds: 500));
    },
    'Move Right': (_) async {
      Get.find<PlayerController>().setBeforeX(
          Get.find<PlayerController>().playerComponent!.position.x);
      Get.find<PlayerController>().setIsMoved(true);
      await Future.delayed(const Duration(seconds: 1));
    },
    'Rotate Up': (_) async {
      await Get.find<PlayerController>().rotate(135);
    },
    'Rotate Down': (_) async {
      await Get.find<PlayerController>().rotate(180);
    },
    'print': (valueKey){
      print(DataRepository.getData(valueKey));
    }
  };
  
  void loadDashBoard(String id){
    FirebaseFirestore.instance.collection('dashboard').doc(id).get().then(
      (x){
        if(x.data()!=null) {
          dashboard.removeAllElements();
          dashboard.elements = Dashboard.algorFromMap(x.data()!);
          dashboard.update();

          startElement = dashboard.elements.singleWhere((element) => element.text=='Start') as StartElement;
          startElement.callback = (_){isRunning.value = true;};
          endElement = dashboard.elements.singleWhere((element) => element.text=='End') as EndElement;
          endElement.callback = (_){isRunning.value = false;};
        }
      },
    );
  }

  void saveDashBoard(){
    final userId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('dashboard').doc(userId).set(
      dashboard.toMap()
    );
  }
}
