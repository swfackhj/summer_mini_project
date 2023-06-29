import 'package:flutter/material.dart';
import 'package:flame_game/flowChart/flutter_flow_chart.dart';

class ConditionElement extends AlgorithmFlowElement{
  bool Function() boolFunc;
  ConditionElement({
    required this.boolFunc,
  }): super(
    kind: ElementKind.diamond,
    text: 'if',
    backgroundColor: Colors.green[300],
    size: const Size(50, 30),
    handlers: const [
      Handler.topCenter,
      Handler.bottomCenter,
      Handler.rightCenter,
    ]
  );

  @override
  String? get nextFlow {
    if(boolFunc()){
      return super.next.singleWhere((element) => element.arrowParams.startArrowPosition == Alignment.bottomCenter).destElementId;
    } else {
      return super.next.singleWhere((element) => element.arrowParams.startArrowPosition == Alignment.centerRight).destElementId;
    }
  }
}