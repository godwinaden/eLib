import 'dart:ui';

import 'package:flutter/material.dart';

import 'curve_container.dart';

//main_layout painter
class SignUpContainer extends StatelessWidget {
  final Color color;
  final Color frontColor;
  final double arcHeight;
  final String position;
  final bool equality;
  final Widget child;
  final double width;
  final double height;
  final bool clock;
  final Radius radius;
  final int type;
  final double space;

  SignUpContainer({
    @required this.color,
    @required this.frontColor,
    @required this.arcHeight,
    @required this.child,
    this.radius: const Radius.circular(10),
    this.position: "Bottom",
    this.equality: false,
    this.width: double.infinity,
    this.height: double.infinity,
    this.clock: false,
    this.type: 1,
    this.space: 0.10
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: width,
          height: height,
          decoration:new BoxDecoration(
            color: Colors.blueAccent,
            image: new DecorationImage(
              image: new AssetImage("assets/images/gg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          width: width,
          height: height,
          child: CustomPaint(
            painter: ArcCurveContainer(
              color: color,
              arcHeight: arcHeight,
              position: position,
              equality: equality,
              clock: clock,
              radius: radius,
              type: type
            ),
          ),
        ),
        Container(
          width: width,
          height: height,
          child: CustomPaint(
            painter: ArcCurveContainer(
              color: frontColor,
              arcHeight: (arcHeight+space),
              position: position,
              equality: equality,
              clock: clock,
              radius: radius,
              type: type
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}