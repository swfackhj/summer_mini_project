import 'package:flutter/material.dart';
import 'package:flame_game/flowChart/flutter_flow_chart.dart';

class StartElement extends AlgorithmFlowElement{
  StartElement({
    Offset position = const Offset(100,100),
    dynamic Function(Dashboard board)? callback,
  }):super(
    callback: callback,
      text: 'Start',
      size: const Size(30, 30),
      position: position,
      kind: ElementKind.oval,
      backgroundColor: Colors.red[300],
      handlers: [
        Handler.bottomCenter,
      ]
  );

  @override
  String? get nextFlow => super.next.singleWhere((element) => element.arrowParams.startArrowPosition == Alignment.bottomCenter).destElementId;

  @override
  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      'type': 'Start',
      'pos.x': position.dx,
      'pos.y': position.dy,
      'id': id,
      'next': next.map((x)=> x.toMap()).toList(),
    };
  }

  factory StartElement.fromMap(Map<String, dynamic> map){
    StartElement e = StartElement(
      position: Offset(map['pos.x'] as double, map['pos.y'] as double),
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

class EndElement extends AlgorithmFlowElement{
  EndElement({
    dynamic Function(Dashboard board)? callback,
    Offset? position,
  }):super(
      callback: callback,
      text: 'End',
      size: const Size(50, 30),
      kind: ElementKind.rectangle,
      position: position ?? const Offset(100, 500),
      backgroundColor: Colors.white,
      handlers: [
        Handler.topCenter,
      ]
  );

  @override
  String? get nextFlow => null;

  @override
  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      'type': 'End',
      'pos.x': position.dx,
      'pos.y': position.dy,
      'id': id
    };
  }

  factory EndElement.fromMap(Map<String,dynamic> map){
    EndElement e = EndElement(
      position: Offset(map['pos.x'] as double, map['pos.y'] as double),
    );
    e.setId(map['id'] as String);
    return e;
  }
}