import 'package:flame_game/controller/code_controller.dart';
import 'package:flutter/material.dart';
import 'package:flame_game/flowChart/flutter_flow_chart.dart';

class ActionElement extends AlgorithmFlowElement{
  ActionElement( {
    void Function(Dashboard)? callback,
    String? text,
    Offset? position,
  }) : super(
    position: position,
    kind: ElementKind.rectangle,
    callback: callback,
    backgroundColor: Colors.blue[300],
    size: const Size(50, 30),
    text: text??'Action',
    handlers: [
      Handler.topCenter,
      Handler.bottomCenter,
    ],
  );

  @override
  String? get nextFlow => super.next.singleWhere((element) => element.arrowParams.startArrowPosition == Alignment.bottomCenter).destElementId;

  @override
  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      'type': 'Action',
      'pos.x': position.dx,
      'pos.y': position.dy,
      'text': text,
      'id': id,
      'next': next.map((x)=> x.toMap()).toList(),
    };
  }

  factory ActionElement.fromMap(Map<String, dynamic> map){
    ActionElement e = ActionElement(
      position: Offset(map['pos.x'] as double, map['pos.y'] as double),
      text: map['text'] as String,
      callback: CodeController.functions[map['text'] as String]
    );
    e.setId(map['id'] as String);
    e.next.addAll(List<ConnectionParams>.from(
      (map['next'] as List<dynamic>).map<dynamic>(
            (x) => ConnectionParams.fromMap(x as Map<String, dynamic>),
      ),
    ));
    return e;
  }
}