import 'package:flutter/material.dart';
import 'package:flame_game/flowChart/flutter_flow_chart.dart';

import 'value_element.dart';

enum Operation{
  set('='),
  add('+'),
  sub('-'),
  mul('×'),
  div('÷'),
  mod('%');

  final String text;
  const Operation(this.text);
}

class DataElement extends AlgorithmFlowElement{
  Operation operation = Operation.set;
  String? operand1;
  String? operand2;
  dynamic resultBuffer;

  DataElement({
    dynamic Function(Dashboard board)? callback,
    Offset? position,
  }): super(
    position: position,
    callback: callback,
    text: 'Data',
    kind: ElementKind.parallelogram,
    backgroundColor: Colors.yellow[300],
    size: const Size(50, 30),
    handlers: [
      Handler.topCenter,
      Handler.bottomCenter,
      // Handler.rightCenter
      Handler.rightUpper,
      Handler.rightLower,
      Handler.leftCenter
    ],
  );

  @override
  Function(Dashboard board)? get callback => (board){
    ValueElement? op1, op2;
    dynamic o1, o2;
    if(operand1!=null){
      final e = board.findElementById(operand1!);
      if(e!=null){
        if(e is ValueElement){
          op1 = e;
          o1 = DataRepository.getData(op1.valueKey);
        }
        else if(e is DataElement){
          o1 = e.resultBuffer;
        }
      }
    }
    if(operand2!=null){
      final e = board.findElementById(operand2!);
      if(e!=null){
        if(e is ValueElement){
          op2 = e;
          o2 = DataRepository.getData(op2.valueKey);
        }
        else if(e is DataElement){
          o2 = e.resultBuffer;
        }
      }
    }

    switch(operation){
      case Operation.add:
        resultBuffer = o1+o2;
        break;
      case Operation.sub:
        resultBuffer = o1-o2;
        break;
      case Operation.mul:
        resultBuffer = o1*o2;
        break;
      case Operation.div:
        resultBuffer = o1/o2;
        break;
      case Operation.mod:
        resultBuffer = o1%o2;
        break;
      case Operation.set:
      default:
        resultBuffer = o1;
    }

    if(result!=null){
      final e = board.findElementById(result!);
      if(e!=null&& e is ValueElement){
        DataRepository.setData(e.valueKey, resultBuffer);
      }
    }
  };

  @override
  dynamic Function(BuildContext context, Offset offset)? get onTap => (context, offset){
    showMenu(
        context: context,
        position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, offset.dy),
        items: [
          for(Operation op in Operation.values)
            PopupMenuItem(
              height: 20,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(op.text),
              onTap: (){
                operation = op;
                setText(op.name);
            },)
        ]
    );
  };

  @override
  String? get nextFlow => super.next.singleWhere((element) => element.arrowParams.startArrowPosition == Alignment.bottomCenter).destElementId;

  String? get result {
    final res = next.where((element) => element.arrowParams.startArrowPosition == Alignment.centerLeft);
    return res.isNotEmpty ? res.first.destElementId : null;
  }
}

class DataRepository {
  static Map<String,dynamic> storage = {};

  static dynamic getData(String? key) {
    if(key==null || !storage.containsKey(key)) return null;
    return storage[key];
  }
  static void setData(String key, dynamic value) {
    storage.putIfAbsent(key, () => value);
    storage[key] = value;
  }
}