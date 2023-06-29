import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'algorithm_flow.dart';
import 'data_element.dart';
import 'flow_element.dart';

class ValueElement extends AlgorithmFlowElement{
  final String valueKey;

  ValueElement({
    required this.valueKey
  }):super(
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
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, offset.dy),
      items: [
        PopupMenuItem(
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: TextField(
                  controller: in1,
                ),
              ),
              TextButton(onPressed: (){
                DataRepository.setData(valueKey, in1.text);
              }, child: const Text('완료'))
            ],
          ),
        ),
        PopupMenuItem(
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: TextField(
                  controller: in2,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                ),
              ),
              TextButton(onPressed: (){
                DataRepository.setData(valueKey, int.parse(in2.text));
              }, child: const Text('완료'))
            ],
          ),
        ),

      ],
    );
  };

  @override
  String? get nextFlow => null;
}