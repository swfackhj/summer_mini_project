import 'package:flutter/material.dart';
import 'package:flame_game/flowChart/flutter_flow_chart.dart';

import 'draw_arrow.dart';
import 'handler_widget.dart';

/// Draw handlers over the element
class ElementHandlers extends StatelessWidget {
  final Dashboard dashboard;
  final FlowElement element;
  final Widget child;
  final double handlerSize;
  final Function(
    BuildContext context,
    Offset position,
    Handler handler,
    FlowElement element,
  )? onHandlerPressed;
  final Function(
    BuildContext context,
    Offset position,
    Handler handler,
    FlowElement element,
  )? onHandlerLongPressed;

  const ElementHandlers({
    Key? key,
    required this.dashboard,
    required this.element,
    required this.handlerSize,
    required this.child,
    required this.onHandlerPressed,
    required this.onHandlerLongPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: element.size.width + handlerSize,
      height: element.size.height + handlerSize,
      child: Stack(
        alignment: Alignment.center,
        children: [
          child,
          for (int i = 0; i < element.handlers.length; i++)
            _ElementHandler(
              element: element,
              handler: element.handlers[i],
              dashboard: dashboard,
              handlerSize: handlerSize,
              onHandlerPressed: onHandlerPressed,
              onHandlerLongPressed: onHandlerLongPressed,
            ),
        ],
      ),
    );
  }
}

class _ElementHandler extends StatelessWidget {
  final FlowElement element;
  final Handler handler;
  final Dashboard dashboard;
  final double handlerSize;
  final Function(
    BuildContext context,
    Offset position,
    Handler handler,
    FlowElement element,
  )? onHandlerPressed;
  final Function(
    BuildContext context,
    Offset position,
    Handler handler,
    FlowElement element,
  )? onHandlerLongPressed;

  const _ElementHandler({
    Key? key,
    required this.element,
    required this.handler,
    required this.dashboard,
    required this.handlerSize,
    required this.onHandlerPressed,
    required this.onHandlerLongPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDragging = false;

    Alignment alignment;
    switch (handler) {
      case Handler.topCenter:
        alignment = const Alignment(0.0, -1.0);
        break;
      case Handler.bottomCenter:
        alignment = const Alignment(0.0, 1.0);
        break;
      case Handler.leftCenter:
        alignment = const Alignment(-1.0, 0.0);
        break;
      case Handler.rightCenter:
        alignment = const Alignment(1.0, 0.0);
        break;
      case Handler.rightUpper:
        alignment = const Alignment(1.0, -0.6);
        break;
      case Handler.rightLower:
        alignment = const Alignment(1.0, 0.6);
        break;
      default:
        alignment = const Alignment(0.0, 0.0);
    }

    Offset tapDown = Offset.zero;

    var isOutput = handler != Handler.topCenter && handler != Handler.rightLower && handler != Handler.rightUpper;

    return Align(
      alignment: alignment,
      child: DragTarget<Map>(
        onWillAccept: (data) {
          if (isOutput) return false;
          DrawingArrow.instance.setParams(DrawingArrow.instance.params
              .copyWith(endArrowPosition: alignment));
          if (data != null && element == data['srcElement']) return false;
          return true;
        },
        onAcceptWithDetails: (details) {
          dashboard.removeElementConnection(details.data['srcElement'], details.data['srcHandler']);
          dashboard.addNextById(
            details.data['srcElement'],
            element.id,
            DrawingArrow.instance.params.copyWith(endArrowPosition: alignment),
          );
          // data handle
          if(element is DataElement){
            final e = element as DataElement;
            if(handler == Handler.rightUpper) {
              e.operand1 = details.data['srcElement'].id;
            } else if(handler == Handler.rightLower) {
              e.operand2 = details.data['srcElement'].id;
            }
          }
        },
        onLeave: (data) {
          DrawingArrow.instance.setParams(DrawingArrow.instance.params
              .copyWith(endArrowPosition: const Alignment(0.0, 0.0)));
        },
        builder: (context, candidateData, rejectedData) {
          return !isOutput ? HandlerWidget(
            width: handlerSize,
            height: handlerSize,
          ) : Draggable<Map>(
            feedback: const SizedBox.shrink(),
            feedbackOffset: dashboard.handlerFeedbackOffset,
            childWhenDragging: HandlerWidget(
              width: handlerSize,
              height: handlerSize,
              backgroundColor: Colors.blue,
            ),
            data: {
              'srcElement': element,
              'srcHandler': handler,
              'alignment': alignment,
            },
            child: GestureDetector(
              onTapDown: (details) => tapDown =
                  details.globalPosition - dashboard.dashboardPosition,
              onTap: () {
                if (onHandlerPressed != null) {
                  onHandlerPressed!(context, tapDown, handler, element);
                }
              },
              onLongPress: () {
                if (onHandlerLongPressed != null) {
                  onHandlerLongPressed!(context, tapDown, handler, element);
                }
              },
              child: HandlerWidget(
                width: handlerSize,
                height: handlerSize,
              ),
            ),
            onDragUpdate: (details) {
              if (!isDragging) {
                DrawingArrow.instance.params = ArrowParams(
                    startArrowPosition: alignment,
                    endArrowPosition: const Alignment(0, 0));
                DrawingArrow.instance.from =
                    details.globalPosition - dashboard.dashboardPosition;
                isDragging = true;
              }
              DrawingArrow.instance.setTo(details.globalPosition -
                  dashboard.dashboardPosition +
                  dashboard.handlerFeedbackOffset );
            },
            onDragEnd: (details) {
              DrawingArrow.instance.reset();
              isDragging = false;
            },
          );
        },
      ),
    );
  }
}
