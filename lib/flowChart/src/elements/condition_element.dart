import 'package:flutter/material.dart';
import 'package:flame_game/flowChart/flutter_flow_chart.dart';

class ConditionElement extends AlgorithmFlowElement {
  bool Function() boolFunc;
  ConditionElement({
    required this.boolFunc,
    String text = 'if',
    Offset? position,
  }) : super(
            position: position,
            kind: ElementKind.diamond,
            text: text,
            backgroundColor: Colors.green[300],
            size: const Size(50, 30),
            handlers: const [
              Handler.topCenter,
              Handler.bottomCenter,
              Handler.rightCenter,
            ]);

  @override
  String? get nextFlow {
    if (boolFunc()) {
      return super
          .next
          .singleWhere((element) =>
              element.arrowParams.startArrowPosition == Alignment.bottomCenter)
          .destElementId;
    } else {
      return super
          .next
          .singleWhere((element) =>
              element.arrowParams.startArrowPosition == Alignment.centerRight)
          .destElementId;
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': 'Condition',
      'pos.x': position.dx,
      'pos.y': position.dy,
      'text': text,
      'id': id,
      'next': next.map((x) => x.toMap()).toList()
    };
  }

  factory ConditionElement.fromMap(Map<String, dynamic> map) {
    ConditionElement e = ConditionElement(
      position: Offset(map['pos.x'] as double, map['pos.y'] as double),
      text: map['text'] as String,
      boolFunc: () => true,
    );
    e.setId(map['id']);
    e.next.addAll(List<ConnectionParams>.from(
      (map['next'] as List<dynamic>).map<dynamic>(
        (x) => ConnectionParams.fromMap(x as Map<String, dynamic>),
      ),
    ));
    return e;
  }
}
