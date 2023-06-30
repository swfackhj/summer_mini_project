import 'package:flame_game/flowChart/flutter_flow_chart.dart';
import 'package:flutter/material.dart';

enum Comparison {
  equal,
  greater,
  lesser,

}

class ValueConditionElement extends ConditionElement{
  String? valueKey;
  bool Function(String valueKey) valuedBoolFunc;

  ValueConditionElement({
    String? text = 'if _ cond',
    required bool Function(String valueKey) boolFunc,
    Offset? position
  }):
  valuedBoolFunc = boolFunc,
  super(
    position: position,
    boolFunc: ()=>true,
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
            child: Text(str, style: const TextStyle(fontSize: 15),),
            onTap: (){
              valueKey = str;
            },
          )
      ],
    );
  };

  @override
  bool Function() get boolFunc=>(){
    if(valueKey!=null){
      return valuedBoolFunc.call(valueKey!);
    }
    return true;
  };
}