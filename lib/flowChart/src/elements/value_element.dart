import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'algorithm_flow.dart';
import 'connection_params.dart';
import 'data_element.dart';
import 'flow_element.dart';

class ValueElement extends AlgorithmFlowElement{
  final String valueKey;

  ValueElement({
    required this.valueKey,
    Offset? position,
  }):super(
    position: position,
    text: valueKey,
    size: const Size(50, 30),
    kind: ElementKind.rectangle,
    backgroundColor: Colors.deepOrange[300],
    handlers: [
      Handler.leftCenter,
      Handler.topCenter
    ]
  );

  TextEditingController in1 = TextEditingController();
  TextEditingController in2 = TextEditingController();

  @override
  void Function(BuildContext context, Offset offset) get onTap => (context, offset){
    final val = DataRepository.getData(valueKey);
    if(val is String){
      in2.clear();
      in1.text = val;
    }else if (val is num){
      in1.clear();
      in2.text = val.toString();
    }

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, offset.dy),
      items: [
        PopupMenuItem(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('텍스트', style: TextStyle(fontSize: 12),),
              SizedBox(
                width: 80,
                child: TextField(
                  controller: in1,
                  style: const TextStyle(fontSize: 12, height: 1),
                  decoration: const InputDecoration(
                    isDense: true
                  ),
                ),
              ),
              TextButton(onPressed: (){
                DataRepository.setData(valueKey, in1.text);
                Navigator.pop(context);
              }, child: const Text('완료', style: TextStyle(fontSize: 12),))
            ],
          ),
        ),
        PopupMenuItem(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('숫 자', style: TextStyle(fontSize: 12),),
              SizedBox(
                width: 80,
                child: TextField(
                  controller: in2,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 12),
                  decoration: const InputDecoration(
                    isDense: true
                  ),
                ),
              ),
              TextButton(onPressed: (){
                DataRepository.setData(valueKey, num.parse(in2.text));
                Navigator.pop(context);
              }, child: const Text('완료', style: TextStyle(fontSize: 12),))
            ],
          ),
        ),

      ],
    );
  };

  @override
  String? get nextFlow => null;

  @override
  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      'type': 'Value',
      'pos.x': position.dx,
      'pos.y': position.dy,
      'id': id,
      'next': next.map((x)=> x.toMap()).toList(),
      'valueKey': valueKey,
    };
  }

  factory ValueElement.fromMap(Map<String, dynamic> map){
    ValueElement e = ValueElement(
      position: Offset(map['pos.x'] as double, map['pos.y'] as double),
      valueKey: map['valueKey'] as String
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