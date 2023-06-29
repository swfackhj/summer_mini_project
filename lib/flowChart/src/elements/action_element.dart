import 'package:flutter/material.dart';
import 'package:flame_game/flowChart/flutter_flow_chart.dart';

class ActionElement extends AlgorithmFlowElement{
  ActionElement( {
    void Function(Dashboard)? callback,
    String? text
  }) : super(
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
}