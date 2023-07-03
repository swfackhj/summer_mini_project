import 'package:flame_game/controller/code_controller.dart';
import 'package:flutter/material.dart';
import 'package:flame_game/flowChart/flutter_flow_chart.dart';

class ValueActionElement extends ActionElement{
  String? valueKey;
  dynamic Function(String valueKey)? valuedCallback;

  ValueActionElement({
    dynamic Function(String valueKey)? callback,
    String? text,
    Offset? position,
  }):
  valuedCallback = callback,
  super(
    position: position,
    text: text
  );

  @override
  void Function(BuildContext context, Offset offset) get onTap => (context, offset){
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, offset.dy),
      items: [
        for(final str in DataRepository.storage.keys)
          PopupMenuItem(
            height: 20,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(str, style: const TextStyle(fontSize: 12),),
            onTap: (){
              valueKey = str;
            },
          )
      ],
    );
  };

  @override
  void Function(Dashboard board) get callback => (board){
    if(valueKey!=null){
      valuedCallback?.call(valueKey!);
    }
  };

  @override
  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      'type': 'ValueAction',
      'pos.x': position.dx,
      'pos.y': position.dy,
      'text': text,
      'id': id,
      'next': next.map((x)=> x.toMap()).toList(),
      'valueKey': valueKey,
    };
  }

  factory ValueActionElement.fromMap(Map<String, dynamic> map){
    ValueActionElement e = ValueActionElement(
        position: Offset(map['pos.x'] as double, map['pos.y'] as double),
        text: map['text'] as String,
        callback: CodeController.functions[map['text'] as String]
    );
    e.setId(map['id']);
    e.next.addAll(List<ConnectionParams>.from(
      (map['next'] as List<dynamic>).map<dynamic>(
            (x) => ConnectionParams.fromMap(x as Map<String, dynamic>),
      ),
    ));
    e.valueKey = map['valueKey'] as String;
    return e;
  }
}