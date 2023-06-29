import 'package:flutter/material.dart';

import '../elements/flow_element.dart';

/// Common widget for the element text
class ElementTextWidget extends StatelessWidget {
  final FlowElement element;

  const ElementTextWidget({
    super.key,
    required this.element,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Text(
        element.text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: element.textColor,
          fontSize: element.textSize,
          fontWeight: element.textIsBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
