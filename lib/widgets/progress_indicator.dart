import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:manga_scraper/theme/app_colors.dart';

class AppProgressIndicator extends StatefulWidget {
  const AppProgressIndicator({
    Key key,
  })  : size = 64.0,
        super(key: key);
  const AppProgressIndicator.custom({Key key, this.size}) : super(key: key);

  const AppProgressIndicator.page({
    Key key,
  })  : size = 164.0,
        super(key: key);

  final double size;

  @override
  _AppProgressIndicatorState createState() => _AppProgressIndicatorState();
}

class _AppProgressIndicatorState extends State<AppProgressIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    controller.repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return AnimatedBuilder(
        animation: controller,
        builder: (context, _) => CustomPaint(
          size: constraints.constrain(Size.square(widget.size)),
          painter: _AppProgressPainter(controller.value),
        ),
      );
    });
  }
}

class _AppProgressPainter extends CustomPainter {
  final double animation;

  _AppProgressPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    final current = animation * 8;
    final paint = Paint()
      ..color = AppColors.getPrimaryColor()
      ..style = PaintingStyle.fill;

    // move canvas origin to center
    canvas.translate(size.width / 2, size.height / 2);
    final degreeZeroRRectCenter =
        Offset(size.width / 2 - size.width / 5.0, 0.0);
    for (int i = 0; i < 8; ++i) {
      paint.color = AppColors.getPrimaryColor().withOpacity(
        dist(current, i) / 4,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: degreeZeroRRectCenter,
              width: size.width / 5.0,
              height: size.height / 12.0),
          Radius.circular(5.0),
        ),
        paint,
      );
      canvas.rotate(2 * math.pi / 8.0);
    }
  }

  double dist(double current, int i) {
    double res = (current - i).abs();
    if (res > 4) {
      res = 8 - res;
    }
    return res;
  }

  @override
  bool shouldRepaint(_AppProgressPainter old) => true;
}
