import 'package:flutter/material.dart';

class MovingCircle extends StatefulWidget {
  final double vertical;
  final double horizontal;
  final List<Color> colors;
  final screenType;
  final double width;
  final Function changePosition;
  final Function setScreen;

  const MovingCircle({
    super.key,
    required this.vertical,
    required this.horizontal,
    required this.colors,
    required this.screenType,
    required this.changePosition,
    required this.setScreen,
    required this.width,
  });

  @override
  State<MovingCircle> createState() {
    return _MovingCircleState();
  }
}

class _MovingCircleState extends State<MovingCircle> {
  bool useParam = true;
  double top = 0;
  double left = 0;

  @override
  void initState() {
    super.initState();
    top = convertVerticalToDraggable(widget.vertical);
    left = convertHorizontalToDraggable(widget.horizontal);
  }

  double convertVerticalToDraggable(value) {
    value = value + 100;
    return (value / 200) * 329;
  }

  double convertHorizontalToDraggable(value) {
    value = value + 100;
    return (value / 200) * (widget.width - 60);
  }

  double convertVerticalToWebGL(value) {
    return ((value / 329) * 200) - 100;
  }

  double convertHorizontalToWebGL(value) {
    return ((value / (widget.width - 60)) * 200) - 100;
  }

  Color getColor() {
    if (widget.colors.length > 2) {
      return Colors.white;
    } else {
      return widget.colors[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 5,
              color: getColor(),
              spreadRadius: 2,
              blurStyle: BlurStyle.normal)
        ],
      ),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: getColor(),
      ),
    );
    return Stack(
      children: <Widget>[
        // SizedBox(
        //     height: 1000,
        //     width: 1000,
        //     child: Text("Top: $top Left: $left useParam: $useParam",
        //         style: TextStyle(color: Colors.white))),
        Positioned(
          top: useParam ? convertVerticalToDraggable(widget.vertical) : top,
          left:
              useParam ? convertHorizontalToDraggable(widget.horizontal) : left,
          child: Draggable<int>(
            onDragUpdate: (details) {
              if (top + details.delta.dy > 329) {
                top = 329;
              } else if (top + details.delta.dy < 0) {
                top = 0;
              } else {
                top = top + details.delta.dy;
              }

              if (left + details.delta.dx > (widget.width - 60)) {
                left = (widget.width - 60);
              } else if (left + details.delta.dx < 0) {
                left = 0;
              } else {
                left = left + details.delta.dx;
              }

              setState(() {
                if (widget.screenType == 0) {
                  widget.changePosition(1.5, 10, convertHorizontalToWebGL(left),
                      convertVerticalToWebGL(top));
                } else {
                  widget.changePosition(1.5, 11, convertHorizontalToWebGL(left),
                      convertVerticalToWebGL(top));
                }
              });
            },
            onDragStarted: () => {
              setState(() {
                top = convertVerticalToDraggable(widget.vertical);
                left = convertHorizontalToDraggable(widget.horizontal);
                useParam = false;
              })
            },
            onDragEnd: (details) => {
              setState(() {
                useParam = true;
              })
            },
            feedback: child,
            child: child,
          ),
        )
      ],
    );
  }
}
