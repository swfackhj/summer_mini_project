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
}