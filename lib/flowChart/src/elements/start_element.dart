import 'package:flutter/material.dart';
import 'package:flame_game/flowChart/flutter_flow_chart.dart';

class StartElement extends AlgorithmFlowElement{
  StartElement({Offset position = const Offset(100,100)}):super(
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
}

class EndElement extends AlgorithmFlowElement{
  EndElement():super(
      text: 'End',
      size: const Size(50, 30),
      kind: ElementKind.rectangle,
      position: const Offset(100, 500),
      backgroundColor: Colors.white,
      handlers: [
        Handler.topCenter,
      ]
  );

  @override
  String? get nextFlow => null;
}