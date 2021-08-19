import 'package:flutter/material.dart';
import 'dart:math' as math;

class AutoRotate extends StatelessWidget {
  final Widget child;

  const AutoRotate({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      alignment: Alignment.center,
      angle: (Directionality.of(context) == TextDirection.rtl) ? math.pi : 0,
      child: child,
    );
  }
}

class AutoFlip extends StatelessWidget {
  final Widget child;

  const AutoFlip({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(
          (Directionality.of(context) == TextDirection.rtl) ? math.pi : 0),
      child: child,
    );
  }
}
