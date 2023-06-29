import 'package:flutter/material.dart';

import '../dashboard.dart';
import '../elements/flow_element.dart';
import 'handler_widget.dart';

class ResizeWidget extends StatefulWidget {
  final Dashboard dashboard;
  final FlowElement element;
  final Widget child;

  const ResizeWidget({
    super.key,
    required this.element,
    required this.dashboard,
    required this.child,
  });

  @override
  State<ResizeWidget> createState() => _ResizeWidgetState();
}

class _ResizeWidgetState extends State<ResizeWidget> {
  late Size elementStartSize;
  late Offset elementStartPosition;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.element.size.width,
      height: widget.element.size.height,
      child: Stack(
        children: [
          widget.child,
          _bottomRightHandler(),
        ],
      ),
    );
  }

  Widget _bottomRightHandler() {
    return Listener(
      onPointerDown: (event) {
        elementStartSize = widget.element.size;
      },
      onPointerMove: (event) {
        elementStartSize += event.localDelta;
        widget.element.changeSize(elementStartSize);
      },
      onPointerUp: (event) {
        widget.dashboard.setElementResizable(widget.element, false);
      },
      child: const Align(
        alignment: Alignment.bottomRight,
        child: HandlerWidget(
          width: 30,
          height: 30,
          icon: Icon(Icons.compare_arrows),
        ),
      ),
    );
  }
}
