import 'package:flame_game/flowChart/flutter_flow_chart.dart';
import 'package:flutter/material.dart';

enum Comparison {
  equal,
  greater,
  lesser,
}

class ValueConditionElement extends ConditionElement{
  String? valueKey1;
  String? valueKey2;
  bool Function(String valueKey1, String valueKey2)? valuedBoolFunc;
  Comparison comparator = Comparison.equal;

  ValueConditionElement({
    String? text = 'if _ cond',
    bool Function(String valueKey1, String valueKey2)? boolFunc,
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
        PopupMenuItem(
          height: 20,
          child: PopupMenuButton(
            child: const Text('Value 1', style: TextStyle(fontSize: 15),),
            itemBuilder: (context)=>[
              if(DataRepository.storage.isNotEmpty)
                for(final str in DataRepository.storage.keys)
                  PopupMenuItem(
                    value: str,
                    height: 20,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(str, style: const TextStyle(fontSize: 15),),
                    onTap: (){
                      valueKey1 = str;
                    },
                  )
            ],
          ),
        ),
        PopupMenuItem(
          height: 20,
          child: PopupMenuButton(
            child: const Text('Comparator', style: TextStyle(fontSize: 15),),
            itemBuilder: (context)=>[
              for(final co in Comparison.values)
                PopupMenuItem(
                  height: 20,
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(co.name),
                  onTap: (){
                    comparator = co;
                    setText(co.name);
                  },)
            ],
          ),
        ),
        PopupMenuItem(
          height: 20,
          child: PopupMenuButton(
            child: const Text('Value 2', style: TextStyle(fontSize: 15),),
            itemBuilder: (context)=>[
              if(DataRepository.storage.isNotEmpty)
                for(final str in DataRepository.storage.keys)
                  PopupMenuItem(
                    value: str,
                    height: 20,
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Text(str, style: const TextStyle(fontSize: 15),),
                    onTap: (){
                      valueKey2 = str;
                    },
                  )
            ],
          ),
        ),
      ],
    );
  };

  @override
  bool Function() get boolFunc=>(){
    if(valueKey1!=null && valueKey2!=null){
      // return valuedBoolFunc?.call(valueKey1!,valueKey2!);

      final val1 = DataRepository.getData(valueKey1);
      final val2 = DataRepository.getData(valueKey2);

      if(val1 != null && val2 != null){
        print('hello');
        switch(comparator){
          case Comparison.equal:
            return val1 == val2;
          case Comparison.greater:
            return val1 > val2;
          case Comparison.lesser:
            return val1 < val2;
        }
      }
    }
    return true;
  };

  Future<String?> showVariables(BuildContext context, Offset offset)async{
    return await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, offset.dy),
      items: [
        for(final str in DataRepository.storage.keys)
          PopupMenuItem(
            value: str,
            height: 20,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(str, style: const TextStyle(fontSize: 15),),
            onTap: (){},
          )
      ],
    );
  }
}